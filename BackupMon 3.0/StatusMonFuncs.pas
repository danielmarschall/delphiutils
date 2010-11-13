unit StatusMonFuncs;

interface

uses
  SysUtils, IdHTTP;

type
  TMonitorState = (msOK, msStatusWarning, msMonitorParseError,
    msMonitorGeneralError, msServerDown, msInternetBroken);

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
  http := TIdHTTP.Create;
  try
    try
      s := http.Get(MonitorUrl);
      if (AnsiPos(OK_COMMENT, s) > 0) and
         (AnsiPos(WARNING_COMMENT, s) > 0) then
      begin
        result := msMonitorParseError;
      end
      else if AnsiPos(OK_COMMENT, s) > 0 then
      begin
        result := msOk;
      end
      else if AnsiPos(WARNING_COMMENT, s) > 0 then
      begin
        result := msStatusWarning;
      end
      else
      begin
        result := msMonitorParseError;
      end;
    except
      if http.Response.ResponseCode <> -1 then
      begin
        result := msMonitorGeneralError;
      end
      else
      begin
        if InternetConnectivity() then
        begin
          result := msServerDown;
        end
        else
        begin
          result := msInternetBroken;
        end;
      end;

      // raise;
    end;
  finally
    http.Free;
  end;
end;

end.
