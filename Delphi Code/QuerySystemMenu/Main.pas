unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, QuerySystemMenu, Menus;

type
  TMainForm = class(TForm)
    CheckBox1: TCheckBox;
    Timer1: TTimer;
    Label1: TLabel;
    MainMenu1: TMainMenu;
    N12231: TMenuItem;
    N123124235425541: TMenuItem;
    N45koiaejfunsdkf1: TMenuItem;
    erlknf1: TMenuItem;
    fkjn1: TMenuItem;
    fe1: TMenuItem;
    flmnakwjfnajwrngl1: TMenuItem;
    ewfkjanwrgboinginrginaikrwngka1: TMenuItem;
    asdasdjknsafjnaskfnakjf1: TMenuItem;
    askfnjakfnkjasndfkjandf1: TMenuItem;
    fkjafnjkasndf1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure SysMenuOpened(Sender: TObject);
    procedure SysMenuClosed(Sender: TObject);
  private
    x: TQuerySystemMenu;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.SysMenuOpened(Sender: TObject);
begin
  CheckBox1.Checked := true;
  Label1.Caption := TimeToStr(Now());
end;

procedure TMainForm.SysMenuClosed(Sender: TObject);
begin
  CheckBox1.Checked := false;
  Label1.Caption := TimeToStr(Now());
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  x := TQuerySystemMenu.Create(Handle);
  x.OnSystemMenuOpen := SysMenuOpened;
  x.OnSystemMenuClose := SysMenuClosed;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  x.Destroy;
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
  // CheckBox1.Checked := x.IsSystemMenuOpened;
end;

end.
