unit UAdditionalExceptions;

interface

uses
  SysUtils,
  Classes,
  UAdditionalTypes;

type

  EWrongClass = class(Exception)
  public
    constructor Create(const aActualClass, aDesiredClass: TClass);
  protected
    FActualClass, FDesiredClass: TClass;
    procedure UpdateMessage;
  public type
    TNilObject = class(TObject)
    end;
  public
    property ActualClass: TClass read FActualClass;
    property DesiredClass: TClass read FDesiredClass;
  end;

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

  EDuplicate = class(Exception);

  EDuplicateClass = class(Exception)
  public
    constructor Create(const aClass: TClass);
  protected
    FClass: TClass;
    procedure UpdateMessage;
  property
    Duplicate: TClass read FClass;
  end;

procedure AssertType(const aObject: TObject; const aType: TClass);

procedure AssertAssigned(const aPointer: pointer; const aVariableName: string;
  const aVariableType: integer); inline;

procedure AssertSuppressable(const e: Exception); inline;

procedure AssertIndex(const aMin, aIndex, aMax: integer);

procedure TryFreeAndNil(var obj);

implementation

constructor EWrongClass.Create(const aActualClass, aDesiredClass: TClass);
begin
  inherited Create('');
  FActualClass := aActualClass;
  FDesiredClass := aDesiredClass;
  UpdateMessage;
end;

procedure EWrongClass.UpdateMessage;
begin
  Message := 'Wrong class: '
      + 'actual class: ' + ActualClass.ClassName + '; '
      + 'desired class: ' + DesiredClass.ClassName;
end;

constructor EUnassigned.Create(const aVariableType: integer; const aVariableName: string);
begin
  inherited Create('');
  fVariableType := aVariableType;
  fVariableName := aVariableName;
  UpdateMessage;
end;

procedure EUnassigned.UpdateMessage;
begin
  Message := 'Unassigned: "' + VariableName + '"; type is ' + TVariableType.ToText(VariableType);
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

constructor EDuplicateClass.Create(const aClass: TClass);
begin
  inherited Create('');
  FClass := aClass;
  UpdateMessage;
end;

procedure EDuplicateClass.UpdateMessage;
begin
  Message := 'Duplicate class: ' + Duplicate.ClassName;
end;


procedure AssertType(const aObject: TObject; const aType: TClass);
begin
  if not Assigned(aObject) then
    raise EWrongClass.Create(EWrongClass.TNilObject, aType);
  if not (aObject is aType) then
    raise EWrongClass.Create(aObject.ClassType, aType);
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

procedure TryFreeAndNil(var obj);
begin
  FreeAndNil(obj);
end;

end.






