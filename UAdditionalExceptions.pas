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
    constructor Create(const aMin, aSpecified, aMax: integer);
  protected
    fMin, fSpecified, fMax: integer;
    procedure UpdateMessage;
  public
    property Min: integer read fMin;
    property Specified: integer read fSpecified;
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


constructor EErroneousSequentIndex.Create(const aMin, aSpecified, aMax: integer);
begin
  inherited Create('');
  fMin := aMin;
  fSpecified := aSpecified;
  fMax := aMax;
  UpdateMessage;
end;

procedure EErroneousSequentIndex.UpdateMessage;
begin
  Message := 'Erroneous index specified: possible indixes are: '
    + '[' + IntToStr(Min) + '..' + IntToStr(Max) + ']; '
    + 'specified index is: ' + IntToStr(Specified);
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
var
  correct: boolean;
begin
  correct := (aMin <= aIndex) and (aIndex <= aMax);
  if not correct then
    raise EErroneousSequentIndex.Create(aMin, aIndex, aMax);
end;

end.
