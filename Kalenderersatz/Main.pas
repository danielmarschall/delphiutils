unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ShellAPI, Menus;

const
  WM_TASKABAREVENT = WM_USER+1; //Taskbar message

type
  TMainForm = class(TForm)
    PopupMenu1: TPopupMenu;
    Anzeigen1: TMenuItem;
    Beenden1: TMenuItem;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Anzeigen1Click(Sender: TObject);
    procedure Beenden1Click(Sender: TObject);
  private
    RealClose: boolean;
    procedure TaskbarEvent(var Msg: TMessage);
      Message WM_TASKABAREVENT;
    procedure OnQueryEndSession(var Msg: TWMQueryEndSession);
      message WM_QUERYENDSESSION ;
    procedure NotifyIconChange(dwMessage: Cardinal);
  protected
    cal: TMonthCalendar;
  public
    procedure Vordergrund;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  CommCtrl, FullYearCalendar;

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

procedure TMainForm.NotifyIconChange(dwMessage: Cardinal);
var
  NotifyIconData: TNotifyIconData;
begin
  Fillchar(NotifyIconData,Sizeof(NotifyIconData),0);
  NotifyIconData.cbSize := Sizeof(NotifyIconData);
  NotifyIconData.Wnd    := Handle;
  NotifyIconData.uFlags := NIF_MESSAGE
    or NIF_ICON
    or NIF_TIP;
  NotifyIconData.uCallbackMessage := WM_TASKABAREVENT;
  NotifyIconData.hIcon := Application.Icon.Handle;
  NotifyIconData.szTip := 'Kalender';
  Shell_NotifyIcon(dwMessage, @NotifyIconData);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  cal.Free;
  NotifyIconChange(NIM_DELETE);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  NotifyIconChange(NIM_ADD);

  cal := TFullYearCalendar.Create(Self);
  cal.Parent := Self;
  cal.WeekNumbers := true;

  ClientWidth := cal.Width;
  ClientHeight := cal.Height;
end;

// Ref: http://www.swissdelphicenter.ch/de/showcode.php?id=261

function ForceForegroundWindow(hwnd: THandle): Boolean;
const
  SPI_GETFOREGROUNDLOCKTIMEOUT = $2000;
  SPI_SETFOREGROUNDLOCKTIMEOUT = $2001;
var
  ForegroundThreadID: DWORD;
  ThisThreadID: DWORD;
  timeout: DWORD;
begin
  if IsIconic(hwnd) then ShowWindow(hwnd, SW_RESTORE);

  if GetForegroundWindow = hwnd then Result := True
  else
  begin
    // Windows 98/2000 doesn't want to foreground a window when some other
    // window has keyboard focus

    if ((Win32Platform = VER_PLATFORM_WIN32_NT) and (Win32MajorVersion > 4)) or
      ((Win32Platform = VER_PLATFORM_WIN32_WINDOWS) and
      ((Win32MajorVersion > 4) or ((Win32MajorVersion = 4) and
      (Win32MinorVersion > 0)))) then
    begin
      // Code from Karl E. Peterson, www.mvps.org/vb/sample.htm
      // Converted to Delphi by Ray Lischner
      // Published in The Delphi Magazine 55, page 16

      Result := False;
      ForegroundThreadID := GetWindowThreadProcessID(GetForegroundWindow, nil);
      ThisThreadID := GetWindowThreadPRocessId(hwnd, nil);
      if AttachThreadInput(ThisThreadID, ForegroundThreadID, True) then
      begin
        BringWindowToTop(hwnd); // IE 5.5 related hack
        SetForegroundWindow(hwnd);
        AttachThreadInput(ThisThreadID, ForegroundThreadID, False);
        Result := (GetForegroundWindow = hwnd);
      end;
      if not Result then
      begin
        // Code by Daniel P. Stasinski
        SystemParametersInfo(SPI_GETFOREGROUNDLOCKTIMEOUT, 0, @timeout, 0);
        SystemParametersInfo(SPI_SETFOREGROUNDLOCKTIMEOUT, 0, TObject(0),
          SPIF_SENDCHANGE);
        BringWindowToTop(hwnd); // IE 5.5 related hack
        SetForegroundWindow(hWnd);
        SystemParametersInfo(SPI_SETFOREGROUNDLOCKTIMEOUT, 0, TObject(timeout), SPIF_SENDCHANGE);
      end;
    end
    else
    begin
      BringWindowToTop(hwnd); // IE 5.5 related hack
      SetForegroundWindow(hwnd);
    end;

    Result := (GetForegroundWindow = hwnd);
  end;
end;

procedure TMainForm.Vordergrund;
begin
  Show;
  ForceForegroundWindow(Handle);
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

procedure TMainForm.Anzeigen1Click(Sender: TObject);
begin
  Vordergrund;
end;

procedure TMainForm.Beenden1Click(Sender: TObject);
begin
  RealClose := true;
  Close;
end;

end.
