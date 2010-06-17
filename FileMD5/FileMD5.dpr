program FileMD5;

uses
  Forms,
  FileMD5Main in 'FileMD5Main.pas' {Form1},
  DropFiles in '..\_Common\DropFiles.pas' {Form2},
  md5 in 'md5.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Quick MD5 Calc';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
