unit WindowsPipes;

interface

uses
  Windows,
  SysUtils,
  SyncObjs,

  UAdditionalExceptions;

type
  ECommonPipe = class(Exception);
  ECannotCreatePipe = class(ECommonPipe);
  ECannotConnectPipe = class(ECommonPipe);
  EClosedPipe = class(ECommonPipe);
  ECannotReadPipe = class(ECommonPipe);
  ECannotWritePipe = class(ECommonPipe);
  EConnectionFailure = class(ECommonPipe);

  TCommonPipe = class
  public
    constructor Create(const aName: string); reintroduce;
  protected
    fName: string;
    fPipe: THandle;
    function IsPipeOpened: boolean;
  public
    property Name: string read fName;
    property Pipe: THandle read fPipe;
    property PipeOpened: boolean read IsPipeOpened;
    procedure AssertPipeOpened;
    destructor Destroy; override;
  end;

  EWaitWindowsOverlappedEvent = class(Exception)
  public
    constructor Create(const aTime: DWORD);
  protected
    fTime: DWORD;
    procedure CreateThis;
  public
    property Time: DWORD read fTime;
  end;

  TWindowsOverlappedEvent = class
  public
    constructor Create;
  public type
    EAbandoned = class(EWaitWindowsOverlappedEvent);
    ETimeOut = class(EWaitWindowsOverlappedEvent);
    EFailed = class(EWaitWindowsOverlappedEvent);
  private
    fOverlapped: TOverlapped;
    function AccessOverlapped: POverlapped;
    function GetEvent: THandle;
    procedure CreateThis;
    procedure CloseEvent;
    procedure DestroyThis;
  public
    property Event: THandle read GetEvent;
    property Overlapped: POverlapped read AccessOverlapped;
    function Wait(const aTime: DWORD): boolean;
    destructor Destroy; override;
  end;

implementation

constructor TCommonPipe.Create(const aName: string);
begin
  inherited Create;
  fName := aName;
  fPipe := 0;
end;

function TCommonPipe.IsPipeOpened: boolean;
begin
  result := (Pipe <> 0) and (Pipe <> INVALID_HANDLE_VALUE);
end;

procedure TCommonPipe.AssertPipeOpened;
begin
  if not PipeOpened then
    raise EClosedPipe.Create('Pipe is closed.');
end;

destructor TCommonPipe.Destroy;
begin
  if PipeOpened then
    CloseHandle(Pipe);
  inherited Destroy;
end;

constructor EWaitWindowsOverlappedEvent.Create(const aTime: DWORD);
begin
  inherited Create('');
  fTime := aTime;
end;

procedure EWaitWindowsOverlappedEvent.CreateThis;
begin
  Message := 'Time: ' + IntToStr(Time);
end;

constructor TWindowsOverlappedEvent.Create;
begin
  inherited Create;
  CreateThis;
end;

function TWindowsOverlappedEvent.AccessOverlapped: POverlapped;
begin
  result := @fOverlapped;
end;

procedure TWindowsOverlappedEvent.CreateThis;
begin
  fOverlapped.hEvent := CreateEvent(nil, false, false, nil);
end;

procedure TWindowsOverlappedEvent.CloseEvent;
begin
  if Event > 0 then
  begin
    CloseHandle(Event);
    Overlapped^.hEvent := 0;
  end;
end;

procedure TWindowsOverlappedEvent.DestroyThis;
begin
  CloseEvent;
end;

function TWindowsOverlappedEvent.GetEvent: THandle;
begin
  result := fOverlapped.hEvent;
end;

function TWindowsOverlappedEvent.Wait(const aTime: DWORD): boolean;
var
  waitResult: DWORD;
begin
  result := false;
  Assert(Event > 0);
  waitResult := WaitForSingleObject(Event, aTime);
  if waitResult = WAIT_ABANDONED then
    raise EAbandoned.Create(aTime);
  if waitResult = WAIT_FAILED then
    raise EFailed.Create(aTime);
  result := not (waitResult = WAIT_TIMEOUT);
end;

destructor TWindowsOverlappedEvent.Destroy;
begin
  CloseHandle(Event);
  Overlapped^.hEvent := 0;
  DestroyThis;
  inherited Destroy;
end;

end.
