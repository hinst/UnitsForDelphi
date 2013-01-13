unit UStreamUtilities;

interface

uses
  SysUtils,
  Classes,

  UAdditionalTypes,
  UAdditionalExceptions;

function StreamToText(const aStream: TStream; const aRewind: boolean): string;
procedure Rewind(const aStream: TStream); overload;
function GetRemainingSize(const aStream: TStream): Int64; overload;
procedure ReverseWord(var aWord: Word); overload;

implementation

function StreamToTextInternal(const aStream: TStream; const aRewind: boolean): string;
var
  x: byte;
  readResult: integer;
begin
  if aStream = nil then
  begin
    result := 'nil';
    exit;
  end;
  if aStream.Size = 0 then
  begin
    result := 'empty';
    exit;
  end;
  if aRewind then
    Rewind(aStream);
  result := '';
  repeat
    readResult := aStream.Read(x, 1);
    if readResult < 1 then
    begin
      break;
    end;
    result := result + IntToHex(x, 2) + ' ';
  until false;
  result := Trim(result);
end;

function StreamToTextSafe(const aStream: TStream; const aRewind: boolean): string;
begin
  try
    result := StreamToTextInternal(aStream, aRewind);
  except
    on e: Exception do
    begin
      result := 'Exception while reading stream: ' + e.ClassName + ' "' + e.Message + '"';
    end;
  end;
end;

function StreamToText(const aStream: TStream; const aRewind: boolean): string;
begin
  result := StreamToTextSafe(aStream, aRewind);
end;

procedure Rewind(const aStream: TStream);
begin
  AssertAssigned(aStream, 'aStream', TVariableType.Argument);
  aStream.Seek(0, soBeginning);
end;

function GetRemainingSize(const aStream: TStream): int64;
begin
  result := aStream.Size - aStream.Position;
end;

procedure ReverseWord(var aWord: Word);
var
  light: byte;
  heavy: byte;
begin
  light := aWord and $00FF;
  heavy := (aWord shr 8) and $00FF;
  aWord := (Word(light) shl 8) or heavy;
end;

end.
