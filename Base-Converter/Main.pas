unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TMainForm = class(TForm)
    Memo1: TMemo;
    Memo2: TMemo;
    Edit1: TEdit;
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    CheckBox1: TCheckBox;
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

// Future Idea: Any <-> Any Converting

function convertToAnyBase(num, base: integer; useAlpha: boolean): String;
var
  q, r: integer;
begin
  result := '';

  while true do
  begin
    q := num div base;
    r := num mod base;

    if useAlpha and (r <= 35) then
    begin
      if (r < 10) then
      begin
        result := IntToStr(r) + result; // 0..9
      end
      else
      begin
        result := chr(ord('A') + r - 10) + result; // A..Z
      end;
    end
    else
    begin
      result := Format('(%d)%s', [r, result]);
    end;

    if q = 0 then
    begin
      break;
    end;

    num := q;
  end;
end;

procedure TMainForm.Button1Click(Sender: TObject);
var
  i, n, b: integer;
  s: string;
begin
  b := StrToInt(Edit1.Text);
  memo2.Lines.Clear;
  for i := 0 to memo1.Lines.Count - 1 do
  begin
    s := memo1.Lines.Strings[i];
    if (s = '') then
    begin
      memo2.Lines.Add('');
    end
    else
    begin
      n := StrToInt(s);
      memo2.Lines.Add(convertToAnyBase(n, b, CheckBox1.Checked));
    end;
  end;
end;

end.
