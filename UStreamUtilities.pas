unit UStreamUtilities;

interface

uses
  SysUtils,
  StrUtils,
  Classes;

function StreamToText(const aStream: TStream): string; overload;

procedure StreamRewind(const aStream: TStream); overload;

procedure RemoveTrailing(var s: String; const aTrailing: String); overload;

procedure ReverseWord(var aWord: word); overload;

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

procedure RemoveTrailing(var s: String; const aTrailing: String);
var
  trailing: string;
begin
  trailing := RightStr(s, length(aTrailing));
  if trailing = aTrailing then
    s := LeftStr(s, length(s) - length(aTrailing));
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
