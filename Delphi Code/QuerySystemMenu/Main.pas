unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, QuerySystemMenu;

type
  TMainForm = class(TForm)
    CheckBox1: TCheckBox;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    x: TQuerySystemMenu;
  public
    { Public-Deklarationen }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  x := TQuerySystemMenu.Create(Handle);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  x.Destroy;
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
  CheckBox1.Checked := x.IsSystemMenuOpened;
end;

end.
