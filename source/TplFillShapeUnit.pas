
{**********************************************************************
 Package pl_Shapes.pkg
 This unit is part of CodeTyphon Studio (http://www.pilotlogic.com/)
***********************************************************************}

unit TplFillShapeUnit;

interface

uses
  Messages, LMessages, Types, LCLType, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

const
  DefSize = 10;
  DefSpacing = 20;
  DefShadowOfs = 2;

type
  TplFillShapeType = (msRectangle, msRoundRect, msDiamond, msEllipse,
    msTriangle, msLine, msText);
  TRepeatMode = (rpNone, rpVert, rpHoriz, rpBoth);

  TShapeStr = string

    [255];

  TplFillShape = class(TGraphicControl)
  private
    FAngle: integer;
    FAutoSize: boolean;
    FDX, FDY: integer;
    FFilled: boolean;
    FRepeatMode: TRepeatMode;
    FShapeType: TplFillShapeType;
    FShapeH: integer;
    FShapeW: integer;
    FXSpacing: integer;
    FYSpacing: integer;
    FXMargin: integer;
    FYMargin: integer;
    FBorder: boolean;
    FBorderColor: TColor;
    FBorderWidth: integer;
    FShadow: boolean;
    FShadowColor: TColor;
    FShadowX: integer;
    FShadowY: integer;

    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMColorChanged(var Message: TMessage); message CM_COLORCHANGED;
  protected

    procedure SetAngle(Value: integer);
    procedure SetAutoSize(Value: boolean); override;
    procedure SetFilled(Value: boolean);
    procedure SetRepeatMode(Value: TRepeatMode);
    procedure SetShapeType(Value: TplFillShapeType);
    procedure SetShapeH(Value: integer);
    procedure SetShapeW(Value: integer);
    procedure SetXSpacing(Value: integer);
    procedure SetYSpacing(Value: integer);
    procedure SetXMargin(Value: integer);
    procedure SetYMargin(Value: integer);
    procedure SetBorder(Value: boolean);
    procedure SetBorderColor(Value: TColor);
    procedure SetBorderWidth(Value: integer);
    procedure SetShadow(Value: boolean);
    procedure SetShadowColor(Value: TColor);
    procedure SetShadowX(Value: integer);
    procedure SetShadowY(Value: integer);

    procedure PrepareText;
    procedure UnprepareText;
    procedure AdjustShapeSize;
    procedure AdjustControlSize;
    procedure DrawRectangle(X, Y: integer);
    procedure DrawRoundRect(X, Y: integer);
    procedure DrawDiamond(X, Y: integer);
    procedure DrawEllipse(X, Y: integer);
    procedure DrawTriangle(X, Y: integer);
    procedure DrawLine(X, Y: integer);
    procedure DrawText(X, Y: integer);
    procedure Paint; override;
    property AutoSize: boolean read FAutoSize write SetAutoSize;
  public
    constructor Create(AOwner: TComponent); override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: integer); override;
  published
    property Angle: integer read FAngle write SetAngle;
    property Filled: boolean read FFilled write SetFilled default True;
    property RepeatMode: TRepeatMode read FRepeatMode write SetRepeatMode default rpBoth;
    property ShapeType: TplFillShapeType read FShapeType write SetShapeType;
    property ShapeH: integer read FShapeH write SetShapeH default DefSize;
    property ShapeW: integer read FShapeW write SetShapeW default DefSize;
    property XSpacing: integer read FXSpacing write SetXSpacing default DefSpacing;
    property YSpacing: integer read FYSpacing write SetYSpacing default DefSpacing;
    property XMargin: integer read FXMargin write SetXMargin;
    property YMargin: integer read FYMargin write SetYMargin;
    property Border: boolean read FBorder write SetBorder;
    property BorderColor: TColor read FBorderColor write SetBorderColor default clBlack;
    property BorderWidth: integer read FBorderWidth write SetBorderWidth default 1;
    property Shadow: boolean read FShadow write SetShadow;
    property ShadowColor: TColor read FShadowColor write SetShadowColor default clGray;
    property ShadowX: integer read FShadowX write SetShadowX default DefShadowOfs;
    property ShadowY: integer read FShadowY write SetShadowY default DefShadowOfs;
    property Align;
    property Color;
    property Font;
    property ParentColor;
    property ParentFont;
    property Text;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
  end;


implementation


constructor TplFillShape.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 64;
  Height := 64;
  Color := clNavy;
  FFilled := True;
  FShapeH := DefSize;
  FShapeW := DefSize;
  FRepeatMode := rpBoth;
  FXSpacing := DefSpacing;
  FYSpacing := DefSpacing;
  FBorderColor := clBlack;
  FBorderWidth := 1;
  FShadowColor := clGray;
  FShadowX := DefShadowOfs;
  FShadowY := DefShadowOfs;
end;

procedure TplFillShape.Paint;
var
  i, j, XN, YN, X, Y: integer;
begin
  inherited Paint;
  if FShapeType = msText then
    PrepareText;
  XN := 1;
  YN := 1;
  if (RepeatMode in [rpHoriz, rpBoth]) and (XSpacing > 0) then
    XN := Width div XSpacing + 1;
  if (RepeatMode in [rpVert, rpBoth]) and (YSpacing > 0) then
    YN := Height div YSpacing + 1;
  for i := 1 to YN do
    for j := 1 to XN do
    begin
      X := (j - 1) * XSpacing + XMargin;
      Y := (i - 1) * YSpacing + YMargin;
      case FShapeType of
        msRectangle: DrawRectangle(X, Y);
        msRoundRect: DrawRoundRect(X, Y);
        msDiamond: DrawDiamond(X, Y);
        msEllipse: DrawEllipse(X, Y);
        msTriangle: DrawTriangle(X, Y);
        msLine: DrawLine(X, Y);
        msText: DrawText(X, Y);
      end;
    end;
  if FShapeType = msText then
    UnprepareText;
end;


procedure TplFillShape.SetBounds(ALeft, ATop, AWidth, AHeight: integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  AdjustShapeSize;
end;

procedure TplFillShape.CMTextChanged(var Message: TMessage);
begin
  Invalidate;
end;

procedure TplFillShape.CMFontChanged(var Message: TMessage);
begin
  inherited;
  Color := Font.Color;
end;

procedure TplFillShape.CMColorChanged(var Message: TMessage);
begin
  inherited;
  Font.Color := Color;
end;

procedure TplFillShape.AdjustShapeSize;
begin
  if FAutoSize then
  begin
    FShapeW := Width - FXMargin * 2;
    FShapeH := Height - FYMargin * 2;
    if Shadow then
    begin
      Dec(FShapeW, ShadowX);
      Dec(FShapeH, ShadowY);
    end;
  end;
end;

procedure TplFillShape.AdjustControlSize;
var
  H, W: integer;
begin
  if FAutoSize then
  begin
    W := FShapeW + FXMargin * 2;
    H := FShapeH + FYMargin * 2;
    if FShadow then
    begin
      Inc(W, ShadowX);
      Inc(H, ShadowY);
    end;
    Width := W;
    Height := H;
  end;
end;


procedure TplFillShape.SetAngle(Value: integer);
begin
  if Value <> FAngle then
  begin
    FAngle := Value;
    {-- Normalization: -179° .. +180° ---------------}
    FAngle := FAngle mod 360;
    if FAngle = -180 then
      FAngle := 180;
    if FAngle > 180 then
      FAngle := -(360 - FAngle);
    if FAngle < -180 then
      FAngle := (360 + FAngle);
    {-- Only 45° steps allowed for triangles --------}
    if ShapeType in [msTriangle, msLine] then
      FAngle := Round(FAngle / 45) * 45;
    {-- Refresh -------------------------------------}
    Invalidate;
  end;
end;

procedure TplFillShape.SetAutoSize(Value: boolean);
begin
  if Value <> FAutoSize then
  begin
    FAutoSize := Value;
    if FAutoSize then
    begin
      FShapeW := Width - FXMargin * 2;
      FShapeH := Height - FYMargin * 2;
    end;
    Invalidate;
  end;
end;

procedure TplFillShape.SetFilled(Value: boolean);
begin
  if Value <> FFilled then
  begin
    FFilled := Value;
    Invalidate;
  end;
end;

procedure TplFillShape.SetRepeatMode(Value: TRepeatMode);
begin
  if Value <> FRepeatMode then
  begin
    FRepeatMode := Value;
    AutoSize := FRepeatMode = rpNone;
    Invalidate;
  end;
end;

procedure TplFillShape.SetShapeType(Value: TplFillShapeType);
begin
  if Value <> FShapeType then
  begin
    FShapeType := Value;
    Invalidate;
  end;
end;

procedure TplFillShape.SetShapeH(Value: integer);
begin
  if Value <> FShapeH then
  begin
    FShapeH := Value;
    AdjustControlSize;
    Invalidate;
  end;
end;

procedure TplFillShape.SetShapeW(Value: integer);
begin
  if Value <> FShapeW then
  begin
    FShapeW := Value;
    AdjustControlSize;
    Invalidate;
  end;
end;

procedure TplFillShape.SetXSpacing(Value: integer);
begin
  if Value <> FXSpacing then
  begin
    FXSpacing := Value;
    Invalidate;
  end;
end;

procedure TplFillShape.SetYSpacing(Value: integer);
begin
  if Value <> FYSpacing then
  begin
    FYSpacing := Value;
    Invalidate;
  end;
end;

procedure TplFillShape.SetXMargin(Value: integer);
begin
  if Value <> FXMargin then
  begin
    FXMargin := Value;
    AdjustControlSize;
    Invalidate;
  end;
end;

procedure TplFillShape.SetYMargin(Value: integer);
begin
  if Value <> FYMargin then
  begin
    FYMargin := Value;
    AdjustControlSize;
    Invalidate;
  end;
end;

procedure TplFillShape.SetBorder(Value: boolean);
begin
  if Value <> FBorder then
  begin
    FBorder := Value;
    Invalidate;
  end;
end;

procedure TplFillShape.SetBorderColor(Value: TColor);
begin
  if Value <> FBorderColor then
  begin
    FBorderColor := Value;
    Invalidate;
  end;
end;

procedure TplFillShape.SetBorderWidth(Value: integer);
begin
  if Value <> FBorderWidth then
  begin
    FBorderWidth := Value;
    Invalidate;
  end;
end;

procedure TplFillShape.SetShadow(Value: boolean);
begin
  if Value <> FShadow then
  begin
    FShadow := Value;
    AdjustControlSize;
    Invalidate;
  end;
end;

procedure TplFillShape.SetShadowColor(Value: TColor);
begin
  if Value <> FShadowColor then
  begin
    FShadowColor := Value;
    Invalidate;
  end;
end;

procedure TplFillShape.SetShadowX(Value: integer);
begin
  if Value <> FShadowX then
  begin
    FShadowX := Value;
    AdjustControlSize;
    Invalidate;
  end;
end;

procedure TplFillShape.SetShadowY(Value: integer);
begin
  if Value <> FShadowY then
  begin
    FShadowY := Value;
    AdjustControlSize;
    Invalidate;
  end;
end;

{--------------------------------------------------------------}
{                          Draw methods                        }
{--------------------------------------------------------------}

procedure TplFillShape.PrepareText;

var
  Rad: extended;
  TL, TH: integer;
  Sz: TSize;
  FontName: string[255];

begin

  Canvas.Font.Assign(Font);

  Canvas.Brush.Style := bsClear;
  {-- Calculates text offset from shape center -------------}

  // GetTextExtentPoint32(Canvas.Handle,@Text[1],Length(Text),Sz);
  Sz := canvas.TextExtent(Text);
  TL := Abs(Sz.CX);
  TH := Abs(Sz.CY);
  Rad := FAngle * Pi / 180;
  FDX := Round(TL / 2 * cos(Rad) + TH / 2 * sin(Rad));
  FDY := Round(TL / 2 * sin(Rad) - TH / 2 * cos(Rad));
end;

procedure TplFillShape.UnprepareText;
begin

end;

procedure TplFillShape.DrawRectangle(X, Y: integer);
var
  SX, SY, i: integer;
  Pt, ShPt: array[1..5] of TPoint;
begin
  Pt[1].X := X;
  Pt[1].Y := Y;
  Pt[2].X := X + ShapeW;
  Pt[2].Y := Y;
  Pt[3].X := X + ShapeW;
  Pt[3].Y := Y + ShapeH;
  Pt[4].X := X;
  Pt[4].Y := Y + ShapeH;
  Pt[5] := Pt[1];
  if Shadow then
  begin
    for i := 1 to 5 do
    begin
      ShPt[i] := Pt[i];
      Inc(ShPt[i].X, ShadowX);
      Inc(ShPt[i].Y, ShadowY);
    end;
    SX := X + ShadowX;
    SY := Y + ShadowY;
    Canvas.Pen.Color := ShadowColor;
    Canvas.Pen.Width := BorderWidth;
    Canvas.Brush.Color := ShadowColor;
    if Filled then
      Canvas.Rectangle(SX, SY, SX + ShapeW, SY + ShapeH)
    else
      Canvas.PolyLine(ShPt);
  end;
  if Border then
    Canvas.Pen.Color := BorderColor
  else
    Canvas.Pen.Color := Color;
  Canvas.Pen.Width := BorderWidth;
  Canvas.Brush.Color := Color;
  if Filled then
    Canvas.Rectangle(X, Y, X + ShapeW, Y + ShapeH)
  else
    Canvas.PolyLine(Pt);
end;

procedure TplFillShape.DrawRoundRect(X, Y: integer);
var
  SX, SY: integer;
begin
  if Shadow then
  begin
    SX := X + ShadowX;
    SY := Y + ShadowY;
    Canvas.Pen.Color := ShadowColor;
    Canvas.Pen.Width := 1;
    Canvas.Brush.Color := ShadowColor;
    Canvas.RoundRect(SX, SY, SX + ShapeW, SY + ShapeH, ShapeW div 2, ShapeH div 2);
  end;
  if Border then
    Canvas.Pen.Color := BorderColor
  else
    Canvas.Pen.Color := Color;
  Canvas.Pen.Width := BorderWidth;
  Canvas.Brush.Color := Color;
  Canvas.RoundRect(X, Y, X + ShapeW, Y + ShapeH, ShapeW div 2, ShapeH div 2);
end;

procedure TplFillShape.DrawDiamond(X, Y: integer);
var
  i: integer;
  Pt, ShPt: array[1..5] of TPoint;
begin
  Pt[1].X := X + ShapeW div 2;
  Pt[1].Y := Y;
  Pt[2].X := X + (ShapeW div 2) * 2;
  Pt[2].Y := Y + ShapeH div 2;
  Pt[3].X := Pt[1].X;
  Pt[3].Y := Y + (ShapeH div 2) * 2;
  Pt[4].X := X;
  Pt[4].Y := Pt[2].Y;
  Pt[5] := Pt[1];
  if Shadow then
  begin
    for i := 1 to 5 do
    begin
      ShPt[i] := Pt[i];
      Inc(ShPt[i].X, ShadowX);
      Inc(ShPt[i].Y, ShadowY);
    end;
    Canvas.Pen.Color := ShadowColor;
    Canvas.Pen.Width := BorderWidth;
    Canvas.Brush.Color := ShadowColor;
    if Filled then
      Canvas.Polygon(ShPt)
    else
      Canvas.PolyLine(ShPt);
  end;
  if Border then
    Canvas.Pen.Color := BorderColor
  else
    Canvas.Pen.Color := Color;
  Canvas.Pen.Width := BorderWidth;
  Canvas.Brush.Color := Color;
  if Filled then
    Canvas.Polygon(Pt)
  else
    Canvas.PolyLine(Pt);
end;

procedure TplFillShape.DrawEllipse(X, Y: integer);
var
  SX, SY: integer;
begin
  if Shadow then
  begin
    SX := X + ShadowX;
    SY := Y + ShadowY;
    Canvas.Pen.Color := ShadowColor;
    Canvas.Pen.Width := BorderWidth;
    Canvas.Brush.Color := ShadowColor;
    if Filled then
      Canvas.Ellipse(SX, SY, SX + ShapeW, SY + ShapeH)
    else
      Canvas.Arc(SX, SY, SX + ShapeW, SY + ShapeH, SX, SY, SX, SY);
  end;
  if Border then
    Canvas.Pen.Color := BorderColor
  else
    Canvas.Pen.Color := Color;
  Canvas.Pen.Width := BorderWidth;
  Canvas.Brush.Color := Color;
  if Filled then
    Canvas.Ellipse(X, Y, X + ShapeW, Y + ShapeH)
  else
    Canvas.Arc(X, Y, X + ShapeW, Y + ShapeH, X, Y, X, Y);
end;

procedure TplFillShape.DrawTriangle(X, Y: integer);
var
  i, SW, SH: integer;
  Pt, ShPt: array[1..4] of TPoint;
begin

  SW := (ShapeW div 2) * 2;
  SH := (ShapeH div 2) * 2;
  case Angle of
    -135:
    begin
      Pt[1].X := X;
      Pt[1].Y := Y;
      Pt[2].X := X;
      Pt[2].Y := Y + SH;
      Pt[3].X := X + SW;
      Pt[3].Y := Y + SH;
    end;
    -90:
    begin
      Pt[1].X := X;
      Pt[1].Y := Y;
      Pt[2].X := X + SW;
      Pt[2].Y := Y;
      Pt[3].X := X + SW div 2;
      Pt[3].Y := Y + SH;
    end;
    -45:
    begin
      Pt[1].X := X + SW;
      Pt[1].Y := Y;
      Pt[2].X := X + SW;
      Pt[2].Y := Y + SH;
      Pt[3].X := X;
      Pt[3].Y := Y + SH;
    end;
    0:
    begin
      Pt[1].X := X;
      Pt[1].Y := Y;
      Pt[2].X := X + SW;
      Pt[2].Y := Y + SH div 2;
      Pt[3].X := X;
      Pt[3].Y := Y + SH;
    end;
    45:
    begin
      Pt[1].X := X;
      Pt[1].Y := Y;
      Pt[2].X := X + SW;
      Pt[2].Y := Y;
      Pt[3].X := X + SW;
      Pt[3].Y := Y + SH;
    end;
    90:
    begin
      Pt[1].X := X + SW div 2;
      Pt[1].Y := Y;
      Pt[2].X := X + SW;
      Pt[2].Y := Y + SH;
      Pt[3].X := X;
      Pt[3].Y := Y + SH;
    end;
    135:
    begin
      Pt[1].X := X;
      Pt[1].Y := Y;
      Pt[2].X := X + SW;
      Pt[2].Y := Y;
      Pt[3].X := X;
      Pt[3].Y := Y + SH;
    end;
    180:
    begin
      Pt[1].X := X;
      Pt[1].Y := Y + SH div 2;
      Pt[2].X := X + SW;
      Pt[2].Y := Y;
      Pt[3].X := X + SW;
      Pt[3].Y := Y + SH;
    end;
  end;
  Pt[4] := Pt[1];
  if Shadow then
  begin
    for i := 1 to 4 do
    begin
      ShPt[i] := Pt[i];
      Inc(ShPt[i].X, ShadowX);
      Inc(ShPt[i].Y, ShadowY);
    end;
    Canvas.Pen.Color := ShadowColor;
    Canvas.Pen.Width := BorderWidth;
    Canvas.Brush.Color := ShadowColor;
    if Filled then
      Canvas.Polygon(ShPt)
    else
      Canvas.PolyLine(ShPt);
  end;
  if Border then
    Canvas.Pen.Color := BorderColor
  else
    Canvas.Pen.Color := Color;
  Canvas.Pen.Width := BorderWidth;
  Canvas.Brush.Color := Color;
  if Filled then
    Canvas.Polygon(Pt)
  else
    Canvas.PolyLine(Pt);
end;

procedure TplFillShape.DrawLine(X, Y: integer);
var
  A, X1, Y1, X2, Y2, CX, CY: integer;
begin
  if Angle < 0 then
    A := 180 - Angle
  else
    A := Angle;
  A := A mod 180;
  CX := ShapeW div 2;
  CY := ShapeH div 2;
  case A of
    0:
    begin
      X1 := X;
      Y1 := Y + CY;
      X2 := X + ShapeW;
      Y2 := Y + CY;
    end;
    45:
    begin
      X1 := X;
      Y1 := Y + ShapeH;
      X2 := X + ShapeW;
      Y2 := Y;
    end;
    90:
    begin
      X1 := X + CX;
      Y1 := Y;
      X2 := X + CX;
      Y2 := Y + ShapeH;
    end;
    135:
    begin
      X1 := X;
      Y1 := Y;
      X2 := X + ShapeW;
      Y2 := Y + ShapeH;
    end;
    else
    begin
      X1 := X + CX;
      Y1 := Y + CY;
      X2 := CX + ShapeW;
      Y2 := Y + CY;
    end;
  end;
  Canvas.Pen.Width := BorderWidth;
  if Shadow then
  begin
    Canvas.Pen.Color := ShadowColor;
    Inc(X1, ShadowX);
    Inc(Y1, ShadowY);
    Inc(X2, ShadowX);
    Inc(Y2, ShadowY);
    Canvas.MoveTo(X1, Y1);
    Canvas.LineTo(X2, Y2);
    Dec(X1, ShadowX);
    Dec(Y1, ShadowY);
    Dec(X2, ShadowX);
    Dec(Y2, ShadowY);
  end;
  Canvas.Pen.Color := Color;
  Canvas.MoveTo(X1, Y1);
  Canvas.LineTo(X2, Y2);
end;

procedure TplFillShape.DrawText(X, Y: integer);
var
  TX, TY, SX, SY: integer;
begin
  TX := X + ShapeW div 2 - FDX;
  TY := Y + ShapeH div 2 + FDY;
  if Shadow then
  begin
    canvas.Font.Color := ColorToRGB(ShadowColor);
    SX := TX + ShadowX;
    SY := TY + ShadowY;
    Canvas.TextOut(SX, SY, Text);
  end;
  canvas.Font.Color := ColorToRGB(Color);
  Canvas.TextOut(TX, TY, Text);
  Canvas.TextOut(TX, TY, Text);
end;


end.
