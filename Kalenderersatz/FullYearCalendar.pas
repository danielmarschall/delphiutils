unit FullYearCalendar;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, ComCtrls;

// TODO: Buggy if you select a month directly (click at the month name)
//       -- since the months are fixed, this functionality should be disabled by Windows!
// TODO: Multiselect führt zu einem Fehler ...
//       -- Grund: Das springen zum Jahresende und Jahresanfang
//       -- Also: Only 30 days selectable
// TODO: Die wahre Größe für 12 Monate feststellen ... wie?
// TODO: MaxSelectRange sollte 365 oder 366 sein...

type
  TFullYearCalendar = class(TMonthCalendar)
  private
    function GetDate: TDate;
    procedure SetDate(Value: TDate);
    function GetDateTime: TDateTime;
    procedure SetDateTime(Value: TDateTime);
    procedure CNNotify(var Message: TWMNotify); message CN_NOTIFY;
  public
    constructor Create(AOwner: TComponent); override;
  protected
    property DateTime: TDateTime read GetDateTime write SetDateTime;
  published
    property Date: TDate read GetDate write SetDate;
  end;

procedure Register;

implementation

uses
  DateUtils, CommCtrl;

function TFullYearCalendar.GetDate: TDate;
begin
  result := inherited Date;
end;

procedure TFullYearCalendar.SetDate(Value: TDate);
begin
  if YearOf(Value) <> YearOf(Date) then
  begin
    // User has scrolled.
    // The problem is, that the scrolling does not use Date as the source,
    // instead it takes the left top month as source. So, every scrolling
    // would set the month to January!

    if MonthOf(DateTime) <> 1 then
    begin
      Value := IncMonth(Value, MonthOf(DateTime)-1);
    end;
  end;

  // We want to have January always on left top!
  // Warning: Does not work if the control is too small.
  if not MultiSelect then
  begin
    inherited Date := EndOfTheYear(Value);
    inherited Date := StartOfTheYear(Value);
  end;

  // Then jump to our desired date
  inherited Date := Value;
end;

function TFullYearCalendar.GetDateTime: TDateTime;
begin
  result := Date;
end;

procedure TFullYearCalendar.SetDateTime(Value: TDateTime);
begin
  Date := Value;
end;

constructor TFullYearCalendar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  // Checked with Windows 2000
  // Warning: Does not work if you use larger fonts!
  // TODO: Is there any way to determinate the real width and height of a full year?
//  Width := 666;
//  Height := 579;
  Width := 724;
  Height := 500;

  Constraints.MinWidth := Width;
  Constraints.MinHeight := Height;

  // Only jump in years
  MonthDelta := 12;
end;

procedure Register;
begin
  RegisterComponents('Beispiele', [TFullYearCalendar]);
end;

// Copied from ComCtrls.pas
function IsBlankSysTime(const ST: TSystemTime): Boolean;
type
  TFast = array [0..3] of DWORD;
begin
  Result := (TFast(ST)[0] or TFast(ST)[1] or TFast(ST)[2] or TFast(ST)[3]) = 0;
end;

// Copied from ComCtrls.pas - modified
// This is necessary, so that our "Date" will be changed when the user scrolls!
procedure TFullYearCalendar.CNNotify(var Message: TWMNotify);
var
  ST: PSystemTime;
  //I, MonthNo: Integer;
  //CurState: PMonthDayState;
begin
  with Message, NMHdr^ do
  begin
    case code of
      (* MCN_GETDAYSTATE:
        with PNmDayState(NMHdr)^ do
        begin
          FillChar(prgDayState^, cDayState * SizeOf(TMonthDayState), 0);
          if Assigned(FOnGetMonthInfo) then
          begin
            CurState := prgDayState;
            for I := 0 to cDayState - 1 do
            begin
              MonthNo := stStart.wMonth + I;
              if MonthNo > 12 then MonthNo := MonthNo - 12;
              FOnGetMonthInfo(Self, MonthNo, CurState^);
              Inc(CurState);
            end;
          end;
        end; *)
      MCN_SELECT, MCN_SELCHANGE:
        begin
          ST := @PNMSelChange(NMHdr).stSelStart;
          if not IsBlankSysTime(ST^) then
            (*F*)DateTime := SystemTimeToDateTime(ST^);
          if (*F*)MultiSelect then
          begin
            ST := @PNMSelChange(NMHdr).stSelEnd;
            if not IsBlankSysTime(ST^) then
              (*F*)EndDate := SystemTimeToDateTime(ST^);
          end;
        end;
    end;
  end;
  inherited;
end;

end.
