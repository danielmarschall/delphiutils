program DlgExtended;

uses
  Forms,
  Main in 'Main.pas' {Form1},
  DragDropOpenDlg in 'DragDropOpenDlg.pas';

{$R *.res}

{$R Manifest.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
