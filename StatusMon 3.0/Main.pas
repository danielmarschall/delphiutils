unit Main;

(*

bug: wenn man einen eintrag ändert oder hinzufügt, werden alle "status" auf unknown zurückgesetzt
td: aktualisierenbutton/f5 erlauben
del-button...
icon: gray(internetdown),red,green
reg-write fehler erkennen

Future
------

- Rote Einträge bei Fehlern? (VCL Problem)
- XP Bubble verwenden?
- Toolbar / ApplicationEvents

*)

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ShellAPI, Menus, Registry, Grids, StdCtrls, ExtCtrls, ImgList;

const
  WM_TASKABAREVENT = WM_USER+1; //Taskbar message

type
  TMainForm = class(TForm)
    TrayPopupMenu: TPopupMenu;
    Anzeigen1: TMenuItem;
    Beenden1: TMenuItem;
    MonitorGrid: TStringGrid;
    MenuPopupMenu: TPopupMenu;
    Edit1: TMenuItem;
    Open1: TMenuItem;
    N1: TMenuItem;
    Delete1: TMenuItem;
    Ping1: TMenuItem;
    InitTimer: TTimer;
    LoopTimer: TTimer;
    Checknow1: TMenuItem;
    MainMenu: TMainMenu;
    MEntry: TMenuItem;
    MHelp: TMenuItem;
    MAbout: TMenuItem;
    MFile: TMenuItem;
    MClose: TMenuItem;
    MCloseAndExit: TMenuItem;
    MNewEntry: TMenuItem;
    N4: TMenuItem;
    MCheckAll: TMenuItem;
    MConfig: TMenuItem;
    MConnWarnOpt: TMenuItem;
    MInitTimeOpt: TMenuItem;
    MitWindowsstarten1: TMenuItem;
    N2: TMenuItem;
    MLoopTimeOpt: TMenuItem;
    MSpecs: TMenuItem;
    Open2: TMenuItem;
    Ping2: TMenuItem;
    Checknow2: TMenuItem;
    N3: TMenuItem;
    Edit2: TMenuItem;
    Delete2: TMenuItem;
    LastCheckPanel: TPanel;
    MUpdate: TMenuItem;
    UpdateTimer: TTimer;
    N5: TMenuItem;
    N6: TMenuItem;
    ImageList1: TImageList;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Anzeigen1Click(Sender: TObject);
    procedure Beenden1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MonitorGridDblClick(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure MonitorGridMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Edit1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure InitTimerTimer(Sender: TObject);
    procedure LoopTimerTimer(Sender: TObject);
    procedure Checknow1Click(Sender: TObject);
    procedure Ping1Click(Sender: TObject);
    procedure MCheckAllClick(Sender: TObject);
    procedure MAboutClick(Sender: TObject);
    procedure MLoopTimeOptClick(Sender: TObject);
    procedure MNewEntryClick(Sender: TObject);
    procedure MConnWarnOptClick(Sender: TObject);
    procedure MInitTimeOptClick(Sender: TObject);
    procedure MCloseClick(Sender: TObject);
    procedure MCloseAndExitClick(Sender: TObject);
    procedure MitWindowsstarten1Click(Sender: TObject);
    procedure MSpecsClick(Sender: TObject);
    procedure Open2Click(Sender: TObject);
    procedure Ping2Click(Sender: TObject);
    procedure Checknow2Click(Sender: TObject);
    procedure Edit2Click(Sender: TObject);
    procedure Delete2Click(Sender: TObject);
    procedure MUpdateClick(Sender: TObject);
    procedure UpdateTimerTimer(Sender: TObject);
  private
    RealClose: boolean;
    WarnAtConnectivityFailure: boolean;
    procedure TaskbarEvent(var Msg: TMessage);
      Message WM_TASKABAREVENT;
    procedure OnQueryEndSession(var Msg: TWMQueryEndSession);
      message WM_QUERYENDSESSION;
    procedure OnWmQuit(var Msg: TWMQuit);
      message WM_QUIT;
    procedure NotifyIconChange(dwMessage: Cardinal);
    procedure LoadConfig;
    procedure ProcessStatMon(i: integer; ShowSuccess: boolean);
    procedure ProcessAll(ShowSuccess: boolean);
    function GetCurrentMonitorName: string;
    function GetCurrentMonitorURL: string;
    procedure Vordergrund;
    procedure LoadList;
    function Status: boolean;
    // procedure RightAlignHelpMenuItem;
  end;

var
  MainForm: TMainForm;

implementation

{$R StatusMonManifest.res}

{$R *.dfm}

uses
  Functions, ServiceEdit, StatusMonFuncs, About, Common;

type
  TExtended = packed record
    Val: Extended;
    Err: boolean;
  end;

function StrToExtended(str: String): TExtended;
begin
  result.Err := false;
  result.Val := 0;
  try
    result.Val := StrToFloat(str);
  except
    result.Err := true;
  end;
end;

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
        GetCursorPos(Point);
        TrayPopupMenu.Popup(Point.x, Point.y);
      end;
  end;
end;

procedure TMainForm.UpdateTimerTimer(Sender: TObject);
begin
  UpdateTimer.Interval := 6*60*60*1000; // Alle 6 Stunden gucken wir mal
  VTSUpdateCheck('statusmon', '3.0', false, false);
end;

procedure TMainForm.MUpdateClick(Sender: TObject);
begin
  VTSUpdateCheck('statusmon', '3.0', true, true);
end;

procedure TMainForm.MNewEntryClick(Sender: TObject);
begin
  if EditForm.ShowDialog('') then LoadList;
end;

procedure TMainForm.MSpecsClick(Sender: TObject);
begin
  // ToDo
end;

procedure TMainForm.NotifyIconChange(dwMessage: Cardinal);
var
  NotifyIconData: TNotifyIconData;
  ico: TIcon;
begin
  Fillchar(NotifyIconData,Sizeof(NotifyIconData), 0);
  NotifyIconData.cbSize := Sizeof(NotifyIconData);
  NotifyIconData.Wnd    := Handle;
  NotifyIconData.uFlags := NIF_MESSAGE or NIF_ICON or NIF_TIP;
  NotifyIconData.uCallbackMessage := WM_TASKABAREVENT;

  ico := TIcon.Create;
  if Status then
    ImageList1.GetIcon(0, ico)
  else
    ImageList1.GetIcon(1, ico);
  NotifyIconData.hIcon := ico.Handle;

  NotifyIconData.szTip := 'ViaThinkSoft Status Monitor 3.0';
  Shell_NotifyIcon(dwMessage, @NotifyIconData);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  NotifyIconChange(NIM_DELETE);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  LastCheckPanel.Caption := Format(LNG_LAST_CHECK, [LNG_LAST_CHECK_UNKNOWN]);

  // RightAlignHelpMenuItem;

  NotifyIconChange(NIM_ADD);

  MonitorGrid.Rows[0].Add(LNG_COLUMN_NAME);
  MonitorGrid.Rows[0].Add(LNG_COLUMN_URL);
  MonitorGrid.Rows[0].Add(LNG_COLUMN_STATUS);

  // Default-Werte
  WarnAtConnectivityFailure := false;
  LoopTimer.Interval   := 1*60*60*1000;
  InitTimer.Interval   :=    5*60*1000;
  UpdateTimer.Interval :=    5*60*1000;

  LoadConfig;
end;

procedure TMainForm.Vordergrund;
begin
  Show;
  ShowWindow(Handle, SW_RESTORE);
  ForceForegroundWindow(Handle);
end;

procedure TMainForm.MLoopTimeOptClick(Sender: TObject);
var
  reg: TRegistry;
  x: string;
  e: TExtended;
begin
  reg := TRegistry.Create;
  try
    reg.RootKey := HKEY_CURRENT_USER;
    if reg.OpenKey(REG_KEY_SETTINGS, true) then
    begin
      x := InputBox(LNG_LOOP_TIME, LNG_INPUT_MINUTE_INTERVAL, IntToStr(round(LoopTimer.Interval/60/1000)));
      e := StrToExtended(x);
      if not e.Err and (e.Val > 0) then
      begin
        LoopTimer.Interval := Round(e.Val*60*1000);
        reg.WriteInteger(REG_VAL_LOOP_TIMER_INTERVAL, LoopTimer.Interval);
        MLoopTimeOpt.Caption := Format(LNG_LOOP_TIME_OPTION, [round(e.Val)]);
      end
      else
      begin
        MessageBox(Handle, PChar(LNG_ERROR), PChar(LNG_NO_POSITIVE_NUMBER_WITHOUT_ZERO), MB_ICONERROR or MB_OK);
      end;
    end;
  finally
    reg.Free;
  end;
end;

procedure TMainForm.MCheckAllClick(Sender: TObject);
begin
  ProcessAll(false);
  MessageBox(Handle, PChar(LNG_CHECKALL_FINISHED_TEXT), PChar(LNG_CHECKALL_FINISHED_CAPTION), MB_ICONINFORMATION or MB_OK);
end;

procedure TMainForm.Anzeigen1Click(Sender: TObject);
begin
  Vordergrund;
end;

procedure TMainForm.Beenden1Click(Sender: TObject);
begin
  MCloseAndExit.Click;
end;

procedure TMainForm.MAboutClick(Sender: TObject);
begin
  AboutForm.PopupParent := Screen.ActiveForm; // Workaround
  AboutForm.ShowModal;
end;

procedure TMainForm.LoadConfig;
var
  reg: TRegistry;
begin
  reg := TRegistry.Create;
  try
    reg.RootKey := HKEY_CURRENT_USER;
    if reg.OpenKeyReadOnly(REG_KEY_SETTINGS) then
    begin
      if reg.ValueExists(REG_VAL_INIT_TIMER_INTERVAL) then
        InitTimer.Interval := reg.ReadInteger(REG_VAL_INIT_TIMER_INTERVAL);

      if reg.ValueExists(REG_VAL_LOOP_TIMER_INTERVAL) then
        LoopTimer.Interval := reg.ReadInteger(REG_VAL_LOOP_TIMER_INTERVAL);

      if reg.ValueExists(REG_VAL_WARN_AT_CONNFAILURE) then
        WarnAtConnectivityFailure := reg.ReadBool(REG_VAL_WARN_AT_CONNFAILURE);

      reg.CloseKey;
    end;
  finally
    reg.Free;
  end;

  MInitTimeOpt.Caption := Format(LNG_INIT_TIME_OPTION, [round(InitTimer.Interval/1000/60)]);
  MLoopTimeOpt.Caption := Format(LNG_LOOP_TIME_OPTION, [round(LoopTimer.Interval/1000/60)]);
  MConnWarnOpt.Checked := WarnAtConnectivityFailure;
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
    if reg.OpenKeyReadOnly(REG_KEY_SERVICES) then
    begin
      reg.GetKeyNames(st);
      MonitorGrid.RowCount := st.Count + 1;
      for i := 0 to st.Count - 1 do
      begin
        if reg.OpenKeyReadOnly(Format(REG_KEY_SERVICE, [st.Strings[i]])) then
        begin
          MonitorGrid.Rows[i+1].Clear;
          MonitorGrid.Rows[i+1].Add(st.Strings[i]);
          MonitorGrid.Rows[i+1].Add(reg.ReadString(REG_VAL_URL));
          MonitorGrid.Rows[i+1].Add(LNG_STAT_UNKNOWN);
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
  ProcessAll(false);
end;

procedure TMainForm.MitWindowsstarten1Click(Sender: TObject);
begin
  ShowMessage('ToDo'); // ToDo
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  LoadList;
end;

procedure TMainForm.MInitTimeOptClick(Sender: TObject);
var
  reg: TRegistry;
  x: string;
  e: TExtended;
begin
  reg := TRegistry.Create;
  try
    reg.RootKey := HKEY_CURRENT_USER;
    if reg.OpenKey(REG_KEY_SETTINGS, true) then
    begin
      x := InputBox(LNG_INIT_TIME, LNG_INPUT_MINUTE_INTERVAL, IntToStr(round(InitTimer.Interval/60/1000)));
      e := StrToExtended(x);
      if not e.Err and (e.Val > 0) then
      begin
        InitTimer.Interval := Round(e.Val*60*1000);
        reg.WriteInteger(REG_VAL_INIT_TIMER_INTERVAL, InitTimer.Interval);
        MInitTimeOpt.Caption := Format(LNG_INIT_TIME_OPTION, [round(e.Val)]);
      end
      else
      begin
        MessageBox(Handle, PChar(LNG_ERROR), PChar(LNG_NO_POSITIVE_NUMBER_WITHOUT_ZERO), MB_ICONERROR or MB_OK);
      end;
    end;
  finally
    reg.Free;
  end;
end;

procedure TMainForm.InitTimerTimer(Sender: TObject);
begin
  InitTimer.Enabled := false;
  LoopTimer.Enabled := true;
end;

procedure TMainForm.MCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.MCloseAndExitClick(Sender: TObject);
begin
  if MessageBox(Handle, PChar(LNG_EXIT_TEXT), PChar(LNG_EXIT_CAPTION), MB_ICONQUESTION or MB_YESNOCANCEL) = IDYES then
  begin
    RealClose := true;
    Close;
  end;
end;

procedure TMainForm.MonitorGridDblClick(Sender: TObject);
begin
  Open1.Click;
end;

function TMainForm.GetCurrentMonitorName: string;
begin
  // result := MonitorGrid.Rows[MonitorGrid.Row].Strings[0];
  result := MonitorGrid.Cells[0, MonitorGrid.Row];
end;

function TMainForm.GetCurrentMonitorURL: string;
begin
  // result := MonitorGrid.Rows[MonitorGrid.Row].Strings[1];
  result := MonitorGrid.Cells[1, MonitorGrid.Row];
end;

procedure TMainForm.Open1Click(Sender: TObject);
begin
  Open2.Click;
end;

procedure TMainForm.Open2Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', PChar(GetCurrentMonitorURL), '', '', SW_SHOW)
end;

procedure TMainForm.Ping1Click(Sender: TObject);
begin
  Ping2.Click;
end;

procedure TMainForm.Ping2Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'ping', PChar(GetDomainNameByURL(GetCurrentMonitorURL)+' -t'), '', SW_NORMAL);
end;

procedure TMainForm.ProcessAll(ShowSuccess: boolean);
var
  i: integer;
begin
  for i := 1 to MonitorGrid.RowCount - 1 do
  begin
    MonitorGrid.Cells[2, i] := LNG_STAT_QUEUE;
  end;
  for i := 1 to MonitorGrid.RowCount - 1 do
  begin
    ProcessStatMon(i, ShowSuccess);
  end;
  LastCheckPanel.Caption := Format(LNG_LAST_CHECK, [DateTimeToStr(Now)]);
end;

procedure TMainForm.ProcessStatMon(i: integer; ShowSuccess: boolean);
var
  x: TMonitorState;
  MonitorUrl, ServerName: string;
begin
  ServerName := MonitorGrid.Rows[i].Strings[0];
  MonitorUrl := MonitorGrid.Rows[i].Strings[1];

  MonitorGrid.Rows[i].Strings[2] := LNG_STAT_CHECKING;
  Application.ProcessMessages;

  x := DeterminateMonitorState(MonitorUrl);

  if x = msOK then
  begin
    MonitorGrid.Rows[i].Strings[2] := LNG_STAT_OK;
    NotifyIconChange(NIM_MODIFY);
    if ShowSuccess then
    begin
      MessageBox(Handle, PChar(Format(LNG_ALERT_STATUS_OK, [ServerName, MonitorUrl])), PChar(LNG_CHECKALL_FINISHED_CAPTION), MB_ICONINFORMATION or MB_OK);
    end;
  end
  else if x = msStatusWarning then
  begin
    MonitorGrid.Rows[i].Strings[2] := LNG_STAT_WARNING;
    NotifyIconChange(NIM_MODIFY);
    if MessageBox(Handle, PChar(Format(LNG_ALERT_STATUS_WARNING, [ServerName, MonitorUrl])), PChar(LNG_ALERT_CAPTION), MB_ICONWARNING or MB_YESNOCANCEL) = IDYES then
    begin
      ShellExecute(Handle, 'open', PChar(MonitorUrl), '', '', SW_NORMAL);
    end;
  end
  else if x = msMonitorParseError then
  begin
    MonitorGrid.Rows[i].Strings[2] := LNG_STAT_PARSEERROR;
    NotifyIconChange(NIM_MODIFY);
    if MessageBox(Handle, PChar(Format(LNG_ALERT_MONITOR_FAILURE, [ServerName, MonitorUrl])), PChar(LNG_ALERT_CAPTION), MB_ICONWARNING or MB_YESNOCANCEL) = IDYES then
    begin
      ShellExecute(Handle, 'open', PChar(MonitorUrl), '', '', SW_NORMAL);
    end;
  end
  else if x = msMonitorGeneralError then
  begin
    MonitorGrid.Rows[i].Strings[2] := LNG_STAT_GENERALERROR;
    NotifyIconChange(NIM_MODIFY);
    if MessageBox(Handle, PChar(Format(LNG_ALERT_MONITOR_FAILURE, [ServerName, MonitorUrl])), PChar(LNG_ALERT_CAPTION), MB_ICONWARNING or MB_YESNOCANCEL) = IDYES then
    begin
      ShellExecute(Handle, 'open', PChar(MonitorUrl), '', '', SW_NORMAL);
    end;
  end
  else if x = msServerDown then
  begin
    MonitorGrid.Rows[i].Strings[2] := LNG_STAT_SERVERDOWN;
    NotifyIconChange(NIM_MODIFY);
    // Es besteht eine Internetverbindung, daher ist wohl was mit dem
    // Server nicht in Ordnung

    if MessageBox(Handle, PChar(Format(LNG_ALERT_SERVER_DOWN, [ServerName, MonitorUrl])), PChar(LNG_ALERT_CAPTION), MB_ICONWARNING or MB_YESNOCANCEL) = IDYES then
    begin
      Ping1.Click;
    end;
  end
  else if x = msInternetBroken then
  begin
    MonitorGrid.Rows[i].Strings[2] := LNG_STAT_INTERNETBROKEN;
    NotifyIconChange(NIM_MODIFY);
    if not WarnAtConnectivityFailure then
    begin
      if MessageBox(Handle, PChar(Format(LNG_ALERT_CONNECTIVITY_FAILURE, [ServerName, MonitorUrl])), PChar(LNG_ALERT_CAPTION), MB_ICONWARNING or MB_YESNOCANCEL) = IDYES then
      begin
        Ping1.Click;
      end;
    end;
  end;
end;

function TMainForm.Status: boolean;
var
  i: integer;
  s: string;
begin
  for i := 1 to MonitorGrid.RowCount - 1 do
  begin
    s := MonitorGrid.Cells[2, i];
    if (s <> LNG_STAT_OK) and (s <> LNG_STAT_UNKNOWN) and
       (s <> LNG_STAT_QUEUE) and (s <> LNG_STAT_CHECKING) and
       (s <> '') then
    begin
      result := false;
      exit;
    end;
  end;
  result := true;
end;

// Ref: http://delphi.about.com/od/adptips2006/qt/rightalignmenu.htm
(* procedure TMainForm.RightAlignHelpMenuItem;
var
  mii: TMenuItemInfo;
  hMainMenu: hMenu;
  Buffer: array[0..79] of Char;
begin
  hMainMenu := Self.Menu.Handle;

  //GET Help Menu Item Info
  mii.cbSize := SizeOf(mii) ;
  mii.fMask := MIIM_TYPE;
  mii.dwTypeData := Buffer;
  mii.cch := SizeOf(Buffer) ;
  GetMenuItemInfo(hMainMenu, MHelp.Command, false, mii) ;

  //SET Help Menu Item Info
  mii.fType := mii.fType or MFT_RIGHTJUSTIFY;
  SetMenuItemInfo(hMainMenu, MHelp.Command, false, mii) ;
end; *)

procedure TMainForm.MonitorGridMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  col, row: integer;
begin
  if Button = mbRight then
  begin
    MonitorGrid.MouseToCell(X, Y, col, row);
    if row >= MonitorGrid.FixedRows then
      MonitorGrid.Row := row;

    if col >= MonitorGrid.FixedCols then
      MonitorGrid.Col := col;

    if (row >= MonitorGrid.FixedRows) and
       (col >= MonitorGrid.FixedCols) then
    begin
      MonitorGrid.PopupMenu := MenuPopupMenu;
    end
    else
    begin
      MonitorGrid.PopupMenu := nil;
    end;
  end;
end;

procedure TMainForm.Edit1Click(Sender: TObject);
begin
  Edit2.Click;
end;

procedure TMainForm.Edit2Click(Sender: TObject);
begin
  if EditForm.ShowDialog(GetCurrentMonitorName) then LoadList;
end;

procedure TMainForm.Delete2Click(Sender: TObject);
var
  reg: TRegistry;
begin
  if MessageBox(Handle, PChar(Format(LNG_DELETE_TEXT, [GetCurrentMonitorName])), PChar(LNG_DELETE_CAPTION), MB_ICONQUESTION or MB_YESNOCANCEL) = IDYES then
  begin
    reg := TRegistry.Create;
    try
      reg.RootKey := HKEY_CURRENT_USER;
      if reg.DeleteKey(Format(REG_KEY_SERVICE, [GetCurrentMonitorName])) then LoadList;
    finally
      reg.Free;
    end;
  end;
end;

procedure TMainForm.Delete1Click(Sender: TObject);
begin
  Delete2.Click;
end;

procedure TMainForm.Checknow1Click(Sender: TObject);
begin
  Checknow2.Click;
end;

procedure TMainForm.Checknow2Click(Sender: TObject);
begin
  ProcessStatMon(MonitorGrid.Row, true);
end;

procedure TMainForm.MConnWarnOptClick(Sender: TObject);
var
  reg: TRegistry;
begin
  reg := TRegistry.Create;
  try
    reg.RootKey := HKEY_CURRENT_USER;
    if reg.OpenKey(REG_KEY_SETTINGS, true) then
    begin
      WarnAtConnectivityFailure := MConnWarnOpt.Checked;
      reg.WriteBool(REG_VAL_WARN_AT_CONNFAILURE, WarnAtConnectivityFailure);
    end;
  finally
    reg.Free;
  end;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  Hide;
  CanClose := RealClose;
end;

procedure TMainForm.OnQueryEndSession(var Msg: TWMQueryEndSession);
begin
  RealClose := true;
  Close;
  Msg.Result := 1;
end;

procedure TMainForm.OnWmQuit(var Msg: TWMQuit);
begin
  RealClose := true;
  Close;
  Msg.Result := 1;
end;

end.
