unit QuerySystemMenu;

(*

QuerySystemMenu.pas
(C) 2010 Daniel Marschall

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
  result := Windows.CallWindowProc(WNDPROC(FPrevWndProc), Handle, Msg, WParam, LParam)
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
  MsgProcPointer := MakeProcInstance(f);

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

function TQuerySystemMenu.MsgProc(Handle: HWnd; Msg: UInt; WParam: Windows.WParam; LParam: Windows.LParam): LResult;
begin
  // TODO bug: löst bei evtl vorhandenen submenus öfters aus
  
  if Msg = WM_INITMENUPOPUP then
  begin
    // if Cardinal(WParam) = GetSystemMenu(FHandle, False) then
    if LongBool(HiWord(lParam)) then
    begin
      FSystemMenuOpened := true;
      if Assigned(FOnSystemMenuOpen) then
      begin
        FOnSystemMenuOpen(Self);
      end;
    end;
  end;
  if Msg = WM_UNINITMENUPOPUP then
  begin
    // if Cardinal(WParam) = GetSystemMenu(FHandle, False) then
    if HiWord(lParam) = MF_SYSMENU then
    begin
      FSystemMenuOpened := false;
      if Assigned(FOnSystemMenuClose) then
      begin
        FOnSystemMenuClose(Self);
      end;
    end;
  end;

  result := inherited MsgProc(Handle, Msg, WParam, LParam);
end;

end.
