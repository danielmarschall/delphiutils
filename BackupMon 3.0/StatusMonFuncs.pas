unit StatusMonFuncs;

interface

uses
  SysUtils, IdHTTP;

type
  TMonitorState = (msOK, msStatusWarning, msMonitorFailure,
    msServerDown, msInternetBroken);

function DeterminateMonitorState(MonitorUrl: String): TMonitorState;

implementation

function InternetConnectivity(): boolean;
resourcestring
  INTERNET_CHECK_URL = 'http://www.google.de/';
var
  http: TIdHTTP;
begin
  result := true;
  try
    http := TIdHTTP.Create;
    try
      http.Get(INTERNET_CHECK_URL);
    finally
      http.Free;
    end;
  except
    result := false;
  end;
end;

function DeterminateMonitorState(MonitorUrl: String): TMonitorState;
var
  http: TIdHTTP;
  s: string;
resourcestring
  OK_COMMENT = '<!-- STATUS: OK -->';
  WARNING_COMMENT = '<!-- STATUS: WARNING -->';
begin
  try
    http := TIdHTTP.Create;
    try
      s := http.Get(MonitorUrl);
      if AnsiPos(OK_COMMENT, s) > 0 then
      begin
        result := msOk;
      end
      else if AnsiPos(WARNING_COMMENT, s) > 0 then
      begin
        result := msStatusWarning;
      end
      else
      begin
        result := msMonitorFailure;
      end;
    finally
      http.Free;
    end;
  except
    if InternetConnectivity() then
    begin
      result := msServerDown;
    end
    else
    begin
      result := msInternetBroken;
    end;

    // raise;
  end;
end;

end.
