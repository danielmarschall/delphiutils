unit Common;

interface

resourcestring
  LNG_INIT_TIME_OPTION = 'Wartezeit bei Programm&start: %d Min.';
  LNG_INIT_TIME = 'Wartezeit bei Programmstart';
  LNG_LOOP_TIME_OPTION = 'Wartezeit zwischen Prüf&zyklen: %d Min.';
  LNG_LOOP_TIME = 'Wartezeit zwischen Prüfzyklen';
  LNG_ERROR = 'Fehler';
  LNG_NO_POSITIVE_NUMBER_WITHOUT_ZERO = 'Der Wert "%s" ist keine positive Zahl (außer 0).';
  LNG_INPUT_MINUTE_INTERVAL = 'Bitte geben Sie einen neuen Wert in Minuten an.';
  LNG_COLUMN_NAME = 'Name';
  LNG_COLUMN_URL = 'URL';
  LNG_COLUMN_STATUS = 'Status';
  LNG_CHECKALL_FINISHED_CAPTION = 'Tests abgeschlossen';
  LNG_CHECKALL_FINISHED_TEXT = 'Alle Tests wurden abgeschlossen.';
  LNG_EXIT_TEXT = 'Möchten Sie den Status Monitor wirklich beenden und keine Warnungen mehr erhalten?';
  LNG_EXIT_CAPTION = 'Beenden?';
  LNG_DELETE_TEXT = 'Statusmonitor "%s" wirklich löschen?';
  LNG_DELETE_CAPTION = 'Lösch-Bestätigung';
  LNG_STAT_QUEUE = 'In queue...';
  LNG_STAT_CHECKING = 'Checking...';
  LNG_STAT_OK = 'OK';
  LNG_STAT_WARNING = 'Warning';
  LNG_STAT_PARSEERROR = 'Parse error';
  LNG_STAT_GENERALERROR = 'General error';
  LNG_STAT_SERVERDOWN = 'Server down';
  LNG_STAT_INTERNETBROKEN = 'Unknown (Internet broken)';
  LNG_STAT_UNKNOWN = 'Unknown (Not checked)';
  LNG_ALERT_CAPTION = 'Status Monitor Alert';
  LNG_ALERT_CAPTION_OK = 'Status Monitor Check';
  LNG_ALERT_STATUS_WARNING = 'Der Status-Monitor "%s" meldet ein Problem! Status-Monitor jetzt öffnen?' + #13#10#13#10 + 'Monitor-URL: %s';
  LNG_ALERT_STATUS_OK = 'Es existieren keine Probleme mit Status-Monitor "%s"' + #13#10#13#10 + 'Monitor-URL: %s';
  LNG_ALERT_MONITOR_FAILURE = 'Die Ausgabe des Status-Monitors "%s" kann nicht interpretiert werden! Status-Monitor jetzt öffnen?' + #13#10#13#10 + 'Monitor-URL: %s';
  LNG_ALERT_CONNECTIVITY_FAILURE = 'Der Status von "%s" konnte nicht überprüft werden, da keine Internetverbindung besteht! Ping-Fenster öffnen?' + #13#10#13#10 + 'Monitor-URL: %s';
  LNG_ALERT_SERVER_DOWN = 'Es konnte keine Verbindung zum Status-Monitor "%s" hergestellt werden, OBWOHL eine Internetverbindung besteht! Ping-Fenster öffnen?' + #13#10#13#10 + 'Monitor-URL: %s';
  LNG_MONITOR_NEW = 'New status monitor';
  LNG_MONITOR_EDIT = 'Edit status monitor';
  LNG_LAST_CHECK = 'Last check: %s';
  LNG_LAST_CHECK_UNKNOWN = 'Unknown';

const
  REG_VAL_LOOP_TIMER_INTERVAL = 'LoopTimerInterval';
  REG_VAL_INIT_TIMER_INTERVAL = 'InitTimerInterval';
  REG_VAL_WARN_AT_CONNFAILURE = 'WarnAtConnectivityFailure';
  REG_VAL_URL = 'URL';
  REG_KEY_SETTINGS = '\Software\ViaThinkSoft\StatusMon\3.0\Settings\';
  REG_KEY_SERVICE = '\Software\ViaThinkSoft\StatusMon\3.0\Services\%s\';
  REG_KEY_SERVICES = '\Software\ViaThinkSoft\StatusMon\3.0\Services\';

implementation

end.
