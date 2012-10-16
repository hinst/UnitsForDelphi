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


end.
