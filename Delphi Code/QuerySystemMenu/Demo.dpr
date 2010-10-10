program Demo;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  QuerySystemMenu in 'QuerySystemMenu.pas',
  WindowsCompat in 'WindowsCompat.pas',
  MethodPtr in 'MethodPtr.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
