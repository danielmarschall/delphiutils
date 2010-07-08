unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    Edit1: TEdit;
    Label1: TLabel;
    Edit2: TEdit;
    GroupBox2: TGroupBox;
    Edit3: TEdit;
    Label3: TLabel;
    Edit4: TEdit;
    GroupBox3: TGroupBox;
    Label2: TLabel;
    Label4: TLabel;
    Panel1: TPanel;
    Label5: TLabel;
    Label6: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Edit5: TEdit;
    Edit6: TEdit;
    procedure Edit3Change(Sender: TObject);
    procedure Edit4Change(Sender: TObject);
    procedure SourceChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure UpdateFract(A, B: Extended);
    procedure AllEnabled(AEnabled: boolean; AExcept: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

{$DEFINE ALLOW_B_IS_ZERO}

// Setzt einen Text ohne OnChange() auszulösen
procedure SetText(AEdit: TEdit; AText: String);
var
  oc: TNotifyEvent;
begin
  oc := AEdit.OnChange;
  try
    AEdit.OnChange := nil;
    AEdit.Text := AText;
  finally
    AEdit.OnChange := oc;
  end;
end;

// http://www.delphi-library.de/viewtopic.php?p=288665#288665
procedure FloatToFrac(const x: Extended; out Numerator, Denominator: Int64);
const
 tol = 1e-12; // Fehlertoleranz
var
  p, lastp, q, lastq, ptemp, qtemp, u, err, d: Extended;
begin
  // Initialisierung
  p := 1;
  q := 0;
  lastp := 0;
  lastq := 1;
  u := x;

  repeat
    // Einen ganzzahligen Anteil abspalten
    d := round(u);
    u := u - d;

    // Update von p und q: Kettenbruch (siehe unten) nachführen. Es gilt: p/q ~= x
    ptemp := p*d+lastp;
    qtemp := q*d+lastq;
    lastp := p;
    lastq := q;
    p := ptemp;
    q := qtemp;

    // Approximationsfehler
    err := abs(p/q-x);

    // Abbruchkriterien
    if (u=0) or (err<tol) or (x+err/4=x {sic!}) then  // (*)
     break;

    // Bruch umkehren
    u := 1/u;
  until false;

  // Vor Integerkonversion auf Bereich überprüfen
  if (p>high(Int64)) or (q>high(Int64)) or
     (p<low(Int64)) or (p<low(Int64)) then
    raise EIntOverflow.Create('FloatToFrac: Integer conversion overflow.');

  // Vorzeichen von Nenner zum Zähler
  if q < 0 then
   Numerator := -Trunc(p) else
   Numerator := Trunc(p);
  Denominator := abs(Trunc(q));
end;

procedure TForm1.UpdateFract(A, B: Extended);
var
  P, Q: Int64;
begin
  {$IFDEF ALLOW_B_IS_ZERO}
  if B = 0 then
  begin
    Label2.Caption := FloatToStr(A);
    Label4.Caption := FloatToStr(B);
    Label6.Caption := '?';
    exit;
  end;
  {$ENDIF}

  FloatToFrac(A / B, P, Q);
  Label2.Caption := IntToStr(P);
  Label4.Caption := IntToStr(Q);
  Label6.Caption := FloatToStr(A / B);
end;

procedure TForm1.AllEnabled(AEnabled: boolean; AExcept: TObject);
begin
  if AExcept <> Edit1 then
    Edit1.Enabled := AEnabled;
  if AExcept <> Edit2 then
    Edit2.Enabled := AEnabled;
  if AExcept <> Edit3 then
    Edit3.Enabled := AEnabled;
  {$IFDEF ALLOW_B_IS_ZERO}
  if Edit2.Text <> '0' then
  begin
  {$ENDIF}
  if AExcept <> Edit4 then
    Edit4.Enabled := AEnabled;
  {$IFDEF ALLOW_B_IS_ZERO}
  end;
  {$ENDIF}
end;

procedure TForm1.SourceChange(Sender: TObject);
var
  A, B: Extended;
begin
  TEdit(Sender).Color := clWindow;
  AllEnabled(true, Sender);
  try
    A := StrToFloat(Edit1.Text);
    B := StrToFloat(Edit2.Text);

    UpdateFract(A, B);

    if RadioButton2.Checked then
    begin
      Edit3.Text := FloatToStr(A / B * StrToFloat(Edit4.Text));
    end
    else
    begin
      {$IFDEF ALLOW_B_IS_ZERO}
      if B = 0 then
      begin
        RadioButton1.Enabled := false;
        RadioButton2.Enabled := false;
        SetText(Edit4, '0');
        Edit6.Text := '0';
        Edit4.Enabled := false;
        Edit6.Enabled := false;
      end
      else
      begin
        RadioButton1.Enabled := true;
        RadioButton2.Enabled := true;
        Edit4.Enabled := true;
        Edit6.Enabled := true;
      {$ENDIF}
      Edit4.Text := FloatToStr(B / A * StrToFloat(Edit3.Text));
      {$IFDEF ALLOW_B_IS_ZERO}
      end;
      {$ENDIF}
    end;
  except
    TEdit(Sender).Color := clRed;
    AllEnabled(false, Sender);
  end;
end;

procedure TForm1.Edit3Change(Sender: TObject);
var
  A, B: Extended;
begin
  Edit3.Color := clWindow;
  AllEnabled(true, Sender);
  try
    A := StrToFloat(Edit1.Text);
    B := StrToFloat(Edit2.Text);

    SetText(Edit4, FloatToStr(B / A * StrToFloat(Edit3.Text)));
    Edit6.Text := IntToStr(Round(StrToFloat(Edit4.Text)));

    Edit5.Text := IntToStr(Round(StrToFloat(Edit3.Text)));
  except
    Edit3.Color := clRed;
    AllEnabled(false, Sender);
  end;
end;

procedure TForm1.Edit4Change(Sender: TObject);
var
  A, B: Extended;
begin
  Edit4.Color := clWindow;
  AllEnabled(true, Sender);
  try
    A := StrToFloat(Edit1.Text);
    B := StrToFloat(Edit2.Text);

    SetText(Edit3, FloatToStr(A / B * StrToFloat(Edit4.Text)));
    Edit5.Text := IntToStr(Round(StrToFloat(Edit3.Text)));

    Edit6.Text := IntToStr(Round(StrToFloat(Edit4.Text)));
  except
    Edit4.Color := clRed;
    AllEnabled(false, Sender);
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
var
  A, B: Extended;
begin
  A := StrToFloat(Edit1.Text);
  B := StrToFloat(Edit2.Text);

  UpdateFract(A, B);
end;

end.
