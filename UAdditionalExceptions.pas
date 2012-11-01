unit UAdditionalExceptions;

interface

uses
  SysUtils,
  Classes,
  UAdditionalTypes;

type
  EUnassigned = class(Exception)
  public
    constructor Create(const aVariableType: integer; const aVariableName: string);
  private
    fVariableType: integer;
    fVariableName: string;
    procedure UpdateMessage;
  public
    property VariableType: integer read fVariableType;
    property VariableName: string read fVariableName;
  end;

  EErroneousIndex = class(Exception);

  EErroneousSequentIndex = class(EErroneousIndex)
  public
    constructor Create(const aMin, aMax: integer);
  protected
    fMin, fMax: integer;
    procedure UpdateMessage;
  public
    property Min: integer read fMin;
    property Max: integer read fMax;
  end;

procedure AssertAssigned(const aPointer: pointer; const aVariableName: string;
  const aVariableType: integer);

procedure AssertSuppressable(const e: Exception);

procedure AssertIndex(const aMin, aIndex, aMax: integer);

implementation

constructor EUnassigned.Create(const aVariableType: integer; const aVariableName: string);
begin
  inherited Create('');
  fVariableType := aVariableType;
  fVariableName := aVariableName;
  UpdateMessage;
end;

procedure EUnassigned.UpdateMessage;
begin
  Message := 'Unassigned: "' + VariableName + '"; Type is ' + TVariableType.ToText(VariableType);
end;


constructor EErroneousSequentIndex.Create(const aMin, aMax: integer);
begin
  inherited Create('');
  fMin := aMin;
  fMax := aMax;
  UpdateMessage;
end;

procedure EErroneousSequentIndex.UpdateMessage;
begin
  Message := 'Erroneous index: possible indixes are: '
    + '[' + IntToStr(Min) + '..' + IntToStr(Max) + ']';
end;


procedure AssertAssigned(const aPointer: pointer; const aVariableName: string;
  const aVariableType: integer);
begin
  if not Assigned(aPointer) then
    raise EUnassigned.Create(aVariableType, aVariableName);
end;

procedure AssertSuppressable(const e: Exception);
begin
  if (e is EOutOfMemory) or (e is EAccessViolation) then
    raise e;
end;

procedure AssertIndex(const aMin, aIndex, aMax: integer);
begin
  if not ((aMin <= aIndex) and (aMax <= aIndex)) then
    raise EErroneousSequentIndex.Create(aMin, aMax);
end;

end.
