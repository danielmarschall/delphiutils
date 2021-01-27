unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    Label1: TLabel;
    Edit1: TEdit;
    CheckBox1: TCheckBox;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    Label4: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    procedure FixShortcut(linkdatei: string);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  ShellApi, ActiveX, SHFolder, ShlObj, ComObj, ioUtils;

procedure TForm1.FixShortcut(linkdatei: string);
var
  UN: IUnknown;
  SL: IShellLink;
  PF: IPersistFile;
  FD: TWin32FindData;
  buf: array[0..MAX_PATH] of char;
  x, y: string;
  w: WideString;
  SR: TSearchRec;
  SEARCH_BEGIN: string;
  REPLACE_BEGIN: string;
begin
  UN:=CreateComObject(CLSID_ShellLink);
  SL:=UN as IShellLink;
  PF:=UN as IPersistFile;
  w:=linkdatei;
  OleCheck(PF.Load(PwideChar(w),STGM_READ));
  OleCheck(SL.GetPath(buf,MAX_PATH,FD,SLGP_UNCPRIORITY));
  x := buf;

  SEARCH_BEGIN := Edit2.Text;
  REPLACE_BEGIN := Edit3.Text;

  if SameText(SEARCH_BEGIN,Copy(x,1,Length(SEARCH_BEGIN))) then
  begin
    y := StringReplace(x,SEARCH_BEGIN,REPLACE_BEGIN,[rfIgnoreCase]);
    if x <> y then
    begin
      memo1.lines.add(x+' => '+y);

      SL.SetPath(PChar(y));
      SL.SetWorkingDirectory(PChar(ExtractFilePath(y)));

      // Write lnk file
      OleCheck(PF.Save(PWideChar(w), false));
    end;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  s: string;
  so: TSearchOption;
begin
  if CheckBox1.Checked then so := TSearchOption.soAllDirectories else so := TSearchOption.soTopDirectoryOnly;
  for s in TDirectory.GetFiles(Edit1.text, '*.lnk', so) do
  begin
    memo1.Lines.add(s);
    FixShortcut(s);
  end;
  ShowMessage('Done');
end;

end.
