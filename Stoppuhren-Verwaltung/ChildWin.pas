unit CHILDWIN;

interface

uses Windows, Classes, Graphics, Forms, Controls, StdCtrls, ExtCtrls, SysUtils, Dialogs;

type
  TMDIChild = class(TForm)
    Memo1: TMemo;
    Label1: TLabel;
    Button1: TButton;
    Timer1: TTimer;
    Button2: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Button2Click(Sender: TObject);
  private
    StartTime: TDateTime;
    SecondsPrev: integer;
    SecondsTotal: integer;
  end;

implementation

{$R *.dfm}

uses
  DateUtils, Math;

procedure TMDIChild.Button1Click(Sender: TObject);
begin
  if CompareValue(StartTime, 0) <> 0 then
  begin
    // Es l‰uft. Stoppe es
    SecondsTotal := SecondsPrev + trunc((Now - StartTime) * 24*60*60);
    SecondsPrev := SecondsTotal;
    StartTime := 0;
    memo1.Color := clWindow;
  end
  else
  begin
    // Es l‰uft nicht. Starte es.
    StartTime := Now;
    memo1.Color := clYellow;
  end;
end;

procedure TMDIChild.Button2Click(Sender: TObject);
begin
  if MessageDlg('Stoppuhr ' + Trim(Memo1.Lines.Text) + ' wirklich resetten?', mtConfirmation, mbYesNoCancel, 0) = mrYes then
  begin
    if CompareValue(StartTime, 0) <> 0 then
    begin
      // Es l‰uft. Starte neu
      StartTime := Now;
    end
    else
    begin
      // Es l‰uft nicht. Resette Zeit
      SecondsPrev := 0;
    end;
  end;
end;

procedure TMDIChild.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TMDIChild.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := MessageDlg('Stoppuhr ' + Trim(Memo1.Lines.Text) + ' wirklich schlieﬂen?', mtConfirmation, mbYesNoCancel, 0) = mrYes;
end;

procedure TMDIChild.FormCreate(Sender: TObject);
begin
  Constraints.MinWidth := Width;
  Constraints.MaxWidth := Width;
  Constraints.MinHeight := Height;
  Constraints.MaxHeight := Height;
end;

procedure TMDIChild.Timer1Timer(Sender: TObject);
begin
  if CompareValue(StartTime, 0) <> 0 then
  begin
    SecondsTotal := SecondsPrev + trunc((Now - StartTime) * 24*60*60);
  end
  else
  begin
    SecondsTotal := SecondsPrev;
  end;

  label1.Caption := FormatDateTime('hh:nn:ss', SecondsTotal / SecsPerDay);
end;

end.
