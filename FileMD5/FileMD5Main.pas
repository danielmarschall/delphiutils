unit FileMD5Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ShellAPI;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormShow(Sender: TObject);
  private
    choosenfile: string;
  protected
    procedure ChooseFile(f: string);
    procedure CalcMD5();
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  MD5, DropFiles;

resourcestring
  lng_file_not_found = 'The file "%s" was not found!';
  lng_is_a_dir = 'MD5 checksum can only calculated for files.';

function MyFileSize(fn: string): int64;
var 
  fs: TFileStream; 
begin
  fs := TFileStream.Create(fn, fmOpenRead or fmShareDenyWrite);
  try
    result := fs.Size;
  finally 
    fs.Free; 
  end; 
end;

procedure TForm1.CalcMD5();
const
  ZERO_HASH = 'd41d8cd98f00b204e9800998ecf8427e';
resourcestring
  lng_fatal_error = 'Fatal error!';
var
  h: string;
begin
  h := MD5Print(MD5File(choosenfile));

  // Additional check
  if (MyFileSize(choosenfile) <> 0) and (h = ZERO_HASH) then
  begin
    ShowMessage(lng_fatal_error);
    Exit;
  end;

  Edit1.Text := h;
end;

procedure TForm1.ChooseFile(f: string);
begin
  choosenfile := f;
  Label1.Caption := ExtractFileName(f);
  Edit2.Text := f;
end;

procedure TForm1.FormShow(Sender: TObject);
var
  f, nf: string;
  i: Integer;
resourcestring
  lng_syntax = 'Syntax: %s filename';
begin
  if ParamCount() < 1 then
  begin
    // ShowMessageFmt(lng_syntax, [ExtractFileName(Application.ExeName)]);
    Form2.SetMsg(Format(lng_syntax, [ExtractFileName(Application.ExeName)]));
    Form2.SetCap(Caption);
    Form2.ShowModal;
    Close;
    Exit;
  end;

  f := ParamStr(1);

  if DirectoryExists(f) then
  begin
    ShowMessage(lng_is_a_dir);
    Close;
    Exit;
  end;

  if not FileExists(f) then
  begin
    ShowMessageFmt(lng_file_not_found, [f]);
    Close;
    Exit;
  end;

  if ParamCount() > 1 then
  begin
    for i := 2 to ParamCount() do
    begin
      nf := ParamStr(i);

      ShellExecute(Handle, 'open', PChar('"'+Application.ExeName+'"'),
        PChar('"'+nf+'"'), PChar('"'+ExtractFilePath(Application.ExeName)+'"'), SW_NORMAL);
    end;
  end;

  ChooseFile(f);
  CalcMD5();
end;

end.
