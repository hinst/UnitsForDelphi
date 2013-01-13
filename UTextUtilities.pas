unit UTextUtilities;

interface

uses
  Types,
  SysUtils,
  Classes,
  StrUtils,

  JclStrings,

  UMath;

type
  TCheckStringMethod = function(var aString: string): boolean of object;

function PointerToText(const aPointer: pointer): string;

function ExcludeEnding(var aText: string; const aEnding: string): boolean;

function IntToZero(const aX, aZeroCount: integer): string;

function GenerateRandomText(const aCountOfWords: integer): string;

function CreateExtractStrings(const aSource: TStrings; const aCondition: TCheckStringMethod)
  : TStrings;

function SeparatedStrings(const aSeparator: string; const a: array of string): string;

function SpacedStrings(const a: array of string): string;

procedure RemoveTrailing(var s: String; const aTrailing: String); inline;

procedure AppendSpaced(var s: string; const x: string); 


implementation

function PointerToText(const aPointer: pointer): string;
begin
  result := '$' + IntToHex(DWord(aPointer), sizeof(pointer)*2);
end;

function ExcludeEnding(var aText: string; const aEnding: string): boolean;
var
  p: integer;
begin
  result := Length(aText) < Length(aEnding);
  if not result then
    exit;
  p := Pos(aEnding, aText);
  result := p = Length(aText) - Length(aEnding) + 1;
  if not result then
    exit;
  Delete(aText, p, Length(aEnding));
end;

function IntToZero(const aX, aZeroCount: integer): string;
begin
  result := IntToStr(aX);
  while Length(result) < aZeroCount do
    result := '0' + result;
end;

function GenerateRandomText(const aCountOfWords: integer): string;

  function RandomWord: string;
  begin
    case random(3) of
      0: result := 'word';
      1: result := 'text';
      2: result := 'abc';
      else result := '?';
    end;
  end;

  function RandomEndOfSentencePunctuation: string;
  begin
    case random(3) of
      0: result := '.';
      1: result := '!';
      2: result := '?';
      else result := '~';
    end;
  end;

const
  Deviation = 0.10;
var
  countOfWords, i: integer;
  r: TStringBuilder;
begin
  countOfWords := RandomDeviateInteger(aCountOfWords, Deviation);
  r := TStringBuilder.Create('text');
  for i := 0 to countOfWords - 1 do
  begin
    case random(3) of
      0..1: r.Append(RandomWord);
      2: r.Append(random(100));
    end;
    if random(5) = 0 then
      r.Append(', ');    
    r.Append(' ');
  end;
  r.Append(RandomEndOfSentencePunctuation);
  result := r.ToString;
  r.Free;
end;

function CreateExtractStrings(const aSource: TStrings; const aCondition: TCheckStringMethod)
  : TStrings;
var
  i: integer;
  s: string;
begin
  result := TStringList.Create;
  i := 0;
  while i < aSource.Count do
  begin
    s := aSource[i];
    if aCondition(s) then
    begin
      result.Add(s);
      aSource.Delete(i);
    end
    else
      i := i + 1;
  end;
end;

function SeparatedStrings(const aSeparator: string; const a: array of string): string;
var
  i: integer;
  r: TStringBuilder;
begin
  result := '';
  if Length(a) = 0 then
    exit;
  r := TStringBuilder.Create('');
  r.Append(a[0]);
  for i := 1 to length(a) - 1 do
    if a[i] <> '' then
    begin
      r.Append(aSeparator);
      r.Append(a[i]);
    end;
  result := r.ToString;
  r.Free;
end;

function SpacedStrings(const a: array of string): string;
begin
  result := SeparatedStrings(' ', a);
end;

procedure RemoveTrailing(var s: String; const aTrailing: String);
var
  trailing: string;
begin
  trailing := RightStr(s, length(aTrailing));
  if trailing = aTrailing then
    s := LeftStr(s, length(s) - length(aTrailing));
end;

procedure AppendSpaced(var s: string; const x: string);
begin
  if x <> '' then
  begin
    if s <> '' then
      s := s + ' ';
    s := s + x;
  end;
end;

end.
