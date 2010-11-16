program StatusMon;

uses
  Forms,
  NoDoubleStart in 'NoDoubleStart.pas',
  StatusMonFuncs in 'StatusMonFuncs.pas',
  Common in 'Common.pas',
  Main in 'Main.pas' {MainForm},
  Functions in 'Functions.pas',
  ServiceEdit in 'ServiceEdit.pas' {EditForm},
  About in 'About.pas' {AboutForm};

{$R *.res}

begin
  Application.Initialize;
  Application.ShowMainForm := false;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TEditForm, EditForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.Run;
end.
