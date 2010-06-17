unit HighPerfFileComparator;

(*

  HighPerfFileComparator.pas
  (C) 2010 ViaThinkSoft, Daniel Marschall

  Last modified: January, 21th 2010

  THighPerfFileComparator.compare(filenameA, filenameB: string): boolean;

  Compares two files primary with size comparison and
  secundary with MD5 hash comparison. All results will be cached.

  Note: If you want to use the cache for every file, please do not
  destroy the instance of THighPerfFileComparator after done your job.
  Use in a field of your form class and free it when the application
  closes.

  Example of usage:

      var
        comparator: THighPerfFileComparator;

      procedure TForm1.FormCreate(Sender: TObject);
      begin
        comparator := THighPerfFileComparator.Create;
      end;

      procedure TForm1.Button1Click(Sender: TObject);
      begin
        // This deletes all cached file hashs, so that the result will be
        // new calculated. Alternatively you can create a new
        // THighPerfFileComparator at the beginning of every new job.
        comparator.clearCache;

        if comparator.Compare('C:\a.txt', 'C:\b.txt') then
          ShowMessage('Files are equal')
        else
          ShowMessage('Files are not equal');
      end;

      procedure TForm1.FormDestroy(Sender: TObject);
      begin
        comparator.Free;
      end;

  Class hierarchie:

      Exception
          EFileNotFound
          ENoRegisteredComparators
      TObject
          (TContainer)
              (TStringContainer)
              (TInteger64Container)
          TCacheManager
              TFilenameCacheManager
                  TInteger64CacheManager
                  TStringCacheManager
      TInterfacedObject
          TComparator
              TFileComparator
                  THashMD5Comparator
                      TCachedHashMD5Comparator [ICachedComparator]
                  TSizeComparator
                      TCachedSizeComparator [ICachedComparator]
                  TMultipleFileComparators
                      TCachedSizeHashMD5FileComparator [ICachedComparator]
                      = THighPerfFileComparator

*)

interface

uses
  SysUtils, Classes, Contnrs;

type
  ICachedComparator = interface(IInterface)
  // private
    procedure SetCacheEnabled(Value: boolean);
    function GetCacheEnabled: boolean;
  // public
    property CacheEnabled: boolean read getCacheEnabled write setCacheEnabled;
    procedure ClearCache;
  end;

  EFileNotFound = class(Exception);

  ENoRegisteredComparators = class(Exception);

  TCacheManager = class(TObject)
  private
    FCache: TStringList;
  public
    procedure SetCache(identifier: string; cacheObject: TObject);
    function GetCache(identifier: string): TObject;
    function IsCached(identifier: string): boolean;
    procedure Clear;
    constructor Create;
    destructor Destroy; override;
  end;

  // TFilenameCacheManager extends every filename to a unique identifier
  TFilenameCacheManager = class(TCacheManager)
  protected
    function FullQualifiedFilename(filename: string): string;
  public
    procedure SetCache(filename: string; cacheObject: TObject);
    function GetCache(filename: string): TObject;
    function IsCached(filename: string): boolean;
  end;

  // Wäre eigentlich ein guter Ansatz für Mehrfachvererbung...
  TInteger64CacheManager = class(TFilenameCacheManager)
  public
    procedure SetCache(filename: string; content: int64);
    function GetCache(filename: string): int64;
  end;

  TStringCacheManager = class(TFilenameCacheManager)
  public
    procedure SetCache(filename: string; content: string);
    function GetCache(filename: string): string;
  end;

  TComparator = class(TInterfacedObject) // abstract
  public
    function Compare(a, b: string): boolean; virtual; abstract;
  end;

  TFileComparator = class(TComparator) // abstract
  protected
    // Please call this method for both filenames at every Compare()
    // call of your derivates.
    procedure CheckFileExistence(filename: string);
  public
    // This is an abstract method since it only checks filenames and returns
    // always false.
    // function Compare(filenameA, filenameB: string): boolean; override;
  end;

  TSizeComparator = class(TFileComparator)
  protected
    function GetFileSize(filename: string): Int64; virtual;
  public
    function Compare(filenameA, filenameB: string): boolean; override;
  end;

  TCachedSizeComparator = class(TSizeComparator, ICachedComparator)
  private
    FCacheManager: TInteger64CacheManager;
    FCacheEnabled: boolean;
    procedure SetCacheEnabled(Value: boolean);
    function GetCacheEnabled: boolean;
  protected
    function GetFileSize(filename: string): Int64; override;
  public
    property CacheEnabled: boolean read getCacheEnabled write setCacheEnabled;
    procedure ClearCache;
    constructor Create;
    destructor Destroy; override;
  end;

  THashMD5Comparator = class(TFileComparator)
  protected
    function GetFileHashMD5(filename: string): String; virtual;
  public
    function Compare(filenameA, filenameB: string): boolean; override;
  end;

  TCachedHashMD5Comparator = class(THashMD5Comparator, ICachedComparator)
  private
    FCacheManager: TStringCacheManager;
    FCacheEnabled: boolean;
    procedure SetCacheEnabled(Value: boolean);
    function GetCacheEnabled: boolean;
  protected
    function GetFileHashMD5(filename: string): String; override;
  public
    property CacheEnabled: boolean read getCacheEnabled write setCacheEnabled;
    procedure ClearCache;
    constructor Create;
    destructor Destroy; override;
  end;

  TMultipleFileComparators = class(TFileComparator) // abstract
  // This is an abstract class since no comparators are registered and so
  // compare() will throw an ENoRegisteredComparators exception.
  protected
    // WARNING: DOES *NOT* OWNS ITS OBJECTS. PLEASE FREE THEM ON DESTROY.
    FRegisteredComparators: TObjectList; // of TFileComparator
    procedure RegisterComparator(comparator: TFileComparator);
  public
    function Compare(filenameA, filenameB: string): boolean; override;
    constructor Create;
    destructor Destroy; override;
  end;

  TCachedSizeHashMD5FileComparator = class(TMultipleFileComparators,
    ICachedComparator)
  private
    FHashComparator: TCachedHashMD5Comparator;
    FSizeComparator: TCachedSizeComparator;
    procedure SetCacheEnabled(Value: boolean);
    function GetCacheEnabled: boolean;
  public
    property CacheEnabled: boolean read getCacheEnabled write setCacheEnabled;
    procedure ClearCache;
    constructor Create;
    destructor Destroy; override;
  end;

  THighPerfFileComparator = TCachedSizeHashMD5FileComparator;

implementation

// Please download MD5.pas from
// http://www.koders.com/delphi/fid1C4B47A76F8C7172FDCFE7B3A74863D6FB7FC2BA.aspx

uses
  MD5;

resourcestring
  LNG_E_NO_REGISTERED_COMPARATORS = 'No comparators registered. Please use ' +
    'a derivate of the class TMultipleFileComparators which does register ' +
    'comparators.';
  LNG_E_FILE_NOT_FOUND = 'The file "%s" was not found.';

type
  TContainer = class(TObject);

  TStringContainer = class(TContainer)
  public
    Content: string;
    constructor Create(AContent: string);
  end;

  TInteger64Container = class(TContainer)
  public
    Content: int64;
    constructor Create(AContent: int64);
  end;

{ Functions }

function _MD5File(filename: string): string;
begin
  result := MD5Print(MD5File(filename));
end;

{ TStringContainer }

constructor TStringContainer.Create(AContent: string);
begin
  inherited Create;

  content := AContent;
end;

{ TInteger64Container }

constructor TInteger64Container.Create(AContent: int64);
begin
  inherited Create;

  content := AContent;
end;

{ TCacheManager }

procedure TCacheManager.SetCache(identifier: string; cacheObject: TObject);
begin
  FCache.AddObject(identifier, cacheObject);
end;

function TCacheManager.GetCache(identifier: string): TObject;
begin
  if isCached(identifier) then
    result := FCache.Objects[FCache.IndexOf(identifier)] as TContainer
  else
    result := nil;
end;

function TCacheManager.IsCached(identifier: string): boolean;
begin
  result := FCache.IndexOf(identifier) <> -1;
end;

procedure TCacheManager.Clear;
begin
  FCache.Clear;
end;

constructor TCacheManager.Create;
begin
  inherited Create;

  FCache := TStringList.Create;
end;

destructor TCacheManager.Destroy;
begin
  FCache.Free;

  inherited Destroy;
end;

{ TFilenameCacheManager }

function TFilenameCacheManager.FullQualifiedFilename(filename: string): string;
begin
  result := ExpandUNCFileName(filename);
end;

procedure TFilenameCacheManager.SetCache(filename: string;
  cacheObject: TObject);
begin
  inherited setCache(FullQualifiedFilename(filename), cacheObject);
end;

function TFilenameCacheManager.GetCache(filename: string): TObject;
begin
  result := inherited getCache(FullQualifiedFilename(filename));
end;

function TFilenameCacheManager.IsCached(filename: string): boolean;
begin
  result := inherited isCached(FullQualifiedFilename(filename));
end;

{ TInteger64CacheManager }

procedure TInteger64CacheManager.SetCache(filename: string; content: int64);
begin
  inherited setCache(filename, TInteger64Container.Create(content));
end;

function TInteger64CacheManager.GetCache(filename: string): int64;
begin
  result := (inherited getCache(filename) as TInteger64Container).content;
end;

{ TStringCacheManager }

procedure TStringCacheManager.SetCache(filename: string; content: string);
begin
  inherited setCache(filename, TStringContainer.Create(content));
end;

function TStringCacheManager.GetCache(filename: string): string;
begin
  result := (inherited getCache(filename) as TStringContainer).content;
end;

{ TFileComparator }

procedure TFileComparator.CheckFileExistence(filename: string);
begin
  if not fileExists(filename) then
    raise EFileNotFound.CreateFmt(LNG_E_FILE_NOT_FOUND, [filename]);
end;

(* function TFileComparator.Compare(filenameA, filenameB: string): boolean;
begin
  if not fileExists(filenameA) then
    raise EFileNotFound.CreateFmt(LNG_E_FILE_NOT_FOUND, [filenameA]);

  if not fileExists(filenameB) then
    raise EFileNotFound.CreateFmt(LNG_E_FILE_NOT_FOUND, [filenameB]);

  // Leider keine Überprüfung, ob Methode überschrieben wurde
  // (da sonst result immer false ist!)
  if Self.ClassType = TFileComparator then
    raise EDirectCall.CreateFmt(LNG_E_DIRECT_CALL, [Self.ClassName]);

  result := false;
end; *)

{ TSizeComparator }

function TSizeComparator.GetFileSize(filename: string): Int64;
var
  f: TFileStream;
begin
  f := TFileStream.Create(filename, fmOpenRead);
  try
    result := f.Size
  finally
    f.Free;
  end;
end;

function TSizeComparator.Compare(filenameA, filenameB: string): boolean;
begin
  //inherited compare(filenameA, filenameB);
  CheckFileExistence(filenameA);
  CheckFileExistence(filenameB);

  result := getFileSize(filenameA) = getFileSize(filenameB);
end;

{ TCachedSizeComparator }

procedure TCachedSizeComparator.SetCacheEnabled(Value: boolean);
begin
  if FCacheEnabled <> Value then
    FCacheEnabled := Value;
end;

function TCachedSizeComparator.GetCacheEnabled: boolean;
begin
  result := FCacheEnabled;
end;

function TCachedSizeComparator.GetFileSize(filename: string): Int64;
begin
  if FCacheEnabled then
  begin
    if FCacheManager.isCached(filename) then
    begin
      result := FCacheManager.getCache(filename);
    end
    else
    begin
      result := inherited getFileSize(filename);
      FCacheManager.setCache(filename, result);
    end;
  end
  else
    result := inherited getFileSize(filename);
end;

procedure TCachedSizeComparator.ClearCache;
begin
  FCacheManager.clear;
end;

constructor TCachedSizeComparator.Create;
begin
  inherited Create;

  FCacheManager := TInteger64CacheManager.Create;
  FCacheEnabled := true;
end;

destructor TCachedSizeComparator.Destroy;
begin
  FCacheManager.Free;

  inherited Destroy;
end;

{ THashMD5Comparator }

function THashMD5Comparator.GetFileHashMD5(filename: string): String;
begin
  result := _MD5File(filename);
end;

function THashMD5Comparator.Compare(filenameA, filenameB: string): boolean;
begin
  //inherited Compare(filenameA, filenameB);
  CheckFileExistence(filenameA);
  CheckFileExistence(filenameB);

  result := GetFileHashMD5(filenameA) = GetFileHashMD5(filenameB);
end;

{ TCachedHashMD5Comparator }

procedure TCachedHashMD5Comparator.SetCacheEnabled(Value: boolean);
begin
  if FCacheEnabled <> Value then
    FCacheEnabled := Value;
end;

function TCachedHashMD5Comparator.GetCacheEnabled: boolean;
begin
  result := FCacheEnabled;
end;

function TCachedHashMD5Comparator.GetFileHashMD5(filename: string): String;
begin
  if FCacheEnabled then
  begin
    if FCacheManager.IsCached(filename) then
    begin
      result := FCacheManager.GetCache(filename);
    end
    else
    begin
      result := inherited GetFileHashMD5(filename);
      FCacheManager.SetCache(filename, result);
    end;
  end
  else
    result := inherited GetFileHashMD5(filename);
end;

procedure TCachedHashMD5Comparator.ClearCache;
begin
  FCacheManager.Clear;
end;

constructor TCachedHashMD5Comparator.Create;
begin
  inherited Create;

  FCacheManager := TStringCacheManager.Create;
  FCacheEnabled := true;
end;

destructor TCachedHashMD5Comparator.Destroy;
begin
  FCacheManager.Free;

  inherited Destroy;
end;

{ TMultipleFileComparators }

procedure TMultipleFileComparators.RegisterComparator(comparator: TFileComparator);
begin
  FRegisteredComparators.Add(comparator)
end;

function TMultipleFileComparators.Compare(filenameA,
  filenameB: string): boolean;
var
  i: integer;
begin
  //inherited Compare(filenameA, filenameB);
  CheckFileExistence(filenameA);
  CheckFileExistence(filenameB);

  if FRegisteredComparators.Count = 0 then
    raise ENoRegisteredComparators.Create(LNG_E_NO_REGISTERED_COMPARATORS);

  for i := 0 to FRegisteredComparators.Count - 1 do
  begin
    if not (FRegisteredComparators.Items[i] as TFileComparator).
      Compare(filenameA, filenameB) then
    begin
      result := false;
      exit;
    end;
  end;
  result := true;
end;

constructor TMultipleFileComparators.Create;
begin
  inherited Create;

  FRegisteredComparators := TObjectList.Create(false);
end;

destructor TMultipleFileComparators.Destroy;
begin
  FRegisteredComparators.Free;

  inherited Destroy;
end;

{ TCachedSizeHashMD5FileComparator }

procedure TCachedSizeHashMD5FileComparator.SetCacheEnabled(Value: boolean);
begin
  FSizeComparator.SetCacheEnabled(Value);
  FHashComparator.SetCacheEnabled(Value);
end;

function TCachedSizeHashMD5FileComparator.getCacheEnabled: boolean;
begin
  result := FSizeComparator.GetCacheEnabled and FHashComparator.GetCacheEnabled;
end;

procedure TCachedSizeHashMD5FileComparator.ClearCache;
begin
  FSizeComparator.ClearCache;
  FHashComparator.ClearCache;
end;

constructor TCachedSizeHashMD5FileComparator.Create;
begin
  inherited Create;

  FSizeComparator := TCachedSizeComparator.Create;
  RegisterComparator(FSizeComparator);

  FHashComparator := TCachedHashMD5Comparator.Create;
  RegisterComparator(FHashComparator);
end;

destructor TCachedSizeHashMD5FileComparator.Destroy;
begin
  FHashComparator.Free;
  FSizeComparator.Free;

  inherited Destroy;
end;

end.
