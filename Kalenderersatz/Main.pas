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
  CommCtrl, FullYearCalendar, Functions;

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

procedure TMainForm.Vordergrund;
begin
  Show;
  ShowWindow(Handle, SW_RESTORE);
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
