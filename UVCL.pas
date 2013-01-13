unit UVCL;

interface

uses
  Types,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Buttons,

  UAdditionalExceptions,
  UAdditionalTypes;

procedure PlaceFormDesktopPart(const aForm: TForm; const aMultiplier: single {0..1});

function IsMouseOverControl(const aControl: TControl): boolean;

function CreateBitmapFromIcon(const aIcon: TIcon): TBitmap;


implementation

procedure PlaceFormDesktopPart(const aForm: TForm; const aMultiplier: single {0..1});
var
  m: single;
  w, h: integer;
begin
  AssertAssigned(aForm, 'aForm', TVariableType.Argument);
  m := aMultiplier;
  if m >= 1 then
    m := 1;
  w := Screen.WorkAreaWidth;
  h := Screen.WorkAreaHeight;
  aForm.Width := round(w * m);
  aForm.Height := round(h * m);
  aForm.Left := (w - aForm.Width) div 2;
  aForm.Top := (h - aForm.Height) div 2;
end;

function IsMouseOverControl(const aControl: TControl): boolean;
var
  r : TRect;
begin
  if aControl = nil then
  begin
    result := false;
    exit;
  end;
  r := Rect(
    aControl.ClientToScreen(Point(0, 0)),
    aControl.ClientToScreen(Point(aControl.Width, aControl.Height))
  );
  result := PtInRect(r, Mouse.CursorPos);
end;

function CreateBitmapFromIcon(const aIcon: TIcon): TBitmap;
begin
  AssertAssigned(aIcon, 'aIcon', TVariableType.Argument);
  result := TBitmap.Create;
  result.Width := aIcon.Width;
  result.Height := aIcon.Height;
  result.Canvas.Draw(0, 0, aIcon);
end;


end.
