{**********************************************************************
 Package pl_Shapes.pkg
 This unit is part of CodeTyphon Studio (http://www.pilotlogic.com/)
***********************************************************************}

unit TplShapeObjects;

interface

uses
  SysUtils, Classes, LMessages, Controls, Graphics, Math,
  Forms, TypInfo, Dialogs, TplShapeObjectsBase,BGRABitmap,BGRABitmapTypes,
  BGRACanvas,LazUTF8;

type
  TFontOutLine = (foNone, foClear, foColored);

  TplLine = class(TplConnector)
  protected
    fArrowSize: Cardinal;
    fArrowFill: Boolean;
    procedure SetArrowSize(const Val:Cardinal);
    procedure SetArrowFill(const Val:Boolean);
    procedure DrawObject(aCanvas: TbgraCanvas; IsShadow: boolean); override;
    procedure SetButtonCount(Count: integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    function Grow(TopEnd: boolean = False): boolean; override;
    function Shrink(TopEnd: boolean = False): boolean; override;
  published
    property ArrowSize: cardinal read fArrowSize write SetArrowSize;
    property ArrowFill: boolean  read fArrowFill write SetArrowFill;
  end;

  TplZLine = class(TplConnector)
  private
    fAutoCenter: boolean;
    fArrowSize: Cardinal;
    fArrowFill: Boolean;
    procedure SetArrowSize(const Val:Cardinal);
    procedure SetArrowFill(const Val:Boolean);
    procedure SetAutoCenter(AutoCenter: boolean);
  protected
    procedure DrawObject(aCanvas: TbgraCanvas; IsShadow: boolean); override;
    procedure InternalBtnMove(BtnIdx: integer; NewPt: TPoint); override;
    procedure UpdateNonEndButtonsAfterBtnMove; override;
    procedure DoQuadPtConnection; override;
    procedure DrawBtn(BtnPt: TPoint; index: integer; Pressed, LastBtn: boolean); override;
    procedure SaveToPropStrings; override;
  public
    constructor Create(AOwner: TComponent); override;
    function IsValidBtnDown(BtnIdx: integer): boolean; override;
    procedure Rotate(degrees: integer); override;
  published
    property AutoCenter: boolean read fAutoCenter write SetAutoCenter;
    property ArrowSize: cardinal read fArrowSize write SetArrowSize;
    property ArrowFill: boolean  read fArrowFill write SetArrowFill;
    property AutoOrientation;
    property Orientation;
  end;

  TplLLine = class(TplConnector)
  protected
    fArrowSize: Cardinal;
    fArrowFill: Boolean;
    procedure SetArrowSize(const Val:Cardinal);
    procedure SetArrowFill(const Val:Boolean);
    procedure DrawObject(aCanvas: TbgraCanvas; IsShadow: boolean); override;
    procedure SaveToPropStrings; override;
    procedure DoQuadPtConnection; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Rotate(degrees: integer); override;
  published
    property ArrowSize: cardinal read fArrowSize write SetArrowSize;
    property ArrowFill: boolean  read fArrowFill write SetArrowFill;
    property Orientation;
  end;

  TplBezier = class(TplConnector)
  private
    fSmooth: boolean;
    fFilled: boolean;
    fArrowSize: Cardinal;
    fArrowFill: Boolean;
    procedure SetArrowSize(const Val:Cardinal);
    procedure SetArrowFill(const Val:Boolean);
  protected
    procedure SetFilled(isFilled: boolean); virtual;
    procedure SetArrow1(Arrow: boolean); override;
    procedure SetArrow2(Arrow: boolean); override;
    procedure SetButtonCount(Count: integer); override;
    procedure DrawControlLines; override;
    procedure DrawObject(aCanvas: TbgraCanvas; IsShadow: boolean); override;
    procedure InternalBtnMove(BtnIdx: integer; NewPt: TPoint); override;
    procedure UpdateConnectionPoints(MovingConnection: TplSolid); override;
    procedure SaveToPropStrings; override;
  public
    constructor Create(AOwner: TComponent); override;
    function Grow(TopEnd: boolean = False): boolean; override;
    function Shrink(TopEnd: boolean = False): boolean; override;
  published
    property Filled: boolean read fFilled write SetFilled;
    property Smooth: boolean read fSmooth write fSmooth default True;
    property ArrowSize: cardinal read fArrowSize write SetArrowSize;
    property ArrowFill: boolean  read fArrowFill write SetArrowFill;
  end;

  TplSolidBezier = class(TplBezier)
  private
    fBorder: integer;
    procedure SetNoConnection(Connection: TplSolid);
    function GetNoConnection: TplSolid;
    procedure SetBorder(border: integer);
  protected
    procedure SetFilled(isFilled: boolean); override;
    procedure SetArrow1(Arrow: boolean); override;
    procedure SetArrow2(Arrow: boolean); override;
    procedure SetUseHitTest(Value: boolean); override;
    procedure DrawObject(aCanvas: TbgraCanvas; IsShadow: boolean); override;
    procedure SaveToPropStrings; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Mirror;
    procedure Flip;
  published
    property Connection1: TplSolid read GetNoConnection write SetNoConnection;
    property Connection2: TplSolid read GetNoConnection write SetNoConnection;
    property BorderWidth: integer read fBorder write SetBorder;
  end;

  TplTextBezier = class(TplBezier)
  private
    fText: string;
    fOuTplLine: TFontOutLine;
    procedure SetNoConnection(Connection: TplSolid);
    function GetNoConnection: TplSolid;
    procedure SetText(const aText: string);
    procedure SetOuTplLine(OuTplLine: TFontOutLine);
    procedure CMFontChanged(var Message: TLMessage); message CM_FONTCHANGED;
  protected
    procedure CalcMargin; override;
    procedure SetFilled(isFilled: boolean); override;
    procedure SetArrow1(Arrow: boolean); override;
    procedure SetArrow2(Arrow: boolean); override;
    procedure SetUseHitTest(Value: boolean); override;
    procedure DrawObject(aCanvas: TbgraCanvas; IsShadow: boolean); override;
    procedure SaveToPropStrings; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Connection1: TplSolid read GetNoConnection write SetNoConnection;
    property Connection2: TplSolid read GetNoConnection write SetNoConnection;
    property Text: string read fText write SetText;
    property Font;
    property OuTplLine: TFontOutLine read fOuTplLine write SetOuTplLine;
    property ParentFont;
  end;

  TplArc = class(TplSolid)
  private
    fAngle1: integer;
    fAngle2: integer;
    fRegular: boolean;
    fCurrRotAngle: integer;
    procedure SetAngle1(ang1: integer);
    procedure SetAngle2(ang2: integer);
    procedure SetRegular(Value: boolean);
  protected
    procedure DrawObject(aCanvas: TbgraCanvas; IsShadow: boolean); override;
    procedure InternalBtnMove(BtnIdx: integer; NewPt: TPoint); override;
    procedure SaveToPropStrings; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure BeginTransform; override;
    procedure Rotate(degrees: integer); override;
  published
    property Angle1: integer read fAngle1 write SetAngle1;
    property Angle2: integer read fAngle2 write SetAngle2;
    property Regular: boolean read fRegular write SetRegular;
  end;


  { TplDrawPicture }

  TplDrawPicture = class(TplSolid)
  private
    //fPic: TBitmap;
    fpic:TBGRABitmap;
    FpictureFileName: AnsiString;
    fStretch: boolean;
    fTransparent: boolean;
    fTightConnections: boolean;
    procedure SetpictureFileName(AValue: AnsiString);
    procedure SetStretch(Stretch: boolean);
    procedure SetTransparent(Transparent: boolean);
    procedure SetTightConnections(Value: boolean);
    procedure LoadPicFromDataStream;
    function GetAngle: integer;
    procedure SetAngle(angle: integer);
  protected
    procedure DrawObject(aCanvas: TbgraCanvas; IsShadow: boolean); override;
    procedure SaveToPropStrings; override;
    procedure BinaryDataLoaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function IsValidBtnDown(BtnIdx: integer): boolean; override;
    function ClosestScreenPt(FromScreenPt: TPoint): TPoint; override;
    procedure LoadPicFromFile(const filename: string);
    procedure SavePicToFile(const filename: string);
    function MergeDrawObjImage(DrawObj: TplDrawObject; TransparentClr: TColor): boolean;
    procedure Rotate(degrees: integer); override;
  published
    property pictureFileName:AnsiString read FpictureFileName write SetpictureFileName;
    property Angle: integer read GetAngle write SetAngle;
    property Stretch: boolean read fStretch write SetStretch;
    property Transparent: boolean read fTransparent write SetTransparent;
    property TightConnections: boolean read fTightConnections write SetTightConnections;
  end;

  TplSolidPoint = class(TplSolid)
  protected
    procedure CalcMargin; override;
    procedure AddConnector(Connector: TplConnector); override;
    procedure DrawObject(aCanvas: TbgraCanvas; IsShadow: boolean); override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TplDiamond = class(TplSolidWithText)
  private
    procedure SeTplDiamondPts;
  protected
    procedure DrawStringsInDiamond(aCanvas: TbgraCanvas; aStrings: TStrings);
    procedure InternalBtnMove(BtnIdx: integer; NewPt: TPoint); override;
    procedure DrawObject(aCanvas: TbgraCanvas; IsShadow: boolean); override;
  public
    constructor Create(AOwner: TComponent); override;
    function ClosestScreenPt(FromScreenPt: TPoint): TPoint; override;
    function ResizeObjectToFitText: boolean; override;
    procedure Rotate(degrees: integer); override;
  end;

  TplRectangle = class(TplSolidWithText)
  private
    fCentered: boolean;
    fRounded: boolean;
    procedure SetCentered(Centered: boolean);
    procedure SetRounded(Rounded: boolean);
    procedure SeTplRectanglePts;
  protected
    procedure DrawStringsInRect(aCanvas: TbgraCanvas; aStrings: TStrings);
    procedure InternalBtnMove(BtnIdx: integer; NewPt: TPoint); override;
    procedure DrawObject(aCanvas: TbgraCanvas; IsShadow: boolean); override;
    procedure SaveToPropStrings; override;
  public
    constructor Create(AOwner: TComponent); override;
    function ClosestScreenPt(FromScreenPt: TPoint): TPoint; override;
    function ResizeObjectToFitText: boolean; override;
    procedure Rotate(degrees: integer); override;
  published
    property Centered: boolean read fCentered write SetCentered default True;
    property Rounded: boolean read fRounded write SetRounded default False;
  end;

  TplText = class(TplRectangle)
  private
    function GetStrings: TStrings;
    procedure SetStrings(astrings: TStrings);
  protected
    procedure DrawObject(aCanvas: TbgraCanvas; IsShadow: boolean); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Strings: TStrings read GetStrings write SetStrings;
  end;

  { TplEllipse }

  TplEllipse = class(TplSolidWithText)
  private
    fBalloonPoint: TBalloonPoint;
    FLabelRatioInUnits: Float;
    fRatioInUnits: Float;
    fRegular: boolean;
    procedure SetBalloonPoint(BalloonPoint: TBalloonPoint);
    procedure SetLabelRatioInUnits(AValue: Float);
    procedure SetratioInUnits(AValue: Float);
    procedure SetRegular(Value: boolean);
  protected
    procedure SetAngle(aangle: integer); override;
    procedure DrawStringsInEllipse(acanvas: TbgraCanvas; aStrings: TStrings);
    procedure SeTplBezierButtons;

    procedure SaveToPropStrings; override;
    procedure InternalBtnMove(BtnIdx: integer; NewPt: TPoint); override;
  public
    procedure DrawObject(aCanvas: TbgraCanvas; IsShadow: boolean); override;  //by zbyna
    procedure drawSpecialDimensions(targetCanvas:TbgraCanvas); override;
    constructor Create(AOwner: TComponent); override;
    function ClosestScreenPt(FromScreenPt: TPoint): TPoint; override;
    function ResizeObjectToFiTText: boolean; override;
    procedure Rotate(degrees: integer); override;
    procedure SetoutsideObject(AValue: TplDrawObject); override;
  published
    property BalloonPoint: TBalloonPoint read fBalloonPoint write SetBalloonPoint;
    property Regular: boolean read fRegular write SetRegular;
    property ratioInUnits:Float read FratioInUnits write SetratioInUnits;
    property labelRatioInUnits:Float read FLabelRatioInUnits write SetLabelRatioInUnits;
  end;

  { TplPolygon }

  TplPolygon = class(TplSolid)
  private
    fPlainPoly: boolean;
    procedure SetPlainPoly(isPlainPoly: boolean);
  protected
    procedure InitializePoints; virtual;
    function GetButtonCount: integer;
    procedure SetButtonCount(Count: integer); virtual;
    procedure SaveToPropStrings; override;
    procedure InternalBtnMove(BtnIdx: integer; NewPt: TPoint); override;
    function IsValidBtnDown(BtnIdx: integer): boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure DrawObject(aCanvas: TbgraCanvas; IsShadow: boolean); override;
    function ClosestScreenPt(FromScreenPt: TPoint): TPoint; override;
    procedure DuplicateButton(btnIdx: integer); virtual;
    procedure RemoveButton(btnIdx: integer); virtual;
    procedure Mirror;
    procedure Flip;
  published
    property ButtonCount: integer read GetButtonCount write SetButtonCount;
    property Regular: boolean read fPlainPoly write SetPlainPoly;
  end;

  { TplSolidArrow }

  TplSolidArrow = class(TplSolid)
  private
    fWasRotated: boolean;
  protected
    procedure InternalBtnMove(BtnIdx: integer; NewPt: TPoint); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure DrawObject(aCanvas: TbgraCanvas; IsShadow: boolean); override;
    procedure Rotate(degrees: integer); override;
  end;

  TplRandomPoly = class(TplPolygon)
  protected
    procedure InitializePoints; override;
    procedure SetButtonCount(Count: integer); override;
  public
    procedure Randomize;
  end;

  TplStar = class(TplPolygon)
  private
    fMidPtInScreenCoords: TPoint;
    fBoringStar: boolean;
    procedure SetBoringStar(BoringStar: boolean);
    procedure SetPointsAroundCirc(StartPtIdx: integer; NewPt: TPoint);
  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: integer); override;
    procedure InternalBtnMove(BtnIdx: integer; NewPt: TPoint); override;
    procedure InitializePoints; override;
    procedure SetButtonCount(Count: integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure DuplicateButton(btnIdx: integer); override;
    procedure RemoveButton(btnIdx: integer); override;
  published
    property Regular: boolean read fBoringStar write SetBoringStar;
  end;


implementation

uses Types, LCLType;

var
  fDummyStrings: TStrings;

function dummyStrings: TStrings;
begin
  if not assigned(fDummyStrings) then
  begin
    fDummyStrings := TStringList.Create;
    fDummyStrings.Add('Text Object'); //otherwise TplText object becomes invisible
  end;
  Result := fDummyStrings;
end;


// =============== Miscellaneous functions ==================================


procedure RegisterDrawObjClasses;
begin
  RegisterClasses([TplLine, TplLLine, TplZLine, TplBezier, TplSolidBezier, TplTextBezier, TplRectangle,
    TplDrawPicture, TplDiamond, TplEllipse, TplArc, TplPolygon, TplSolidArrow, TplRandomPoly, TplStar, TplSolidPoint, TplText]);
end;

function ClosestPointIdx(pts: array of TPoint; toPoint: TPoint): integer;
var
  i: integer;
  resDist, dist: single;
begin
  Result := 0;
  resDist := SquaredDistBetweenPoints(pts[0], toPoint);
  for i := 1 to high(pts) do
  begin
    dist := SquaredDistBetweenPoints(pts[i], toPoint);
    if dist >= resDist then
      continue;
    resDist := dist;
    Result := i;
  end;
end;

function APointIsBetweenPts(aPoint, Pt1, Pt2: TPoint): boolean;
begin
  Result := False;
  if (Pt1.X < Pt2.X) and ((aPoint.X < Pt1.X) or (aPoint.X > Pt2.X)) then
    exit;
  if (Pt1.X > Pt2.X) and ((aPoint.X > Pt1.X) or (aPoint.X < Pt2.X)) then
    exit;
  if (Pt1.Y < Pt2.Y) and ((aPoint.Y < Pt1.Y) or (aPoint.Y > Pt2.Y)) then
    exit;
  if (Pt1.Y > Pt2.Y) and ((aPoint.Y > Pt1.Y) or (aPoint.Y < Pt2.Y)) then
    exit;
  Result := True;
end;

function GeTplBezierPt(const u: single; pts: array of TPoint): TPoint;
var
  i: integer;
  sx, sy: single;
begin
  if high(pts) < 0 then
    Result := Point(0, 0)
  else if u <= 0 then
    Result := pts[0]
  else if u >= 1 then
    Result := pts[high(pts)]
  else
  begin
    sx := pts[0].X * power(1 - u, high(pts)) + pts[high(pts)].X * power(u, high(pts));

    for i := 1 to high(pts) - 1 do
      sx := sx + pts[i].X * power(u, i) * power(1 - u, high(pts) - i) * high(pts);

    sy := pts[0].Y * power(1 - u, high(pts)) + pts[high(pts)].Y * power(u, high(pts));
    for i := 1 to high(pts) - 1 do
      sy := sy + pts[i].Y * power(u, i) * power(1 - u, high(pts) - i) * high(pts);

    Result := Point(round(sx), round(sy));
  end;
end;

function GeTplEllipseXValFromYVal(radius_horz, radius_vert, y_offset_in: integer; out x_offset_out: integer): boolean;
begin
  //(x/radius_horz)^2 + (y/radius_vert)^2 = 1
  //====> x = +/- radius_horz * SQRT(1 - SQR(y/radius_vert))
  Result :=
    (y_offset_in < radius_vert) and (radius_horz <> 0) and (radius_vert <> 0);
  if not Result then
    exit;
  x_offset_out := round(radius_horz * SQRT(1 - SQR(y_offset_in / radius_vert)));
end;

function GetPtOnEllipseFromAngle(radius_horz, radius_vert: integer; radians_in: single; out point_out: TPoint): boolean;
var
  quadrant: integer;
  q: single;
begin
  //given ellipse x = radius_horz*cos(q) and y = radius_vert*sin(q),
  //then q = arctan(radius_horz*tan(angle_in)/radius_vert)
  Result := (radius_vert <> 0) and (radians_in >= 0) and (radians_in <= PI_Mul2);
  if not Result then
    exit;

  if radians_in > PI_Mul3_Div2 then
    quadrant := 4
  else if radians_in > pi then
    quadrant := 3
  else if radians_in > PI_Div2 then
    quadrant := 2
  else
    quadrant := 1;
  q := arctan(radius_horz * tan(radians_in) / radius_vert);
  if (quadrant = 1) or (quadrant = 4) then
    point_out.X := abs(round(radius_horz * cos(q)))
  else
    point_out.X := -abs(round(radius_horz * cos(q)));
  if (quadrant < 3) then
    point_out.Y := -abs(round(radius_vert * sin(q)))
  else
    point_out.Y := abs(round(radius_vert * sin(q)));
end;

function GetPtOnCircleFromAngle(radius: integer; angle: single): TPoint;
begin
  Result.X := round(radius * cos(angle));
  Result.Y := -round(radius * sin(angle)); //nb: Y axis is +ve down
end;

function SetPointsAroundCircle(origin: TPoint; radius, Count: integer; var pts: array of TPoint): boolean;
var
  i: integer;
  angle: single;
begin
  Result := Count <= high(pts) + 1;
  if not Result or (Count = 0) then
    exit;
  angle := PI_Mul2 / Count;
  for i := 0 to Count - 1 do
    pts[i] := GetPtOnCircleFromAngle(radius, i * angle);

  //now, offset the points around the origin...
  for i := 0 to Count - 1 do
    OffsetPt(pts[i], origin.X, origin.Y);
end;

function GetDiagonalOppositePoint(Pt, PtOfRotation: TPoint): TPoint;
begin
  Result.X := 2 * PtOfRotation.X - Pt.X;
  Result.Y := 2 * PtOfRotation.Y - Pt.Y;
end;

procedure MovePtDiagonalOppositeAnotherPt(var PtToMove: TPoint; Pt, PtOfRotation: TPoint);
var
  dist, tmpDist, ratio: single;
begin
  //Given Pt, move PtToMove to its diagonally opposite point (about PtOfRotation)
  //while maintaining PtToMove the same dist it currently is from PtOfRotation.
  dist := sqrt(SquaredDistBetweenPoints(PtToMove, PtOfRotation));
  tmpDist := sqrt(SquaredDistBetweenPoints(Pt, PtOfRotation));
  if tmpDist = 0 then
    exit; //ie: don't move it
  PtToMove := GetDiagonalOppositePoint(Pt, PtOfRotation);
  //now, move result to previous distance ...
  ratio := dist / tmpDist;
  with PtOfRotation do
    OffsetPt(PtToMove, -X, -Y);
  PtToMove.X := round(PtToMove.X * ratio);
  PtToMove.Y := round(PtToMove.Y * ratio);
  with PtOfRotation do
    OffsetPt(PtToMove, X, Y);

end;

function DistanceBetween2Pts(pt1, pt2: TPoint): single;
begin
  Result := sqrt((pt1.X - pt2.X) * (pt1.X - pt2.X) + (pt1.Y - pt2.Y) * (pt1.Y - pt2.Y));
end;

function GetPtAtDistAndAngleFromPt(pt: TPoint; dist: integer; angle: single): TPoint;
begin
  Result.X := round(dist * cos(angle));
  Result.Y := -round(dist * sin(angle)); //nb: Y axis is +ve down
  OffsetPt(Result, pt.X, pt.Y);
end;

function PtBetween2Pts(pt1, pt2: TPoint; relativeDistFRomPt1: single): TPoint;
begin
  if pt2.X = pt1.X then
    Result.X := pt2.X
  else
    Result.X := pt1.X + round((pt2.X - pt1.X) * relativeDistFRomPt1);
  if pt2.Y = pt1.Y then
    Result.Y := pt2.Y
  else
    Result.Y := pt1.Y + round((pt2.Y - pt1.Y) * relativeDistFRomPt1);
end;

procedure AngledCharOut(Canvas: TbgraCanvas; pt: TPoint; c: char; radians: single; offsetX, offsetY: integer; ouTplLine: TFontOutLine);
var
  lf: TLogFont;
  OldFontHdl, NewFontHdl: HFont;
  angle: integer;
begin
  assert(False, 'not implemented in portable code!');
  angle := round(radians * 180 / PI);
  if angle > 180 then
    angle := angle - 360;

  //workaround -
  //since textout() without rotation is malaligned relative to rotated text ...
  if angle = 0 then
    angle := 1;

  { TODO -oTC -cLazarus_Port_Step2 : function GetObject needs to be ported! }
  //TCQ: the following does not compile
  //with Canvas do
  //begin
  //  if GetObject(Font.Handle, SizeOf(lf), @lf) = 0 then exit;
  //  lf.lfEscapement := Angle * 10;
  //  lf.lfOrientation := Angle * 10;
  //  lf.lfOutPrecision := OUT_TT_ONLY_PRECIS;
  //  NewFontHdl := CreateFontIndirect(lf);
  //  OldFontHdl := selectObject(handle,NewFontHdl);
  //  if offsetX < 0 then
  //    pt := GetPtAtDistAndAngleFromPt(pt, -offsetX, radians + Pi)
  //  else if offsetX > 0 then
  //    pt := GetPtAtDistAndAngleFromPt(pt, offsetX, radians);
  //  if offsetY < 0 then
  //    pt := GetPtAtDistAndAngleFromPt(pt, -offsetY, radians + PI_Div2)
  //  else if offsetY > 0 then
  //    pt := GetPtAtDistAndAngleFromPt(pt, offsetY, radians - PI_Div2);

  //  case ouTplLine of
  //    foNone : TextOut(pt.x, pt.y, c);
  //    foClear:
  //      begin
  //        beginPath(handle);
  //        TextOut(pt.x, pt.y, c);
  //        endPath(handle);
  //        StrokePath(handle);
  //      end;
  //    else
  //      begin
  //        TextOut(pt.x, pt.y, c);
  //        beginPath(handle);
  //        TextOut(pt.x, pt.y, c);
  //        endPath(handle);
  //        StrokePath(handle);
  //      end;
  //  end;

  //  selectObject(handle,OldFontHdl);
  //  DeleteObject(NewFontHdl);
  //end;
end;

type
  TPoints = array[0.. (maxInt div sizeof(TPoint)) - 1] of TPoint;
  PPoints = ^TPoints;
  Integers = array[0.. (maxInt div sizeof(integer)) - 1] of integer;
  PIntegers = ^Integers;

procedure TextAlongBezier(canvas: TbgraCanvas; bezierPts: array of TPoint; s: string; curveOffset: integer; ouTplLine: TFontOutLine);
var
  i, j, ptCnt, sLenPxls, sLen: integer;
  currentInsertionDist, charWidthDiv2: integer;
  pt: TPoint;
  flatPts: PPoints;
  types: PByte;
  distances: PIntegers;
  angle, spcPxls, bezierLen, relativeDistFRomPt1: single;
  charWidths: array[#32..#255] of integer;
begin
  assert(False, 'not implemented in portable code!');
  sLen := length(s);
  //make sure there's text and a valid number of bezier points ...
  if (sLen = 0) or (high(bezierPts) mod 3 <> 0) then
    exit;


  { TODO -oTC -cLazarus_Port_Step2 : function BeginPath needs to be ported! }
  //TCQ
  //with canvas do
  //begin
  //  BeginPath(handle);
  //  PolyBezier(bezierPts);
  //  EndPath(handle);
  //  FlattenPath(handle);

  //  if not GetCharWidth32(handle,32,255, charWidths[#32]) then exit;
  //  //get the number of points needed to define the flattened path ...
  //  ptCnt := GetPath(handle, flatPts, types, 0);
  //  if ptCnt < 1 then exit;

  //  GetMem(flatPts, ptCnt* sizeof(TPoint));
  //  GetMem(types, ptCnt* sizeof(byte));
  //  GetMem(distances, ptCnt* sizeof(integer));
  //  try
  //    //get the 'flattened' array of points along the bezier path ...
  //    GetPath(handle, flatPts^, types^, ptCnt);

  //    //calculate and fill the distances array ...
  //    distances[0] := 0;
  //    bezierLen := 0;
  //    for i := 1 to ptCnt -1 do
  //    begin
  //      bezierLen := bezierLen +
  //        DistanceBetween2Pts(flatPts[i], flatPts[i-1]);
  //      distances[i] := trunc(bezierLen);
  //    end;

  //    //calc length of text in pixels ...
  //    sLenPxls := 0;
  //    for i := 1 to sLen do inc(sLenPxls, charWidths[s[i]]);

  //    //calc extra space between chars to spread string along entire curve ...
  //    if sLen = 1 then
  //      spcPxls := 0 else
  //      spcPxls := (bezierLen - sLenPxls)/(sLen -1);

  //    //nb: the canvas font color must be assign *before* calling AngledCharOut
  //    //otherwise the first char will be malaligned ...
  //    if ouTplLine = foColored then font.Color := Brush.Color
  //    else if ouTplLine = foClear then brush.Style := bsClear;
  //    SetBkMode (handle, TRANSPARENT);

  //    j := 1;
  //    currentInsertionDist := 0;
  //    for i := 1 to sLen do
  //    begin
  //      //increment currentInsertionDist (half) the width of char to get the
  //      //slope of the curve at the midpoint of that character ...
  //      charWidthDiv2 := charWidths[s[i]] div 2;
  //      inc(currentInsertionDist, charWidthDiv2);
  //      while (j < ptCnt -1) and (distances[j] < currentInsertionDist) do inc(j);
  //      if distances[j] = currentInsertionDist then
  //        pt := flatPts[j]
  //      else
  //      begin
  //        relativeDistFRomPt1 := (currentInsertionDist - distances[j-1]) /
  //          (distances[j] - distances[j-1]);
  //        pt := PtBetween2Pts(flatPts[j-1], flatPts[j], relativeDistFRomPt1);
  //      end;
  //      angle := GetAnglePt2FromPt1(flatPts[j-1], flatPts[j]);

  //      AngledCharOut(canvas, pt,
  //        s[i], angle, -charWidthDiv2, curveOffset, ouTplLine);
  //      inc(currentInsertionDist,
  //        charWidthDiv2 + trunc(spcPxls) + round(frac(spcPxls*i)));
  //    end;

  //    //debug only - draw just the points ...
  //    //for i := 0 to ptCnt -1 do with flatPts[i] do
  //    //begin canvas.moveto(X,Y); canvas.lineto(X+1,Y+1); end;

  //    //debug only - draw the path from the points ...
  //    //with flatPts[0] do canvas.moveto(X,Y);
  //    //for i := 1 to ptCnt -1 do with flatPts[i] do canvas.lineto(X,Y);

  //  finally
  //    FreeMem(flatPts);
  //    FreeMem(types);
  //    FreeMem(distances);
  //  end;
  //end;
end;


//This DrawArrowHead() function is loosely based on code downloaded from
//http://www.efg2.com/Lab/Library/Delphi/Graphics/Algorithms.htm
procedure DrawArrowHead(aCanvas: TbgraCanvas; FromPoint, ToPoint: TPoint; HeadSize: cardinal; SolidArrowHead: boolean);
var
  xbase: integer;
  xLineDelta: double;
  xLineUnitDelta: double;
  xNormalDelta: double;
  xNormalUnitDelta: double;
  ybase: integer;
  yLineDelta: double;
  yLineUnitDelta: double;
  yNormalDelta: double;
  yNormalUnitDelta: double;
  SavedBrushColor: TColor;
  ArrowDelta: double;
  base: TPoint;
  savedPenWidth: integer;
begin
  //avoid drawing arrows with pen widths > 2 otherwise arrowheads look ugly...
  savedPenWidth := aCanvas.Pen.Width;
  Inc(HeadSize, 2 * savedPenWidth div 3);
  if aCanvas.Pen.Width > 2 then
    aCanvas.Pen.Width := 2;

  xLineDelta := ToPoint.X - FromPoint.X;
  yLineDelta := ToPoint.Y - FromPoint.Y;

  if (xLineDelta = 0) and (yLineDelta = 0) then
  begin
    xLineUnitDelta := 0;
    yLineUnitDelta := 0;
    xNormalUnitDelta := 0;
    yNormalUnitDelta := 0;
  end
  else
  begin
    xLineUnitDelta := xLineDelta / hypot(xLineDelta, yLineDelta);
    yLineUnitDelta := yLineDelta / hypot(xLineDelta, yLineDelta);
    xNormalDelta := yLineDelta;
    yNormalDelta := -xLineDelta;
    xNormalUnitDelta := xNormalDelta / hypot(xNormalDelta, yNormalDelta);
    yNormalUnitDelta := yNormalDelta / hypot(xNormalDelta, yNormalDelta);
  end;
  ArrowDelta := 7 / 4; // ArrowDelta == 1 result in an ugly boxed arrow

  //(xBase, yBase) is where arrow line is perpendicular to base of triangle.
  xBase := ToPoint.X - ROUND(HeadSize * xLineUnitDelta * ArrowDelta);
  yBase := ToPoint.Y - ROUND(HeadSize * yLineUnitDelta * ArrowDelta);

  base := Point(ToPoint.X - ROUND(HeadSize * xLineUnitDelta), ToPoint.Y - ROUND(HeadSize * yLineUnitDelta));

  if SolidArrowHead then
  begin
    SavedBrushColor := aCanvas.Brush.Color;
    aCanvas.Brush.Color := aCanvas.Pen.Color;
    aCanvas.Polygon([ToPoint, Point(xBase + ROUND(HeadSize * xNormalUnitDelta), yBase + ROUND(HeadSize * yNormalUnitDelta)),
      base, Point(xBase - ROUND(HeadSize * xNormalUnitDelta), yBase - ROUND(HeadSize * yNormalUnitDelta))]);
    aCanvas.Brush.Color := SavedBrushColor;
  end
  else
    aCanvas.PolyLine([Point(xBase + ROUND(HeadSize * xNormalUnitDelta), yBase + ROUND(HeadSize * yNormalUnitDelta)),
      ToPoint, Point(xBase - ROUND(HeadSize * xNormalUnitDelta), yBase - ROUND(HeadSize * yNormalUnitDelta))]);
  aCanvas.Pen.Width := savedPenWidth;
end;

function ArrowBase(FromPoint, ToPoint: TPoint; HeadSize: cardinal): TPoint;
var
  xLen: integer;
  xLenPxRatio: double;
  yLen: integer;
  yLenPxRatio: double;
  hypotenuse: double;
begin
  xLen := ToPoint.X - FromPoint.X;
  yLen := ToPoint.Y - FromPoint.Y;
  if (xLen = 0) and (yLen = 0) then
  begin
    xLenPxRatio := 0;
    yLenPxRatio := 0;
  end
  else
  begin
    hypotenuse := hypot(xLen, yLen);
    //for every virtual pixel moved along the hypotenuse,
    //how much does the x & y coords change ...
    xLenPxRatio := xLen / hypotenuse;
    yLenPxRatio := yLen / hypotenuse;
  end;
  //'Base' is where the line intersects the base of the arrow triangle.
  Result.X := ToPoint.X - ROUND(HeadSize * xLenPxRatio);
  Result.Y := ToPoint.Y - ROUND(HeadSize * yLenPxRatio);
end;

{ TODO -oTC -cLazarus_Port_Step2 : gdi32 is specific to Windows. Not used. }
{ TODO -oTC -cLazarus_Port_Step2 : find a linux replacement for GeTplTextExtentExPoint }
// TCQ
////This declaration modifies Delphi's declaration of GeTplTextExtentExPoint
////so that the variable to receive partial string extents (p6) is ignored ...
//function GeTplTextExtentExPointNoPartials(DC: HDC; p2: PAnsiChar; p3, p4: Integer;
//  var p5: Integer; const p6: integer; var p7: TSize): BOOL; stdcall;
//    external gdi32 name 'GeTplTextExtentExPointA';



//TrimLine: Splits off from LS any characters beyond the allowed width
//breaking at the end of a word if possible. Leftover chars -> RS.
procedure TrimLine(canvas: TbgraCanvas; var ls: string; out rs: string; LineWidthInPxls: integer);
var
  i, len, NumCharWhichFit: integer;
  dummy: TSize;
begin
  if ls = '' then
    exit;
  len := length(ls);

  { TODO -oTC -cLazarus_Port_Step2 : find a linux replacement for GeTplTextExtentExPoint }
  //TCQ
  ////get the number of characters which will fit within LineWidth...
  //if not GeTplTextExtentExPoint(canvas.handle,
  //  pchar(ls),len,LineWidthInPxls,NumCharWhichFit,0,dummy) then
  //  begin
  //    ls := '';
  //    rs := '';
  //    exit; //oops!!
  //  end;
  //TCQ replaced by
  NumCharWhichFit := len;

  if NumCharWhichFit = len then
    exit //if everything fits then stop here
  else if NumCharWhichFit = 0 then
  begin
    rs := ls;
    ls := '';
  end
  else
  begin
    i := NumCharWhichFit;
    //find the end of the last whole word which will fit...
    while (NumCharWhichFit > 0) and (ls[NumCharWhichFit] > ' ') do
      Dec(NumCharWhichFit);
    if (NumCharWhichFit = 0) then
      NumCharWhichFit := i;

    i := NumCharWhichFit + 1;
    //ignore trailing blanks in LS...
    while (ls[NumCharWhichFit] = ' ') do
      Dec(NumCharWhichFit);
    //ignore beginning blanks in RS...
    while (i < len) and (ls[i] = ' ') do
      Inc(i);
    rs := copy(ls, i, len);
    ls := copy(ls, 1, NumCharWhichFit);        //nb: assign ls AFTER rs here
  end;
end;


(* RotateBitmap() function - (c) har*GIS L.L.C., 1999
   You are free to use this in any way, but please retain this comment block.
   Please email questions to jim@har-gis.com .
   Doc & Updates: http://www.efg2.com/Lab/ImageProcessing/RotateScanline.htm and
   http://www.efg2.com/Lab/Library/Delphi/Graphics/JimHargis_RotateBitMap.zip *)


type
  SiCoDiType = record
    si, co, di: single; {sine, cosine, distance}
  end;

{  Calculate sine/cosine/distance from INTEGER coordinates}
function SiCoDiPoint(const p1, p2: TPoint): SiCoDiType;
var
  dx, dy: integer;
begin
  dx := (p2.x - p1.x);
  dy := (p2.y - p1.y);
  with Result do
  begin
    di := HYPOT(dx, dy); //di := Sqrt( dx * dx + dy * dy );
    if abs(di) < 1 then
    begin
      si := 0.0;
      co := 1.0;
    end //Zero length line
    else
    begin
      si := dy / di;
      co := dx / di;
    end;
  end;
end;

//Rotate  a bitmap about an arbritray center point;
procedure RotateBitmap(const BitmapOriginal: TbgraBitMap;//input bitmap (possibly converted)
  out BitMapRotated: TbgraBitMap; //output bitmap
  const theta: single;  // rotn angle in radians counterclockwise in windows
  const oldAxis: TPOINT;   // center of rotation in pixels, rel to bmp origin
  var newAxis: TPOINT);  // center of rotated bitmap, relative to bmp origin
var
  cosTheta: single;   {in windows}
  sinTheta: single;
  i: integer;
  iOriginal: integer;
  iPrime: integer;
  //    iPrimeRotated  :  INTEGER; use width if doubled
  j: integer;
  jOriginal: integer;
  jPrime: integer;
  //    jPrimeRotated  :  INTEGER; use height if doubled
  NewWidth, NewHeight: integer;
  nBytes, nBits: integer;//no. bytes per pixelformat
  Oht, Owi, Rht, Rwi: integer;//Original and Rotated subscripts to bottom/right
  //The variant pixel formats for subscripting       1/6/00
type // from Delphi
  TRGBTripleArray = array [0..32767] of TRGBTriple; //allow integer subscript
  pRGBTripleArray = ^TRGBTripleArray;
  TRGBQuadArray = array [0..32767] of TRGBQuad;//allow integer subscript
  pRGBQuadArray = ^TRGBQuadArray;
var //each of the following points to the same scanlines
  RowRotatedB: pByteArray;       //1 byte
  RowRotatedW: pWordArray;      //2 bytes
  RowRotatedT: pRGBtripleArray;  //3 bytes
  RowRotatedQ: pRGBquadArray;    //4 bytes
var //a single pixel for each format   1/8/00
  TransparentB: byte;
  TransparentW: word;
  TransparentT: TRGBTriple;
  TransparentQ: TRGBQuad;
var
  DIB: TDIBSection;     //10/31/00
  SiCoPhi: SiCoDiType;  //sine,cosine, distance

begin
  { TODO -oTC -cLazarus_Port_Step2 : The code rotating bitmaps is specific to windows. Not used. }


  //with BitMapOriginal do
  //begin
  //                                         { TODO -oTC -cLazarus_Port_Step2 : function CreatePenHandle needs to be ported! }

  //  TransparentB := 0; TransparentW := 0; //added by AWJ to avoid warning messages

  ////Decipher the appropriate pixelformat to use Delphi byte subscripting 1/6/00
  ////pfDevice, pf1bit, pf4bit, pf8bit, pf15bit, pf16bit, pf24bit, pf32bit,pfCustom;
  //  case pixelformat of
  //    pfDevice: begin //handle only pixelbits= 1..8,16,24,32 //10/31/00
  //      nbits :=  GetDeviceCaps( Canvas.Handle,BITSPIXEL )+1 ;
  //      nbytes := nbits div 8; //no. bytes for bits per pixel
  //      if (nbytes>0)and(nbits mod 8 <> 0) then exit;//ignore if invalid
  //      end;
  //    pf1bit:  nBytes:=0;// 1bit, TByteArray      //2 color pallete , re-assign byte value to 8 pixels, for entire scan line
  //    pf4bit:   nBytes:=0;// 4bit, PByteArray     // 16 color pallette; build nibble for pixel pallette index; convert to 8 pixels
  //    pf8bit:  nBytes:=1;// 8bit, PByteArray     // byte pallette, 253 out of 256 colors; depends on display mode, needs truecolor ;
  //    pf15bit: nBytes:=2;// 15bit,PWordArrayType // 0rrrrr ggggg bbbbb  0+5+5+5
  //    pf16bit: nBytes:=2;// 16bit,PWordArrayType // rrrrr gggggg bbbbb  5+6+5
  //    pf24bit: nBytes:=3;// 24bit,pRGBtripleArray// bbbbbbbb gggggggg rrrrrrrr  8+8+8
  //    pf32bit: nBytes:=4;// 32bit,pRGBquadArray  // bbbbbbbb gggggggg rrrrrrrr aaaaaaaa 8+8+8+alpha
  //                       // can assign 'Single' reals to this for generating displays/plasma!
  //    pfCustom: begin  //handle only pixelbits= 1..8,16,24,32  //10/31/00
  //        GetObject( Handle, SizeOf(DIB), @DIB );
  //        nbits := DIB.dsBmih.biSizeImage;
  //        nbytes := nbits div 8;
  //        if (nbytes>0)and(nbits mod 8 <> 0) then exit;//ignore if invalid
  //      end;// pfcustom

  //    else exit;// 10/31/00 ignore invalid formats
  //  end;// case

  //// BitmapRotated.PixelFormat is the same as BitmapOriginal.PixelFormat;
  //// IF PixelFormat is less than 8 bit, then BitMapOriginal.PixelFormat = pf8Bit,
  ////  because Delphi can't index to bits, just bytes;
  //// The next time BitMapOriginal is used it will already be converted.
  ////( bmp storage may increase by factor of n*n, where n=8/(no. bits per pixel)  )
  //  if nBytes=0 then PixelFormat := pf8bit; //note that input bmp is changed

  ////assign copies all properties, including pallette and transparency   11/7/00
  ////fix bug 1/30/00 where BitMapOriginal was overwritten bec. pointer was copied
  //  BitmapRotated.Assign( BitMapOriginal);

  ////COUNTERCLOCKWISE rotation angle in radians. 12/10/99
  //   sinTheta := SIN( theta ); cosTheta := COS( theta );
  ////SINCOS( theta, sinTheta, cosTheta ) ; math.pas requires extended reals.

  ////calculate the enclosing rectangle  12/15/00
  //  NewWidth  := ABS( ROUND( Height*sinTheta) ) + ABS( ROUND( Width*cosTheta ) );
  //  NewHeight := ABS( ROUND( Width*sinTheta ) ) + ABS( ROUND( Height*cosTheta) );

  ////diff size bitmaps have diff resolution of angle, ie r*sin(theta)<1 pixel
  ////use the small angle approx: sin(theta) ~~ theta   //11/7/00
  //  if ( ABS(theta)*MAX( width,height ) ) > 1 then
  //  begin//non-zero rotation

  //  //set output bitmap formats; we do not assume a fixed format or size 1/6/00
  //    BitmapRotated.Width  := NewWidth;   //resize it for rotation
  //    BitmapRotated.Height := NewHeight;

  //  //local constants for loop, each was hit at least width*height times   1/8/00
  //    Rwi := NewWidth - 1; //right column index
  //    Rht := NewHeight - 1;//bottom row index
  //    Owi := Width - 1;    //transp color column index
  //    Oht := Height - 1;   //transp color row  index

  //  //Transparent pixel color used for out of range pixels 1/8/00
  //  //how to translate a Bitmap.TransparentColor=Canvas.Pixels[0, Height - 1];
  //  // from Tcolor into pixelformat..
  //  { TODO -oTC -cLazarus_Port_Step1 : Scanline is not recognized }
  //  //TCQ  case nBytes of
  //    //  0,1: TransparentB := PByteArray     ( Scanline[ Oht ] )[0];
  //    //  2:   TransparentW := PWordArray     ( Scanline[ Oht ] )[0];
  //    //  3:   TransparentT := pRGBtripleArray( Scanline[ Oht ] )[0];
  //    //  4:   TransparentQ := pRGBquadArray  ( Scanline[ Oht ] )[0];
  //    //end;//case *)

  //  // Step through each row of rotated image.
  //    FOR j := Rht DOWNTO 0 DO   //1/8/00
  //    BEGIN //for j

  //    { TODO -oTC -cLazarus_Port_Step1 : Scanline not recognized }
  //    //TCQ
  //      //case nBytes of  //1/6/00
  //      //0,1: RowRotatedB := BitmapRotated.Scanline[ j ] ;
  //      //2:   RowRotatedW := BitmapRotated.Scanline[ j ] ;
  //      //3:   RowRotatedT := BitmapRotated.Scanline[ j ] ;
  //      //4:   RowRotatedQ := BitmapRotated.Scanline[ j ] ;
  //      //end;//case

  //    // offset origin by the growth factor     //12/25/99
  //    //  jPrime := 2*(j - (NewHeight - Height) div 2 - jRotationAxis) + 1 ;
  //      jPrime := 2*j - NewHeight + 1 ;

  //    // Step through each column of rotated image
  //      FOR i := Rwi DOWNTO 0 DO   //1/8/00
  //      BEGIN //for i

  //        // offset origin by the growth factor  //12/25/99
  //        //iPrime := 2*(i - (NewWidth - Width) div 2 - iRotationAxis ) + 1;
  //        iPrime := 2*i - NewWidth   + 1;

  //        // Rotate (iPrime, jPrime) to location of desired pixel  (iPrimeRotated,jPrimeRotated)
  //        // Transform back to pixel coordinates of image, including translation
  //        // of origin from axis of rotation to origin of image.
  //  //iOriginal := ( ROUND( iPrime*CosTheta - jPrime*sinTheta ) - 1) DIV 2 + iRotationAxis;
  //  //jOriginal := ( ROUND( iPrime*sinTheta + jPrime*cosTheta ) - 1) DIV 2 + jRotationAxis;
  //        iOriginal := ( ROUND( iPrime*CosTheta - jPrime*sinTheta ) -1 + width ) DIV 2;
  //        jOriginal := ( ROUND( iPrime*sinTheta + jPrime*cosTheta ) -1 + height) DIV 2 ;

  //        // Make sure (iOriginal, jOriginal) is in BitmapOriginal.  If not,
  //        // assign background color to corner points.
  //        IF   ( iOriginal >= 0 ) AND ( iOriginal <= Owi ) AND
  //             ( jOriginal >= 0 ) AND ( jOriginal <= Oht )    //1/8/00
  //        THEN BEGIN //inside
  //          // Assign pixel from rotated space to current pixel in BitmapRotated
  //          //( nearest neighbor interpolation)
  //          { TODO -oTC -cLazarus_Port_Step1 : Scanline not recognized }
  //          //TCQ
  //          //case nBytes of  //get pixel bytes according to pixel format   1/6/00
  //          //0,1:RowRotatedB[i] := pByteArray(      scanline[joriginal] )[iOriginal];
  //          //2:  RowRotatedW[i] := pWordArray(      Scanline[jOriginal] )[iOriginal];
  //          //3:  RowRotatedT[i] := pRGBtripleArray( Scanline[jOriginal] )[iOriginal];
  //          //4:  RowRotatedQ[i] := pRGBquadArray(   Scanline[jOriginal] )[iOriginal];
  //          //end;//case
  //        END //inside
  //        ELSE
  //        BEGIN //outside

  //  //12/10/99 set background corner color to transparent (lower left corner)
  //  //  RowRotated[i]:=tpixelformat(BitMapOriginal.TRANSPARENTCOLOR) ; wont work
  //          case nBytes of
  //            0,1:RowRotatedB[i] := TransparentB;
  //            2:  RowRotatedW[i] := TransparentW;
  //            3:  RowRotatedT[i] := TransparentT;
  //            4:  RowRotatedQ[i] := TransparentQ;
  //          end;//case
  //        END //if inside

  //      END //for i
  //    END;//for j
  //  end;//non-zero rotation

  ////offset to the apparent center of rotation   11/12/00 12/25/99
  ////rotate/translate the old bitmap origin to the new bitmap origin,FIXED 11/12/00
  //  sicoPhi := sicodiPoint(  POINT( width div 2, height div 2 ),oldaxis );
  //  //sine/cosine/dist of axis point from center point
  //  with sicoPhi do begin
  ////NewAxis := NewCenter + dist* <sin( theta+phi ),cos( theta+phi )>
  //    NewAxis.x := newWidth div 2 + ROUND( di*(CosTheta*co - SinTheta*si) );
  //    NewAxis.y := newHeight div 2- ROUND( di*(SinTheta*co + CosTheta*si) );//flip yaxis
  //  end;

  //end;

end; {RotateBitmap}



// ==================== TplSolidPoint =============================================


constructor TplSolidPoint.Create(AOwner: TComponent);
var
  margX2: integer;
begin
  inherited;
  InternalSetCount(1);
  Pen.Width := 3;
  margX2 := Margin * 2;
  Bitmap.SetSize(margX2,margX2);
  SetBounds(0, 0, margX2, margX2);
  DoSaveInfo;
end;

procedure TplSolidPoint.AddConnector(Connector: TplConnector);
begin
  inherited;
  //to control this connection point it's important it's on top
  //if assigned(Connector) then Connector.SendToBack;
  //BringToFront;
  with Connector do
  begin
    if (Connection1 is TplSolidPoint) then
      Connection1.BringToFront;
    if (Connection2 is TplSolidPoint) then
      Connection2.BringToFront;
  end;
end;

procedure TplSolidPoint.CalcMargin;
begin
  //the following formula is empirical ...
  Margin := max(ButtonSize + marginForDimensions, (pen.Width * 3) div 2 + max(2, abs(ShadowSize)));
  //the following is also needed (see ancestor method) ...
  ResizeNeeded;
end;

procedure TplSolidPoint.DrawObject(aCanvas: TbgraCanvas; IsShadow: boolean);
var
  pw: integer;
begin
  with acanvas do
  begin
    pw := Pen.Width - 1;
    if pw < 2 then
      exit;
    brush.Color := Pen.Color;
    with BtnPoints[0] do
      Ellipse(X - pw, Y - pw, X + pw, Y + pw);
  end;
end;


// ====================== TplLine ===============================


constructor TplLine.Create(AOwner: TComponent);
begin
  inherited;
  fArrowSize:= 5;
  fArrowFill:= true;
  DoSaveInfo;
end;

procedure TplLine.SetArrowSize(const Val:Cardinal);
begin
  if fArrowSize=val then exit;
  fArrowSize:=val;
  UpdateNeeded;
end;

procedure TplLine.SetArrowFill(const Val:Boolean);
begin
  if fArrowFill=val then exit;
  fArrowFill:=val;
  UpdateNeeded;
end;

procedure TplLine.SetButtonCount(Count: integer);
begin
  if Count < 2 then
    Count := 2;
  if (ButtonCount = Count) or IsConnected then
    exit;
  if Count > ButtonCount then
    while Count > ButtonCount do
      Grow
  else
    while Count < ButtonCount do
      Shrink;
end;

function TplLine.Grow(TopEnd: boolean): boolean;
var
  i: integer;
begin
  Result := not IsConnected;
  if not Result then
    exit;
  InternalSetCount(buttonCount + 1);
  if TopEnd then
  begin
    //first, move all the buttons in the array down a place ...
    for i := buttonCount - 1 downto 1 do
      BtnPoints[i] := BtnPoints[i - 1];
    //update new button ...
    BtnPoints[0] := Point(2 * BtnPoints[1].X - BtnPoints[2].X, 2 * BtnPoints[1].Y - BtnPoints[2].Y);
  end
  else
  begin
    //update new button ...
    BtnPoints[buttonCount - 1] :=
      Point(2 * BtnPoints[buttonCount - 2].X - BtnPoints[buttonCount - 3].X, 2 * BtnPoints[buttonCount - 2].Y - BtnPoints[buttonCount - 3].Y);
  end;
  ResizeNeeded;
end;

function TplLine.Shrink(TopEnd: boolean): boolean;
var
  i: integer;
begin
  Result := not IsConnected and (ButtonCount > 2);
  if not Result then
    exit;
  if TopEnd then //first, move all the buttons in the array up a place ...
    for i := 1 to buttonCount - 1 do
      BtnPoints[i - 1] := BtnPoints[i];
  InternalSetCount(buttonCount - 1);
  ResizeNeeded;
end;

procedure TplLine.DrawObject(aCanvas: TbgraCanvas; IsShadow: boolean);
var
  startPt, endPt: TPoint;
begin
  with acanvas do
  begin
    endPt := BtnPoints[ButtonCount - 1];
    startPt := BtnPoints[0];
    //if arrows are used then inset the lines to avoid spoiling them ...
    if Arrow2 then
      BtnPoints[ButtonCount - 1] := ArrowBase(BtnPoints[ButtonCount - 2], BtnPoints[ButtonCount - 1], (2 * pen.Width div 3) + 5);
    if Arrow1 then
      BtnPoints[0] := ArrowBase(BtnPoints[1], BtnPoints[0], (2 * pen.Width div 3) + 5);

    //draw the lines ...
    if (acanvas.pen.Style <> psSolid) then
      Brush.Style := bsClear;
    aCanvas.PolyLine(BtnPoints);

    //restore first and last BtnPoints ...
    BtnPoints[0] := startPt;
    BtnPoints[ButtonCount - 1] := endPt;

    if Arrow2 then
      DrawArrowHead(acanvas,
        BtnPoints[buttonCount - 2], BtnPoints[buttonCount - 1], fArrowSize, fArrowFill);
    if Arrow1 then
      DrawArrowHead(acanvas, BtnPoints[1], BtnPoints[0], fArrowSize, fArrowFill);
  end;
end;


// ========================= TplZLine =====================================


constructor TplZLine.Create(AOwner: TComponent);
var
  mp: TPoint;
begin
  inherited;
  fArrowSize:= 5;
  fArrowFill:= true;
  InternalSetCount(4);
  QuadPtConnect := True;
  AutoOrientation := True;
  mp := ObjectMidPoint;
  BtnPoints[0] := Point(Margin, Margin);
  BtnPoints[3] := Point(Width - Margin, Height - Margin);
  BtnPoints[1] := Point(mp.X, BtnPoints[0].Y);
  BtnPoints[2] := Point(mp.X, BtnPoints[3].Y);
  AutoCenter := True;
  DoSaveInfo;
end;

procedure TplZLine.SetArrowSize(const Val:Cardinal);
begin
  if fArrowSize=val then exit;
  fArrowSize:=val;
  UpdateNeeded;
end;

procedure TplZLine.SetArrowFill(const Val:Boolean);
begin
  if fArrowFill=val then exit;
  fArrowFill:=val;
  UpdateNeeded;
end;

function TplZLine.IsValidBtnDown(BtnIdx: integer): boolean;
begin
  //don't allow clicking of auto-centering buttons ...
  Result := inherited IsValidBtnDown(BtnIdx) and not (fAutoCenter and (BtnIdx in [1, 2]));
end;

procedure TplZLine.UpdateNonEndButtonsAfterBtnMove;
const
  MIN_Z = 20; //avoids (if possible) Z line being too close to either end pt


  procedure CheckHorz;
  var
    vectorUp: boolean;
    midX: integer;
  begin
    midX := (BtnPoints[3].X + BtnPoints[0].X) div 2;
    if fAutoCenter then
    begin
      BtnPoints[1].X := midX;
      BtnPoints[1].Y := BtnPoints[0].Y;
      BtnPoints[2].X := midX;
      BtnPoints[2].Y := BtnPoints[3].Y;
    end
    else
    begin
      BtnPoints[1].Y := BtnPoints[0].Y;
      BtnPoints[2].Y := BtnPoints[3].Y;
      vectorUp := BtnPoints[3].X >= BtnPoints[0].X;
      if vectorUp then
      begin
        BtnPoints[1].X := min(max(BtnPoints[0].X, BtnPoints[1].X), BtnPoints[3].X);
        //try and stop Z's becoming L's if possible ...
        if BtnPoints[1].X - BtnPoints[0].X < MIN_Z then
          BtnPoints[1].X := min(BtnPoints[0].X + MIN_Z, midX)
        else if BtnPoints[3].X - BtnPoints[1].X < MIN_Z then
          BtnPoints[1].X := max(BtnPoints[3].X - MIN_Z, midX);
        BtnPoints[2].X := BtnPoints[1].X;
      end
      else
      begin
        BtnPoints[1].X := max(min(BtnPoints[0].X, BtnPoints[1].X), BtnPoints[3].X);
        //try and stop Z's becoming L's if possible ...
        if BtnPoints[0].X - BtnPoints[1].X < MIN_Z then
          BtnPoints[1].X := max(BtnPoints[0].X - MIN_Z, midX)
        else if BtnPoints[1].X - BtnPoints[3].X < MIN_Z then
          BtnPoints[1].X := min(BtnPoints[3].X + MIN_Z, midX);
        BtnPoints[2].X := BtnPoints[1].X;
      end;
    end;
  end;

  procedure CheckVert;
  var
    vectorLeft: boolean;
    midY: integer;
  begin
    midY := (BtnPoints[3].Y + BtnPoints[0].Y) div 2;
    if fAutoCenter then
    begin
      BtnPoints[1].y := midY;
      BtnPoints[1].X := BtnPoints[0].X;
      BtnPoints[2].Y := midY;
      BtnPoints[2].X := BtnPoints[3].X;
    end
    else
    begin
      BtnPoints[1].X := BtnPoints[0].X;
      BtnPoints[2].X := BtnPoints[3].X;
      vectorLeft := BtnPoints[3].Y >= BtnPoints[0].Y;
      if vectorLeft then
      begin
        BtnPoints[1].Y := min(max(BtnPoints[0].Y, BtnPoints[1].Y), BtnPoints[3].Y);
        //try and stop Z's becoming L's if possible ...
        if BtnPoints[1].Y - BtnPoints[0].Y < MIN_Z then
          BtnPoints[1].Y := min(BtnPoints[0].Y + MIN_Z, midY)
        else if BtnPoints[3].Y - BtnPoints[1].Y < MIN_Z then
          BtnPoints[1].Y := max(BtnPoints[3].Y - MIN_Z, midY);
        BtnPoints[2].Y := BtnPoints[1].Y;
      end
      else
      begin
        BtnPoints[1].Y := max(min(BtnPoints[0].Y, BtnPoints[1].Y), BtnPoints[3].Y);
        //try and stop Z's becoming L's if possible ...
        if BtnPoints[0].Y - BtnPoints[1].Y < MIN_Z then
          BtnPoints[1].Y := max(BtnPoints[0].Y - MIN_Z, midY)
        else if BtnPoints[1].Y - BtnPoints[3].Y < MIN_Z then
          BtnPoints[1].Y := min(BtnPoints[3].Y + MIN_Z, midY);
        BtnPoints[2].Y := BtnPoints[1].Y;
      end;
    end;
  end;

begin
  if Orientation = oHorizontal then
    CheckHorz
  else
    CheckVert;
end;

procedure TplZLine.DoQuadPtConnection;
var
  ScreenMp1, ScreenMp2: TPoint;
  Rec1, Rec2: TRect;

  function RecsOverlapVertically: boolean;
  begin
    Result := ((Rec2.Left <= Rec1.Right) and (Rec2.Right >= Rec1.Left)) or ((Rec1.Left <= Rec2.Right) and (Rec1.Right >= Rec2.Left));
  end;

  function RecsOverlapHorizontally: boolean;
  begin
    Result := ((Rec2.Top <= Rec1.Bottom) and (Rec2.Bottom >= Rec1.Top)) or ((Rec1.Top <= Rec2.Bottom) and (Rec1.Bottom >= Rec2.Top));
  end;

begin
  //get orientation points ...
  if assigned(Connection1) then
  begin
    ScreenMp1 := Connection1.ClientToScreen(Connection1.ObjectMidPoint);
    with Connection1.BoundsRect do
      Rec1 := Rect(Left, Top, Right, Bottom);
  end
  else
  begin
    ScreenMp1 := ClientToScreen(BtnPoints[0]);
    with BtnPoints[0] do
      Rec1 := Rect(x, y, x, y);
  end;

  if assigned(Connection2) then
  begin
    ScreenMp2 := Connection2.ClientToScreen(Connection2.ObjectMidPoint);
    with Connection2.BoundsRect do
      Rec2 := Rect(Left, Top, Right, Bottom);
  end
  else
  begin
    ScreenMp2 := ClientToScreen(BtnPoints[ButtonCount - 1]);
    with BtnPoints[ButtonCount - 1] do
      Rec1 := Rect(x, y, x, y);
  end;

  //check and possibly adjust orientation ...
  if not AutoOrientation then
  //do nothing
  else if (Orientation = oVertical) then
  begin
    if RecsOverlapHorizontally and not RecsOverlapVertically then
      Orientation := oHorizontal;
  end
  else if (Orientation = oHorizontal) then
  begin
    if RecsOverlapVertically and not RecsOverlapHorizontally then
      Orientation := oVertical;
  end;

  //finally move ends to appropriate connection points ...
  if Orientation = oHorizontal then
  begin
    if ScreenMp1.X < ScreenMp2.X then
    begin
      if assigned(Connection1) then
        BtnPoints[0] :=
          ScreenToClient(Connection1.QuadScreenPt(qcRight));
      if assigned(Connection2) then
        BtnPoints[ButtonCount - 1] :=
          ScreenToClient(Connection2.QuadScreenPt(qcLeft));
    end
    else
    begin
      if assigned(Connection1) then
        BtnPoints[0] :=
          ScreenToClient(Connection1.QuadScreenPt(qcLeft));
      if assigned(Connection2) then
        BtnPoints[ButtonCount - 1] :=
          ScreenToClient(Connection2.QuadScreenPt(qcRight));
    end;
  end
  else
  begin
    if ScreenMp1.Y < ScreenMp2.Y then
    begin
      if assigned(Connection1) then
        BtnPoints[0] :=
          ScreenToClient(Connection1.QuadScreenPt(qcBottom));
      if assigned(Connection2) then
        BtnPoints[ButtonCount - 1] :=
          ScreenToClient(Connection2.QuadScreenPt(qcTop));
    end
    else
    begin
      if assigned(Connection1) then
        BtnPoints[0] :=
          ScreenToClient(Connection1.QuadScreenPt(qcTop));
      if assigned(Connection2) then
        BtnPoints[ButtonCount - 1] :=
          ScreenToClient(Connection2.QuadScreenPt(qcBottom));
    end;
  end;
end;

procedure TplZLine.DrawBtn(BtnPt: TPoint; index: integer; Pressed, LastBtn: boolean);
begin
  if not Self.fAutoCenter or (index = 0) or (index = 3) then
    inherited;
end;

procedure TplZLine.InternalBtnMove(BtnIdx: integer; NewPt: TPoint);
begin
  BtnPoints[BtnIdx] := NewPt;
  if (BtnIdx = 1) then
  begin
    if Orientation = oHorizontal then
      BtnPoints[2].X := BtnPoints[1].X
    else
      BtnPoints[2].Y := BtnPoints[1].Y;
    UpdateNeeded;
  end
  else if (BtnIdx = 2) then
  begin
    if Orientation = oHorizontal then
      BtnPoints[1].X := BtnPoints[2].X
    else
      BtnPoints[1].Y := BtnPoints[2].Y;
    UpdateNeeded;
  end
  else
    ResizeNeeded; //an end button, so it's evidently not attached

  UpdateNonEndButtonsAfterBtnMove;
end;

procedure TplZLine.SetAutoCenter(AutoCenter: boolean);
begin
  if fAutoCenter = AutoCenter then
    exit;
  fAutoCenter := AutoCenter;
  if AutoCenter then
    UpdateNonEndButtonsAfterBtnMove;
  UpdateNeeded;
end;

procedure TplZLine.DrawObject(aCanvas: TbgraCanvas; IsShadow: boolean);
var
  startPt, endPt: TPoint;
begin
  with acanvas do
  begin
    endPt := BtnPoints[ButtonCount - 1];
    startPt := BtnPoints[0];
    //if arrows are used then inset the lines to avoid spoiling them ...
    if Arrow2 then
      BtnPoints[ButtonCount - 1] := ArrowBase(BtnPoints[ButtonCount - 2], BtnPoints[ButtonCount - 1], (2 * pen.Width div 3) + 5);
    if Arrow1 then
      BtnPoints[0] := ArrowBase(BtnPoints[1], BtnPoints[0], (2 * pen.Width div 3) + 5);

    //draw the lines ...
    if (acanvas.pen.Style <> psSolid) then
      Brush.Style := bsClear;
    aCanvas.PolyLine(BtnPoints);

    //restore first and last BtnPoints ...
    BtnPoints[0] := startPt;
    BtnPoints[ButtonCount - 1] := endPt;

    if Arrow2 then
      DrawArrowHead(acanvas,
        BtnPoints[buttonCount - 2], BtnPoints[buttonCount - 1], fArrowSize, fArrowFill);
    if Arrow1 then
      DrawArrowHead(acanvas, BtnPoints[1], BtnPoints[0], fArrowSize, fArrowFill);
  end;
end;

procedure TplZLine.Rotate(degrees: integer);
begin
  //disable rotate() for TplZLine
end;

procedure TplZLine.SaveToPropStrings;
begin
  inherited;
  AddToPropStrings('Orientation', GetEnumProp(self, 'Orientation'));
  AddToPropStrings('AutoCenter', GetEnumProp(self, 'AutoCenter'));
  AddToPropStrings('AutoOrientation', GetEnumProp(self, 'AutoOrientation'));
end;



// ================ TplLLine =========================================


constructor TplLLine.Create(AOwner: TComponent);
begin
  inherited;
  fArrowSize:= 5;
  fArrowFill:= true;
  QuadPtConnect := True;
  //AutoOrientation := false;
  DoSaveInfo;
end;

procedure TplLLine.SetArrowSize(const Val:Cardinal);
begin
  if fArrowSize=val then exit;
  fArrowSize:=val;
  UpdateNeeded;
end;

procedure TplLLine.SetArrowFill(const Val:Boolean);
begin
  if fArrowFill=val then exit;
  fArrowFill:=val;
  UpdateNeeded;
end;

procedure TplLLine.Rotate(degrees: integer);
begin
  //disable rotate() for TplLLine
end;

procedure TplLLine.DrawObject(aCanvas: TbgraCanvas; IsShadow: boolean);
var
  startPt, endPt, midPt: TPoint;
begin
  with acanvas do
  begin
    endPt := BtnPoints[1];
    startPt := BtnPoints[0];
    if ((Orientation = oHorizontal) and (startPt.X < endPt.X)) or ((Orientation = oVertical) and (startPt.X > endPt.X)) then
      midPt := Point(endPt.X, startPt.Y)
    else
      midPt := Point(startPt.X, endPt.Y);

    //if arrows are used then inset the lines to avoid spoiling them ...
    if Arrow2 then
      endPt := ArrowBase(midPt, endPt, (2 * pen.Width div 3) + 5);
    if Arrow1 then
      startPt := ArrowBase(midPt, startPt, (2 * pen.Width div 3) + 5);

    //draw the lines ...
    if (acanvas.pen.Style <> psSolid) then
      Brush.Style := bsClear;
    aCanvas.PolyLine([startPt, midPt, endPt]);

    if Arrow2 then
      DrawArrowHead(acanvas, midPt, BtnPoints[1], fArrowSize, fArrowFill);
    if Arrow1 then
      DrawArrowHead(acanvas, midPt, BtnPoints[0], fArrowSize, fArrowFill);
  end;
end;

procedure TplLLine.SaveToPropStrings;
begin
  inherited;
  AddToPropStrings('Orientation', GetEnumProp(self, 'Orientation'));
end;

procedure TplLLine.DoQuadPtConnection;
var
  ScreenMp1, ScreenMp2: TPoint;
begin
  //get orientation points ...
  if assigned(Connection1) then
    ScreenMp1 := Connection1.ClientToScreen(Connection1.ObjectMidPoint)
  else
    ScreenMp1 := ClientToScreen(BtnPoints[0]);
  if assigned(Connection2) then
    ScreenMp2 := Connection2.ClientToScreen(Connection2.ObjectMidPoint)
  else
    ScreenMp2 := ClientToScreen(BtnPoints[ButtonCount - 1]);

  if assigned(Connection1) then
  begin
    if ((Orientation = oHorizontal) and (ScreenMp1.X < ScreenMp2.X)) or ((Orientation = oVertical) and (ScreenMp1.X >= ScreenMp2.X)) then
    begin
      if ScreenMp1.X < ScreenMp2.X then
        BtnPoints[0] := ScreenToClient(Connection1.QuadScreenPt(qcRight))
      else
        BtnPoints[0] := ScreenToClient(Connection1.QuadScreenPt(qcLeft));
    end
    else
    begin
      if ScreenMp1.Y < ScreenMp2.Y then
        BtnPoints[0] := ScreenToClient(Connection1.QuadScreenPt(qcBottom))
      else
        BtnPoints[0] := ScreenToClient(Connection1.QuadScreenPt(qcTop));
    end;
  end;
  if assigned(Connection2) then
  begin
    if ((Orientation = oHorizontal) and (ScreenMp1.X < ScreenMp2.X)) or ((Orientation = oVertical) and (ScreenMp1.X >= ScreenMp2.X)) then
    begin
      if ScreenMp1.Y < ScreenMp2.Y then
        BtnPoints[1] := ScreenToClient(Connection2.QuadScreenPt(qcTop))
      else
        BtnPoints[1] := ScreenToClient(Connection2.QuadScreenPt(qcBottom));
    end
    else
    begin
      if ScreenMp1.X < ScreenMp2.X then
        BtnPoints[1] := ScreenToClient(Connection2.QuadScreenPt(qcLeft))
      else
        BtnPoints[1] := ScreenToClient(Connection2.QuadScreenPt(qcRight));
    end;
  end;
end;

// =============== TplBezier ==================================

constructor TplBezier.Create(AOwner: TComponent);
var
  i, w, h: integer;
begin
  inherited Create(AOwner);

  fArrowSize:= 5;
  fArrowFill:= true;

  InternalSetCount(4);
  fSmooth := True;
  w := Width - Margin * 2;
  h := Height - Margin * 2;
  for i := 0 to ButtonCount - 1 do
    BtnPoints[i] :=
      Point(Margin + i * w div (ButtonCount - 1), Margin + i * h div (ButtonCount - 1));
  DoSaveInfo;
end;

procedure TplBezier.SetArrowSize(const Val:Cardinal);
begin
  if fArrowSize=val then exit;
  fArrowSize:=val;
  UpdateNeeded;
end;

procedure TplBezier.SetArrowFill(const Val:Boolean);
begin
  if fArrowFill=val then exit;
  fArrowFill:=val;
  UpdateNeeded;
end;

procedure TplBezier.SetArrow1(Arrow: boolean);
begin
  inherited;
  if Arrow then
    Filled := False;
end;

procedure TplBezier.SetArrow2(Arrow: boolean);
begin
  inherited;
  if Arrow then
    Filled := False;
end;

procedure TplBezier.SetFilled(isFilled: boolean);
begin
  if fFilled = isFilled then
    exit;
  fFilled := isFilled;
  if fFilled then
  begin
    Arrow1 := False;
    Arrow2 := False;
  end;
  UpdateNeeded;
end;

procedure TplBezier.SetButtonCount(Count: integer);
begin
  if Count < 4 then
    Count := 4;
  if (ButtonCount = Count) or IsConnected then
    exit;
  Count := 3 * (Count div 3) + 1;
  if Count > ButtonCount then
    while Count > ButtonCount do
      Grow
  else
    while Count < ButtonCount do
      Shrink;
end;

function TplBezier.Grow(TopEnd: boolean): boolean;
var
  i: integer;
begin
  Result := not IsConnected;
  if not Result then
    exit;
  InternalSetCount(buttonCount + 3);
  if TopEnd then
  begin
    //first, move all the buttons in the array down three places ...
    for i := buttonCount - 1 downto 3 do
      BtnPoints[i] := BtnPoints[i - 3];
    //update new buttons ...
    BtnPoints[0] := Point(3 * BtnPoints[3].X - 2 * BtnPoints[4].X, 3 * BtnPoints[3].Y - 2 * BtnPoints[4].Y);
    BtnPoints[2] := MidPoint(BtnPoints[0], BtnPoints[3]);
    BtnPoints[1] := MidPoint(BtnPoints[0], BtnPoints[2]);
  end
  else
  begin
    //update new buttons ...
    BtnPoints[buttonCount - 1] :=
      Point(3 * BtnPoints[buttonCount - 4].X - 2 * BtnPoints[buttonCount - 5].X, 3 * BtnPoints[buttonCount - 4].Y - 2 * BtnPoints[buttonCount - 5].Y);
    BtnPoints[buttonCount - 3] :=
      MidPoint(BtnPoints[buttonCount - 1], BtnPoints[buttonCount - 4]);
    BtnPoints[buttonCount - 2] := MidPoint(BtnPoints[buttonCount - 3], BtnPoints[buttonCount - 1]);
  end;
  ResizeNeeded;
end;

function TplBezier.Shrink(TopEnd: boolean): boolean;
var
  i: integer;
begin
  Result := not IsConnected and (ButtonCount > 4);
  if not Result then
    exit;
  if TopEnd then //first, move all the buttons in the array up three places ...
    for i := 3 to buttonCount - 1 do
      BtnPoints[i - 3] := BtnPoints[i];
  InternalSetCount(buttonCount - 3);
  ResizeNeeded;
end;

procedure TplBezier.DrawControlLines;
var
  i: integer;
begin
  inherited;
  with canvas do
  begin
    with BtnPoints[0] do
      Moveto(X, Y);
    for i := 0 to (ButtonCount div 3) - 1 do
    begin
      with BtnPoints[i * 3 + 1] do
        Lineto(X, Y);
      with BtnPoints[i * 3 + 2] do
        Moveto(X, Y);
      with BtnPoints[i * 3 + 3] do
        Lineto(X, Y);
    end;
  end;
end;

{ DONE -oTC -cLazarus_Port_Step2 : replaced win32 polybezier by Canvas.PolyBezier }
{ DONE -oTC -cLazarus_Port_Step2 : CreatePenHandle and other pen functions
  are not needed now that polybezier has been replaced. Removed
  DrawDottedPolyBezier(Canvas: TCanvas) procedure, replaced by
  Canvas.PolyBezier( BtnPoints); }


procedure TplBezier.DrawObject(aCanvas: TbgraCanvas; IsShadow: boolean);
var
  startPt, endPt: TPoint;
begin
  with acanvas do
  begin
    endPt := BtnPoints[ButtonCount - 1];
    startPt := BtnPoints[0];
    //if arrows are used then inset the lines to avoid spoiling them ...
    if Arrow2 then
      BtnPoints[ButtonCount - 1] := ArrowBase(BtnPoints[ButtonCount - 2], BtnPoints[ButtonCount - 1], (2 * pen.Width div 3) + 5);
    if Arrow1 then
      BtnPoints[0] := ArrowBase(BtnPoints[1], BtnPoints[0], (2 * pen.Width div 3) + 5);

    //draw the curve ...
    if (acanvas.pen.Style <> psSolid) then
      Brush.Style := bsClear;
    if Filled then
    begin
      acanvas.Brush.Color := color;
      { TODO -oTC -cLazarus_Port_Step2 : BeginPath and other functions }
      { TODO -oTC -cLazarus_Test : Add test case to check filled polybezier.}
      //TCQ
      //beginpath(handle);
      PolyBezier(BtnPoints, Filled);
      //endpath(handle);
      //StrokeAndFillPath(handle);
    end
    else
      aCanvas.PolyBezier(BtnPoints);

    //restore first and last BtnPoints ...
    BtnPoints[0] := startPt;
    BtnPoints[ButtonCount - 1] := endPt;

    //finally draw the arrows ...
    if Arrow2 then
      DrawArrowHead(acanvas,
        BtnPoints[ButtonCount - 2], BtnPoints[ButtonCount - 1], fArrowSize, fArrowFill);
    if Arrow1 then
      DrawArrowHead(acanvas, BtnPoints[1], BtnPoints[0], fArrowSize, fArrowFill);
  end;
end;

procedure TplBezier.InternalBtnMove(BtnIdx: integer; NewPt: TPoint);
var
  dx, dy: integer;
begin
  //? keep polybezier control buttons aligned flat to maintain smooth joins ...
  if Smooth then
  begin
    //if a center (non-control) button ...
    if (BtnIdx mod 3 = 0) or (BtnIdx = 0) or (BtnIdx = ButtonCount - 1) then
    begin
      dx := NewPt.X - BtnPoints[BtnIdx].X;
      dy := NewPt.Y - BtnPoints[BtnIdx].Y;
      if (BtnIdx > 0) then
        offsetPt(BtnPoints[BtnIdx - 1], dx, dy);
      if (BtnIdx < ButtonCount - 1) then
        offsetPt(BtnPoints[BtnIdx + 1], dx, dy);
    end
    else if (BtnIdx = 1) or (BtnIdx = ButtonCount - 2) then //do nothing
    else if (BtnIdx mod 3 = 2) then
      MovePtDiagonalOppositeAnotherPt(
        BtnPoints[BtnIdx + 2], BtnPoints[BtnIdx], BtnPoints[BtnIdx + 1])
    else
      MovePtDiagonalOppositeAnotherPt(
        BtnPoints[BtnIdx - 2], BtnPoints[BtnIdx], BtnPoints[BtnIdx - 1]);
  end;
  if (BtnIdx = 1) and assigned(Connection1) then
    UpdateConnectionPoints(Connection1)
  else if (BtnIdx = ButtonCount - 2) and assigned(Connection2) then
    UpdateConnectionPoints(Connection2);
  inherited;
end;

procedure TplBezier.UpdateConnectionPoints(MovingConnection: TplSolid);
var
  pt: TPoint;
begin
  if not assigned(Parent) then
    exit;

  //make sure connection parents are assigned otherwise quit ...
  if (assigned(Connection1) and not assigned(Connection1.Parent)) or (assigned(Connection2) and not assigned(Connection2.Parent)) then
    exit;

  if assigned(Connection1) then
  begin
    pt := Connection1.ClosestScreenPt(ClientToScreen(BtnPoints[1]));
    BtnPoints[0] := ScreenToClient(pt);
  end;
  if assigned(Connection2) then
  begin
    pt := Connection2.ClosestScreenPt(ClientToScreen(BtnPoints[ButtonCount - 2]));
    BtnPoints[ButtonCount - 1] := ScreenToClient(pt);
  end;
  ResizeNeeded;
end;

procedure TplBezier.SaveToPropStrings;
begin
  inherited;
  if Filled then
    AddToPropStrings('Filled', GetEnumProp(self, 'Filled'));
  if not Smooth then
    AddToPropStrings('Smooth', GetEnumProp(self, 'Smooth'));
end;

// ================ TplSolidBezier =============================

constructor TplSolidBezier.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  pen.Width := 20;
  fBorder := 3;
  DoSaveInfo;
end;

procedure TplSolidBezier.SetNoConnection(Connection: TplSolid);
begin
  //although this object is a line it looks like a solid so it makes no
  //sense to allow it to connect to other solids.
end;

function TplSolidBezier.GetNoConnection: TplSolid;
begin
  Result := nil; //see above
end;

procedure TplSolidBezier.SetArrow1(Arrow: boolean);
begin
  //see above
end;

procedure TplSolidBezier.SetArrow2(Arrow: boolean);
begin
  //see above
end;

procedure TplSolidBezier.SetFilled(isFilled: boolean);
begin
  //do nothing
end;

procedure TplSolidBezier.SetUseHitTest(Value: boolean);
begin
  inherited SetUseHitTest(False);
end;

procedure TplSolidBezier.SetBorder(border: integer);
begin
  if Border * 2 >= Pen.Width then
    Border := Pen.Width div 2
  else if Border < 0 then
    Border := 0;
  if fBorder = border then
    exit;
  fBorder := border;
  UpdateNeeded;
end;

procedure TplSolidBezier.DrawObject(aCanvas: TbgraCanvas; IsShadow: boolean);
begin
  with aCanvas do
  begin
    PolyBezier(BtnPoints);
    if isShadow then
      exit;
    Pen.Width := Pen.Width - fBorder * 2;
    Pen.Color := self.Color;
    PolyBezier(BtnPoints);
  end;
end;

procedure TplSolidBezier.SaveToPropStrings;
begin
  inherited;
  AddToPropStrings('BorderWidth', IntToStr(BorderWidth));
end;

procedure TplSolidBezier.Mirror;
var
  i: integer;
begin
  for i := 0 to ButtonCount - 1 do
    BtnPoints[i].X := Width - BtnPoints[i].X;
  ResizeNeeded;
end;

procedure TplSolidBezier.Flip;
var
  i: integer;
begin
  for i := 0 to ButtonCount - 1 do
    BtnPoints[i].Y := Height - BtnPoints[i].Y;
  ResizeNeeded;
end;

// ================== TplTextBezier =============================

constructor TplTextBezier.Create(AOwner: TComponent);
begin
  inherited;
  ParentFont := True;
end;

procedure TplTextBezier.SeTText(const aText: string);
begin
  if fText =aText then
    exit;
  fText := aText;
  UpdateNeeded;
end;

procedure TplTextBezier.SetOuTplLine(OuTplLine: TFontOutLine);
begin
  if fOuTplLine = OuTplLine then
    exit;
  fOuTplLine := OuTplLine;
  UpdateNeeded;
end;

procedure TplTextBezier.CMFontChanged(var Message: TLMessage);
begin
  inherited;
  CalcMargin;
end;

procedure TplTextBezier.CalcMargin;
begin
  //the following formula is empirical ...
  Margin := max(ButtonSize + marginForDimensions, 2 * abs(Font.Height) div 3);
  //the following is also needed (see ancestor method) ...
  ResizeNeeded;
end;

procedure TplTextBezier.SetNoConnection(Connection: TplSolid);
begin
  //although this object is a line it looks like a solid so it makes no
  //sense to allow it to connect to other solids.
end;

function TplTextBezier.GetNoConnection: TplSolid;
begin
  Result := nil; //see above
end;

procedure TplTextBezier.SetArrow1(Arrow: boolean);
begin
  //see above
end;

procedure TplTextBezier.SetArrow2(Arrow: boolean);
begin
  //see above
end;

procedure TplTextBezier.SetUseHitTest(Value: boolean);
begin
  inherited SetUseHitTest(False);
end;

procedure TplTextBezier.SetFilled(isFilled: boolean);
begin
  //do nothing
end;

procedure TplTextBezier.DrawObject(aCanvas: TbgraCanvas; IsShadow: boolean);
var
  s: string;
  SavedColor: TColor;
begin
  if fText = '' then
    s := trim(dummyStrings.Text)
  else
    s := fText;
  with acanvas do
  begin
    Brush.Style := bsClear;
    if IsShadow then
    begin
      SavedColor := Font.Color;
      Font.Color := ColorShadow;
      Brush.Color := ColorShadow;
      TextAlongBezier(acanvas, BtnPoints,
        s, -round(2 * TextHeight('Yy') / 3), fOuTplLine);
      Font.Color := SavedColor;
    end
    else
    begin
      if fOuTplLine = foColored then
        brush.Color := color;
      TextAlongBezier(acanvas, BtnPoints,
        s, -round(2 * TextHeight('Yy') / 3), fOuTplLine);
    end;
  end;
end;

procedure TplTextBezier.SaveToPropStrings;
begin
  inherited;
  AddToPropStrings('Text', fText);
  AddToPropStrings('Font.Charset', IntToStr(Font.Charset));
  AddToPropStrings('Font.Color', '$' + inttohex(ColorToRGB(Font.Color), 8));
  AddToPropStrings('Font.Name', Font.Name);
  AddToPropStrings('Font.Size', IntToStr(Font.Size));
  AddToPropStrings('Font.Style', GetSetProp(Font, 'Style', False));
  AddToPropStrings('OuTplLine', GetEnumProp(self, 'OuTplLine'));
end;

// ================== TplArc =================================

constructor TplArc.Create(AOwner: TComponent);
begin
  inherited;
  fAngle1 := 45;
  DoSaveInfo;
end;

procedure TplArc.DrawObject(aCanvas: TbgraCanvas; IsShadow: boolean);
var
  mp, pt1, pt2: TPoint;
begin
  mp.X := (BtnPoints[0].X + BtnPoints[1].X) div 2;
  mp.Y := (BtnPoints[0].Y + BtnPoints[1].Y) div 2;

  pt1 := GetPtOnCircleFromAngle(100, (fAngle1 * pi) / 180);
  OffsetPt(pt1, mp.X, mp.Y);
  pt2 := GetPtOnCircleFromAngle(100, (fAngle2 * pi) / 180);
  OffsetPt(pt2, mp.X, mp.Y);

  with acanvas do
  begin
     if self.Filled then
         aCanvas.Brush.Style:=bsSolid
      else
          aCanvas.Brush.Style:=bsClear;
    Pie(BtnPoints[0].X, BtnPoints[0].Y, BtnPoints[1].X, BtnPoints[1].Y,
      pt1.X, pt1.Y, pt2.X, pt2.Y);
  end;
end;


procedure TplArc.SetAngle1(ang1: integer);
begin
  while (ang1 < 0) do
    Inc(ang1, 360);
  while (ang1 > 359) do
    Dec(ang1, 360);
  if (fAngle1 = ang1) then
    exit;
  fAngle1 := ang1;
  UpdateNeeded;
end;


procedure TplArc.SetAngle2(ang2: integer);
begin
  while (ang2 < 0) do
    Inc(ang2, 360);
  while (ang2 > 359) do
    Dec(ang2, 360);
  if (fAngle2 = ang2) then
    exit;
  fAngle2 := ang2;
  UpdateNeeded;
end;


procedure TplArc.SetRegular(Value: boolean);
begin
  if fRegular = Value then
    exit;
  fRegular := Value;
  if not fRegular then
    exit;
  BtnPoints[1].Y := BtnPoints[0].Y + (BtnPoints[1].X - BtnPoints[0].X);
  ResizeNeeded;
end;


procedure TplArc.BeginTransform;
begin
  inherited;
  fCurrRotAngle := 0;
end;


procedure TplArc.Rotate(degrees: integer);
var
  diff: integer;
begin
  if not SavedInfo.isTransforming then
    raise Exception.Create('Error: Rotate() without BeginRotate().');

  degrees := degrees mod 360;
  if degrees < 0 then
    Inc(degrees, 360);
  diff := degrees - fCurrRotAngle;
  if diff = 0 then
    exit;

  fCurrRotAngle := degrees;
  Angle1 := Angle1 + diff;
  Angle2 := Angle2 + diff;
  UpdateNeeded;
end;


procedure TplArc.InternalBtnMove(BtnIdx: integer; NewPt: TPoint);
begin
  if fRegular then
  begin
    if BtnIdx = 0 then
    begin
      BtnPoints[0].X := NewPt.X;
      BtnPoints[0].Y := BtnPoints[1].Y - (BtnPoints[1].X - NewPt.X);
    end
    else
    begin
      BtnPoints[1].X := NewPt.X;
      BtnPoints[1].Y := BtnPoints[0].Y + (NewPt.X - BtnPoints[0].X);
    end;
    ResizeNeeded;
  end
  else
    inherited;
end;


procedure TplArc.SaveToPropStrings;
begin
  inherited;
  AddToPropStrings('Angle1', IntToStr(Angle1));
  AddToPropStrings('Angle2', IntToStr(Angle2));
  if Regular then
    AddToPropStrings('Regular', GetEnumProp(self, 'Regular'));
end;


// =============== TplDiamond ============================================


constructor TplDiamond.Create(AOwner: TComponent);
begin
  inherited;
  InternalSetCount(6);
  SeTplDiamondPts;
  DoSaveInfo;
end;


procedure TplDiamond.SeTplDiamondPts;
var
  mp: TPoint;
begin
  mp := MidPoint(BtnPoints[0], BtnPoints[1]);
  //left,top,right,bottom ...
  BtnPoints[2] := Point(BtnPoints[0].X, mp.Y);
  BtnPoints[3] := Point(mp.X, BtnPoints[0].Y);
  BtnPoints[4] := Point(BtnPoints[1].X, mp.Y);
  BtnPoints[5] := Point(mp.X, BtnPoints[1].Y);

  //now rotate all drawing points (ie pts > 1) about the diamond center ...
  if SavedInfo.AngleInDegrees <> 0 then
    RotatePts(BtnPoints, 2, mp, SavedInfo.AngleInDegrees * pi / 180);
end;


procedure TplDiamond.Rotate(degrees: integer);
begin
  inherited;
  SeTplDiamondPts;
end;


procedure TplDiamond.DrawStringsInDiamond(aCanvas: TbgraCanvas; aStrings: TStrings);
var
  YPos, YLimit, lineHeight, space, VertSpace, pad, XCenter, YCenter, MaxX: integer;
  ls, rs: string;

  function DoTextOut(DraftOnly: boolean): integer;
  var
    i, startY: integer;
  begin
    startY := YPos;
    for i := 0 to aStrings.Count - 1 do
    begin
      ls := aStrings[i];
      if (ls = '') then
        Inc(YPos, lineHeight)
      else
        while (ls <> '') and (YPos < YLimit - lineHeight) do
        begin
          if YPos < YCenter then
            space := trunc(MaxX * (YPos - BtnPoints[0].Y - padding) / (YCenter - BtnPoints[0].Y - padding))
          else
            space := trunc(MaxX * (BtnPoints[1].Y - YPos - lineHeight - padding) / (BtnPoints[1].Y - YCenter - padding));
          TrimLine(aCanvas, ls, rs, space);
          if (ls <> '') and not DraftOnly then
            with aCanvas do
              if Angle = 0 then
                TextOut(XCenter - TextWidth(ls) div 2, Ypos, ls)
              else
                RotatedTextAtPt(aCanvas, XCenter - TextWidth(ls) div 2, Ypos, ls);
          ls := rs;
          Inc(YPos, lineHeight);
        end;
      if (YPos >= YLimit - lineHeight) then
        break;
    end;
    Result := YPos - StartY;
  end;

  function CalcVertSpace: integer;
  var
    i, cnt: integer;
  begin
    Result := 0;
    cnt := 0;
    for i := 0 to aStrings.Count - 1 do
    begin
      if (YPos + lineHeight >= YLimit) then
        break;
      ls := aStrings[i];
      if (ls = '') then
      begin
        Inc(cnt);
        if odd(cnt) then
          Inc(Ypos, lineheight);
        Inc(Result, lineheight);
      end
      else
        while (ls <> '') and (YPos + lineHeight < YLimit) do
        begin
          space := trunc(MaxX * (BtnPoints[1].Y - YPos - lineHeight - padding) / (BtnPoints[1].Y - YCenter - padding));
          TrimLine(aCanvas, ls, rs, space);
          ls := rs;
          //simplified by simulating oscillating text about x axis ...
          Inc(cnt);
          if odd(cnt) then
            Inc(YPos, lineHeight);
          Inc(Result, lineheight);
        end;
    end;
  end;

begin
  with aCanvas do
    try
      lineHeight := TextHeight('Yy');
      pad := padding + (Pen.Width div 2);
      if odd(Pen.Width) then
        Inc(pad);
      XCenter := (BtnPoints[0].X + BtnPoints[1].X) div 2;
      MaxX := BtnPoints[1].X - BtnPoints[0].X - pad * 2;
      YCenter := (BtnPoints[0].Y + BtnPoints[1].Y) div 2; //widest point
      YLimit := BtnPoints[1].Y - pad;

      //calc approx vertical space required for text
      YPos := YCenter - lineHeight div 2;
      VertSpace := CalcVertSpace;
      //now test draw the text & get real vertSpace ...
      YPos := YCenter - VertSpace div 2;
      VertSpace := DoTextOut(True);
      //now draw text ...
      YPos := YCenter - VertSpace div 2;
      DoTextOut(False);
    except
      //ie divide by zero errors - just don't print anything
    end;
end;


procedure TplDiamond.InternalBtnMove(BtnIdx: integer; NewPt: TPoint);
begin
  inherited;
  SeTplDiamondPts;
end;


function TplDiamond.ClosestScreenPt(FromScreenPt: TPoint): TPoint;
var
  FromPt, mp, pt, pt1, pt2: TPoint;
  i: integer;
begin
  FromPt := ScreenToClient(FromScreenPt);
  mp := ObjectMidpoint;
  //find the closest vertex to the FromPt ...
  i := ClosestPointIdx([BtnPoints[2], BtnPoints[3], BtnPoints[4], BtnPoints[5]], FromPt) + 2; //nb Index: 0 => BtnPoints[2]

  //given the vertex closest to FromPt, the line between the object's midpoint
  //and FromPt intersects one of the vertex's adjoining edges ...
  case i of
    2, 4:
    begin
      pt1 := BtnPoints[3];
      pt2 := BtnPoints[5];
    end;
    3, 5:
    begin
      pt1 := BtnPoints[2];
      pt2 := BtnPoints[4];
    end;
  end;
  IntersectionPoint(mp, fromPt, BtnPoints[i], pt1, pt);
  if not APointIsBetweenPts(pt, BtnPoints[i], pt1) then
    IntersectionPoint(mp, fromPt, BtnPoints[i], pt2, pt);
  Result := ClientToScreen(pt);
end;


procedure TplDiamond.DrawObject(aCanvas: TbgraCanvas; IsShadow: boolean);
begin
  with acanvas do
  begin
    if self.Filled then
         aCanvas.Brush.Style:=bsSolid
      else
          aCanvas.Brush.Style:=bsClear;
    Polygon([BtnPoints[2], BtnPoints[3], BtnPoints[4], BtnPoints[5]]);
    if IsShadow or (Strings.Count = 0) then
      exit;
    DrawStringsInDiamond(aCanvas, Strings);
  end;
end;



function TplDiamond.ResizeObjectToFiTText: boolean;
var
  i, w, marg: integer;
  size: TSize;
begin
  size.cx := 0;
  size.cy := bitmap.canvas.TextHeight('Yy') * (Strings.Count + 1);
  for i := 0 to Strings.Count - 1 do
  begin
    w := bitmap.canvas.TextWidth(Strings[i]);
    if w > size.cx then
      size.cx := w;
  end;
  marg := Margin + (Pen.Width div 2) + 1 + Padding;
  //theoretically only need twice width and height of rectangular text box,
  //but for some reason needs a bit more in practise (hence extra line above)...
  SetBounds(left, top, round(size.cx * 2) + marg * 2, round(size.cy * 2) + marg * 2);
  Result := True;
end;


// ================= TplDrawPicture ==============================


constructor TplDrawPicture.Create(AOwner: TComponent);
begin
  inherited;
  fpic := TBGRABitmap.create;
  DataStream := TMemoryStream.Create;
  Pen.Width := 1;
  ShadowSize := 0;
  DoSaveInfo;
end;


destructor TplDrawPicture.Destroy;
begin
  fPic.Free;
  DataStream.Free;
  DataStream := nil;
  inherited;
end;


procedure TplDrawPicture.BinaryDataLoaded;
begin
  LoadPicFromDataStream;
end;


procedure TplDrawPicture.LoadPicFromFile(const filename: string);
begin
  try
    DataStream.LoadFromFile(filename);
    LoadPicFromDataStream;
  except
  end;
end;


procedure TplDrawPicture.LoadPicFromDataStream;
var
  pomPic:Tpicture;
begin
  if (self.pictureFileName = '') and (self.DataStream.Size = 0) then exit;
  if self.pictureFileName = 'clear' then
     begin
      fpic.destroy; // did not find any other way how to erase and clean fpic :-(
      fpic := TBGRABitmap.create;
      self.UpdateNeeded;
      self.FpictureFileName:=''; // nutno obejít setter :-)
      exit;
     end;
  try
    DataStream.Position := 0;
    pomPic:=TPicture.Create;
    pomPic.LoadFromStream(DataStream);
    // not found way to load bmp both with TBGRABitmap and TPicture - Strange :-)
    if pomPic.Bitmap.GetFileExtensions = 'bmp' then
       begin
          DataStream.Position := 0;
          fPic.LoadFromStream(DataStream);
       end
    else
        fPic.Assign(pomPic.Bitmap);
    pomPic.Destroy;

    if not fStretch then
      begin
        if not BlockResize then //ie: BlockResize when loading from *.dob file
        begin
          BtnPoints[1].X := BtnPoints[0].X + fPic.Width;
          BtnPoints[1].Y := BtnPoints[0].Y + fPic.Height;
          BlockResize := True;
          SetBounds(left, top, BtnPoints[1].X + Margin, BtnPoints[1].Y + Margin);
          BlockResize := False;
        end;
        Bitmap.SetSize(Width,Height);
      end;
  except
    begin
      DataStream.Size := 0;
      pomPic.destroy;
      UpdateNeeded;
    end;
  end;
  UpdateNeeded;
end;


procedure TplDrawPicture.SavePicToFile(const filename: string);
begin
  DataStream.SaveToFile(filename);
end;


function TplDrawPicture.IsValidBtnDown(BtnIdx: integer): boolean;
begin
  Result := fStretch;
end;


procedure PrintBitmapROP(DestCanvas: TbgraCanvas; DestRect: TRect; Bitmap: TbgraBitmap; rop: cardinal);
var
  BitmapHeader: pBitmapInfo;
  BitmapImage: POINTER;
  HeaderSize: dword;
  ImageSize: dword;
begin
  assert(False, 'portable function not implemented!');
  { TODO -oTC -cLazarus_Port_Step1 : GetDIBSizes not recognized }
  //TCQ GetDIBSizes(Bitmap.Handle,HeaderSize,ImageSize);
  GetMem(BitmapHeader, HeaderSize);
  GetMem(BitmapImage, ImageSize);
  try
    { TODO -oTC -cLazarus_Port_Step1 : GetDIB not recognized }
    //TC GetDIB(Bitmap.Handle, Bitmap.Palette, BitmapHeader^, BitmapImage^);
    //StretchDIBits(DestCanvas.Handle,
    //              DestRect.Left, DestRect.Top,     // Destination Origin
    //              DestRect.Right  - DestRect.Left, // Destination Width
    //              DestRect.Bottom - DestRect.Top,  // Destination Height
    //              0,0,                             // Source Origin
    //              Bitmap.Width, Bitmap.Height,     // Source Width & Height
    //              BitmapImage,
    //              TBitmapInfo(BitmapHeader^),
    //              DIB_RGB_COLORS,
    //              rop);
  finally
    FreeMem(BitmapHeader);
    FreeMem(BitmapImage)
  end;
end;

procedure PrintBitmap(DestCanvas: TbgraCanvas; DestRect: TRect; Bitmap: TbgraBitmap);
var
  transpClr: TColor;
  mask: TBitmap;
  oldMode: integer;
  oldColor: cardinal;
const
  CAPS1 = 94;
  C1_TRANSPARENT = 1;
  NEWTRANSPARENT = 3;
begin
  //if Bitmap.Transparent then
  if True then    // should think about it :-)
  begin
    //transpClr := Bitmap.TransparentColor and $FFFFFF;

    { TODO -oTC -cLazarus_Port_Step2 : GetDeviceCaps is specific to Windows. Not used. }
    //if (GetDeviceCaps(DestCanvas.Handle, CAPS1) and C1_TRANSPARENT) <> 0 then
    //begin
    //  //if the device context handles transparency natively then ...
    //  oldMode := SetBkMode(DestCanvas.Handle, NEWTRANSPARENT);
    //  oldColor := SetBkColor(DestCanvas.Handle, cardinal(transpClr));
    //  PrintBitmapROP(DestCanvas, DestRect, Bitmap, SRCCOPY);
    //  SetBkColor(DestCanvas.Handle, oldColor);
    //  SetBkMode(DestCanvas.Handle, oldMode);
    //end else
    //begin
    //  //otherwise do transparency this way ...
    //  mask := TBitmap.Create;
    //  try
    //    mask.Assign(Bitmap);
    //    mask.Mask(transpClr);
    //    PrintBitmapROP(DestCanvas, DestRect, Bitmap, SRCINVERT);
    //    PrintBitmapROP(DestCanvas, DestRect, mask, SRCAND);
    //    PrintBitmapROP(DestCanvas, DestRect, Bitmap, SRCINVERT);
    //  finally
    //    mask.Free;
    //  end;
    //end;
    DestCanvas.Draw(DestRect.Top ,DestRect.Left,Bitmap);
  end
  else
    PrintBitmapROP(DestCanvas, DestRect, Bitmap, SRCCOPY);
end;

procedure TplDrawPicture.DrawObject(aCanvas: TbgraCanvas; IsShadow: boolean);
var
  tmpRect: TRect;
  pom:TBGRABitmap;
begin
  if IsShadow then exit;
  tmpRect := Rect(BtnPoints[0].X, BtnPoints[0].Y, BtnPoints[1].X, BtnPoints[1].Y);

  //nb: Delphi's Canvas.Draw() & Canvas.StretchDraw() are buggy. The pallete is
  //often corrupted when stretching a transparent image on screen and they
  //simply don't display at all in metafile canvases. (If you're not convinced,
  //try a few bitmaps in a stretched & transparent TImage component and see what
  //happens to their images.)

  //Anyhow, this PrintBitmap() function seems to (mostly) solve these issues
  //while bearing in mind that some printers (eg PostScript printers) do not
  //support ROPs that involve the destination canvas.

  pom:=TBGRABitmap.Create;
  BGRAReplace(pom, fpic.Resample(tmpRect.Width,tmpRect.Height,rmSimpleStretch));
  if Transparent  then  pom.ApplyGlobalOpacity(128);
  PrintBitmap(aCanvas, tmpRect, pom);
  pom.Destroy;
end;

procedure TplDrawPicture.SetStretch(Stretch: boolean);
begin
  if Stretch = fStretch then
    exit;
  fStretch := Stretch;
  if not Stretch and (fPic.Width > 0) and not BlockResize then
  begin
    BtnPoints[1].X := fPic.Width + BtnPoints[0].X;
    BtnPoints[1].Y := fPic.Height + BtnPoints[0].Y;
    ResizeNeeded;
  end
  else
   begin
     UpdateNeeded;
   end;
end;

procedure TplDrawPicture.SetpictureFileName(AValue: AnsiString);
begin
  if (FpictureFileName=AValue) or (AValue = '') then Exit;
  FpictureFileName:=AValue;
  if AValue = 'clear' then
     begin
       self.DataStream.clear;
       self.LoadPicFromDataStream;
     end
  else
      self.LoadPicFromFile(AValue);
end;

procedure TplDrawPicture.SetTransparent(Transparent: boolean);
begin
  if Transparent = fTransparent then
    exit;
  fTransparent := Transparent;
  UpdateNeeded;
end;

procedure TplDrawPicture.SetTightConnections(Value: boolean);
begin
  if Value = fTightConnections then
    exit;
  fTightConnections := Value;
  if assigned(ConnectorList) then
    ResizeNeeded;
end;

function TplDrawPicture.ClosestScreenPt(FromScreenPt: TPoint): TPoint;
var
  mp: TPoint;
  trnspClr: TColor;
  slope: single;
begin
  Result := inherited ClosestScreenPt(FromScreenPt);
  if not fTightConnections or not fTransparent or Stretch then
    exit;
  //trnspClr := fPic.TransparentColor and $FFFFFF;
  trnspClr := clBackground;


  Result := ScreenToClient(Result);
  OffsetPt(Result, -margin, -margin);
  if (Result.X < 0) then
    Result.X := 0;
  while (Result.X >= fPic.Width) do
    Dec(Result.X);
  while (Result.Y >= fPic.Height) do
    Dec(Result.Y);
  mp := ObjectMidPoint;

  if (Result.X = mp.X) then
  begin
    if (Result.Y > mp.Y) then
      while (fPic.canvas.pixels[Result.X, Result.Y] = trnspClr) and (Result.Y > mp.Y) do
        Dec(Result.Y)
    else
      while (fPic.canvas.pixels[Result.X, Result.Y] = trnspClr) and (Result.Y < mp.Y) do
        Inc(Result.Y);
  end
  else if (Result.X >= mp.X) and (Result.Y >= mp.Y) then
  begin
    slope := (Result.Y - mp.Y) / (Result.X - mp.X);
    while (fPic.canvas.pixels[Result.X, Result.Y] = trnspClr) and not PointsEqual(Result, mp) do
      if (Result.X = mp.X) or ((Result.Y - mp.Y) / (Result.X - mp.X) >= slope) then
        Dec(Result.Y)
      else
        Dec(Result.X);
  end
  else if (Result.X >= mp.X) and (Result.Y < mp.Y) then
  begin
    slope := (Result.Y - mp.Y) / (Result.X - mp.X);
    while (fPic.canvas.pixels[Result.X, Result.Y] = trnspClr) and not PointsEqual(Result, mp) do
      if (Result.X = mp.X) or ((Result.Y - mp.Y) / (Result.X - mp.X) <= slope) then
        Inc(Result.Y)
      else
        Dec(Result.X);
  end
  else if (Result.X < mp.X) and (Result.Y < mp.Y) then
  begin
    slope := (Result.Y - mp.Y) / (Result.X - mp.X);
    while (fPic.canvas.pixels[Result.X, Result.Y] = trnspClr) and not PointsEqual(Result, mp) do
      if (Result.X = mp.X) or ((Result.Y - mp.Y) / (Result.X - mp.X) >= slope) then
        Inc(Result.Y)
      else
        Inc(Result.X);
  end
  else
  begin
    slope := (Result.Y - mp.Y) / (Result.X - mp.X);
    while (fPic.canvas.pixels[Result.X, Result.Y] = trnspClr) and not PointsEqual(Result, mp) do
      if (Result.X = mp.X) or ((Result.Y - mp.Y) / (Result.X - mp.X) <= slope) then
        Dec(Result.Y)
      else
        Inc(Result.X);
  end;
  OffsetPt(Result, margin, margin);
  Result := ClientToScreen(Result);
end;

procedure TplDrawPicture.SaveToPropStrings;
begin
  inherited;
  if Angle <> 0 then
    AddToPropStrings('Angle', GetEnumProp(self, 'Angle'));
  if Stretch then
    AddToPropStrings('Stretch', GetEnumProp(self, 'Stretch'));
  if TightConnections then
    AddToPropStrings('TightConnections', GetEnumProp(self, 'TightConnections'));
end;

function TplDrawPicture.MergeDrawObjImage(DrawObj: TplDrawObject; TransparentClr: TColor): boolean;
var
  //bmp: TBitmap;
  bmp :TBGRABitmap;
  l, t, w, h: integer;
begin
  Result := assigned(DrawObj) and DrawObj.Visible and (DrawObj.Parent = Parent);
  if not Result then
    exit;

  if (fPic.Width = 0) or (Left + Margin > DrawObj.Left) then
    l := DrawObj.Left
  else
    l := Left + Margin;
  if (fPic.Height = 0) or (Top + Margin > DrawObj.Top) then
    t := DrawObj.Top
  else
    t := Top + Margin;
  w := max(DrawObj.Left + DrawObj.Width, Left + Width - Margin) - l;
  h := max(DrawObj.Top + DrawObj.Height, Top + Height - Margin) - t;


  bmp:= TBGRABitmap.create(w,h);
  try
    //bmp.Width := w;
    //bmp.Height := h;
    //bmp.Canvas.Brush.Color := TransparentClr;
    bmp.CanvasBGRA.FillRect(Rect(0, 0, w, h));
    bmp.canvasBGRA.Draw(left + Margin - l, top + Margin - t, fPic);
    bmp.canvasBgra.Draw(DrawObj.left - l, DrawObj.top - t, DrawObj.Bitmap);
    fPic.Assign(bmp);
    DataStream.Size := 0;
    fPic.SaveToStreamAsPng(DataStream);
    SetBounds(l - Margin, t - Margin, w + Margin * 2, h + Margin * 2);
    BtnPoints[1].X := Width - Margin;
    BtnPoints[1].Y := Height - Margin;
  finally
    bmp.Free;
  end;
end;

procedure TplDrawPicture.Rotate(degrees: integer);
var
  mp: TPoint;
  TmpPic: TbgraBitmap;
begin
  if not SavedInfo.isTransforming then
    raise Exception.Create('Error: Rotate() without BeginTransform().');

  degrees := degrees mod 360;
  if degrees < 0 then
    Inc(degrees, 360);
  if degrees = SavedInfo.AngleInDegrees then
    exit;

  DataStream.Position := 0;
  TmpPic := TBGRABitmap.Create;
  try
    //TmpPic.Transparent := fPic.Transparent;
    TmpPic.LoadFromStream(DataStream);
    RotateBitmap(TmpPic, fPic, (360 - degrees) * pi / 180,
      Point(TmpPic.Width div 2, TmpPic.Height div 2), mp);
  finally
    TmpPic.Free;
  end;
  SavedInfo.AngleInDegrees := degrees;

  if BlockResize then
    exit; //ie loading from *.dob file
  BtnPoints[1].X := fPic.Width + Margin;
  BtnPoints[1].Y := fPic.Height + Margin;
  ResizeNeeded;
end;

function TplDrawPicture.GetAngle: integer;
begin
  Result := SavedInfo.AngleInDegrees;
  if Result > 180 then
    Dec(Result, 360);
end;

procedure TplDrawPicture.SetAngle(angle: integer);
begin
  angle := angle mod 360;
  if angle < 0 then
    Inc(angle, 360);
  if angle = SavedInfo.AngleInDegrees then
    exit;
  BeginTransform;
  Rotate(angle);
  EndTransform;
end;

// ===================== TplRectangle =========================

constructor TplRectangle.Create(AOwner: TComponent);
begin
  inherited;
  InternalSetCount(6);
  fCentered := True;
  Padding := 4;
  SeTplRectanglePts;
  DoSaveInfo;
end;

procedure TplRectangle.SeTplRectanglePts;
var
  mp: TPoint;
begin
  mp := MidPoint(BtnPoints[0], BtnPoints[1]);
  //tl,tr,br,bl ...
  BtnPoints[2] := BtnPoints[0];
  BtnPoints[3] := Point(BtnPoints[1].X, BtnPoints[0].Y);
  BtnPoints[4] := BtnPoints[1];
  BtnPoints[5] := Point(BtnPoints[0].X, BtnPoints[1].Y);

  //now rotate all drawing points (ie pts > 1) about the diamond center ...
  if SavedInfo.AngleInDegrees <> 0 then
    RotatePts(BtnPoints, 2, mp, SavedInfo.AngleInDegrees * pi / 180);
end;


// Helper function for ClosestScreenPt() to elegantly handle rounded corners ...
function RoundedCorner(pt1, pt2: TPoint; circOrigX, circOrigY, circRadius: integer; pos: TBalloonPoint): TPoint;
var
  m, a, b, c, z, x1, x2: double;
begin
  //given 2 pts & eq'n line (y=mx+z) ...
  //m = (y2-y1)/(x2-x1)
  //z = y1 - m * x1
  m := (pt2.Y - pt1.Y) / (pt2.X - pt1.X);
  z := pt1.Y - m * pt1.X;

  //eq'n circle (x - cx)^2 + (y - cy)^2 = r^2 given origin (cx,cy), radius (r)
  //solve using simultaneous equations, substituting (mx + z) for y ...

  //(x - cx)^2 + (m*x + z - cy)^2 = r^2 given origin (cx,cy), radius (r)
  //x^2 - 2cx*x + cx^2 + m^2*x^2 + 2(z-cy)m*x + (z-cy)^2 = r^2
  //(m^2 + 1)x^2 + (2.m(z-cy) - 2.cx)x + cx^2 + (z-cy)^2 - r^2 = 0

  //Given general solution to quadratic ... x = (-b +/- sqrt(b^2 - 4ac))/2a
  a := m * m + 1;
  b := (2 * m * (z - circOrigY) - 2 * circOrigX);
  c := circOrigX * circOrigX + (z - circOrigY) * (z - circOrigY) - circRadius * circRadius;

  x1 := (-b + SQRT(b * b - 4 * a * c)) / (2 * a);
  x2 := (-b - SQRT(b * b - 4 * a * c)) / (2 * a);

  case pos of
    bpTopLeft, bpBottomLeft: if x2 < x1 then
        x1 := x2;
    else
      if x2 > x1 then
        x1 := x2;
  end;
  Result.X := round(x1);
  Result.Y := round(x1 * m + z);

end;


function TplRectangle.ClosestScreenPt(FromScreenPt: TPoint): TPoint;
var
  FromPt, mp, pt, pt1, pt2: TPoint;
  i, radius: integer;
begin
  FromPt := ScreenToClient(FromScreenPt);
  mp := ObjectMidpoint;

  i := ClosestPointIdx([BtnPoints[2], BtnPoints[3], BtnPoints[4], BtnPoints[5]], FromPt) + 2;

  case i of
    2, 4:
    begin
      pt1 := BtnPoints[3];
      pt2 := BtnPoints[5];
    end;
    3, 5:
    begin
      pt1 := BtnPoints[2];
      pt2 := BtnPoints[4];
    end;
  end;
  IntersectionPoint(mp, fromPt, BtnPoints[i], pt1, pt);
  if not APointIsBetweenPts(pt, BtnPoints[i], pt1) then
    IntersectionPoint(mp, fromPt, BtnPoints[i], pt2, pt);
  Result := ClientToScreen(pt);


  if fRounded then
  begin

    radius := min(BtnPoints[1].X - BtnPoints[0].X, BtnPoints[1].Y - BtnPoints[0].Y) div 4;
    if pt.X < BtnPoints[0].X + radius then
    begin
      if pt.Y < BtnPoints[0].Y + radius then
        pt := RoundedCorner(pt, mp, BtnPoints[0].X + radius, BtnPoints[0].Y + radius, radius, bpTopLeft)
      else if pt.Y > BtnPoints[1].Y - radius then
        pt := RoundedCorner(pt, mp, BtnPoints[0].X + radius, BtnPoints[1].Y - radius, radius, bpBottomLeft);
    end
    else if pt.X > BtnPoints[1].X - radius then
    begin
      if pt.Y < BtnPoints[0].Y + radius then
        pt := RoundedCorner(pt, mp, BtnPoints[1].X - radius, BtnPoints[0].Y + radius, radius, bpTopRight)
      else if pt.Y > BtnPoints[1].Y - radius then
        pt := RoundedCorner(pt, mp, BtnPoints[1].X - radius, BtnPoints[1].Y - radius, radius, bpBottomRight);
    end;
    Result := ClientToScreen(pt);
  end;
end;

procedure TplRectangle.SetCentered(Centered: boolean);
begin
  if fCentered = Centered then
    exit;
  fCentered := Centered;
  UpdateNeeded;
end;

procedure TplRectangle.SetRounded(Rounded: boolean);
begin
  if (fRounded = Rounded) or (Angle <> 0) then
    exit;
  fRounded := Rounded;
  if assigned(ConnectorList) then
    ResizeNeeded
  else
    UpdateNeeded;
end;

procedure TplRectangle.Rotate(degrees: integer);
begin
  inherited;
  if (Angle <> 0) then
    fRounded := False;
  SeTplRectanglePts;
end;

procedure TplRectangle.InternalBtnMove(BtnIdx: integer; NewPt: TPoint);
begin
  inherited;
  SeTplRectanglePts;
end;

procedure TplRectangle.DrawStringsInRect(aCanvas: TbgraCanvas; aStrings: TStrings);
var
  i, YPos, YLimit, lineHeight, space, pad, XCenter: integer;
  ls, rs: string;

  procedure CalcOnlyOrTextOut(CalcOnly: boolean);
  var
    i: integer;
  begin
    for i := 0 to aStrings.Count - 1 do
    begin
      ls := aStrings[i];
      if ls = '' then
        Inc(YPos, lineHeight)
      else
        while (ls <> '') and (YPos < YLimit) do
        begin
          TrimLine(aCanvas, ls, rs, space);
          if ls = '' then
            exit;
          if not CalcOnly then
            with aCanvas do
              if Centered then
              begin
                if Angle = 0 then
                  TextOut(XCenter - TextWidth(ls) div 2, Ypos, ls)
                else
                  RotatedTextAtPt(aCanvas, XCenter - TextWidth(ls) div 2, Ypos, ls);
              end
              else
              begin
                if Angle = 0 then
                  TextOut(BtnPoints[0].X + Padding + Pen.Width, Ypos, ls)
                else
                  RotatedTextAtPt(aCanvas, BtnPoints[0].X + Padding + Pen.Width, Ypos, ls);
              end;
          Inc(YPos, lineHeight);
          ls := rs;
        end;
      if (YPos >= YLimit) then
        break;
    end;
  end;

begin
  with aCanvas do
  begin
    lineHeight := TextHeight('Yy');
    pad := padding + (Pen.Width div 2);
    if odd(Pen.Width) then
      Inc(pad);
    XCenter := (BtnPoints[0].X + BtnPoints[1].X) div 2;
    YPos := BtnPoints[0].Y + padding;
    YLimit := BtnPoints[1].Y - lineHeight - pad;
    space := BtnPoints[1].X - BtnPoints[0].X - pad * 2;
    CalcOnlyOrTextOut(True);
    i := BtnPoints[1].Y - pad - YPos;
    YPos := BtnPoints[0].Y + pad;
    if i > 1 then
      Inc(YPos, i div 2);
    CalcOnlyOrTextOut(False);
  end;
end;

procedure TplRectangle.DrawObject(aCanvas: TbgraCanvas; IsShadow: boolean);
var
  tmpRect: TRect;
  minRadius: integer;
begin
  with acanvas do
  begin
    tmpRect.TopLeft := BtnPoints[0];
    tmpRect.BottomRight := BtnPoints[1];
    if self.Filled then
         aCanvas.Brush.Style:=bsSolid
      else
          aCanvas.Brush.Style:=bsClear;

    if fRounded and (Angle = 0) then //nb: can't 'round' rotated rectangles
    begin
      minRadius := min(BtnPoints[4].X - BtnPoints[2].X, BtnPoints[4].Y - BtnPoints[2].Y) div 2;
      RoundRect(BtnPoints[2].X, BtnPoints[2].Y, BtnPoints[4].X, BtnPoints[4].Y,
        minRadius, minRadius);
    end
    else
      //use polygon for rotation support ...
      Polygon([BtnPoints[2], BtnPoints[3], BtnPoints[4], BtnPoints[5]]);

    if IsShadow or (Strings.Count = 0) then
      exit;
    DrawStringsInRect(aCanvas, strings);
  end;
end;

function TplRectangle.ResizeObjectToFiTText: boolean;
var
  i, w, marg: integer;
  size: TSize;
begin
  Result := False;
  if strings.Count = 0 then
    exit;
  size.cx := 0;
  size.cy := bitmap.canvas.TextHeight('Yy') * Strings.Count;
  for i := 0 to Strings.Count - 1 do
  begin
    w := bitmap.canvas.TextWidth(Strings[i]);
    if w > size.cx then
      size.cx := w;
  end;
  marg := (Margin + (Pen.Width div 2) + 1 + Padding);
  SetBounds(left, top, size.cx + marg * 2, size.cy + marg * 2);
  Result := True;
end;

procedure TplRectangle.SaveToPropStrings;
begin
  inherited;
  AddToPropStrings('Centered', GetEnumProp(self, 'Centered'));
  if Rounded then
    AddToPropStrings('Rounded', GetEnumProp(self, 'Rounded'));
end;

// ================ TObjecTplText ===========================

constructor TplText.Create(AOwner: TComponent);
begin
  inherited;
  Padding := 0;
  ShadowSize := -1;
  DoSaveInfo;
  CanConnect := False;
end;

function TplText.GetStrings: TStrings;
begin
  Result := inherited Strings;
end;

procedure TplText.SetStrings(astrings: TStrings);
begin
  inherited Strings := astrings;
  ResizeObjectToFiTText;
end;

procedure TplText.DrawObject(aCanvas: TbgraCanvas; IsShadow: boolean);
var
  SavedColor: TColor;
  stringsToParse: TStrings;
begin
  if (Strings.Count = 0) then
    stringsToParse := dummyStrings
  else
    stringsToParse := Strings;

  acanvas.Brush.Style := bsClear;
  with acanvas do
  begin
    if IsShadow then
    begin
      SavedColor := Font.Color;
      Font.Color := ColorShadow;
      DrawStringsInRect(aCanvas, stringsToParse);
      Font.Color := SavedColor;
    end
    else
      DrawStringsInRect(aCanvas, stringsToParse);
  end;
end;

// =================== TplEllipse methods ==============================

constructor TplEllipse.Create(AOwner: TComponent);
begin
  inherited;
  InternalSetCount(15);
  SeTplBezierButtons;
  showLeftDimension:=False;
  showTopDimension:=False;
  DoSaveInfo;
end;

function TplEllipse.ClosestScreenPt(FromScreenPt: TPoint): TPoint;
var
  xangle, rotationAngle: single;
  FromPt: TPoint;
begin
  FromPt := ScreenToClient(FromScreenPt);

  if SavedInfo.AngleInDegrees <> 0 then
    rotationAngle := SavedInfo.AngleInDegrees * pi / 180
  else
    rotationAngle := 0;

  xangle := GetAnglePt2FromPt1(ObjectMidpoint, FromPt) + rotationAngle;
  if xangle > PI_Mul2 then
    xangle := xangle - PI_Mul2;

  if GetPtOnEllipseFromAngle((BtnPoints[1].X - BtnPoints[0].X) div 2, (BtnPoints[1].Y - BtnPoints[0].Y) div 2, xangle, Result) then
  begin
    Inc(Result.X, ObjectMidpoint.X);
    Inc(Result.Y, ObjectMidpoint.Y);
    if SavedInfo.AngleInDegrees <> 0 then
      Result := RotatePt(Result, ObjectMidPoint, rotationAngle);
    Result := ClientToScreen(Result);
  end
  else
    Result := ClientToScreen(ObjectMidPoint);
end;

procedure TplEllipse.SetBalloonPoint(BalloonPoint: TBalloonPoint);
begin
  if Angle <> 0 then
    BalloonPoint := bpNone;
  if fBalloonPoint = BalloonPoint then
    exit;
  fBalloonPoint := BalloonPoint;
  UpdateNeeded;
end;

procedure TplEllipse.SetLabelRatioInUnits(AValue: Float);
begin
  if FLabelRatioInUnits=AValue then Exit;
  FLabelRatioInUnits:=AValue;
end;

procedure TplEllipse.SetratioInUnits(AValue: Float);
begin
  //if FratioInUnits=AValue then Exit;
  FratioInUnits:=AValue;
  //fratioForDimensions:=heightInUnits/(height-2*fmarginForDimensions);
  Height:=round(fratioInUnits/ratioForDimensions+2*marginForDimensions);
  Width:=Height;
  self.Loaded;
end;

procedure TplEllipse.SetAngle(aangle: integer);
begin
  if aangle <> 0 then
    BalloonPoint := bpNone;
  inherited;
end;

procedure TplEllipse.SetRegular(Value: boolean);
begin
  if fRegular = Value then
    exit;
  fRegular := Value;
  if not fRegular then
    exit;
  BtnPoints[1].Y := BtnPoints[0].Y + (BtnPoints[1].X - BtnPoints[0].X);

  SavedInfo.AngleInDegrees := 0;
  SeTplBezierButtons;
  ResizeNeeded;
end;

procedure TplEllipse.DrawStringsInEllipse(acanvas: TbgraCanvas; aStrings: TStrings);
var
  rad_horz, rad_vert: integer;
  XPos, YPos, XCenter, YCenter, lineHeight, space, vertSpace, pad: integer;
  ls, rs: string;

  function DoTextOut(DraftOnly: boolean): integer;
  var
    i, startY: integer;
  begin
    startY := YPos;
    for i := 0 to aStrings.Count - 1 do
    begin
      if (YPos + lineHeight + pad >= YCenter + rad_vert) then
        break;
      ls := astrings[i];
      if ls = '' then
        Inc(YPos, lineHeight)
      else
        while (ls <> '') and (YPos + lineHeight + pad < YCenter + rad_vert) do
        begin
          if YCenter > YPos then
          begin
            if not GeTplEllipseXValFromYVal(rad_horz, rad_vert, YCenter - YPos, XPos) then
              break;
          end
          else
          if not GeTplEllipseXValFromYVal(rad_horz, rad_vert, YPos + lineHeight - YCenter, XPos) then
            break;
          space := (XPos - pad) * 2;
          TrimLine(aCanvas, ls, rs, space);
          if ls = '' then
            break;
          if not DraftOnly then
            with aCanvas do
              if Angle = 0 then
                TextOut(XCenter - textwidth(ls) div 2, Ypos, ls)
              else
                RotatedTextAtPt(aCanvas, XCenter - textwidth(ls) div 2, Ypos, ls);
          Inc(YPos, lineHeight);
          ls := rs;
        end;
    end;
    Result := YPos - StartY;
  end;

  function CalcVertSpace: integer;
  var
    i, cnt: integer;
  begin
    Result := 0;
    cnt := 0;
    YPos := YCenter - lineHeight div 2;
    for i := 0 to aStrings.Count - 1 do
    begin
      if (YPos + lineHeight + pad >= YCenter + rad_vert) then
        break;
      ls := aStrings[i];
      if (ls = '') then
      begin
        Inc(cnt);
        if odd(cnt) then
          Inc(Ypos, lineheight);
        Inc(Result, lineheight);
      end
      else
        while (ls <> '') and (YPos + lineHeight + pad < YCenter + rad_vert) do
        begin
          if not GeTplEllipseXValFromYVal(rad_horz, rad_vert, YPos + lineHeight - YCenter, XPos) then
            break;
          space := (XPos - pad) * 2;
          TrimLine(aCanvas, ls, rs, space);
          ls := rs;
          Inc(cnt);
          if odd(cnt) then
            Inc(YPos, lineHeight);
          Inc(Result, lineheight);
        end;
    end;
  end;

begin
  with aCanvas do
  begin
    lineHeight := TextHeight('Yy');
    rad_horz := (BtnPoints[1].X - BtnPoints[0].X) div 2;
    rad_vert := (BtnPoints[1].Y - BtnPoints[0].Y) div 2;
    XCenter := BtnPoints[0].X + rad_horz;
    YCenter := BtnPoints[0].Y + rad_vert;
    pad := padding + (Pen.Width div 2);
    if odd(Pen.Width) then
      Inc(pad);
    vertSpace := CalcVertSpace;
    YPos := YCenter - vertSpace div 2;
    vertSpace := DoTextOut(True);
    YPos := YCenter - vertSpace div 2;
    DoTextOut(False);
  end;
end;


procedure TplEllipse.DrawObject(aCanvas: TbgraCanvas; IsShadow: boolean);

var
  pt1, pt2, pt3: TPoint;
  dx, dy: integer;
  SavedClr: TColor;
  IsValidPoints: boolean;

  //Get2PtsOnEllipse: helper function for Balloon extention drawing.
  //Since the balloon tip is in one corner, from that corner (pt1) find the
  //intersection pts (pt2 & pt3) of 2 lines and the ellipse where each line is
  //either 1/8 distance vertically or 1/8 distance horizontally from that
  //corner and passes through the elliptical center ...
  function Get2PtsOnEllipse(wPt, hPt: TPoint): boolean;
  var
    angle1, angle2: single;
    mp: TPoint;
  begin
    mp := Point((BtnPoints[0].X + BtnPoints[1].X) div 2, (BtnPoints[0].Y + BtnPoints[1].Y) div 2);
    angle1 := GetAnglePt2FromPt1(mp, hPt);
    angle2 := GetAnglePt2FromPt1(mp, wPt);
    Result :=
      GetPtOnEllipseFromAngle((BtnPoints[1].X - BtnPoints[0].X) div 2, (BtnPoints[1].Y - BtnPoints[0].Y) div 2, angle1, pt2) and
      GetPtOnEllipseFromAngle((BtnPoints[1].X - BtnPoints[0].X) div 2, (BtnPoints[1].Y - BtnPoints[0].Y) div 2, angle2, pt3);
    with mp do
      OffsetPt(pt2, X, Y);
    with mp do
      OffsetPt(pt3, X, Y);
  end;

  procedure DrawBalloonExtension;
  begin
    case fBalloonPoint of
      bpTopLeft:
      begin
        IsValidPoints := Get2PtsOnEllipse(Point(BtnPoints[0].X + round(Width * 1 / 8), BtnPoints[0].Y),
          Point(BtnPoints[0].X, BtnPoints[0].Y + round(Height * 1 / 8)));
        pt1 := BtnPoints[0];
        dx := 1;
        dy := 1;
      end;
      bpTopRight:
      begin
        IsValidPoints := Get2PtsOnEllipse(Point(BtnPoints[1].X - round(Width * 1 / 8), BtnPoints[0].Y),
          Point(BtnPoints[1].X, BtnPoints[0].Y + round(Height * 1 / 8)));
        pt1 := Point(BtnPoints[1].X, BtnPoints[0].Y);
        dx := -1;
        dy := 1;
      end;
      bpBottomLeft:
      begin
        IsValidPoints := Get2PtsOnEllipse(Point(BtnPoints[0].X + round(Width * 1 / 8), BtnPoints[1].Y),
          Point(BtnPoints[0].X, BtnPoints[1].Y - round(Height * 1 / 8)));
        pt1 := Point(BtnPoints[0].X, BtnPoints[1].Y);
        dx := 1;
        dy := -1;
      end;
      else
      begin
        IsValidPoints := Get2PtsOnEllipse(Point(BtnPoints[1].X - round(Width * 1 / 8), BtnPoints[1].Y),
          Point(BtnPoints[1].X, BtnPoints[1].Y - round(Height * 1 / 8)));
        pt1 := BtnPoints[1];
        dx := -1;
        dy := -1;
      end;
    end;
    if IsValidPoints then
      with acanvas do
      begin
        if not IsShadow then
        begin
          SavedClr := pen.Color;
          pen.Color := brush.Color;
          offsetPt(pt2, dx, dy);
          offsetPt(pt3, dx, dy);
          polygon([pt1, pt2, pt3]);
          pen.Color := SavedClr;
        end;
        MoveTo(Pt2.X, Pt2.Y);
        LineTo(Pt1.X, Pt1.Y);
        LineTo(Pt3.X, Pt3.Y);
      end;
  end;

begin

  with acanvas do
  begin
    if self.Filled then
         aCanvas.Brush.Style:=bsSolid
      else
          aCanvas.Brush.Style:=bsClear;
    if SavedInfo.AngleInDegrees <> 0 then
    begin
      { TODO -oTC -cLazarus_Port_Step2 : function BeginPath needs to be ported! }
      { TODO -oTC -cLazarus_Test : Add test case to check PolyBezier for rotated ellipses. }
      //TCQ
      //beginPath(Handle);
      PolyBezier([BtnPoints[2], BtnPoints[3], BtnPoints[4], BtnPoints[5], BtnPoints[6], BtnPoints[7], BtnPoints[8], BtnPoints[9], BtnPoints[10],
        BtnPoints[11], BtnPoints[12], BtnPoints[13], BtnPoints[14]]);
      //EndPath(Handle);
      //if Brush.Style = bsClear then
        //StrokePath(Handle) else
      //  StrokeAndFillPath(Handle);
    end
    else
    begin
      ellipse(BtnPoints[0].X, BtnPoints[0].Y, BtnPoints[1].X, BtnPoints[1].Y);
      if (fBalloonPoint <> bpNone) then
        DrawBalloonExtension;
    end;
    if IsShadow or (Strings.Count = 0) then
      exit;
    DrawStringsInEllipse(aCanvas, Strings);
  end;

end;

procedure TplEllipse.drawSpecialDimensions(targetCanvas: TbgraCanvas);
var
   radius : Integer;
   pointOnCircle,point1,point2,point3,pointForText:TPoint;
   a2,b2,c2 : Real;
   lineVector:Tpoint;
   distance, textPosition: Integer;
   dimensionText: String;

  procedure drawMarker(point1,lineVector:Tpoint;markLen:Byte);
  var
    point1Marker2: Tpoint;
    point1Marker1: Tpoint;
    c1: Real;
    b1: Real;
    a1: Real;
  begin
    markLen:=markLen div 2;
    // standard equation of line in point1 perpendicular to lineVector
    c1:=-1*(lineVector.x*point1.x + lineVector.y*point1.y);
    a1:=-1*(lineVector.y*point1.y + c1)/point1.x;
    b1:=-1*(a1*point1.x+c1)/point1.y;
    point1Marker1:=Point(point1.x-markLen,round(-1*(a1*(point1.x-markLen)+c1)/b1));
    point1Marker2:=Point(point1.x+markLen,round(-1*(a1*(point1.x+markLen)+c1)/b1));
    targetCanvas.moveTo(point1Marker1);
    targetCanvas.LineTo(point1Marker2);
  end;

  function pointsOnCircle(radius:integer): TPoint;
  begin
    Result:=Point(round(radius*cos(PI_Mul7_Div4)),
                  round(radius*sin(PI_Mul7_Div4)));
  end;

begin
  if not showSpecialDimensions then exit;
  //inherited drawSpecialDimensions(targetCanvas);
  radius:= ((height-2*marginForDimensions) div 2) ;
  pointOnCircle:=pointsOnCircle(radius);
  point1:= self.ClientRect.CenterPoint - pointOnCircle;
  point2:= self.ClientRect.CenterPoint + pointOnCircle;
  radius:= radius + 75;
  point3:= self.ClientRect.CenterPoint+pointsOnCircle(radius);
  targetCanvas.moveTo(point1);
  targetCanvas.LineTo(point3);
  // lineVector is normalVector of line determinited by Poin1,point2
  lineVector:= point2 - point1;
  drawMarker(point1,lineVector,20);
  drawMarker(point2,lineVector,20);
  // draw text
  distance:=(height-2*marginForDimensions); //round(point1.Distance(point2));
  fRatioInUnits:=distance*self.ratioForDimensions;
  if custSpecialDimension <> 0 then
      dimensionText:=FloatToStrF(custSpecialDimension,ffFixed,4,1)
  else
   begin
      dimensionText:= UnicodeToUTF8(8960)+FloatToStrF(
                                           distance*self.ratioForDimensions,ffFixed,4,1);
   end;
  if not self.zooming then
                FLabelRatioInUnits:=StrToFloat(FloatToStrF(
                                          distance*self.ratioForDimensions,ffFixed,4,1));
  textPosition:= (75 - targetCanvas.TextWidth(dimensionText)) div 2;
  pointForText:=point2 + pointsOnCircle(textPosition);
  targetCanvas.Font.Height:=(marginForDimensions div 2);
  targetCanvas.Font.Name:='DejaVu Sans Condensed';
  targetCanvas.Brush.Style:=bsClear;
  targetCanvas.Font.Orientation:=450;
  targetCanvas.TextOut(pointForText.x - 20,pointForText.y - 20,dimensionText);
end;


function TplEllipse.ResizeObjectToFiTText: boolean;
var
  i, w, marg: integer;
  size: TSize;
begin
  size.cx := 0;
  size.cy := bitmap.CanvasBGRA.TextHeight('Yy') * (Strings.Count + 1);
  for i := 0 to Strings.Count - 1 do
  begin
    w := bitmap.CanvasBGRA.TextWidth(Strings[i]);
    if w > size.cx then
      size.cx := w;
  end;
  marg := (Margin + (Pen.Width div 2) + 1 + Padding);
  //nb: sqrt(2) ~= 1.42 (theoretical space required)
  SetBounds(left, top, round(size.cx * 1.42) + marg * 2, round(size.cy * 1.42) + marg * 2);
  Result := True;
end;


procedure TplEllipse.InternalBtnMove(BtnIdx: integer; NewPt: TPoint);
begin
  if fRegular then
  begin
    if BtnIdx = 0 then
    begin
      BtnPoints[0].X := NewPt.X;
      BtnPoints[0].Y := BtnPoints[1].Y - (BtnPoints[1].X - NewPt.X);
    end
    else
    begin
      BtnPoints[1].X := NewPt.X;
      BtnPoints[1].Y := BtnPoints[0].Y + (NewPt.X - BtnPoints[0].X);
    end;
    ResizeNeeded;
  end
  else
    inherited;

  SeTplBezierButtons;
end;


procedure TplEllipse.SeTplBezierButtons;
const
  xoffset: single = 0.27614237; //  2/3*(sqrt(2)-1)
var
  midx, midy, offx, offy: integer;
  rec: TRect;
begin

  rec := Rect(BtnPoints[0].X, BtnPoints[0].Y, BtnPoints[1].X - 1, BtnPoints[1].Y - 1);
  with rec do
  begin
    midx := (right - left) div 2 + left;
    midy := (bottom - top) div 2 + top;
    offx := round((right - left) * xoffset);
    offy := round((bottom - top) * xoffset);
    BtnPoints[2] := Point(left, midy);
    BtnPoints[3] := Point(left, midy - offy);
    BtnPoints[4] := Point(midx - offx, top);
    BtnPoints[5] := Point(midx, top);
    BtnPoints[6] := Point(midx + offx, top);
    BtnPoints[7] := Point(right, midy - offy);
    BtnPoints[8] := Point(right, midy);
    BtnPoints[9] := Point(right, midy + offy);
    BtnPoints[10] := Point(midx + offx, bottom);
    BtnPoints[11] := Point(midx, bottom);
    BtnPoints[12] := Point(midx - offx, bottom);
    BtnPoints[13] := Point(left, midy + offy);
    BtnPoints[14] := BtnPoints[2];

    if SavedInfo.AngleInDegrees <> 0 then
      RotatePts(BtnPoints, 2, Point(midx, midy), SavedInfo.AngleInDegrees * pi / 180);
  end;
end;

procedure TplEllipse.Rotate(degrees: integer);
begin
  if fRegular then
    exit;
  inherited;
  SeTplBezierButtons;
end;

procedure TplEllipse.SetoutsideObject(AValue: TplDrawObject);
begin
  inherited SetoutsideObject(AValue);
  showRightDimension:=False;
  showBottomDimension:=False;
end;

procedure TplEllipse.SaveToPropStrings;
begin
  inherited;
  AddToPropStrings('BalloonPoint', GetEnumProp(self, 'BalloonPoint'));
  if Regular then
    AddToPropStrings('Regular', GetEnumProp(self, 'Regular'));
  AddToPropStrings('ratioInUnits', FloatToStr(ratioInUnits));
end;

// ================= TplPolygon =====================================

constructor TplPolygon.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  InternalSetCount(5);
  InitializePoints;
end;

procedure TplPolygon.DrawObject(aCanvas: TbgraCanvas; IsShadow: boolean);

begin
  if self.Filled then
         aCanvas.Brush.Style:=bsSolid
      else
          aCanvas.Brush.Style:=bsClear;
  aCanvas.Polygon(BtnPoints);
end;


function TplPolygon.ClosestScreenPt(FromScreenPt: TPoint): TPoint;
var
  i, bestBtnIdx, dist, dist2: integer;
  FromPt: TPoint;
begin
  FromPt := ScreenToClient(FromScreenPt);
  dist := SquaredDistBetweenPoints(FromPt, BtnPoints[0]);
  bestBtnIdx := 0;
  for i := 1 to ButtonCount - 1 do
  begin
    dist2 := SquaredDistBetweenPoints(FromPt, BtnPoints[i]);
    if dist2 < dist then
    begin
      dist := dist2;
      bestBtnIdx := i;
    end;
  end;
  Result := ClientToScreen(BtnPoints[bestBtnIdx]);
end;

procedure TplPolygon.InitializePoints;
var
  radius: integer;
begin
  radius := min(Width, Height) div 2 - Margin;
  SetPointsAroundCircle(ObjectMidPoint, radius, ButtonCount, BtnPoints);
  DoSaveInfo;
end;

function TplPolygon.GetButtonCount: integer;
begin
  Result := inherited ButtonCount;
end;

procedure TplPolygon.SetButtonCount(Count: integer);
begin
  if (Count < 3) then
    exit;
  InternalSetCount(Count);
  InitializePoints;
  ResizeNeeded;
end;

procedure TplPolygon.DuplicateButton(btnIdx: integer);
var
  i: integer;
begin
  if (btnIdx < 0) then
    btnIdx := 0
  else if (btnIdx >= ButtonCount) then
    btnIdx := ButtonCount - 1;
  InternalSetCount(ButtonCount + 1);
  for i := ButtonCount - 1 downto btnIdx + 1 do
    BtnPoints[i] := BtnPoints[i - 1];
  OffsetPt(BtnPoints[btnIdx], -1, -1);
  OffsetPt(BtnPoints[btnIdx + 1], 1, 1);
  ResizeNeeded;
end;

procedure TplPolygon.RemoveButton(btnIdx: integer);
var
  i: integer;
begin
  if ButtonCount < 4 then
    exit;
  if (btnIdx < 0) then
    btnIdx := 0
  else if (btnIdx >= ButtonCount) then
    btnIdx := ButtonCount - 1;

  for i := btnIdx to ButtonCount - 2 do
    BtnPoints[i] := BtnPoints[i + 1];
  InternalSetCount(ButtonCount - 1);
  ResizeNeeded;
end;

procedure TplPolygon.Mirror;
var
  i: integer;
begin
  for i := 0 to ButtonCount - 1 do
    BtnPoints[i].X := Width - BtnPoints[i].X;
  ResizeNeeded;
end;

procedure TplPolygon.Flip;
var
  i: integer;
begin
  for i := 0 to ButtonCount - 1 do
    BtnPoints[i].Y := Height - BtnPoints[i].Y;
  ResizeNeeded;
end;

procedure TplPolygon.SetPlainPoly(isPlainPoly: boolean);
begin
  if fPlainPoly = isPlainPoly then
    exit;
  fPlainPoly := isPlainPoly;
  if not fPlainPoly then
    exit;
  InitializePoints;
  ResizeNeeded;
end;

procedure TplPolygon.InternalBtnMove(BtnIdx: integer; NewPt: TPoint);
var
  radius: integer;
  mp: TPoint;
  rec: TRect;
begin
  if Regular then
  begin
    mp := ObjectMidPoint;
    radius := round(SQRT(SquaredDistBetweenPoints(mp, NewPt)));
    SetPointsAroundCircle(mp, radius, ButtonCount, BtnPoints);

    //ResizeNeeded() only works for even numbered ButtonCounts
    //otherwise ObjectMidPoint moves and causes havoc...
    if odd(ButtonCount) then
    begin
      with rec do
      begin
        Right := (radius + Margin) * 2;
        Bottom := Right;
        left := self.Left + mp.X - (radius + Margin);
        Top := self.Top + mp.Y - (radius + Margin);
        Bitmap.SetSize(right,Bottom);
        BlockResize := True; //blocks scaling while resizing Bitmap
        try
          self.setBounds(Left, Top, Right, Bottom);
        finally
          BlockResize := False;
        end;
      end;
      UpdateNeeded;
    end
    else
      ResizeNeeded;
  end
  else
    inherited;
end;

function TplPolygon.IsValidBtnDown(BtnIdx: integer): boolean;
begin
  Result := not Regular;
end;

procedure TplPolygon.SaveToPropStrings;
begin
  inherited;
  if Regular then
    AddToPropStrings('Regular', GetEnumProp(self, 'Regular'));
end;

// =========== TplSolidArrow =================================

constructor TplSolidArrow.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  InternalSetCount(7);
  BtnPoints[0] := Point(Width - Margin, Height div 2);
  BtnPoints[1] := Point(Margin + (Width - Margin * 2) div 5, Margin);
  BtnPoints[2] := Point(BtnPoints[1].X, Margin + (Height - Margin * 2) div 3);
  BtnPoints[3] := Point(Margin, BtnPoints[2].Y);
  BtnPoints[4] := Point(Margin, Margin + (Height - Margin * 2) * 2 div 3);
  BtnPoints[5] := Point(BtnPoints[1].X, BtnPoints[4].Y);
  BtnPoints[6] := Point(BtnPoints[1].X, Height - Margin);
  DoSaveInfo;
end;

procedure TplSolidArrow.DrawObject(aCanvas: TbgraCanvas; IsShadow: boolean);
begin
  if self.Filled then
         aCanvas.Brush.Style:=bsSolid
      else
          aCanvas.Brush.Style:=bsClear;
  aCanvas.Polygon(BtnPoints);
end;

procedure TplSolidArrow.InternalBtnMove(BtnIdx: integer; NewPt: TPoint);
//.............................................
  procedure AlignPt1;
  begin
    if (NewPt.Y >= BtnPoints[0].Y) then
      NewPt.Y := BtnPoints[0].Y - 1;
    BtnPoints[6].Y := 2 * BtnPoints[0].Y - BtnPoints[1].Y;
  end;

  procedure AlignPt6;
  begin
    if (NewPt.Y <= BtnPoints[0].Y) then
      NewPt.Y := BtnPoints[0].Y + 1;
    BtnPoints[1].Y := 2 * BtnPoints[0].Y - BtnPoints[6].Y;
  end;

  procedure AlignArrowHorz;
  begin
    BtnPoints[1].X := NewPt.X;
    BtnPoints[2].X := NewPt.X;
    BtnPoints[5].X := NewPt.X;
    BtnPoints[6].X := NewPt.X;
  end;

  procedure AlignTailTop;
  begin
    if (NewPt.Y >= BtnPoints[0].Y) then
      NewPt.Y := BtnPoints[0].Y - 1;
    BtnPoints[2].Y := NewPt.Y;
    BtnPoints[3].Y := NewPt.Y;
    BtnPoints[4].Y := 2 * BtnPoints[0].Y - BtnPoints[2].Y;
    BtnPoints[5].Y := BtnPoints[4].Y;
  end;

  procedure AlignTailBottom;
  begin
    if (NewPt.Y <= BtnPoints[0].Y) then
      NewPt.Y := BtnPoints[0].Y + 1;
    BtnPoints[4].Y := NewPt.Y;
    BtnPoints[5].Y := NewPt.Y;
    BtnPoints[2].Y := 2 * BtnPoints[0].Y - BtnPoints[4].Y;
    BtnPoints[3].Y := BtnPoints[2].Y;
  end;

  procedure AlignTail;
  begin
    BtnPoints[3].X := NewPt.X;
    BtnPoints[4].X := NewPt.X;
  end;
  //.............................................
begin
  if fWasRotated then
  begin
    inherited;
    exit;
  end;
  case BtnIdx of
    0: NewPt.Y := BtnPoints[0].Y;
    1:
    begin
      AlignPt1;
      AlignArrowHorz;
    end;
    2:
    begin
      AlignArrowHorz;
      AlignTailTop;
    end;
    3:
    begin
      AlignTailTop;
      AlignTail;
    end;
    4:
    begin
      AlignTailBottom;
      AlignTail;
    end;
    5:
    begin
      AlignArrowHorz;
      AlignTailBottom;
    end;
    6:
    begin
      AlignPt6;
      AlignArrowHorz;
    end;
  end;
  inherited InternalBtnMove(BtnIdx, NewPt);
end;


procedure TplSolidArrow.Rotate(degrees: integer);
begin
  inherited Rotate(degrees);
  fWasRotated := True;
end;


//=================== TplRandomPoly =======================

procedure TplRandomPoly.Randomize;
begin
  InitializePoints;
  UpdateNeeded;
end;

procedure TplRandomPoly.InitializePoints;
var
  i: integer;
begin
  for i := 0 to ButtonCount - 1 do
    BtnPoints[i] := Point(system.Random(Width - Margin * 2) + Margin, system.Random(Height - Margin * 2) + Margin);
  DoSaveInfo;
end;

procedure TplRandomPoly.SetButtonCount(Count: integer);
begin
  if (Count < 3) then
    Count := 3;
  if Count = ButtonCount then
    exit;
  InternalSetCount(Count);
  InitializePoints;
  UpdateNeeded;
end;

// =============== TplStar ============================

constructor TplStar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  InternalSetCount(18); //nb: NOT similarly named new SetButtonCount() method
  InitializePoints;
end;

procedure TplStar.DuplicateButton(btnIdx: integer);
begin
  //do nothing
end;

procedure TplStar.RemoveButton(btnIdx: integer);
begin
  //do nothing
end;

procedure TplStar.SetButtonCount(Count: integer);
begin
  if (Count < 10) then
    Count := 10
  else if odd(Count) then
    Dec(Count);
  if Count = ButtonCount then
    exit;
  InternalSetCount(Count);
  InitializePoints;
  UpdateNeeded;
end;

procedure TplStar.InitializePoints;
var
  i: integer;
  radius: integer;
  innerCirc: array of TPoint;
begin
  radius := min(Width, Height) div 2 - Margin;
  SetPointsAroundCircle(ObjectMidPoint, radius, ButtonCount, BtnPoints);
  radius := min(Width, Height) div 4 - Margin;
  setLength(innerCirc, ButtonCount div 2);
  SetPointsAroundCircle(ObjectMidpoint, radius, ButtonCount div 2, innerCirc);
  for i := 0 to (ButtonCount div 2) - 1 do
    BtnPoints[i * 2] := innerCirc[i];
  DoSaveInfo;
end;

procedure TplStar.SetBoringStar(BoringStar: boolean);
begin
  if fBoringStar = BoringStar then
    exit;
  fBoringStar := BoringStar;
  if fBoringStar then
    InitializePoints;
  UpdateNeeded;
end;

procedure TplStar.SetPointsAroundCirc(StartPtIdx: integer; NewPt: TPoint);
var
  i, radius: integer;
  angle_increment, angle_offset: single;
  mp: TPoint;
  tmpPts: array of TPoint;
begin
  mp := ScreenToClient(fMidPtInScreenCoords);
  if PointsEqual(NewPt, mp) then
    exit;
  radius := round(sqrt(SquaredDistBetweenPoints(NewPt, mp)));

  if fBoringStar then
  begin
    setLength(tmpPts, ButtonCount);
    SetPointsAroundCircle(ScreenToClient(fMidPtInScreenCoords),
      radius, ButtonCount, tmpPts);
    if Odd(StartPtIdx) then
      for i := 0 to (ButtonCount div 2) - 1 do
        BtnPoints[i * 2 + 1] := tmpPts[i * 2 + 1]
    else
      for i := 0 to (ButtonCount div 2) - 1 do
        BtnPoints[i * 2] := tmpPts[i * 2];
  end
  else
  begin
    angle_increment := PI_Mul2 / ButtonCount;
    angle_offset := GetAnglePt2FromPt1(mp, NewPt) - angle_increment * StartPtIdx;
    if odd(StartPtIdx) then
      i := 1
    else
      i := 0;
    while i < ButtonCount do
    begin
      BtnPoints[i] := GetPtOnCircleFromAngle(radius, i * angle_increment + angle_offset);
      OffsetPt(BtnPoints[i], mp.X, mp.Y);
      Inc(i, 2);
    end;
  end;
end;

procedure TplStar.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  inherited;
  fMidPtInScreenCoords := ClientToScreen(ObjectMidPoint);
end;

procedure TplStar.InternalBtnMove(BtnIdx: integer; NewPt: TPoint);
begin
  SetPointsAroundCirc(BtnIdx, NewPt);
  ResizeNeeded;
end;


initialization
  RegisterDrawObjClasses;

finalization
  FreeAndNil(fDummyStrings);

end.
