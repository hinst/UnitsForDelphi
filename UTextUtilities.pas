unit UTextUtilities;

interface

uses
  SysUtils,
  Types;

function PointerToText(const aPointer: pointer): string;


implementation

function PointerToText(const aPointer: pointer): string;
begin
  result := '$' + IntToHex(DWord(aPointer), sizeof(pointer)*2);
end;

end.
