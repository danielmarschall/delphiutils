unit FileReadCheckerMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, FileCtrl, Math;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Memo1: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    ProgressBar1: TProgressBar;
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    procedure FindFiles(FilesList: TStrings; StartDir, FileMask: string; errorSL: TStrings=nil);
    procedure EnableDisableControls(enabled: boolean);
    function Readable(filename: string): boolean;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

// Recursive procedure to build a list of files
procedure TForm1.FindFiles(FilesList: TStrings; StartDir, FileMask: string; errorSL: TStrings=nil);
var
  SR: TSearchRec;
  DirList: TStrings;
  IsFound: Boolean;
  i: integer;
begin
  if StartDir[length(StartDir)] <> PathDelim then
    StartDir := StartDir + PathDelim;

  IsFound := FindFirst(StartDir+FileMask, faAnyFile-faDirectory, SR) = 0;
  while IsFound do
  begin
    Application.ProcessMessages;
    if Application.Terminated then Abort;
    FilesList.Add(StartDir + SR.Name);
    IsFound := FindNext(SR) = 0;
  end;
  FindClose(SR);

  // Build a list of subdirectories
  DirList := TStringList.Create;
  IsFound := FindFirst(StartDir+'*.*', faAnyFile, SR) = 0;
  if DirectoryExists(StartDir) and not IsFound then
  begin
    // Every directory has always at least 2 items ('.' and '..')
    // If not, we have an ACL problem.
    if Assigned(errorSL) then errorSL.Add(StartDir);
  end;
  while IsFound do begin
    if ((SR.Attr and faDirectory) <> 0) and
         (SR.Name[1] <> '.') then
    begin
      Application.ProcessMessages;
      if Application.Terminated then Abort;
      DirList.Add(StartDir + SR.Name);
    end;
    IsFound := FindNext(SR) = 0;
  end;
  FindClose(SR);

  // Scan the list of subdirectories
  for i := 0 to DirList.Count - 1 do
  begin
    FindFiles(FilesList, DirList[i], FileMask, errorSL);
  end;

  DirList.Free;
end;

function TForm1.Readable(filename: string): boolean;
var
  ss: TFileStream;
begin
  result := false;
  if not FileExists(filename) then exit;
  try
    ss := TFileStream.Create(filename, fmOpenRead or fmShareDenyNone);
    ss.Free;
    result := true;
  except
    exit;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  sl: TStringList;
  fil: string;
  cnt: integer;
  c1, c2, f: Int64;
  elapsedSecs: Int64;
begin
  if not DirectoryExists(edit1.Text) then
  begin
    raise Exception.CreateFmt('Directory %s does not exist!', [Edit1.Text]);
  end;

  QueryPerformanceFrequency(f);
  QueryPerformanceCounter(c1);

  EnableDisableControls(false);
  try
    Memo1.Lines.Clear;
    cnt := 0;
    sl := TStringList.Create;
    try
      sl.BeginUpdate;
      Label2.Caption := 'Scan folders ...';
      
      FindFiles(sl, edit1.text, '*', Memo1.Lines);
      Inc(cnt, Memo1.Lines.Count); // failed folders

      ProgressBar1.Max := sl.Count;
      ProgressBar1.Min := 0;
      ProgressBar1.Position := 0;

      for fil in sl do
      begin
        ProgressBar1.Position := ProgressBar1.Position + 1;

        if not Readable(fil) then
        begin
          Memo1.Lines.Add(fil);
          inc(cnt);
        end;

        Label2.Caption := MinimizeName(fil, Label2.Canvas, Label2.Width);

        Application.ProcessMessages;
        if Application.Terminated then Abort;
      end;
      sl.EndUpdate;
    finally
      sl.Free;
    end;

    if not Application.Terminated then
    begin
      QueryPerformanceCounter(c2);
      elapsedSecs := Ceil((c2-c1)/f);

      ShowMessageFmt('Finished. Found %d error(s). Time: %.2d:%.2d:%.2d', [cnt, elapsedSecs div 3600, elapsedSecs mod 3600 div 60, elapsedSecs mod 3600 mod 60]);
    end;
  finally
    EnableDisableControls(true);
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
end;

procedure TForm1.EnableDisableControls(enabled: boolean);
begin
  Button1.Enabled := enabled;
  Label1.Enabled := enabled;
  Edit1.Enabled := enabled;
  Memo1.Enabled := enabled;
end;

end.
