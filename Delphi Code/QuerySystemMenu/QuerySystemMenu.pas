unit QuerySystemMenu;

(*

QuerySystemMenu.pas
(C) 2010 Daniel Marschall

*)

interface

uses
  Windows, WindowsCompat, Classes;

type
  TQuerySystemMenu = class(TObject)
  private
    FOnSystemMenuOpen: TNotifyEvent;
    FOnSystemMenuClose: TNotifyEvent;
    FSystemMenuOpened: boolean;
    FHandle: HWnd;
    FPrevWndProc: LONG_PTR;
    MsgProcPointer: Pointer;
    function MsgProc(Handle: HWnd; Msg: UInt; WParam: Windows.WParam; LParam: Windows.LParam): LResult; stdcall;
  public
    constructor Create(AHandle: Hwnd);
    destructor Destroy; override;
  published
    property IsSystemMenuOpened: boolean read FSystemMenuOpened;
    property OnSystemMenuOpen: TNotifyEvent read FOnSystemMenuOpen write FOnSystemMenuOpen;
    property OnSystemMenuClose: TNotifyEvent read FOnSystemMenuClose write FOnSystemMenuClose;
  end;

implementation

uses
  Messages, MethodPtr;

function TQuerySystemMenu.MsgProc(Handle: HWnd; Msg: UInt; WParam: Windows.WParam; LParam: Windows.LParam): LResult; stdcall;
begin
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
  Result := Windows.CallWindowProc(WNDPROC(FPrevWndProc), Handle, Msg, WParam, LParam);
end;

constructor TQuerySystemMenu.Create(AHandle: Hwnd);
var
  f: TMethod;
begin
  FHandle := AHandle;

  FPrevWndProc := GetWindowLongPtr(FHandle, GWL_WNDPROC);

  f.Code := @TQuerySystemMenu.MsgProc;
  f.Data := Self;
  MsgProcPointer := MakeProcInstance(f);

  // Kann es zu Komplikationen mit mehreren msg handlern kommen?
  SetWindowLongPtr(FHandle, GWL_WNDPROC, MsgProcPointer);
end;

destructor TQuerySystemMenu.Destroy;
begin
  SetWindowLongPtr(FHandle, GWL_WNDPROC, FPrevWndProc);

  FreeProcInstance(MsgProcPointer);
end;

end.
