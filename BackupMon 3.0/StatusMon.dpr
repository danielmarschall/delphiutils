program StatusMon;

uses
  Forms,
  NoDoubleStart in 'NoDoubleStart.pas',
  Main in 'Main.pas' {MainForm},
  Functions in 'Functions.pas',
  ServiceEdit in 'ServiceEdit.pas' {EditForm},
  StatusMonFuncs in 'StatusMonFuncs.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.ShowMainForm := false;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TEditForm, EditForm);
  Application.Run;
end.
