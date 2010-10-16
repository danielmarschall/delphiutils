unit DragDropOpenDlg;

// Improvements to the Dialogs
// - New design
// - Overwrite (Save) / MustExists (Open) as default
// - DragDrop feature!

// TODO (incl. QuerySystemMenu): Besser mit WndProc(var Message) und Dispatch wie in Dialogs.pas arbeiten?

interface

uses
  Windows, Dialogs, Classes, messages, shellapi, sysutils, WindowsCompat;

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
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses
  MethodPtr;

{ TDragDropOpenDlg }

const
  IDA = 101;

function TDragDropOpenDlg.msgr(Handle: HWnd; Msg: UInt;
  WParam: Windows.WParam; LParam: Windows.LParam): LResult;
 const
   MAXFILENAME = 255; // TODO MAX_PATH?
 var
   cnt, fileCount : integer;
   fileName : array [0..MAXFILENAME] of char;
begin
  if Msg = WM_DROPFILES then
  begin
    // how many files dropped?
    fileCount := DragQueryFile(wParam, $FFFFFFFF, fileName, MAXFILENAME) ;

    // query for file names

    for cnt := 0 to fileCount-1 do
    begin
      DragQueryFile(wParam, cnt, fileName, MAXFILENAME) ;

      //do something with the file(s)
      showmessage('Drag accepted: ' + filename);
    end;

    //release memory
    DragFinish(wParam);

    // TODO: Geht nicht
SendMessage(Self.Handle, WM_CLOSE, 0, 0);
DestroyWindow(Self.Handle);
  end;

  result := Windows.CallWindowProc({!!!}WindowsCompat.WNDPROC(FPrevWndProc), Handle, Msg, WParam, LParam)
end;

procedure TDragDropOpenDlg.OpenDialog1Show(Sender: TObject);
var
  hParent: THandle;
  rect: TRect;
  hEdit: THandle;
  f: TMethod;
begin
  // OpenDialog1.Handle ist irgendwie das falsche :?
  hParent := GetParent(Handle);
  // Position und Größe ermitteln
  GetWindowRect(hParent, rect);
  // Dialog vergrößern für Edit
  SetWindowPos(hParent, 0, 0, 0, rect.Right - rect.Left, rect.Bottom - rect.Top
    + 25*2, SWP_NOMOVE);
  // Edit erzeugen, ID = 101
  hEdit := CreateWindowEx(WS_EX_CLIENTEDGE, 'EDIT', '', WS_VISIBLE or WS_CHILD,
    195, rect.Bottom - rect.Top - 27, 150, 20, hParent, IDA, 0, nil);
  if hEdit = 0 then
    RaiseLastOSError;

  FPrevWndProc := GetWindowLongPtr(hEdit, GWLP_WNDPROC);

  f.Code := @TDragDropOpenDlg.msgr;
  f.Data := Self;
  MsgProcPointer := {!!!}MethodPtr.MakeProcInstance(f);

  // Problem: Kann es zu Komplikationen mit mehreren msg handlern kommen?
  // (Beim vermischten register+unregister !)

  SetWindowLongPtr(hEdit, GWLP_WNDPROC, LONG_PTR(MsgProcPointer));
  DragAcceptFiles(hEdit, true);
end;

procedure TDragDropOpenDlg.OpenDialog1Close(Sender: TObject);
var
  hParent: THandle;
  hEdit: THandle;
  Buffer: PChar;
  len: Integer;
begin
  hParent := GetParent(Handle);
  // Handle des Edits ermitteln, ID = 101 siehe oben
  hEdit := GetDlgItem(hParent, IDA);

  DragAcceptFiles(hEdit, false);
  SetWindowLongPtr(hEdit, GWLP_WNDPROC, FPrevWndProc);

  // Speicher allozieren
  len := SendMessage(hEdit, WM_GETTEXTLENGTH, 0, 0);
  GetMem(Buffer, len + 1);
  try
    ZeroMemory(Buffer, len + 1);
    // Text aus Edit holen
    SendMessage(hEdit, WM_GETTEXT, len, lParam(Buffer));
    ShowMessage('Text im Editfeld:' + Buffer);
  finally
    FreeMem(Buffer, len + 1);
  end;
end;

constructor TDragDropOpenDlg.Create(AOwner: TComponent);
begin
  inherited;

  // TODO: Als Wrapper, damit auch weiter verwendbar!
  OnClose := OpenDialog1Close;
  OnShow := OpenDialog1Show;

end;

// {!!!} = Bitte auch in QuerySystemMenu verwenden!

end.
