unit FileExtChMain;

interface

uses
  Windows, Dialogs, SysUtils, Forms, Classes, Controls, StdCtrls;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    f, e: string;
  protected
    function GetChoosenExt: string;
  end;

var
  Form1: TForm1;

implementation

uses
  DropFiles, ShellAPI;

{$R *.dfm}

resourcestring
  lng_file_not_found = 'The file "%s" was not found!';
  lng_is_a_dir = 'A directory has no filename extension which could be changed.';

function RemoveFileNameExt(fn: string): string;
begin
  result := Copy(fn, 1, Length(fn)-Length(ExtractFileExt(fn)));
end;

procedure TForm1.FormShow(Sender: TObject);
resourcestring
  lng_syntax = 'Syntax: %s filename';
var
  i: integer;
  nf: string;
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
  e := ExtractFileExt(f);

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

  Label1.Caption := ExtractFileName(f);
  Edit1.Text := Copy(e, 2, Length(e)-1);
  Edit1.SetFocus;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  n: string;
resourcestring
  lng_move_error = 'Could not move file "%s" to "%s". Error code: %d.';
  lng_target_already_exists = 'The target file "%s" already exists. Rename not possible.';
begin
  n := RemoveFileNameExt(f)+GetChoosenExt;

  if not FileExists(f) then
  begin
    ShowMessageFmt(lng_file_not_found, [f]);
    Close;
    Exit;
  end;

  if FileExists(n) then
  begin
    ShowMessageFmt(lng_target_already_exists, [n]);
    Close;
    Exit;
  end;

  if not MoveFile(PChar(f), PChar(n)) then
  begin
    ShowMessageFmt(lng_move_error, [f, n, GetLastError()]);
  end;

  Close;
end;

function TForm1.GetChoosenExt: string;
begin
  if Edit1.Text = '' then
    result := ''
  else
    result := '.'+Edit1.text;
end;

end.
