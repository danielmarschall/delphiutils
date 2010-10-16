program Demo;

uses
  Forms,
  DemoMain in 'DemoMain.pas' {Form1},
  ParamUtils in 'ParamUtils.pas',
  Functions in 'Functions.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
