program Calender;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  FullYearCalendar in 'FullYearCalendar.pas',
  NoDoubleStart in 'NoDoubleStart.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.ShowMainForm := false;
  Application.Title := 'Kalender';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
