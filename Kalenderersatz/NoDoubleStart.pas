unit NoDoubleStart;

interface 

implementation 

uses
  Windows, SysUtils, Forms;

var
  mHandle: THandle;

Initialization
  mHandle := CreateMutex(nil, True, 'ViaThinkSoft-Calendar');
  if GetLastError = ERROR_ALREADY_EXISTS then
  begin
    Halt;
  end;

finalization
  if mHandle <> 0 then
  begin
    CloseHandle(mHandle)
  end;
end.
