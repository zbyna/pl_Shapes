
{**********************************************************************
 Package pl_Shapes.pkg
 This unit is part of CodeTyphon Studio (http://www.pilotlogic.com/)
***********************************************************************}
unit TplShapesUnit;

{$R-,W-,S-}

interface

uses
  LCLType, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Math;

type

  TplCustomShape = class(TGraphicControl)
  private
    FBrush: TBrush;
    FPen: TPen;
    FShadow: boolean;
    FShadowOffset: integer;
    FShadowColor: TColor;
    procedure ChangeRedraw(Sender: TObject);
    procedure SetBrush(Value: TBrush);
    procedure SetPen(Value: TPen);
    procedure SetShadow(Value: boolean);
    procedure SetShadowOffset(Value: integer);
    procedure SetShadowColor(Value: TColor);
  protected
    procedure Paint; override;
    procedure PaintShadow; virtual;
    procedure PaintShape; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Align;
    property Brush: TBrush read FBrush write SetBrush;
    property DragCursor;
    property DragMode;
    property Enabled;
    property ParentShowHint;
    property Pen: TPen read FPen write SetPen;
    property Shadow: boolean read FShadow write SetShadow;
    property ShadowOffset: integer read FShadowOffset write SetShadowOffset;
    property ShadowColor: TColor read FShadowColor write SetShadowColor;
    property ShowHint;
    property Visible;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
  end;

  TplCustomPolyShape = class(TplCustomShape)
  protected
    fAngle: single;
    procedure SetAngle(val: single);
    function CalcPoly(var Points: array of TPoint; Source: array of TPoint; AWidth, AHeight: integer): boolean; virtual;
    procedure OffsetPoly(var Points: array of TPoint; OfsX, OfsY: integer); virtual;
    property Angle: single read fangle write SetAngle;
  end;

  //.............NO Angle Shapes ...................

  TplRectShape = class(TplCustomShape)
  protected
    procedure PaintShadow; override;
    procedure PaintShape; override;
  end;

  TplRoundRectShape = class(TplCustomShape)
  protected
    procedure PaintShadow; override;
    procedure PaintShape; override;
  end;

  TplSquareShape = class(TplCustomShape)
  protected
    procedure PaintShadow; override;
    procedure PaintShape; override;
  end;

  TplRoundSquareShape = class(TplCustomShape)
  protected
    procedure PaintShadow; override;
    procedure PaintShape; override;
  end;

  TplEllipseShape = class(TplCustomShape)
  protected
    procedure PaintShadow; override;
    procedure PaintShape; override;
  end;

  TplCircleShape = class(TplCustomShape)
  protected
    procedure PaintShadow; override;
    procedure PaintShape; override;
  end;

  //.............Angle Shapes ...................

  TplTriangleShape = class(TplCustomPolyShape)
  protected
    procedure PaintShadow; override;
    procedure PaintShape; override;
  published
    property Angle;
  end;

  TplRectangleShape = class(TplCustomPolyShape)
  protected
    procedure PaintShadow; override;
    procedure PaintShape; override;
  published
    property Angle;
  end;

  TplParallelogramShape = class(TplCustomPolyShape)
  protected
    procedure PaintShadow; override;
    procedure PaintShape; override;
  published
    property Angle;
  end;


  TplTrapezoidShape = class(TplCustomPolyShape)
  protected
    procedure PaintShadow; override;
    procedure PaintShape; override;
  published
    property Angle;
  end;

  TplPentagonShape = class(TplCustomPolyShape)
  protected
    procedure PaintShadow; override;
    procedure PaintShape; override;
  published
    property Angle;
  end;


  TplHexagonShape = class(TplCustomPolyShape)
  protected
    procedure PaintShadow; override;
    procedure PaintShape; override;
  published
    property Angle;
  end;

  TplOctagonShape = class(TplCustomPolyShape)
  protected
    procedure PaintShadow; override;
    procedure PaintShape; override;
  published
    property Angle;
  end;


  TplStarShape = class(TplCustomPolyShape)
  protected
    procedure PaintShadow; override;
    procedure PaintShape; override;
  published
    property Angle;
  end;


  TplBubbleShape = class(TplCustomPolyShape)
  protected
    procedure PaintShadow; override;
    procedure PaintShape; override;
  published
    property Angle;
  end;


implementation

{ Polygon points for geometric shapes }
const
  POLY_TRIANGLE: array[0..3] of TPoint =
    ((X: 50; Y: 0), (X: 100; Y: 100), (X: 0; Y: 100), (X: 50; Y: 0));
  POLY_RECTANGLE: array[0..4] of TPoint =
    ((X: 0; Y: 0), (X: 100; Y: 0), (X: 100; Y: 100), (X: 0; Y: 100), (X: 0; Y: 0));
  POLY_PARALLELOGRAM: array[0..4] of TPoint =
    ((X: 0; Y: 0), (X: 75; Y: 0), (X: 100; Y: 100), (X: 25; Y: 100), (X: 0; Y: 0));
  POLY_TRAPEZOID: array[0..4] of TPoint =
    ((X: 25; Y: 0), (X: 75; Y: 0), (X: 100; Y: 100), (X: 0; Y: 100), (X: 25; Y: 0));
  POLY_PENTAGON: array[0..5] of TPoint =
    ((X: 50; Y: 0), (X: 100; Y: 50), (X: 75; Y: 100), (X: 25; Y: 100), (X: 0; Y: 50), (X: 50; Y: 0));
  POLY_HEXAGON: array[0..6] of TPoint =
    ((X: 25; Y: 0), (X: 75; Y: 0), (X: 100; Y: 50), (X: 75; Y: 100), (X: 25; Y: 100), (X: 0; Y: 50),
    (X: 25; Y: 0));
  POLY_OCTAGON: array[0..8] of TPoint =
    ((X: 25; Y: 0), (X: 75; Y: 0), (X: 100; Y: 25), (X: 100; Y: 75), (X: 75; Y: 100), (X: 25; Y: 100),
    (X: 0; Y: 75), (X: 0; Y: 25), (X: 25; Y: 0));

  POLY_STAR: array[0..16] of TPoint =
    ((X: 44; Y: 0), (X: 52; Y: 24), (X: 76; Y: 12), (X: 64; Y: 36), (X: 88; Y: 44), (X: 64; Y: 52),
    (X: 76; Y: 76), (X: 52; Y: 64), (X: 44; Y: 88), (X: 36; Y: 64), (X: 12; Y: 76), (X: 24; Y: 52),
    (X: 0; Y: 44), (X: 24; Y: 36), (X: 12; Y: 12), (X: 36; Y: 24), (X: 44; Y: 0));

  POLY_BUBBLE: array[0..11] of TPoint =
    ((X: 40; Y: 92), (X: 68; Y: 40), (X: 80; Y: 40), (X: 92; Y: 28), (X: 92; Y: 12), (X: 80; Y: 0),
    (X: 12; Y: 0), (X: 0; Y: 12), (X: 0; Y: 28), (X: 12; Y: 40), (X: 60; Y: 40), (X: 40; Y: 92));

//============================ TplCustomShape =======================================
constructor TplCustomShape.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csReplicatable];
  Width := 64;
  Height := 64;
  FBrush := TBrush.Create;
  FBrush.OnChange := @ChangeRedraw;
  FPen := TPen.Create;
  FPen.OnChange := @ChangeRedraw;
  FShadow := True;
  FShadowOffset := 2;
  FShadowColor := clBtnShadow;
end;

destructor TplCustomShape.Destroy;
begin
  FBrush.Free;
  FPen.Free;
  inherited Destroy;
end;

procedure TplCustomShape.Paint;
begin
  inherited Paint;

  Canvas.Brush := FBrush;
  Canvas.Pen := FPen;

  if Shadow then
    PaintShadow;
  PaintShape;
end;

procedure TplCustomShape.PaintShadow;
begin
  Canvas.Brush.Color := FShadowColor;
  Canvas.Pen.Color := FShadowColor;
end;

procedure TplCustomShape.PaintShape;
begin
  Canvas.Brush.Color := FBrush.Color;
  Canvas.Pen.Color := FPen.Color;
end;

procedure TplCustomShape.ChangeRedraw(Sender: TObject);
begin
  Invalidate;
end;

procedure TplCustomShape.SetBrush(Value: TBrush);
begin
  FBrush.Assign(Value);
end;

procedure TplCustomShape.SetPen(Value: TPen);
begin
  FPen.Assign(Value);
end;

procedure TplCustomShape.SetShadow(Value: boolean);
begin
  if FShadow <> Value then
  begin
    FShadow := Value;
    Invalidate;
  end;
end;

procedure TplCustomShape.SetShadowOffset(Value: integer);
begin
  if FShadowOffset <> Value then
  begin
    FShadowOffset := Value;
    Invalidate;
  end;
end;

procedure TplCustomShape.SetShadowColor(Value: TColor);
begin
  if FShadowColor <> Value then
  begin
    FShadowColor := Value;
    Invalidate;
  end;
end;

//=========================== TplCustomPolyShape ===========================================
function TplCustomPolyShape.CalcPoly(var Points: array of TPoint; Source: array of TPoint; AWidth, AHeight: integer): boolean;
var
  i: integer;
  lx, ly: longint;
  vSin, vCos: extended;
  Px, Py, CenterX, CenterY, FminX, FminY, FmaxX, FMaxY: Float;
begin
  Result := True;
  try

    //......Resize to AWidth/AHeight ..........................
    for i := Low(Points) to High(Points) do
    begin
      lx := MulDiv(Source[i].x, AWidth, 100);
      ly := MulDiv(Source[i].y, AHeight, 100);
      Points[i].x := lx;
      Points[i].y := ly;
    end;

    //... Rotate for angle ....................................
    CenterX := AWidth / 2;
    CenterY := AHeight / 2;
    SinCos(DegToRad(-fAngle), vSin, vCos);

    for i := Low(Points) to High(Points) do
    begin
      Px := (Points[i].x - CenterX);
      Py := (Points[i].y - CenterY);
      Points[i].x := round(Px * vCos + Py * vSin + CenterX);
      Points[i].y := round(Py * vCos - Px * vSin + CenterY);
    end;
    //.........................................................
    FminX := 0;
    FminY := 0;
    FmaxX := AWidth;
    FmaxY := AHeight;

    for i := Low(Points) to High(Points) do
    begin
      //..find min....
      if Points[i].x < 0 then
        if Points[i].x < FminX then
          FminX := Points[i].x;

      if Points[i].y < 0 then
        if Points[i].y < FminY then
          FminY := Points[i].y;
      //..find max....
      if Points[i].x > AWidth then
        if Points[i].x > FmaxX then
          FmaxX := Points[i].x;

      if Points[i].y > AHeight then
        if Points[i].y > FmaxY then
          FmaxY := Points[i].y;
    end;

    for i := Low(Points) to High(Points) do
    begin
      Points[i].x := round(Points[i].x - FminX);
      Points[i].y := round(Points[i].y - FminY);

      lx := MulDiv(Points[i].x, AWidth, Round(FmaxX - FminX));
      ly := MulDiv(Points[i].y, AHeight, Round(FmaxY - FminY));
      Points[i].x := lx;
      Points[i].y := ly;
    end;

  except
    Result := False;
  end;
end;

procedure TplCustomPolyShape.OffsetPoly(var Points: array of TPoint; OfsX, OfsY: integer);
var
  i: integer;
begin
  for i := Low(Points) to High(Points) do
  begin
    Points[i].x := Points[i].x + OfsX;
    Points[i].y := Points[i].y + OfsY;
  end;
end;

procedure TplCustomPolyShape.SetAngle(val: single);
begin
  if val = angle then
    exit;

  fangle := val;
  if fangle > 360 then
    fangle := 360;
  if fangle < 0 then
    fangle := 0;

  Invalidate;
end;

//================================================================

{$I wAngleShapes.inc}
{$I wNoAngleShapes.inc}

end.
