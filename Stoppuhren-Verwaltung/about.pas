unit about;

interface

uses Windows, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
  TAboutBox = class(TForm)
    Panel1: TPanel;
    OKButton: TButton;
    ProgramIcon: TImage;
    ProductName: TLabel;
    Version: TLabel;
    Copyright: TLabel;
    Comments: TLabel;
    Label1: TLabel;
    procedure Label1Click(Sender: TObject);
  end;

var
  AboutBox: TAboutBox;

implementation

{$R *.dfm}

uses
  ShellAPI;

procedure TAboutBox.Label1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'https://www.viathinksoft.de/', '', '', SW_NORMAL);
end;

end.

