unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ShellAPI, Menus, Registry, Grids, StdCtrls, ExtCtrls;

const
  WM_TASKABAREVENT = WM_USER+1; //Taskbar message

type
  TMainForm = class(TForm)
    PopupMenu1: TPopupMenu;
    Anzeigen1: TMenuItem;
    Beenden1: TMenuItem;
    StringGrid1: TStringGrid;
    Panel1: TPanel;
    Panel2: TPanel;
    PopupMenu2: TPopupMenu;
    Edit1: TMenuItem;
    Open1: TMenuItem;
    Button3: TButton;
    N1: TMenuItem;
    Delete1: TMenuItem;
    Button5: TButton;
    New1: TMenuItem;
    N2: TMenuItem;
    Ping1: TMenuItem;
    InitTimer: TTimer;
    LoopTimer: TTimer;
    Checknow1: TMenuItem;
    Button1: TButton;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Anzeigen1Click(Sender: TObject);
    procedure Beenden1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure StringGrid1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Edit1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure New1Click(Sender: TObject);
    procedure InitTimerTimer(Sender: TObject);
    procedure LoopTimerTimer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    RealClose: boolean;
    WarnAtConnectivityFailure: boolean;
    procedure TaskbarEvent(var Msg: TMessage);
      Message WM_TASKABAREVENT;
    procedure OnQueryEndSession(var Msg: TWMQueryEndSession);
      message WM_QUERYENDSESSION;
    procedure NotifyIconChange(dwMessage: Cardinal);
    procedure LoadConfig;
    procedure ProcessStatMon(MonitorUrl, ServerName: string; Silent: boolean);
    procedure ProcessAll(Silent: boolean);
  public
    procedure Vordergrund;
    procedure LoadList;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  Functions,
  ServiceEdit,
  StatusMonFuncs;

// Ref: http://www.delphi-fundgrube.de/faq01.htm

procedure TMainForm.TaskbarEvent(var Msg: TMessage);
var
  Point: TPoint;
begin

  { Die WM_TaskbarEvent-Message "Msg" gibt in Msg.LParam
    das genaue Ereignis an. Msg.LParam kann folgende Werte für
    Mausereignisse annehmen:

    WM_MouseMove
    WM_LButtonDown
    WM_LButtonUp
    WM_LButtonDblClk
    WM_RButtonDown
    WM_RButtonUp
    WM_RButtonDblClk }

  case Msg.LParam of
    WM_LButtonDblClk:
      begin
        Vordergrund;
      end;
    WM_RButtonUp:
      begin
        // Rechtsklick
        // Diese Zeile ist wichtig, damit das PopupMenu korrekt
        // wieder geschlossen wird:
        SetForegroundWindow(Handle);
        // PopupMenu anzeigen:
        GetCursorPos(Point);
        PopupMenu1.Popup(Point.x, Point.y);
        //oder ohne Variable Point:
        //PopupMenu1.Popup(Mouse.CursorPos.x, Mouse.CursorPos.y);
      end;
  end;
end;

procedure TMainForm.New1Click(Sender: TObject);
begin
  if EditForm.ShowDialog('') then LoadList;
end;

procedure TMainForm.NotifyIconChange(dwMessage: Cardinal);
var
  NotifyIconData: TNotifyIconData;
begin
  Fillchar(NotifyIconData,Sizeof(NotifyIconData), 0);
  NotifyIconData.cbSize := Sizeof(NotifyIconData);
  NotifyIconData.Wnd    := Handle;
  NotifyIconData.uFlags := NIF_MESSAGE or NIF_ICON or NIF_TIP;
  NotifyIconData.uCallbackMessage := WM_TASKABAREVENT;
  NotifyIconData.hIcon := Application.Icon.Handle;
  NotifyIconData.szTip := 'ViaThinkSoft Status Monitor 3.0';
  Shell_NotifyIcon(dwMessage, @NotifyIconData);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  NotifyIconChange(NIM_DELETE);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  NotifyIconChange(NIM_ADD);

  StringGrid1.Rows[0].Add('Name');
  StringGrid1.Rows[0].Add('URL');
  StringGrid1.Rows[0].Add('Status');

  LoadConfig;
end;

procedure TMainForm.Vordergrund;
begin
  Show;
  ShowWindow(Handle, SW_RESTORE);
  ForceForegroundWindow(Handle);
end;

procedure TMainForm.Anzeigen1Click(Sender: TObject);
begin
  Vordergrund;
end;

procedure TMainForm.Beenden1Click(Sender: TObject);
begin
  RealClose := true;
  Close;
end;

procedure TMainForm.LoadConfig;
var
  reg: TRegistry;
begin
  reg := TRegistry.Create;
  try
    reg.RootKey := HKEY_CURRENT_USER;
    if reg.OpenKeyReadOnly('\Software\ViaThinkSoft\StatusMon\3.0\Settings\') then
    begin
      InitTimer.Interval := reg.ReadInteger('InitTimerInterval');
      LoopTimer.Interval := reg.ReadInteger('LoopTimerInterval');
      WarnAtConnectivityFailure := reg.ReadBool('WarnAtConnectivityFailure');
      reg.CloseKey;
    end;
  finally
    reg.Free;
  end;
end;

procedure TMainForm.LoadList;
var
  reg: TRegistry;
  st: TStringList;
  i: Integer;
begin
  reg := TRegistry.Create;
  st := TStringList.Create;
  try
    reg.RootKey := HKEY_CURRENT_USER;
    if reg.OpenKeyReadOnly('\Software\ViaThinkSoft\StatusMon\3.0\Services\') then
    begin
      reg.GetKeyNames(st);
      StringGrid1.RowCount := st.Count + 1;
      for i := 0 to st.Count - 1 do
      begin
        if reg.OpenKeyReadOnly('\Software\ViaThinkSoft\StatusMon\3.0\Services\'+st.Strings[i]+'\') then
        begin
          StringGrid1.Rows[i+1].Clear;
          StringGrid1.Rows[i+1].Add(st.Strings[i]);
          StringGrid1.Rows[i+1].Add(reg.ReadString('URL'));
          StringGrid1.Rows[i+1].Add('Unknown');
        end;
      end;
      reg.CloseKey;
    end;
  finally
    st.Free;
    reg.Free;
  end;
end;

procedure TMainForm.LoopTimerTimer(Sender: TObject);
begin
  ProcessAll(true);
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  LoadList;
end;

procedure TMainForm.InitTimerTimer(Sender: TObject);
begin
  InitTimer.Enabled := false;
  LoopTimer.Enabled := true;
end;

procedure TMainForm.StringGrid1DblClick(Sender: TObject);
begin
  Open1.Click;
end;

procedure TMainForm.Open1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', PChar(StringGrid1.Rows[StringGrid1.Row].Strings[1]), '', '', SW_SHOW)
end;

procedure TMainForm.ProcessAll(Silent: boolean);
var
  i: integer;
begin
  for i := 1 to StringGrid1.RowCount - 1 do
  begin
    ProcessStatMon(StringGrid1.Rows[i].Strings[1], StringGrid1.Rows[i].Strings[0], Silent);
  end;
end;

procedure TMainForm.ProcessStatMon(MonitorUrl, ServerName: string;
  Silent: boolean);
resourcestring
  LNG_CAPTION = 'Status Monitor Alert';
  LNG_CAPTION_OK = 'Status Monitor Check';
  LNG_STATUS_WARNING = 'Der Status-Monitor "%s" meldet ein Problem! Status-Monitor jetzt öffnen?' + #13#10#13#10 + 'Monitor-URL: %s';
  LNG_STATUS_OK = 'Es existieren keine Probleme mit Status-Monitor "%s"' + #13#10#13#10 + 'Monitor-URL: %s';
  LNG_MONITOR_FAILURE = 'Die Ausgabe des Status-Monitors "%s" kann nicht interpretiert werden! Status-Monitor jetzt öffnen?' + #13#10#13#10 + 'Monitor-URL: %s';
  LNG_CONNECTIVITY_FAILURE = 'Der Status von "%s" konnte nicht überprüft werden, da keine Internetverbindung besteht! Ping-Fenster öffnen?' + #13#10#13#10 + 'Monitor-URL: %s';
  LNG_SERVER_DOWN = 'Es konnte keine Verbindung zum Status-Monitor "%s" hergestellt werden, OBWOHL eine Internetverbindung besteht! Ping-Fenster öffnen?' + #13#10#13#10 + 'Monitor-URL: %s';
var
  x: TMonitorState;
begin
  x := DeterminateMonitorState(MonitorUrl);

  if x = msOK then
  begin
    MessageBox(Handle, PChar(Format(LNG_STATUS_OK, [ServerName, MonitorUrl])), PChar(LNG_CAPTION_OK), MB_ICONINFORMATION or MB_OK);
  end
  else if x = msStatusWarning then
  begin
    if MessageBox(Handle, PChar(Format(LNG_STATUS_WARNING, [ServerName, MonitorUrl])), PChar(LNG_CAPTION), MB_ICONWARNING or MB_YESNOCANCEL) = IDYES then
    begin
      ShellExecute(Handle, 'open', PChar(MonitorUrl), '', '', SW_NORMAL);
    end;
  end
  else if x = msMonitorFailure then
  begin
    if MessageBox(Handle, PChar(Format(LNG_MONITOR_FAILURE, [ServerName, MonitorUrl])), PChar(LNG_CAPTION), MB_ICONWARNING or MB_YESNOCANCEL) = IDYES then
    begin
      ShellExecute(Handle, 'open', PChar(MonitorUrl), '', '', SW_NORMAL);
    end;
  end
  else if x = msServerDown then
  begin
    // Es besteht eine Internetverbindung, daher ist wohl was mit dem
    // Server nicht in Ordnung

    if MessageBox(Handle, PChar(Format(LNG_SERVER_DOWN, [ServerName, MonitorUrl])), PChar(LNG_CAPTION), MB_ICONWARNING or MB_YESNOCANCEL) = IDYES then
    begin
      ShellExecute(Handle, 'open', 'ping', PChar(GetDomainNameByURL(MonitorURL)+' -t'), '', SW_NORMAL);
    end;
  end
  else if x = msInternetBroken then
  begin
    if not WarnAtConnectivityFailure then
    begin
      if MessageBox(Handle, PChar(Format(LNG_CONNECTIVITY_FAILURE, [ServerName, MonitorUrl])), PChar(LNG_CAPTION), MB_ICONWARNING or MB_YESNOCANCEL) = IDYES then
      begin
        ShellExecute(Handle, 'open', 'ping', PChar(GetDomainNameByURL(MonitorURL)+' -t'), '', SW_NORMAL);
      end;
    end;
  end;
end;

procedure TMainForm.StringGrid1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  col, row: integer;
begin
  if Button = mbRight then
  begin
    stringgrid1.MouseToCell(X, Y, col, row);
    if row >= stringgrid1.FixedRows then
      stringgrid1.Row := row;

    if col >= stringgrid1.FixedCols then
      stringgrid1.Col := col;

    if (row >= stringgrid1.FixedRows) and
       (col >= stringgrid1.FixedCols) then
    begin
      StringGrid1.PopupMenu := PopupMenu2;
    end
    else
    begin
      StringGrid1.PopupMenu := nil;
    end;
  end;
end;

procedure TMainForm.Edit1Click(Sender: TObject);
begin
  if EditForm.ShowDialog(StringGrid1.Rows[StringGrid1.Row].Strings[0]) then LoadList;
end;

procedure TMainForm.Delete1Click(Sender: TObject);
resourcestring
  LNG_DELETE = 'Statusmonitor "%s" wirklich löschen?';
  LNG_CAPTION = 'Lösch-Bestätigung';
var
  reg: TRegistry;
  Val: String;
begin
  Val := StringGrid1.Cells[0, StringGrid1.Row];

  if MessageBox(Handle, PChar(Format(LNG_DELETE, [Val])), PChar(LNG_CAPTION), MB_ICONQUESTION or MB_YESNOCANCEL) = IDYES then
  begin
    reg := TRegistry.Create;
    try
      reg.RootKey := HKEY_CURRENT_USER;
      if reg.DeleteKey('\Software\ViaThinkSoft\StatusMon\3.0\Services\'+Val+'\') then LoadList;
    finally
      reg.Free;
    end;
  end;
end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  ProcessAll(false);
end;

procedure TMainForm.Button5Click(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  Hide;
  CanClose := RealClose;
end;

procedure TMainForm.OnQueryEndSession;
begin
  RealClose := true;
  Close;
  Msg.Result := 1;
end;

end.
