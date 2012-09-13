unit UStreamUtilities;

interface

uses
  Classes,
  SysUtils;

function StreamToText(const aStream: TStream): string;

procedure StreamRewind(const aStream: TStream);

implementation

function StreamToText(const aStream: TStream): string;
var
  x: byte;
  readResult: integer;
  once: boolean;
begin
  if aStream = nil then
  begin
    result := 'nil$TREAM';
    exit;
  end;
  result := '$';
  once := false;
  repeat
    readResult := aStream.Read(x, 1);
    if readResult < 1 then
    begin
      break;
    end;
    result := result + IntToHex(x, 2) + ' ';
    once := true;
  until false;
  if once then
    Delete(result, Length(result), 1);
  result := result + '$';
end;

procedure StreamRewind(const aStream: TStream);
begin
  aStream.Seek(0, soBeginning);
end;

end.
