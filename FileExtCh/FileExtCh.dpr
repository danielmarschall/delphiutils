program FileExtCh;

uses
  Forms,
  FileExtChMain in 'FileExtChMain.pas' {Form1},
  DropFiles in '..\_Common\DropFiles.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Change FileExt';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
