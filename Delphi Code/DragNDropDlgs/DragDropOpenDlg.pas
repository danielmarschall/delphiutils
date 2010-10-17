unit DragDropOpenDlg;

// Improvements to the Dialogs
// + Automatic new design for Windows Vista
// + PathMustExists+Overwrite (Save) / FileMustExists (Open) as default
// + DragDrop Feature!
// + DialogHandle

// TODO (incl. QuerySystemMenu): Besser mit WndProc(var Message) und Dispatch wie in Dialogs.pas arbeiten?

interface

uses
  Windows, WindowsCompat, Dialogs, Classes, Messages, ShellAPI, SysUtils;

type
  TDragDropOpenDlg = class(TOpenDialog)
  private
    MsgProcPointer: pointer;
    FPrevWndProc: LONG_PTR;
    FOnClose: TNotifyEvent;
    FOnShow: TNotifyEvent;
    FDNDArea: boolean;
    procedure DialogShow(Sender: TObject);
    procedure DialogClose(Sender: TObject);
    function DropGroundWndProc(Handle: HWnd; Msg: UInt;
      WParam: Windows.WParam; LParam: Windows.LParam): LResult; stdcall;
    function GetDialogHandle: THandle;
  protected
    function IsFileAllowed(AFileName: string; AShowWarning: boolean): boolean;
  public
    constructor Create(AOwner: TComponent); override;
    property DialogHandle: THandle read GetDialogHandle;
  published
    property OnClose: TNotifyEvent read FOnClose write FOnClose;
    property OnShow: TNotifyEvent read FOnShow write FOnShow;
    property DragDropArea: boolean read FDNDArea write FDNDArea default true;
  end;

implementation

uses
  MethodPtr;

{ TDragDropOpenDlg }

const
  ID_DROP_FIELD = 101;

function TDragDropOpenDlg.GetDialogHandle: THandle;
begin
  result := GetParent(Self.Handle);
end;

function TDragDropOpenDlg.IsFileAllowed(AFileName: string;
  AShowWarning: boolean): boolean;

  procedure DoMessage(AMessageText: String);
  resourcestring
    LNG_DND_ERROR = 'Drag''n''Drop Fehler';
  begin
    if AShowWarning then
    begin
      MessageBox(DialogHandle, PChar(AMessageText), PChar(LNG_DND_ERROR), MB_ICONHAND or MB_OK)  
    end;
  end;
  
resourcestring
  LNG_NO_FOLDER = 'Ordner können nicht aufgenommen werden. Bitte die Ordner aus der Selektion nehmen.';
  LNG_FILE_NOT_EXISTS = 'Datei "%s" existiert nicht. Bitte korrigieren Sie die Selektion.';
begin
  // TODO: Wurden alle Dinge aus den Options berücksichtigt?

  result := false;
  
  if DirectoryExists(fileName) then
  begin
    DoMessage(LNG_NO_FOLDER);
    Exit;
  end;

  if (ofFileMustExist in Options) and not FileExists(fileName) then
  begin
    // Should usually never happen
    DoMessage(Format(LNG_FILE_NOT_EXISTS, [fileName]));
    Exit;
  end;

  result := true;
end;

function TDragDropOpenDlg.DropGroundWndProc(Handle: HWnd; Msg: UInt;
  WParam: Windows.WParam; LParam: Windows.LParam): LResult;
const
  ID_FILENAME_EDIT = $47C; // Tested on Win XP
var
  i, fileCount: integer;
  fileName: array [0..MAX_PATH-1] of char;
  hDialog, hFilename: THandle;
  Filenames: string;
resourcestring
  LNG_NO_MULTISELECT = 'Es kann nur eine Datei ausgewählt werden.';
begin
  result := Windows.CallWindowProc(WindowsCompat.WNDPROC(FPrevWndProc), Handle, Msg, WParam, LParam);

  if Msg = WM_DROPFILES then
  begin
    fileCount := DragQueryFile(wParam, DWord(-1) (* $FFFFFFFF *), nil, 0);
    try
      if (fileCount > 1) and not (ofAllowMultiSelect in Options) then
      begin
        ShowMessage(LNG_NO_MULTISELECT);
        Exit;
      end;

      Filenames := '';
      for i := 0 to fileCount-1 do
      begin
        DragQueryFile(wParam, i, fileName, MAX_PATH);
        if not IsFileAllowed(fileName, true) then Exit;
        Filenames := Filenames + '"' + fileName + '"' + ' ';
      end;
      Filenames := Copy(Filenames, 1, length(Filenames)-1);
    finally
      DragFinish(wParam);
    end;

    hDialog := DialogHandle;
    hFilename := GetDlgItem(hDialog, ID_FILENAME_EDIT);
    if hFilename = 0 then RaiseLastOSError;
    SendMessage(hFilename, WM_SETTEXT, 0, DWord(PChar(Filenames)));

    SendMessage(hDialog, WM_COMMAND, IDOK, 0);
  end;
end;

procedure TDragDropOpenDlg.DialogShow(Sender: TObject);
var
  hDialog: THandle;
  rect: TRect;
  hEdit: THandle;
  f: TMethod;
begin
  if FDNDArea then
  begin
    hDialog := DialogHandle;
    GetWindowRect(hDialog, rect);
    SetWindowPos(hDialog, 0, 0, 0, rect.Right - rect.Left, rect.Bottom - rect.Top
      + 25*2, SWP_NOMOVE);
    hEdit := CreateWindowEx(WS_EX_CLIENTEDGE, 'EDIT', 'Drag''n''Drop', WS_VISIBLE or WS_CHILD,
      5, rect.Bottom - rect.Top - 27, 89, 35, hDialog, ID_DROP_FIELD, 0, nil);
    if hEdit = 0 then RaiseLastOSError;

    FPrevWndProc := GetWindowLongPtr(hEdit, GWLP_WNDPROC);

    f.Code := @TDragDropOpenDlg.DropGroundWndProc;
    f.Data := Self;
    MsgProcPointer := MethodPtr.MakeProcInstance(f);

    SetWindowLongPtr(hEdit, GWLP_WNDPROC, LONG_PTR(MsgProcPointer));
    DragAcceptFiles(hEdit, true);
  end;

  if Assigned(FOnShow) then FOnShow(Sender);
end;

procedure TDragDropOpenDlg.DialogClose(Sender: TObject);
var
  hDialog: THandle;
  hEdit: THandle;
begin
  if FDNDArea then
  begin
    hDialog := DialogHandle;
    hEdit := GetDlgItem(hDialog, ID_DROP_FIELD);

    DragAcceptFiles(hEdit, false);
    SetWindowLongPtr(hEdit, GWLP_WNDPROC, FPrevWndProc);
  end;

  if Assigned(FOnClose) then FOnClose(Sender);
end;

constructor TDragDropOpenDlg.Create(AOwner: TComponent);
begin
  inherited;

  FDNDArea := true;

  // In my opinion these options are neccessary for an open dialog!
  Options := Options + [ofFileMustExist];
  // Options := Options + [ofPathMustExist];

  inherited OnClose := DialogClose;
  inherited OnShow := DialogShow;
end;

initialization
  {$IF DECLARED(UseLatestCommonDialogs)}
  Dialogs.UseLatestCommonDialogs := true;
  {$IFEND}
end.
