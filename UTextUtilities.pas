unit UTextUtilities;

interface

uses
  SysUtils,
  Types;

function PointerToText(const aPointer: pointer): string;

function ExcludeEnding(var aText: string; const aEnding: string): boolean; 


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

end.
