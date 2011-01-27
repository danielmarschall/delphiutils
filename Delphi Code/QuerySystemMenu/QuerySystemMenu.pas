unit QuerySystemMenu;

(*

QuerySystemMenu.pas
(C) 2010 - 2011 Daniel Marschall

*)

interface

// TODO: DefWindowProc() verwenden?

uses
  Windows, WindowsCompat, Classes, SysUtils;

type
  TWndProcIntercept = class(TObject)
  private
    FHandle: HWnd;
    FPrevWndProc: LONG_PTR;
    MsgProcPointer: Pointer;
    FIsRegistered: boolean;
    function MsgProcVirtualCall(Handle: HWnd; Msg: UInt; WParam: Windows.WParam; LParam: Windows.LParam): LResult; stdcall;
    procedure RegisterCB;
    procedure UnregisterCB;
  protected
    function MsgProc(Handle: HWnd; Msg: UInt; WParam: Windows.WParam; LParam: Windows.LParam): LResult; virtual; stdcall;
  public
    constructor Create(AHandle: Hwnd);
    destructor Destroy; override;
  end;

  TQueryMenu = class(TWndProcIntercept)
  private
    FOnMenuOpen: TNotifyEvent;
    FOnMenuClose: TNotifyEvent;
    FMenuOpened: boolean;
  protected
    function MsgProc(Handle: HWnd; Msg: UInt; WParam: Windows.WParam; LParam: Windows.LParam): LResult; override; stdcall;
  published
    property IsMenuOpened: boolean read FMenuOpened;
    property OnMenuOpen: TNotifyEvent read FOnMenuOpen write FOnMenuOpen;
    property OnMenuClose: TNotifyEvent read FOnMenuClose write FOnMenuClose;
  end;

  TQuerySystemMenu = class(TWndProcIntercept)
  private
    FOnSystemMenuOpen: TNotifyEvent;
    FOnSystemMenuClose: TNotifyEvent;
    FSystemMenuOpened: boolean;
  protected
    function MsgProc(Handle: HWnd; Msg: UInt; WParam: Windows.WParam; LParam: Windows.LParam): LResult; override; stdcall;
    function IsSystemMenuSubmenu(h: hwnd): boolean;
  published
    property IsSystemMenuOpened: boolean read FSystemMenuOpened;
    property OnSystemMenuOpen: TNotifyEvent read FOnSystemMenuOpen write FOnSystemMenuOpen;
    property OnSystemMenuClose: TNotifyEvent read FOnSystemMenuClose write FOnSystemMenuClose;
  end;

implementation

uses
  Messages, MethodPtr;

{ TWndProcIntercept }

constructor TWndProcIntercept.Create(AHandle: Hwnd);
begin
  FHandle := AHandle;

  RegisterCB;
end;

destructor TWndProcIntercept.Destroy;
begin
  UnregisterCB;

  inherited;
end;

function TWndProcIntercept.MsgProc(Handle: HWnd; Msg: UInt;
  WParam: Windows.WParam; LParam: Windows.LParam): LResult;
begin
  result := Windows.CallWindowProc(WindowsCompat.WNDPROC(FPrevWndProc), Handle, Msg, WParam, LParam)
end;

function TWndProcIntercept.MsgProcVirtualCall(Handle: HWnd; Msg: UInt;
  WParam: Windows.WParam; LParam: Windows.LParam): LResult;
begin
  // Virtual call
  result := MsgProc(Handle, Msg, WParam, LParam);
end;

procedure TWndProcIntercept.RegisterCB;
var
  f: TMethod;
begin
  if FIsRegistered then exit;
  FIsRegistered := true;

  FPrevWndProc := GetWindowLongPtr(FHandle, GWLP_WNDPROC);

  f.Code := @TWndProcIntercept.MsgProcVirtualCall;
  f.Data := Self;
  MsgProcPointer := MethodPtr.MakeProcInstance(f);

  // Problem: Kann es zu Komplikationen mit mehreren msg handlern kommen?
  // (Beim vermischten register+unregister !)

  SetWindowLongPtr(FHandle, GWLP_WNDPROC, LONG_PTR(MsgProcPointer));
end;

procedure TWndProcIntercept.UnregisterCB;
begin
  if not FIsRegistered then exit;
  FIsRegistered := false;

  SetWindowLongPtr(FHandle, GWLP_WNDPROC, FPrevWndProc);

  FreeProcInstance(MsgProcPointer);
end;

{ TQueryMenu }

function TQueryMenu.MsgProc(Handle: HWnd; Msg: UInt; WParam: Windows.WParam;
  LParam: Windows.LParam): LResult;
begin
  if Msg = WM_INITMENUPOPUP then
  begin
    FMenuOpened := true;
    if Assigned(FOnMenuOpen) then
    begin
      FOnMenuOpen(Self);
    end;
  end;
  if Msg = WM_UNINITMENUPOPUP then
  begin
    FMenuOpened := false;
    if Assigned(FOnMenuClose) then
    begin
      FOnMenuClose(Self);
    end;
  end;

  result := inherited MsgProc(Handle, Msg, WParam, LParam);
end;

{ TQuerySystemMenu }

function TQuerySystemMenu.IsSystemMenuSubmenu(h: hwnd): boolean;
var
  sym: hwnd;
begin
  sym := GetSystemMenu(FHandle, False);

  repeat
    if h = sym then
    begin
      result := true;
      exit;
    end;
    h := GetParent(h);
  until h = 0;

  result := false;
end;

function TQuerySystemMenu.MsgProc(Handle: HWnd; Msg: UInt; WParam: Windows.WParam; LParam: Windows.LParam): LResult;
begin
  if FSystemMenuOpened then
  begin
    // WM_UNINITMENUPOPUP ist nicht in Windows 95 implementiert.
    // Daher wird WM_EXITMENULOOP verwendet.
    // WM_INITMENUPOPUP wird benötigt, falls man z.B. direkt in das
    // MainMenu mit einem Klick wechselt. (kein WM_EXITMENULOOP wird aufgerufen)

    if ((Msg = WM_UNINITMENUPOPUP) {and IsSystemMenuSubmenu(Cardinal(wParam))} and (HiWord(lParam) = MF_SYSMENU)) or
       (Msg = WM_EXITMENULOOP) or
       ((Msg = WM_INITMENUPOPUP) and not IsSystemMenuSubmenu(Cardinal(WParam))) then
    begin
      FSystemMenuOpened := false;
      if Assigned(FOnSystemMenuClose) then
      begin
        FOnSystemMenuClose(Self);
      end;
    end;
  end
  else
  begin
    if (Msg = WM_INITMENUPOPUP) {and IsSystemMenuSubmenu(Cardinal(wParam))} and LongBool(HiWord(lParam)) then
    begin
      FSystemMenuOpened := true;
      if Assigned(FOnSystemMenuOpen) then
      begin
        FOnSystemMenuOpen(Self);
      end;
    end;
  end;

  result := inherited MsgProc(Handle, Msg, WParam, LParam);
end;

end.
