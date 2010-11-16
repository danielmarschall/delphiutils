unit ServiceEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Registry;

type
  TEditForm = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    OriginalValue: String;
  public
    function ShowDialog(AServiceName: string): boolean;
  end;

var
  EditForm: TEditForm;

implementation

{$R *.dfm}

uses
  Common;

procedure TEditForm.Button1Click(Sender: TObject);
var
  reg: TRegistry;
begin
  reg := TRegistry.Create;
  try
    reg.RootKey := HKEY_CURRENT_USER;
    if reg.OpenKey(REG_KEY_SERVICES, true) then
    begin
      if OriginalValue <> '' then
      begin
        reg.DeleteKey(OriginalValue);
      end;
      if reg.OpenKey(Edit1.Text, true) then
      begin
        reg.WriteString(REG_VAL_URL, Edit2.Text);
      end;
      reg.CloseKey;
    end;
  finally
    reg.Free;
  end;

  ModalResult := mrOk;
end;

procedure TEditForm.Button2Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

function TEditForm.ShowDialog(AServiceName: string): boolean;
var
  reg: TRegistry;
begin
  Edit1.Text := AServiceName;
  OriginalValue := AServiceName;

  if AServiceName = '' then
    Caption := LNG_MONITOR_NEW
  else
    Caption := LNG_MONITOR_EDIT;

  reg := TRegistry.Create;
  try
    reg.RootKey := HKEY_CURRENT_USER;
    if reg.OpenKeyReadOnly(REG_KEY_SERVICES) then
    begin
      if reg.OpenKeyReadOnly(AServiceName) then
      begin
        Edit2.Text := reg.ReadString(REG_VAL_URL);
      end;
      reg.CloseKey;
    end;
  finally
    reg.Free;
  end;

  Show;
  Edit1.SetFocus;
  Hide;

  Result := ShowModal() = mrOk;
end;

end.
