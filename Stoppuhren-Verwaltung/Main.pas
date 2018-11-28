unit MAIN;

// TODO: Wenn man das Hauptfenster schlieﬂt, sollen nicht alle Uhren meckern
// TODO: Uhrzeiten abspeichern?
// TODO: Uhrzeitenwert manuell ‰nderbar machen?
// TODO: Automatische Fenster-Anordnung funktioniert nicht korrekt mit poDefaultSizeOnly

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, Menus,
  StdCtrls, Dialogs, Buttons, Messages, ExtCtrls, ComCtrls, StdActns,
  ActnList, ToolWin, ImgList;

type
  TMainForm = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    FileNewItem: TMenuItem;
    FileCloseItem: TMenuItem;
    Window1: TMenuItem;
    Help1: TMenuItem;
    N1: TMenuItem;
    FileExitItem: TMenuItem;
    WindowCascadeItem: TMenuItem;
    WindowTileItem: TMenuItem;
    WindowArrangeItem: TMenuItem;
    HelpAboutItem: TMenuItem;
    OpenDialog: TOpenDialog;
    WindowMinimizeItem: TMenuItem;
    StatusBar: TStatusBar;
    ActionList1: TActionList;
    FileNew1: TAction;
    FileExit1: TAction;
    WindowCascade1: TWindowCascade;
    WindowTileHorizontal1: TWindowTileHorizontal;
    WindowArrangeAll1: TWindowArrange;
    WindowMinimizeAll1: TWindowMinimizeAll;
    HelpAbout1: TAction;
    FileClose1: TWindowClose;
    WindowTileVertical1: TWindowTileVertical;
    WindowTileItem2: TMenuItem;
    ToolBar2: TToolBar;
    ToolButton9: TToolButton;
    ToolButton8: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ImageList1: TImageList;
    Einstellungen1: TMenuItem;
    NureineUhrgleichzeitig1: TMenuItem;
    AlleUhrenstoppen1: TMenuItem;
    N2: TMenuItem;
    procedure FileNew1Execute(Sender: TObject);
    procedure FileOpen1Execute(Sender: TObject);
    procedure HelpAbout1Execute(Sender: TObject);
    procedure FileExit1Execute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure NureineUhrgleichzeitig1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure AlleUhrenstoppen1Click(Sender: TObject);
  private
    procedure CreateMDIChild(const Name: string);
  public
    procedure StopAllTimers;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses CHILDWIN, about, IniFiles;

var
  StopUhrCount: integer = 1;

procedure TMainForm.AlleUhrenstoppen1Click(Sender: TObject);
begin
  StopAllTimers;
end;

procedure TMainForm.CreateMDIChild(const Name: string);
var
  Child: TMDIChild;
begin
  Child := TMDIChild.Create(Application);
  Child.Caption := Name;
  Child.Memo1.Lines.Text := Name;
end;

procedure TMainForm.FileNew1Execute(Sender: TObject);
begin
  CreateMDIChild('Stoppuhr #' + IntToStr(StopUhrCount));
  Inc(StopUhrCount);
end;

procedure TMainForm.FileOpen1Execute(Sender: TObject);
begin
  if OpenDialog.Execute then
    CreateMDIChild(OpenDialog.FileName);
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  // Brauchen wir nicht, da die einzelnen MDI-Fenster ja schon meckern
  //CanClose := MessageDlg('Programm wirklich beenden?', mtConfirmation, mbYesNoCancel, 0) = mrYes;
end;

procedure TMainForm.FormShow(Sender: TObject);
var
  x: TMemIniFile;
begin
  x := TMemIniFile.Create('Settings.ini');
  try
    NureineUhrgleichzeitig1.Checked := x.ReadBool('Settings', 'SingleClockMode', false);
  finally
    FreeAndNil(x);
  end;
end;

procedure TMainForm.HelpAbout1Execute(Sender: TObject);
begin
  AboutBox.ShowModal;
end;

procedure TMainForm.NureineUhrgleichzeitig1Click(Sender: TObject);
var
  x: TMemIniFile;
begin
  x := TMemIniFile.Create('Settings.ini');
  try
    x.WriteBool('Settings', 'SingleClockMode', NureineUhrgleichzeitig1.Checked);
    x.UpdateFile;
  finally
    FreeAndNil(x);
  end;
end;

procedure TMainForm.StopAllTimers;
var
  i: integer;
begin
  for i := 0 to MDIChildCount - 1 do
  begin
    TMdiChild(MDIChildren[i]).StopTimer;
  end;
end;

procedure TMainForm.FileExit1Execute(Sender: TObject);
begin
  Close;
end;

end.
