unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

uses
  DragDropOpenDlg;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  x: TDragDropOpenDlg;
begin
  x := TDragDropOpenDlg.Create(self);
  try
    x.Options := x.Options + [ofAllowMultiSelect];
    if x.Execute then
    begin
      ShowMessage('Datei erhalten: ' + x.Files.Text);
    end;
  finally
    x.Free;
  end;
end;

end.
