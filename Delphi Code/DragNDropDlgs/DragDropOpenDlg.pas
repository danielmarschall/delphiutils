unit DragDropOpenDlg;

// Improvements to the Dialogs
// - New design
// - Overwrite (Save) / MustExists (Open) as default
// - DragDrop feature!
// + DialogHandle

// TODO (incl. QuerySystemMenu): Besser mit WndProc(var Message) und Dispatch wie in Dialogs.pas arbeiten?

// TODO
// - Fertigstellen. Alles ausschließen wie z.B. Ordner, Nonexisting files etc. (je nach Options)

interface

uses
  Windows, WindowsCompat, Dialogs, Classes, Messages, ShellAPI, SysUtils;

type
  TDragDropOpenDlg = class(TOpenDialog)
  private
    MsgProcPointer: pointer;
    FPrevWndProc: LONG_PTR;
    procedure OpenDialog1Show(Sender: TObject);
    procedure OpenDialog1Close(Sender: TObject);
    function msgr(Handle: HWnd; Msg: UInt;
      WParam: Windows.WParam; LParam: Windows.LParam): LResult; stdcall;
  public
    function DialogHandle: THandle;
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses
  MethodPtr;

{ TDragDropOpenDlg }

const
  ID_DROP_FIELD = 101;

function TDragDropOpenDlg.DialogHandle: THandle;
begin
  result := GetParent(Self.Handle);
end;

function TDragDropOpenDlg.msgr(Handle: HWnd; Msg: UInt;
  WParam: Windows.WParam; LParam: Windows.LParam): LResult;
const
  MAXFILENAME = 255; // MAX_PATH???
  ID_FILENAME_EDIT = $47C; // Tested on Win XP
var
  cnt, fileCount : integer;
  fileName : array [0..MAXFILENAME] of char;
  hDialog, hFilename: THandle;
  Filenames: string;
resourcestring
  LNG_NO_MULTISELECT = 'Es kann nur eine Datei ausgewählt werden.';
  LNG_NO_FOLDER = 'Ordner können nicht aufgenommen werden. Bitte die Ordner aus der Selektion nehmen.';
  LNG_FILE_NOT_EXISTS = 'Datei "%s" existiert nicht. Bitte korrigieren Sie die Selektion.';
begin
  result := Windows.CallWindowProc(WindowsCompat.WNDPROC(FPrevWndProc), Handle, Msg, WParam, LParam);

  if Msg = WM_DROPFILES then
  begin
    fileCount := DragQueryFile(wParam, $FFFFFFFF, fileName, MAXFILENAME) ;

    if (fileCount > 1) and not (ofAllowMultiSelect in Options) then
    begin
      ShowMessage(LNG_NO_MULTISELECT);
      Exit;
    end;

    Filenames := '';
    for cnt := 0 to fileCount-1 do
    begin
      DragQueryFile(wParam, cnt, fileName, MAXFILENAME);

      if DirectoryExists(fileName) then
      begin
        ShowMessage(LNG_NO_FOLDER);
        Exit;
      end;

      if (ofFileMustExist in Options) and not FileExists(fileName) then
      begin
        // Should never happen
        ShowMessageFmt(LNG_FILE_NOT_EXISTS, [fileName]);
        Exit;
      end;

      Filenames := Filenames + '"' + fileName + '"' + ' ';
    end;
    Filenames := copy(Filenames, 1, length(Filenames)-1);

    DragFinish(wParam);

    hDialog := DialogHandle;
    hFilename := GetDlgItem(hDialog, ID_FILENAME_EDIT);
    SendMessage(hFilename, WM_SETTEXT, 0, DWord(PChar(Filenames)));

    SendMessage(hDialog, WM_COMMAND, IDOK, 0);
  end;
end;

procedure TDragDropOpenDlg.OpenDialog1Show(Sender: TObject);
var
  hDialog: THandle;
  rect: TRect;
  hEdit: THandle;
  f: TMethod;
begin
  hDialog := DialogHandle;
  GetWindowRect(hDialog, rect);
  SetWindowPos(hDialog, 0, 0, 0, rect.Right - rect.Left, rect.Bottom - rect.Top
    + 25*2, SWP_NOMOVE);
  hEdit := CreateWindowEx(WS_EX_CLIENTEDGE, 'EDIT', '', WS_VISIBLE or WS_CHILD,
    195, rect.Bottom - rect.Top - 27, 150, 20, hDialog, ID_DROP_FIELD, 0, nil);
  if hEdit = 0 then RaiseLastOSError;

  FPrevWndProc := GetWindowLongPtr(hEdit, GWLP_WNDPROC);

  f.Code := @TDragDropOpenDlg.msgr;
  f.Data := Self;
  MsgProcPointer := MethodPtr.MakeProcInstance(f);

  // Problem: Kann es zu Komplikationen mit mehreren msg handlern kommen?
  // (Beim vermischten register+unregister !)

  SetWindowLongPtr(hEdit, GWLP_WNDPROC, LONG_PTR(MsgProcPointer));
  DragAcceptFiles(hEdit, true);
end;

procedure TDragDropOpenDlg.OpenDialog1Close(Sender: TObject);
var
  hDialog: THandle;
  hEdit: THandle;
begin
  hDialog := DialogHandle;
  hEdit := GetDlgItem(hDialog, ID_DROP_FIELD);

  DragAcceptFiles(hEdit, false);
  SetWindowLongPtr(hEdit, GWLP_WNDPROC, FPrevWndProc);
end;

constructor TDragDropOpenDlg.Create(AOwner: TComponent);
begin
  inherited;

  // TODO: Als Wrapper, damit auch weiter verwendbar!
  OnClose := OpenDialog1Close;
  OnShow := OpenDialog1Show;
end;

end.
