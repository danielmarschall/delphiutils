unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  memo1.Text := StringReplace(memo1.Text, 'Ã¤', '&auml;', [rfReplaceAll]);
  memo1.Text := StringReplace(memo1.Text, 'ä', '&auml;', [rfReplaceAll]);
  memo1.Text := StringReplace(memo1.Text, 'Ã¶', '&ouml;', [rfReplaceAll]);
  memo1.Text := StringReplace(memo1.Text, 'ö', '&ouml;', [rfReplaceAll]);
  memo1.Text := StringReplace(memo1.Text, 'Ã¼', '&uuml;', [rfReplaceAll]);
  memo1.Text := StringReplace(memo1.Text, 'ü', '&uuml;', [rfReplaceAll]);

  memo1.Text := StringReplace(memo1.Text, 'Ã„', '&Auml;', [rfReplaceAll]);
  memo1.Text := StringReplace(memo1.Text, 'Ä', '&Auml;', [rfReplaceAll]);
  memo1.Text := StringReplace(memo1.Text, 'Ã–', '&Ouml;', [rfReplaceAll]);
  memo1.Text := StringReplace(memo1.Text, 'Ö', '&Ouml;', [rfReplaceAll]);
  memo1.Text := StringReplace(memo1.Text, 'Ãœ', '&Uuml;', [rfReplaceAll]);
  memo1.Text := StringReplace(memo1.Text, 'Ü', '&Uuml;', [rfReplaceAll]);

  memo1.Text := StringReplace(memo1.Text, 'ÃŸ', '&szlig;', [rfReplaceAll]);
  memo1.Text := StringReplace(memo1.Text, 'ß', '&szlig;', [rfReplaceAll]);

  memo1.Text := StringReplace(memo1.Text, 'Ã³', '&oacute;', [rfReplaceAll]);
  memo1.Text := StringReplace(memo1.Text, 'ó', '&oacute;', [rfReplaceAll]);
end;

end.
