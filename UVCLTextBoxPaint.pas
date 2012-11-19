unit UVCLTextBoxPaint;

interface

uses
  Windows,
  Types,
  SysUtils,
  Math,
  Graphics,
  Controls,
  Forms,
  ExtCtrls,

  JCLSortedMaps,

  UMath;

type
  TTextBoxPainter = class
  public
    constructor Create;
  public const
    DefaultCacheSize = 1000;
    DefaultScrollSpeed = 600;
    DefaultTolerableTime = 0.6;
  protected
    FBox: TPaintBox;
    FCurrentHeight: integer;
    FLeftGap, FRightGap: integer;
    FInnerTextGap: integer;
    FTop: integer;
    FScrollSpeed: integer;
    FDesiredTop: integer;
    FCache: TJclStrSortedMap;
    function EnsureValidateTop(const aTop: integer): integer; virtual;
    procedure SetTop(const aTop: integer); virtual;
    procedure SetDesiredTop(const aTop: integer); 
    function GetIsBottomOfPaintBoxReached: boolean;
    function ActualEvaluateHeight(const aText: string): integer; inline;
    procedure AppendDrawInternal(const aText: string; const aColor: TColor; const aHeight: integer);
  public
    property PaintBox: TPaintBox read FBox write FBox;
    property CurrentHeight: integer read FCurrentHeight write FCurrentHeight;
    property LeftGap: integer read FLeftGap write FLeftGap;
    property RightGap: integer read FRightGap write FRightGap;
    property InnerTextGap: integer read FInnerTextGap write FInnerTextGap;
    property Top: integer read FTop write SetTop;
    property ScrollSpeed: integer read FScrollSpeed write FScrollSpeed;
    property DesiredTop: integer read FDesiredTop write SetDesiredTop;
    property Cache: TJclStrSortedMap read FCache;
    property IsBottomOfPaintBoxReached: boolean read GetIsBottomOfPaintBoxReached;
    function EvaluateHeight(const aText: string): integer; inline;
    function CheckAppendVisible(const aHeight: integer): boolean; inline;
    function AppendDraw(const aText: string; const aColor: TColor; const aDraw: boolean = true)
      : boolean; inline;
      // returns whether invalidation required or not
    function Update(const aTime: integer): boolean;
    destructor Destroy; override;
  end;


implementation

constructor TTextBoxPainter.Create;
begin
  inherited Create;
  FCurrentHeight := 0;
  ScrollSpeed := DefaultScrollSpeed;
  FCache := TJclStrSortedMap.Create(0, false);
end;

function TTextBoxPainter.EnsureValidateTop(const aTop: integer): integer;
begin
  result := aTop;
  if result > 0 then
    result := 0;
end;

procedure TTextBoxPainter.SetTop(const aTop: integer);
begin
  FTop := EnsureValidateTop(aTop);
  FDesiredTop := FTop;
end;

procedure TTextBoxPainter.SetDesiredTop(const aTop: integer);
begin
  FDesiredTop := EnsureValidateTop(aTop);
end;

function TTextBoxPainter.GetIsBottomOfPaintBoxReached: boolean;
begin
  result := Top + CurrentHeight >= FBox.Height;
end;

function TTextBoxPainter.ActualEvaluateHeight(const aText: string): integer;
var
  r: TRect;
begin
  if Length(aText) = 0 then
  begin
    result := 0;
    exit;
  end;
  r := Rect(
    LeftGap + InnerTextGap,
    Top + CurrentHeight,
    PaintBox.Width - RightGap - InnerTextGap,
    0
  );
  DrawText(PaintBox.Canvas.Handle,
    PChar(PChar(aText)),
    Length(aText),
    r,
    DT_LEFT or DT_TOP or DT_WORDBREAK or DT_CALCRECT
  );
  result := r.Bottom - r.Top;
end;

procedure TTextBoxPainter.AppendDrawInternal(const aText: string; const aColor: TColor;
  const aHeight: integer);
var
  r: TRect;
  canv: TCanvas;
  text: string;
begin
  r := Rect(
    LeftGap + InnerTextGap,
    Top + CurrentHeight,
    PaintBox.ClientWidth - RightGap - InnerTextGap,
    Top + CurrentHeight + InnerTextGap + aHeight
  );
  canv := PaintBox.Canvas;
  canv.Font.Color := aColor;
  text := aText;
  canv.TextRect(r, text, [tfWordBreak]);
end;

function TTextBoxPainter.EvaluateHeight(const aText: string): integer;
begin
  if FCache.ContainsKey(aText) then
    result := integer(FCache.GetValue(aText))
  else
  begin
    result := ActualEvaluateHeight(aText);
    FCache.PutValue(aText, TObject(result));
  end;
  if FCache.Size > DefaultCacheSize then
    FCache.Clear;
end;

function TTextBoxPainter.CheckAppendVisible(const aHeight: integer): boolean;
var
  fitsTop: boolean;
  fitsBottom: boolean;
begin
  fitsTop := Top + CurrentHeight + InnerTextGap + aHeight >= 0;
  fitsBottom := Top + CurrentHeight + InnerTextGap <= FBox.Height;
  result := fitsTop and fitsBottom;
end;

function TTextBoxPainter.AppendDraw(const aText: string; const aColor: TColor; const aDraw: boolean)
  : boolean;
var
  textHeight: integer;
  text: string;
begin
  text := aText;
  textHeight := EvaluateHeight(text);
  result := CheckAppendVisible(textHeight);
  if result and aDraw then
    AppendDrawInternal(aText, aColor, textHeight);
  CurrentHeight := CurrentHeight + textHeight + InnerTextGap;
end;

function TTextBoxPainter.Update(const aTime: integer): boolean;
var
  delta: integer;
  approached: boolean;
  validTop: integer;
begin
  if FTop = FDesiredTop then
  begin
    result := false;
    exit;
  end;
  delta := round(aTime / 1000 * ScrollSpeed);
  delta := max(
    delta,
    round(
      delta * exp(abs(FTop - FDesiredTop) / ScrollSpeed / DefaultTolerableTime)
    )
  );
  approached := ApproachInteger(FTop, FDesiredTop, delta);
  validTop := EnsureValidateTop(Top);
  if validTop <> Top then // выход за границы страницы
    Top := validTop;
  result := not approached; // repaint required
end;

destructor TTextBoxPainter.Destroy;
begin
  FreeAndNil(FCache);
  inherited Destroy;
end;

end.
