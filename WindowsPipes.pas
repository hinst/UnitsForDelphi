unit WindowsPipes;

interface

uses
  Windows, SysUtils;

type
  ECannotCreatePipe = class(Exception);
  EInvalidPipe = class(Exception);
  ECannotReadPipe = class(Exception);
  EConnectionFailure = class(Exception);

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
  end;

implementation

constructor TCommonPipe.Create(const aName: string);
begin
  inherited Create;
  fName := aName;
end;

function TCommonPipe.IsPipeOpened: boolean;
begin
  result := (Pipe <> 0) and (Pipe <> INVALID_HANDLE_VALUE);
end;

procedure TCommonPipe.AssertPipeOpened;
begin
  if not PipeOpened then
    raise EInvalidPipe.Create('');
end;

end.
