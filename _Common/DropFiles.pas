unit DropFiles;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm2 = class(TForm)
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
  private
    procedure HandleDroppedFile(acFileName: string);
  public
    procedure DropFiles( var msg : TMessage );
      message WM_DROPFILES;
    procedure SetMsg(s: string);
    procedure SetCap(s: string);
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

uses
  ShellAPI;

procedure TForm2.HandleDroppedFile(acFileName: string);
begin
  // Showmessage(acFileName);
  ShellExecute(Handle, 'open', PChar('"'+Application.ExeName+'"'), PChar('"'+acFileName+'"'), PChar('"'+ExtractFilePath(Application.ExeName)+'"'), SW_NORMAL);

  // Das ist Ansichtssache
  // Close;
end;

// Ref: http://www.chami.com/tips/delphi/111196D.html

(*

  public
    procedure DropFiles( var msg : TMessage );
      message WM_DROPFILES;

*)

procedure TForm2.DropFiles( var msg : TMessage );
const
  cnMaxFileNameLen = 255;
var
  i,
  nCount     : integer;
  acFileName : array [0..cnMaxFileNameLen] of char;
begin
  nCount := DragQueryFile( msg.WParam,
                           $FFFFFFFF,
                           acFileName,
                           cnMaxFileNameLen );

  for i := 0 to nCount-1 do
  begin
    DragQueryFile( msg.WParam, i,
                   acFileName, cnMaxFileNameLen );

    HandleDroppedFile(acFileName);
  end;

  DragFinish( msg.WParam );
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  DragAcceptFiles( Handle, True );
end;

procedure TForm2.SetMsg(s: string);
begin
  Memo1.Text := s;
end;

procedure TForm2.SetCap(s: string);
begin
  Caption := s + ' - ' + Caption;
end;

end.
