{**********************************************************************
 Package pl_Shapes.pkg
 This unit is part of CodeTyphon Studio (http://www.pilotlogic.com/)
***********************************************************************}

unit TplShapeObjectsBase;

interface

uses
  SysUtils, Classes, LMessages, Controls, Graphics, Math,
  Forms, TypInfo, ZLib,BGRABitmap,BGRACanvas,BGRAGraphicControl,BGRABitmapTypes,
  Dialogs;

const

  HITTESTSENSITIVITY = 2;

  MAX_SHADOW_SIZE = 50;
  FOCUSED_DESIGN_COLOR = clRed;
  FOCUSED_DESIGN_COLOR2 = clGreen;
  MARGIN_FOR_DIMENSIONS = 45;


  PI_Div4 = pi / 4;
  PI_Div2 = pi / 2;
  PI_Mul3_Div4 = pi * 3 / 4;
  PI_Mul5_Div4 = pi * 5 / 4;
  PI_Mul3_Div2 = pi * 3 / 2;
  PI_Mul7_Div4 = pi * 7 / 4;
  PI_Mul2 = pi * 2;

  CRLF: array [0..1] of char = #13#10;

type
  TBalloonPoint = (bpNone, bpTopLeft, bpTopRight, bpBottomLeft, bpBottomRight);
  TOrientation = (oHorizontal, oVertical);
  TQuadConnection = (qcLeft, qcTop, qcRight, qcBottom);

  TSavedSizeInfo = record
    SavedLeft: integer;
    SavedTop: integer;
    SavedWidth: integer;
    SavedHeight: integer;
    SavedPts: array of TPoint;

    isTransforming: boolean; //see Zoom & Rotate
    AngleInDegrees: integer;
    ZoomAsPercent: integer;  //also amalgamate this with TArc's fCurrRotAngle.
    RotateScreenPt: TPoint;
  end;

  TplDrawObjectClass = class of TplDrawObject;
  TplDrawObject = class;

  PObjPropInfo = ^TObjPropInfo;

  TObjPropInfo = record
    fOwner: TplDrawObject;
    fProperty: string;
    fPropVal: string;
  end;

  TPenEx = class(TPen)
    property Width default 2;
  end;

  TCMDesignHitTest = TLMMouse;


  { TplDrawObject }

  TplDrawObject = class(TbgraGraphicControl)                // TGraphicControl
  private
    fBitmap: TBGRABitmap;
    FEnableDrawDimensions: Boolean;
    fmarginForDimensions : Integer;
    finsideObject: TplDrawObject;
    FoutsideObject: TplDrawObject;
    fPen: TPenEx;
    fPropStrings: TStrings;
    fBtnCount: integer;
    fMargin: integer;
    fBtnSize: integer;
    fFocused: boolean;
    fCanFocus: boolean;
    fShadowSize: integer;
    fColorShadow: TColor;
    fDistinctiveLastBtn: boolean;
    fPressedBtnIdx: integer;
    fUseHitTest: boolean;
    fDblClickPressed: boolean;
    fBlockResize: boolean;
    fUpdateNeeded, fReSizeNeeded: boolean;
    fMoving: boolean;
    fMovingPt: TPoint;
    fStreamID: string;
    fDataStream: TMemoryStream;
    fFocusChangedEvent: TNotifyEvent;
    procedure SetEnableDrawDimensions(AValue: Boolean);
    procedure SetinsideObject(AValue: TplDrawObject);
    procedure SetoutsideObject(AValue: TplDrawObject);
    procedure WriteBtnData(S: TStream);
    procedure WriteData(S: TStream);
    procedure ReadBtnData(S: TStream);
    procedure ReadData(S: TStream);
    procedure GetBinaryData(var lineIdx: integer); //loads binary data
    procedure SetPen(Value: TPenEx);
    procedure PenOnChange(Sender: TObject);
    procedure SetCanFocus(CanFocus: boolean);
    procedure SetFocused(Focused: boolean);
    procedure SetBtnSize(size: integer);
    procedure SetShadowSize(size: integer);
    procedure SetColorShadow(aColor: TColor);
    function GetColor: TColor;
    function GetBitmap: TbgraBitmap;
    procedure PrepareBitmap; virtual;
    procedure FontChanged(Sender: TObject); override;
  protected

    SavedInfo: TSavedSizeInfo;
    procedure SetColor(aColor: TColor); virtual;
    procedure OffsetBtns(x, y: integer);
    procedure InternalSetCount(Count: integer);
    procedure DefineProperties(Filer: TFiler); override;
    procedure ResizeNeeded; virtual;
    procedure UpdateNeeded; virtual;
    procedure Paint; override;
    procedure Resize; override;
    procedure Loaded; override;
    procedure CalcMargin; virtual;
    procedure DoSaveInfo; virtual;
    function GetCanMove: boolean; virtual;
    procedure SetUseHitTest(Value: boolean); virtual;
    procedure DrawBtn(BtnPt: TPoint; index: integer; Pressed, LastBtn: boolean); virtual;
    procedure InternalResize;
    procedure CMHitTest(var Message: TCMHittest); message CM_HITTEST;
    procedure DrawControlLines; virtual;
    procedure WMEraseBkgnd(var Message: TLMEraseBkgnd); message LM_ERASEBKGND;
    procedure CMDesignHitTest(var Message: TCMDesignHitTest); message CM_DESIGNHITTEST;
    procedure DblClick; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: integer); override;
    function IsValidBtnDown(BtnIdx: integer): boolean; virtual;
    procedure MouseMove(Shift: TShiftState; X, Y: integer); override;
    function IsValidBtnMove(BtnIdx: integer; NewPt: TPoint): boolean; virtual;
    procedure InternalBtnMove(BtnIdx: integer; NewPt: TPoint); virtual;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: integer); override;
    procedure LoadFromPropStrings;
    procedure BinaryDataLoaded; virtual;
    procedure SaveToPropStrings; virtual;
    procedure AddToPropStrings(const PropName, PropVal: string);
    property BlockResize: boolean read fBlockResize write fBlockResize;
    property DataStream: TMemoryStream read fDataStream write fDataStream;
    property DistinctiveLastBtn: boolean read fDistinctiveLastBtn write fDistinctiveLastBtn;
    property PropStrings: TStrings read fPropStrings;
  public
    BtnPoints: array of TPoint;  // by zbyna
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DrawObject(aCanvas: TbgraCanvas; IsShadow: boolean); virtual;
    procedure Draw(targetCanvas: TbgraCanvas; offsetX, offsetY: integer);
    procedure DrawOwnDimensions(targetCanvas:TBgraCanvas); virtuaL;
    procedure drawLineWithDimension(targetCanvas: TBGRACanvas;b1,b2:TPoint;kam,
                                                  markerThickness: integer;
                                                  enableMarginForDimensions:Boolean);
    function Clone: TplDrawObject;
    function BtnIdxFromPt(pt: TPoint; ignoreDisabled: boolean; out BtnIdx: integer): boolean;
    function ObjectMidPoint: TPoint;
    function PointOverObject(ScreenPt: TPoint): boolean; virtual;
    function MoveBtnTo(BtnIdx: integer; screenPt: TPoint): boolean;
    procedure BeginTransform; virtual;
    procedure EndTransform; virtual;
    procedure Rotate(degrees: integer); virtual; //(0..360)
    procedure Zoom(percent: integer); virtual;
    property ButtonCount: integer read fBtnCount;
    property PressedBtnIdx: integer read fPressedBtnIdx;
    property Bitmap: TbgraBitmap read GetBitmap;
    property CanMove: boolean read GetCanMove;
    property Margin: integer read fMargin write fMargin;
    property marginForDimensions : integer read fmarginForDimensions write fmarginForDimensions;
    property Moving: boolean read fMoving;
  published
    property insideObject : TplDrawObject read FinsideObject write SetinsideObject;
    property outsideObject : TplDrawObject read FoutsideObject write SetoutsideObject;
    property EnableDrawDimensions :Boolean read FEnableDrawDimensions write SetEnableDrawDimensions;
    property ButtonSize: integer read fBtnSize write SetBtnSize;
    property Color read GetColor write SetColor;
    property ColorShadow: TColor read fColorShadow write SetColorShadow;
    property CanFocus: boolean read fCanFocus write SetCanFocus;
    property Focused: boolean read fFocused write SetFocused;
    property Pen: TPenEx read fPen write SetPen;
    property ShadowSize: integer read fShadowSize write SetShadowSize;
    property PopupMenu;
    property Tag;
    property UseHitTest: boolean read fUseHitTest write SetUseHitTest;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDblClick;
    property OnContextPopup;
    property FocusChangedEvent: TNotifyEvent read fFocusChangedEvent write fFocusChangedEvent;
  end;

  TplBaseLine = class(TplDrawObject)
  private
    fArrow1: boolean;
    fArrow2: boolean;
    function GetButtonCount: integer;
  protected
    procedure CalcMargin; override;
    procedure SetButtonCount(Count: integer); virtual;
    procedure SetArrow1(Arrow: boolean); virtual;
    procedure SetArrow2(Arrow: boolean); virtual;
    procedure SaveToPropStrings; override;
  public
    constructor Create(AOwner: TComponent); override;
    function Grow(TopEnd: boolean = False): boolean; virtual;
    function Shrink(TopEnd: boolean = False): boolean; virtual;
  published
    property Arrow1: boolean read fArrow1 write SetArrow1;
    property Arrow2: boolean read fArrow2 write SetArrow2;
    property ButtonCount: integer read GetButtonCount write SetButtonCount;
  end;

  TplSolid = class; //forward declaration

  TplConnector = class(TplBaseLine)
  private
    fQuadPtConnect: boolean;
    fOrientation: TOrientation;
    fAutoOrientation: boolean;
    fConnection1: TplSolid;
    fConnection2: TplSolid;
    procedure SetOrientation(orientation: TOrientation);
    procedure SetConnection1(Connection: TplSolid);
    procedure SetConnection2(Connection: TplSolid);
    procedure SetAutoOrientation(Value: boolean);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure UpdateConnectionPoints(MovingConnection: TplSolid); virtual;
    procedure Resize; override;
    function GetCanMove: boolean; override;
    procedure DoQuadPtConnection; virtual;
    procedure UpdateNonEndButtonsAfterBtnMove; virtual;
    function IsValidBtnDown(BtnIdx: integer): boolean; override;
    procedure MouseMove(Shift: TShiftState; X, Y: integer); override;
    procedure SaveToPropStrings; override;
    property QuadPtConnect: boolean read fQuadPtConnect write fQuadPtConnect;
    property Orientation: TOrientation read fOrientation write SetOrientation;
    property AutoOrientation: boolean read fAutoOrientation write SetAutoOrientation;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Rotate(degrees: integer); override;
    function IsConnected: boolean;
  published
    property Connection1: TplSolid read fConnection1 write SetConnection1;
    property Connection2: TplSolid read fConnection2 write SetConnection2;
  end;

  TplConnectorClass = class of TplConnector;

  { TplSolid }

  TplSolid = class(TplDrawObject)
  private
    fCanConnect: boolean;
    fConnectorList: TList;
    fFilled:Boolean;
    procedure RemoveConnector(Connector: TplConnector);
    procedure SetFilled(AValue: boolean);
  protected
    procedure AddConnector(Connector: TplConnector); virtual;
    procedure Resize; override;
    property CanConnect: boolean read fCanConnect write fCanConnect;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ClosestScreenPt(FromScreenPt: TPoint): TPoint; virtual;
    function QuadScreenPt(QuadConnect: TQuadConnection): TPoint; virtual;
    property ConnectorList: TList read fConnectorList;
  published
    property Filled: boolean read fFilled write SetFilled;
  end;

  TplSolidWithText = class(TplSolid)
  private
    fPadding: integer;
    fStrings: TStrings;
    fAction: string;
    procedure SetPadding(padding: integer);
    procedure SetStrings(strings: TStrings);
    procedure StringsOnChange(Sender: TObject);
    function GetAngle: integer;
  protected
    procedure SetAngle(angle: integer); virtual;
    procedure RotatedTextAtPt(aCanvas: TbgraCanvas; x, y: integer; const s: string);
    procedure DrawBtn(BtnPt: TPoint; index: integer; Pressed, LastBtn: boolean); override;
    function IsValidBtnDown(BtnIdx: integer): boolean; override;
    procedure InternalBtnMove(BtnIdx: integer; NewPt: TPoint); override;
    procedure SaveToPropStrings; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Rotate(degrees: integer); override;
    function ResizeObjectToFitText: boolean; virtual;
  published
    property Action: string read fAction write fAction;
    property Angle: integer read GetAngle write SetAngle;
    property Strings: TStrings read fStrings write SetStrings;
    property Padding: integer read fPadding write SetPadding;
    property Font;
    property ParentFont;
  end;

function PtInPolygon(const pts: array of TPoint; pt: TPoint): boolean;
function MidPoint(pt1, pt2: TPoint): TPoint;
procedure OffsetPt(var pt: TPoint; dx, dy: integer);
function RotatePt(pt, origin: TPoint; radians: single): TPoint;
procedure RotatePts(var pts: array of TPoint; startArrayIdx: integer; origin: TPoint; radians: single);
function SquaredDistBetweenPoints(pt1, pt2: TPoint): cardinal;
function IntersectionPoint(Line1a, line1b, Line2a, line2b: TPoint; out IntersectionPt: TPoint): boolean;
function GetAnglePt2FromPt1(pt1, pt2: TPoint): single;
function SlopeLessThanOne(pt1, pt2: TPoint): boolean;
procedure SaveDrawObjectsToStrings(DoList: TList; Strings: TStrings);
procedure LoadDrawObjectsFromStrings(strings: TStrings; Owner: TComponent; Parent: TWinControl; EachDrawObjLoadedEvent: TNotifyEvent);
function MakeNameForControl(ctrl: TControl): boolean;

implementation

uses Types, LCLType;

var
  ObjPropertyList: TList;


// Miscellaneous functions


function ClickPosNearPaintedObject(bmp: TbgraBitmap; X, Y, dist: integer): boolean;
var
  i, j: integer;
  clr: TColor;
begin
  //tests if pos(X,Y) is within 'dist' pixels of the painted object (line) ...
  Result := True;
  with bmp do
  begin
    if  ScanAtInteger(X, Y).alpha = 255 then
      exit;
    if dist > 0 then
    begin
      for i := max(0, X - dist) to min(X + dist, Width - 1) do
        for j := max(0, Y - dist) to min(Y + dist, Height - 1) do
          if ScanAtInteger(i,j).alpha = 255 then
            exit;
    end;
  end;
  Result := False;
end;

function TrimNonPrintChrs(const S: string): string;
var
  i, j: integer;
begin
  i := 1;
  j := Length(S);
  while (j > 0) and (S[j] < ' ') do
    Dec(j);
  while (i < j) and (S[i] < ' ') do
    Inc(i);
  Result := Copy(S, i, j - i + 1);
end;

function PtInPolygon(const pts: array of TPoint; pt: TPoint): boolean;
var
  i, j: integer;
begin
  Result := False;
  j := high(pts);
  for i := low(pts) to high(pts) do
  begin
    if ((pts[i].Y <= pt.Y) and (pt.Y < pts[j].Y)) or ((pts[j].Y <= pt.Y) and (pt.Y < pts[i].Y)) then
      if (pt.X < (pts[j].X - pts[i].X) * (pt.Y - pts[i].Y) / (pts[j].Y - pts[i].Y) + pts[i].X) then
        Result := not Result;
    j := i;
  end;
end;

function InvertColor(color: TColor): TColor;
var
  r, g, b: byte;
begin
  Color := ColorToRGB(color);
  b := (Color shr 16) and $FF;
  g := (Color shr 8) and $FF;
  r := (Color and $FF);
  b := 255 - b;
  g := 255 - g;
  r := 255 - r;
  Result := (b shl 16) or (g shl 8) or r;
end;

function SlopeLessThanOne(pt1, pt2: TPoint): boolean;
begin
  if pt2.X = pt1.X then
    Result := False
  else
    Result := abs((pt2.y - pt1.y) / (pt2.x - pt1.x)) < 1;
end;

function BtnRectFromPt(pt: TPoint; size: integer): TRect;
begin
  Result := Rect(pt.X - size, pt.Y - size, pt.X + size, pt.Y + size);
end;

procedure OffsetPt(var pt: TPoint; dx, dy: integer);
begin
  Inc(pt.X, dx);
  Inc(pt.Y, dy);
end;

function MidPoint(pt1, pt2: TPoint): TPoint;
begin
  Result.X := (pt1.X + pt2.X) div 2;
  Result.Y := (pt1.Y + pt2.Y) div 2;
end;

function RotatePt(pt, origin: TPoint; radians: single): TPoint;
var
  x, y: integer;
  cosAng, sinAng: single;
begin
  cosAng := cos(radians);
  sinAng := sin(radians);
  x := pt.X - origin.X;
  y := pt.Y - origin.Y;
  Result.X := round((x * cosAng) - (y * sinAng)) + origin.X;
  Result.Y := round((x * sinAng) + (y * cosAng)) + origin.Y;
end;

procedure RotatePts(var pts: array of TPoint; startArrayIdx: integer; origin: TPoint; radians: single);
var
  i, x, y: integer;
  cosAng, sinAng: single;
begin
  cosAng := cos(radians);
  sinAng := sin(radians);

  for i := startArrayIdx to high(pts) do
  begin
    x := pts[i].X - origin.X;
    y := pts[i].Y - origin.Y;
    pts[i].X := round((x * cosAng) - (y * sinAng)) + origin.X;
    pts[i].Y := round((x * sinAng) + (y * cosAng)) + origin.Y;
  end;
end;

function SquaredDistBetweenPoints(pt1, pt2: TPoint): cardinal;
begin
  Result := sqr(pt2.X - pt1.X) + sqr(pt2.Y - pt1.Y);
end;

function IntersectionPoint(Line1a, line1b, Line2a, line2b: TPoint; out IntersectionPt: TPoint): boolean;
var
  m1, m2, b1, b2: single;
begin
  //nb: Y axis is positive down ...
  //y = mx + b  ;  b := y - mx
  IntersectionPt := Point(0, 0);
  Result := False;
  if (line1b.X = line1a.X) then                            //vertical line
  begin
    if (line2b.X = line2a.X) then
      exit;                    //parallel lines
    m2 := (line2b.Y - line2a.Y) / (line2b.X - line2a.X);
    b2 := Line2a.Y - m2 * Line2a.X;
    IntersectionPt.X := line1a.X;
    IntersectionPt.Y := round((line1a.X * m2) + b2);
  end
  else
  if (line2b.X = line2a.X) then                            //vertical line
  begin
    if (line1b.X = line1a.X) then
      exit;                    //parallel lines
    m1 := (line1b.Y - line1a.Y) / (line1b.X - line1a.X);
    b1 := Line1a.Y - m1 * Line1a.X;
    IntersectionPt.X := line2a.X;
    IntersectionPt.Y := round((line2a.X * m1) + b1);
  end
  else
  begin
    m1 := (line1b.Y - line1a.Y) / (line1b.X - line1a.X);
    m2 := (line2b.Y - line2a.Y) / (line2b.X - line2a.X);
    if m1 = m2 then
      exit;                                  //parellel lines
    b1 := Line1a.Y - m1 * Line1a.X;
    b2 := Line2a.Y - m2 * Line2a.X;
    //via similtaneous equations ...
    IntersectionPt.X := round((b1 - b2) / (m2 - m1));
    IntersectionPt.Y := round(m1 * (b1 - b2) / (m2 - m1) + b1);
  end;
  Result := True;
end;

function GetAnglePt2FromPt1(pt1, pt2: TPoint): single;
begin
  with pt1 do
    OffsetPt(pt2, -X, -Y);
  with pt2 do
    if X = 0 then
    begin
      Result := PI_Div2;
      if Y > 0 then
        Result := PI_Mul3_Div2;
    end
    else
    begin
      Result := arctan2(-Y, X);
      if Result < 0 then
        Result := Result + PI_Mul2;
    end;
end;

procedure SaveDrawObjectsToStrings(DoList: TList; Strings: TStrings);
var
  i: integer;
begin
  //use the object pointer as a unique ID ...
  for i := 0 to DoList.Count - 1 do
    TplDrawObject(DoList[i]).fStreamID := inttohex(longint(DoList[i]), 8);

  for i := 0 to DoList.Count - 1 do
    with TplDrawObject(DoList[i]) do
    begin
      SaveToPropStrings;
      Strings.AddStrings(PropStrings);
      Strings.Add(''); //add a blank line between each component
      fStreamID := ''; //finally, cleanup temp streaming name
    end;
end;

function FindNextObjectLineIdx(Lines: TStrings; StartAtLine: integer): integer;
var
  EndAtLine: integer;
begin
  EndAtLine := Lines.Count;
  Result := StartAtLine;
  while (Result < EndAtLine) do
    if (Lines[Result] <> '') and (Lines[Result][1] = '[') then
      break
    else
      Inc(Result);
end;

procedure GetClassAndName(const ClassInfoLine: string; out objClass, objName: string);
var
  i: integer;
begin
  i := pos(':', ClassInfoLine);
  objClass := copy(ClassInfoLine, 2, i - 2);
  objName := copy(ClassInfoLine, i + 1, length(ClassInfoLine) - i - 1);
end;

procedure ClearAndNilObjPropertyList;
var
  i: integer;
begin
  if not assigned(ObjPropertyList) then
    exit;
  for i := 0 to ObjPropertyList.Count - 1 do
    dispose(PObjPropInfo(ObjPropertyList[i]));
  FreeAndNil(ObjPropertyList);
end;

procedure LoadDrawObjectsFromStrings(strings: TStrings; Owner: TComponent; Parent: TWinControl; EachDrawObjLoadedEvent: TNotifyEvent);
var
  i, j: integer;
  ObjList: TList;

{steps:
1. Create a list of instantiated DrawObjects
2. DrawObjects fill their own properties and add any DrawObj links to a fixup
   list (containing instance, property, name value)
3. Parse fixup list - using name values to find and assign link instances }

  function NameInUse(const newName: string): boolean;
  var
    i: integer;
  begin
    Result := True;
    for i := 0 to Owner.ComponentCount - 1 do
      if SameText(Owner.Components[i].Name, newName) then
        exit;
    Result := False;
  end;

  procedure BuildObjList(Lines: TStrings; ObjList: TList);
  var
    i, ClassInfoLineIdx, StartAtLine, EndAtLine: integer;
    ObjInstance: TplDrawObject;
    objClass, objName: string;
    PersistentClass: TPersistentClass;
  begin
    EndAtLine := Lines.Count;
    ClassInfoLineIdx := FindNextObjectLineIdx(Lines, 0);
    while ClassInfoLineIdx < EndAtLine do
    begin
      //for each item ...
      StartAtLine := ClassInfoLineIdx;
      GetClassAndName(Lines[ClassInfoLineIdx], objClass, objName);
      ObjInstance := nil;
      try
        PersistentClass := FindClass(objClass);
        if assigned(PersistentClass) and PersistentClass.InheritsFrom(TplDrawObject) then
          ObjInstance := TplDrawObjectClass(PersistentClass).Create(Owner);
      except
      end;
      //find offset of next item so we know which lines pertain to this one ...
      ClassInfoLineIdx := FindNextObjectLineIdx(Lines, ClassInfoLineIdx + 1);

      if ObjInstance = nil then
        continue;

      ObjInstance.Parent := Parent;

      if NameInUse(objName) then
        MakeNameForControl(ObjInstance)
      else
        ObjInstance.Name := objName;

      ObjList.Add(ObjInstance);
      //copy property strings to the new object ...
      for i := StartAtLine to ClassInfoLineIdx - 1 do
        ObjInstance.PropStrings.Add(Lines[i]);
      ObjInstance.LoadFromPropStrings;
      ObjInstance.PropStrings.Clear;
    end;
  end;

begin
  if not assigned(owner) or not assigned(parent) then
    exit;

  ObjPropertyList := TList.Create;
  ObjList := TList.Create;
  try
    //fill ObjList with new top level items ...
    BuildObjList(Strings, ObjList);

    //fixup any entries in ObjPropertyList...
    for i := 0 to ObjPropertyList.Count - 1 do
      with PObjPropInfo(ObjPropertyList[i])^ do
        for j := 0 to ObjList.Count - 1 do
          if (TplDrawObject(ObjList[j]).fStreamID = fPropVal) then
          begin
            SetObjectProp(fOwner, fProperty, TObject(ObjList[j]));
            break; //ie this property has been fixed up
          end;
    for i := 0 to ObjList.Count - 1 do
    begin
      TplDrawObject(ObjList[i]).fStreamID := '';
      //notify of object creation ...
      if assigned(EachDrawObjLoadedEvent) then
        EachDrawObjLoadedEvent(TplDrawObject(ObjList[i]));
    end;
  finally
    ObjList.Free;
    ClearAndNilObjPropertyList;
  end;
end;

procedure GetStrings(FromStrings, ToStrings: TStrings; var lineIdx: integer);
var
  i: integer;
begin
  //format (nb: contained lines all indented 2 spaces) -
  //stringsPropName={
  //  contained text line 1
  //  contained text line 2
  //}
  if not assigned(FromStrings) or not assigned(toStrings) then
    exit;
  i := pos('={', FromStrings[lineIdx]);
  if i = 0 then
    exit;
  Inc(lineIdx);
  while (lineIdx < FromStrings.Count) and (FromStrings[lineIdx] <> '}') do
  begin
    //strip 2 spaces at beginning of every line ...
    ToStrings.Add(copy(FromStrings[lineIdx], 3, 512));
    Inc(lineIdx);
  end;
end;

function MakeNameForControl(ctrl: TControl): boolean;
var
  i, j: integer;
  s: string;
  ownerCtrl: TComponent;
begin
  Result := False;
  if not assigned(ctrl) or not assigned(ctrl.Owner) or (ctrl.Name <> '') then
    exit;
  ownerCtrl := ctrl.Owner;
  s := copy(ctrl.ClassName, 2, 256);
  j := 0;
  while not Result do
  begin
    Inc(j);
    Result := True;
    with ownerCtrl do
      for i := 0 to ComponentCount - 1 do
        if SameText(Components[i].Name, s + IntToStr(j)) then
        begin
          Result := False;
          break;
        end;
    if Result then
      ctrl.Name := s + IntToStr(j);
  end;
end;



//================== TplDrawObject =======================
//========================================================

constructor TplDrawObject.Create(AOwner: TComponent);
begin
  // moved by zbyna  because sequence from inherited Create(AOwner)
  // needs fbitmap.Width and fbitmat.height
  fBitmap:=TBGRABitmap.Create(100,100);
  fColorShadow := clWhite;
  fShadowSize := -2;

  inherited Create(AOwner);
  fPen := TPenEx.Create;
  fPen.Width := 2;
  fPen.OnChange := @PenOnChange;

  fPropStrings := TStringList.Create;

  InternalSetCount(2);
  SavedInfo.ZoomAsPercent := 100;
  fBtnSize := 4;
  fMargin := 2;
  fPressedBtnIdx := -1;
  fDistinctiveLastBtn := False;
  fUseHitTest := True;

  fCanFocus := True;
  ParentColor := False;
  inherited Color := clWhite;

  SetBounds(0, 0, 100, 100);
  //fmarginForDimensions := MARGIN_FOR_DIMENSIONS;
  fmarginForDimensions:=2;
  CalcMargin; //4-dec-2005 moved up 3 lines
  BtnPoints[0] := Point(fMargin, fMargin);
  BtnPoints[1] := Point(Width - fMargin, Height - fMargin);
  fUpdateNeeded := True;
  finsideObject:=nil;
  FoutsideObject:=nil;
end;

destructor TplDrawObject.Destroy;
begin
  fBitmap.Free;
  fPen.Free;
  fPropStrings.Free;
  // it is needed to cancel relation to the outside object
  if outsideObject <> nil then
     outsideObject.insideObject:=nil;
  finsideObject:=nil;
  FoutsideObject:=nil;
  inherited;
end;

procedure TplDrawObject.DefineProperties(Filer: TFiler);
begin
  inherited;
  Filer.DefineBinaryProperty('BinaryBtnData', @ReadBtnData,
    @WriteBtnData, fBtnCount > 0);
  Filer.DefineBinaryProperty('BinaryData', @ReadData,
    @WriteData, assigned(fDataStream) and (fDataStream.Size > 0));
end;

procedure TplDrawObject.ReadBtnData(S: TStream);
var
  i: integer;
begin
  for i := 0 to fBtnCount - 1 do
    S.Read(BtnPoints[i], SizeOf(TPoint));
end;

procedure TplDrawObject.ReadData(S: TStream);
begin
  fDataStream.LoadFromStream(S);
end;

procedure TplDrawObject.WriteBtnData(S: TStream);
var
  i: integer;
begin
  for i := 0 to fBtnCount - 1 do
    S.Write(BtnPoints[i], SizeOf(TPoint));
end;

procedure TplDrawObject.SetEnableDrawDimensions(AValue: Boolean);
begin
  if FEnableDrawDimensions=AValue then Exit;
  FEnableDrawDimensions:=AValue;
  if FEnableDrawDimensions then
     begin
     //  It is needed to solve properly, as workaround
     //  direct fmarginForDimesions := Margin_FOR_DIMENSIONS in constructor
       fmarginForDimensions:=MARGIN_FOR_DIMENSIONS;
       CalcMargin;
       fUpdateNeeded:=True;
       self.Loaded;
     end
  else
     begin
       fmarginForDimensions:=2;
       CalcMargin;
       ResizeNeeded;
       fUpdateNeeded:=True;
       self.Loaded;
     end;
end;

procedure TplDrawObject.SetinsideObject(AValue: TplDrawObject);
begin
  if finsideObject=AValue then Exit;
  finsideObject:=AValue;
end;

procedure TplDrawObject.SetoutsideObject(AValue: TplDrawObject);
begin
  if FoutsideObject=AValue then Exit;
  FoutsideObject:=AValue;
end;

procedure TplDrawObject.WriteData(S: TStream);
begin
  fDataStream.Position := 0;
  S.CopyFrom(fDataStream, fDataStream.Size);
end;

function TplDrawObject.GetCanMove: boolean;
begin
  Result := focused;
end;

function TplDrawObject.Clone: TplDrawObject;
begin
  Result := nil;
  if not assigned(owner) then
    exit;

  //load the sl with property values ...
  SaveToPropStrings;
  Result := TplDrawObjectClass(ClassType).Create(Owner);
  //copy property values in sl to new object ...
  Result.PropStrings.Assign(PropStrings);
  Result.LoadFromPropStrings;
  Result.left := Result.left + 10;
  Result.top := Result.top + 10;
  Result.Parent := parent;
end;

procedure TplDrawObject.InternalSetCount(Count: integer);
begin
  if Count < 1 then
    raise Exception.Create('Not enough buttons');
  fBtnCount := Count;
  setLength(BtnPoints, fBtnCount);
  setLength(SavedInfo.SavedPts, fBtnCount);
end;

procedure TplDrawObject.ResizeNeeded;
begin
  if fBlockResize then
    exit;
  fResizeNeeded := True;
  invalidate;
end;

procedure TplDrawObject.UpdateNeeded;
begin
  fUpdateNeeded := True;
  invalidate;
end;

procedure TplDrawObject.OffsetBtns(x, y: integer);
var
  i: integer;
begin
  for i := 0 to fBtnCount - 1 do
  begin
    Inc(BtnPoints[i].X, x);
    Inc(BtnPoints[i].Y, y);
  end;
end;

function TplDrawObject.ObjectMidPoint: TPoint;
begin
  Result := Point(Width div 2, Height div 2);
end;

function TplDrawObject.PointOverObject(ScreenPt: TPoint): boolean;
var
  pt: TPoint;
begin
  pt := ScreenToClient(ScreenPt);
  //nb: returns false if Pt in object is transparent (same color as its parent)
  with fBitmap.Canvas do
    Result := PtInRect(ClientRect, pt) and (Pixels[pt.X, pt.Y] <> Pixels[Width - 1, Height - 1]);
end;

function TplDrawObject.MoveBtnTo(BtnIdx: integer; screenPt: TPoint): boolean;
var
  clientPt: TPoint;
begin
  clientPt := ScreenToClient(screenPt);
  Result := IsValidBtnMove(BtnIdx, clientPt);
  if Result then
    InternalBtnMove(BtnIdx, clientPt);
end;

procedure TplDrawObject.DrawObject(aCanvas: TbgraCanvas; IsShadow: boolean);

begin
  //override this method in descendant classes
  aCanvas.Polygon(BtnPoints);
end;

procedure TplDrawObject.DrawControlLines;
begin
  //implement this method in descendant classes
end;

procedure TplDrawObject.Paint;
var
  i: integer;
begin

  if fResizeNeeded then
    InternalResize;
  if fUpdateNeeded then
    PrepareBitmap;

    inherited Bitmap.Assign(fBitmap);

  if EnableDrawDimensions then DrawOwnDimensions(Bitmap.CanvasBGRA);
  if (Focused or (csDesigning in ComponentState)) then
    with inherited Bitmap.CanvasBGRA  do
      begin
        //draw control lines ...
        Pen.Color := FOCUSED_DESIGN_COLOR;
        Pen.Width := 1;
        Pen.Style := psDot;
        Brush.Style := bsClear;
        Rectangle(ClientRect);
        DrawControlLines;
        //finally, draw buttons ...
        Pen.Style := psSolid;
        for i := 0 to ButtonCount - 1 do
          DrawBtn(BtnPoints[i], i, i = fPressedBtnIdx,
            (i = ButtonCount - 1) and fDistinctiveLastBtn);
      end;
  inherited Paint;
end;

procedure TplDrawObject.Loaded;
begin
  inherited;
  fBitmap.SetSize(width,Height);
  fResizeNeeded := True;          // by zbyna
  DoSaveInfo;
end;

procedure TplDrawObject.Resize;
var
  i, margX2: integer;
  ratioW, ratioH: single;
begin
  inherited Resize;
  if fBlockResize then
    exit;

  //whenever the drawobject is resized externally, SCALE the resulting object ...
  if ((Width <> fBitmap.Width) or (Height <> fBitmap.Height)) then
  begin
    if (Width <= fMargin) or (Height <= fMargin) then
      exit;
    margX2 := fMargin * 2;
    //scale all button positions to the new dimensions ...
    if (SavedInfo.SavedWidth - margX2 = 0) then
      ratioW := 1
    else
      ratioW := (Width - margX2) / (SavedInfo.SavedWidth - margX2);
    if (SavedInfo.SavedHeight - margX2 = 0) then
      ratioH := 1
    else
      ratioH := (Height - margX2) / (SavedInfo.SavedHeight - margX2);
    fBitmap.SetSize(width,Height);
    for i := 0 to ButtonCount - 1 do
    begin
      BtnPoints[i].X := round((SavedInfo.SavedPts[i].X - fMargin) * ratioW) + fMargin;
      BtnPoints[i].Y := round((SavedInfo.SavedPts[i].Y - fMargin) * ratioH) + fMargin;
    end;
    UpdateNeeded;
  end;
end;

procedure TplDrawObject.DoSaveInfo;
var
  i: integer;
begin
  with SavedInfo do
  begin
    if isTransforming then
      exit;
    //nb: fBitmap is the size of the object dimensions prior to resizing ...
    SavedLeft := left;
    SavedTop := top;
    SavedWidth := fBitmap.Width;
    SavedHeight := fBitmap.Height;
    for i := 0 to ButtonCount - 1 do
    begin
      SavedPts[i].X := BtnPoints[i].X;
      SavedPts[i].Y := BtnPoints[i].Y;
    end;
  end;
end;

procedure TplDrawObject.DrawBtn(BtnPt: TPoint; index: integer; Pressed, LastBtn: boolean);
var
  BtnRect: TRect;
begin
  BtnRect := BtnRectFromPt(BtnPt, fBtnSize);
  with inherited Bitmap.CanvasBGRA do    // by zbyna
  begin
    if Focused or (fPressedBtnIdx >= 0) or Moving then
    begin
      if LastBtn then
        Pen.Color := FOCUSED_DESIGN_COLOR2
      else
        Pen.Color := FOCUSED_DESIGN_COLOR;
    end
    else
      Pen.Color := clSkyBlue;
    Rectangle(BtnRect);
    InflateRect(BtnRect, -1, -1);
    if Pressed then
      Pen.Color := clBtnShadow
    else
      Pen.Color := clBtnHighlight;
    MoveTo(BtnRect.Left, BtnRect.Bottom - 1);
    LineTo(BtnRect.Left, BtnRect.Top);
    LineTo(BtnRect.Right - 1, BtnRect.Top);
    if Pressed then
      Pen.Color := clBtnHighlight
    else
      Pen.Color := clBtnShadow;
    LineTo(BtnRect.Right - 1, BtnRect.Bottom - 1);
    LineTo(BtnRect.Left - 1, BtnRect.Bottom - 1);
  end;
end;

procedure TplDrawObject.InternalResize;
var
  i: integer;
  NewBounds: TRect;
begin
  with BtnPoints[0] do
    NewBounds := Rect(X, Y, X, Y);
  for i := 1 to ButtonCount - 1 do
  begin
    if BtnPoints[i].X < NewBounds.Left then
      NewBounds.Left := BtnPoints[i].X;
    if BtnPoints[i].X > NewBounds.Right then
      NewBounds.Right := BtnPoints[i].X;
    if BtnPoints[i].Y < NewBounds.Top then
      NewBounds.Top := BtnPoints[i].Y;
    if BtnPoints[i].Y > NewBounds.Bottom then
      NewBounds.Bottom := BtnPoints[i].Y;
  end;
  OffsetBtns(fMargin - NewBounds.Left, fMargin - NewBounds.Top);
  OffsetRect(NewBounds, Left, Top);
  InflateRect(NewBounds, fMargin, fMargin);
  with NewBounds do
  begin
    Right := Right - Left; //ie right = width
    Bottom := Bottom - Top; //ie bottom = height
    if (Left <> self.Left) or (Top <> self.Top) or (Right <> self.Width) or (Bottom <> self.Height) then
    begin
      fBitmap.SetSize(right,bottom);
      fBlockResize := True; //blocks scaling while resizing Bitmap
      try
        //todo - reorder InternalResize logic to come AFTER
        //UpdateConnectionPoints which is called indirectly via setBounds ...
        self.setBounds(Left, Top, Right, Bottom);
      finally
        fBlockResize := False;
      end;
    end
    else if self is TplSolid and assigned(TplSolid(self).ConnectorList) then
    begin
      with TplSolid(self) do
        for i := 0 to fConnectorList.Count - 1 do
          TplConnector(fConnectorList[i]).UpdateConnectionPoints(TplSolid(self));
    end;
  end;
  DoSaveInfo;
  fResizeNeeded := False;
  fUpdateNeeded := True;
end;

procedure TplDrawObject.Draw(targetCanvas: TbgraCanvas; offsetX, offsetY: integer);

begin
  with targetCanvas do
  begin
    Font.Assign(self.font);
    Pen.Assign(self.fPen);
    //draw the object shadow ...
    if fShadowSize <> 0 then
    begin
      Pen.Color := fColorShadow;
      brush.Color := fColorShadow;
      OffsetBtns(fShadowSize + offsetX, fShadowSize + offsetY);
      try
        DrawObject(targetCanvas, True);
      finally
        OffsetBtns(-fShadowSize - offsetX, -fShadowSize - offsetY);
      end;
    end;

    //draw the object ...
    Pen.Color := self.Pen.Color;
    brush.Color := self.Color;
    OffsetBtns(offsetX, offsetY);
    try
      DrawObject(targetCanvas, False);
    finally
      OffsetBtns(-offsetX, -offsetY);
    end;
  end;
end;

procedure TplDrawObject.drawLineWithDimension(targetCanvas: TBGRACanvas;
                                              b1,b2:TPoint;
                                              kam,markerThickness:integer;
                                              enableMarginForDimensions:Boolean);
var
  pomS:Integer;
  rectForText : TRect;
begin
  if enableMarginForDimensions then
     pomS:= kam*marginForDimensions
  else
     pomS:=kam;
  if b1.y = b2.y then
    begin
      targetCanvas.MoveTo(b1.x,b1.y + kam*markerThickness);
      targetCanvas.LineTo(b1.x,b1.y + pomS - kam*markerThickness );
      targetCanvas.MoveTo(b2.x,b2.y + kam*markerThickness );
      targetCanvas.lineTo(b2.x,b2.y + pomS - kam*markerThickness );
      targetCanvas.MoveTo(b1.x,b1.y + pomS div 2);
      targetCanvas.LineTo(b2.x,b2.y + pomS div 2);
      rectForText:=Trect.Create(b1.x,b1.y + pomS div 2,b2.x,b2.y + pomS - kam*markerThickness);
      if kam < 0 then
              targetCanvas.TextRect(rectForText,rectForText.Left +2*markerThickness,rectForText.Bottom,
                                       inttostr(width),targetCanvas.TextStyle)
             else
               targetCanvas.TextRect(rectForText,rectForText.Left + 2*markerThickness,rectForText.top,
                                       inttostr(width),targetCanvas.TextStyle)


    end
                 else
    begin
      targetCanvas.MoveTo(b1.x + kam*markerThickness ,b1.y);
      targetCanvas.LineTo(b1.x + pomS - kam*markerThickness ,b1.y );
      targetCanvas.MoveTo(b2.x + kam*markerThickness ,b2.y);
      targetCanvas.lineTo(b2.x + pomS - kam*markerThickness ,b2.y );
      targetCanvas.MoveTo(b1.x + pomS div 2,b1.y );
      targetCanvas.LineTo(b2.x + pomS div 2,b2.y );
      rectForText:=Trect.Create(b1.x + pomS div 2,b1.y,b2.x + pomS - kam*markerThickness,b2.y);
      //targetCanvas.Rectangle(rectForText);
      if kam < 0 then
         targetCanvas.TextRect(rectForText,rectForText.left - 2*markerThickness,
                                           rectForText.top + Height div 4,
                               inttostr(Height),targetCanvas.TextStyle)
                 else
         targetCanvas.TextRect(rectForText,rectForText.left,
                                           rectForText.top + Height div 4 ,
                               inttostr(Height),targetCanvas.TextStyle)
    end;
end;

procedure TplDrawObject.DrawOwnDimensions(targetCanvas: TBgraCanvas);
// for rectangle should be here,
// other shapes, for example circle, should override this
var
   pomRect : TRect;
begin
  pomRect:=TRect.Create(clientRect);
  InflateRect(pomRect,-marginForDimensions,-marginForDimensions);
  targetCanvas.Pen.Width:=1;
  targetCanvas.MoveTo(pomRect.TopLeft);
  targetCanvas.LineTo(pomRect.Left,pomRect.top - marginForDimensions);
  targetCanvas.MoveTo(pomRect.Right,pomRect.Top);
  targetCanvas.lineTo(pomRect.Right,pomRect.top - marginForDimensions);
  targetCanvas.MoveTo(pomRect.Left,pomRect.top - marginForDimensions div 2);
  targetCanvas.LineTo(pomRect.Right,pomRect.top - marginForDimensions div 2);

  //targetCanvas.brush.Style:=bsClear;
  //targetCanvas.Rectangle(pomRect);

end;

procedure TplDrawObject.PrepareBitmap;

begin
  { DONE -oTC -cLazarus_Port_Step2 : Bitmap needs a transparent color identical to the color of the owner. }
  //fBitmap.canvas.brush.Color := fBitmap.TransparentColor and $FFFFFF;
  //fBitmap.canvas.brush.Color := fBitmap.TransparentColor;
  //fBitmap.canvas.FillRect(ClientRect);

  fBitmap.ApplyGlobalOpacity(0);
  Draw(fBitmap.CanvasBGRA,0,0);
  //invalidate;
  fUpdateNeeded := False;
end;

procedure TplDrawObject.SetPen(Value: TPenEx);
begin
  fPen.Assign(Value);
end;

procedure TplDrawObject.PenOnChange(Sender: TObject);
begin
  CalcMargin;
end;

procedure TplDrawObject.SetFocused(Focused: boolean);
begin
  if (fFocused = Focused) or (not fCanFocus and Focused) then
    exit;
  fFocused := Focused;
  if assigned(fFocusChangedEvent) then
    fFocusChangedEvent(self);
  invalidate;
end;

procedure TplDrawObject.SetCanFocus(CanFocus: boolean);
begin
  if fCanFocus = CanFocus then
    exit;
  fCanFocus := CanFocus;
  if not CanFocus then
    SetFocused(False);
end;

procedure TplDrawObject.CalcMargin;
var
  pwDiv2: integer;
begin
  //may need to override this method (eg if line arrowheads are made sizable)
  if odd(pen.Width) then
    pwDiv2 := (pen.Width div 2) + 1
  else
    pwDiv2 := (pen.Width div 2);
  //make sure there's at least 2 pxls outside buttons for designer size btns...
  fmargin := max(fBtnSize + fmarginForDimensions, pwDiv2 + max(2, abs(fShadowSize)));
  ResizeNeeded;
end;

procedure TplDrawObject.SetBtnSize(size: integer);
begin
  if (size < 3) or (size > 10) then
    exit;
  if fBtnSize = size then
    exit;
  fBtnSize := size;
  CalcMargin;
end;

procedure TplDrawObject.SetShadowSize(size: integer);
begin
  if size > MAX_SHADOW_SIZE then
    size := MAX_SHADOW_SIZE
  else if size < -MAX_SHADOW_SIZE then
    size := -MAX_SHADOW_SIZE;
  if fShadowSize = size then
    exit;
  fShadowSize := size;
  CalcMargin;
end;

procedure TplDrawObject.SetColorShadow(aColor: TColor);
begin
  if fColorShadow = aColor then
    exit;
  fColorShadow := aColor;
  UpdateNeeded;
end;

function TplDrawObject.GetColor: TColor;
begin
  Result := inherited Color;
end;

procedure TplDrawObject.SetColor(aColor: TColor);
begin
  if inherited Color = aColor then
    exit;
  inherited Color := aColor;
  UpdateNeeded;
end;

function TplDrawObject.GetBitmap: TbgraBitmap;
begin
  if fUpdateNeeded then
    PrepareBitmap;
  Result := fBitmap;
end;

procedure TplDrawObject.SetUseHitTest(Value: boolean);
begin
  fUseHitTest := Value;
end;


procedure TplDrawObject.CMHitTest(var Message: TCMHittest);
begin
  if Focused or not fUseHitTest then
    Message.Result := HTCLIENT
  else if ClickPosNearPaintedObject(Bitmap, Message.XPos, Message.YPos, HITTESTSENSITIVITY) then
    Message.Result := HTCLIENT
  else
    Message.Result := HTNOWHERE;
end;

procedure TplDrawObject.DblClick;
begin
  inherited;
  //the object can lose 'capture' via DblClick (eg a popup window) so
  //flag DblClick to avoid issues in MouseDown() & MouseMove() ...
  fDblClickPressed := True;
end;

procedure TplDrawObject.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  inherited;
  if not (csDesigning in ComponentState) and not fDblClickPressed then
  begin
    //nb: left click while shift key pressed will toggle selection ...
    if (ssShift in Shift) and focused and (Button = mbLeft) then
    begin
      Focused := False;
      exit;
    end
    else if not focused and CanFocus then
    begin
      Focused := True;
      exit;
    end;

    if Button = mbLeft then
    begin
      if not focused then
        fPressedBtnIdx := -1
      else if BtnIdxFromPt(Point(X, Y), True, fPressedBtnIdx) then
        invalidate;
      if (fPressedBtnIdx < 0) and CanMove then
      begin
        fMovingPt := Point(X, Y);
        fMoving := True;
      end;
    end;
  end;
  fDblClickPressed := False;
end;

procedure TplDrawObject.MouseMove(Shift: TShiftState; X, Y: integer);
var
  NewPt: TPoint;
  idx, dx, dy: integer;
  r: TRect;
begin
  if (csDesigning in ComponentState) then
  begin
    inherited;
  end
  else
  begin
    dx := left;
    dy := top;
    NewPt := Point(X, Y);
    if BtnIdxFromPt(NewPt, True, idx) then
      cursor := crHandPoint
    else
      cursor := crDefault;
    if (fPressedBtnIdx >= 0) then
    begin
      //button move (ie resizing object)
      if IsValidBtnMove(fPressedBtnIdx, NewPt) then
        InternalBtnMove(fPressedBtnIdx, NewPt);
      //bugfix (2-May-08) ...
      //control disappeared when it had its last remaining button temporarily
      //dragged off parent canvas but wouldn't reappear on returning ...
      if not IntersectRect(r, self.BoundsRect, parent.ClientRect) then
        InternalResize; //needed because Paint() isn't called
    end
    else if fMoving then
      SetBounds(left + X - fMovingPt.X, top + Y - fMovingPt.Y, Width, Height);

    dx := left - dx;
    dy := top - dy; //bugfix (17-Jan-07)
    inherited MouseMove(Shift, X - dx, Y - dy);
  end;
end;

procedure TplDrawObject.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  if not (csDesigning in ComponentState) then
  begin
    if fPressedBtnIdx >= 0 then
    begin
      fPressedBtnIdx := -1;
      invalidate;
    end;
    fMoving := False;
  end;
  inherited;
end;

function TplDrawObject.IsValidBtnDown(BtnIdx: integer): boolean;
begin
  //override in descendant classes
  Result := True;
end;

function TplDrawObject.IsValidBtnMove(BtnIdx: integer; NewPt: TPoint): boolean;
begin
  Result := (BtnIdx >= 0) and (BtnIdx < ButtonCount);
end;

procedure TplDrawObject.InternalBtnMove(BtnIdx: integer; NewPt: TPoint);
begin
  BtnPoints[BtnIdx] := NewPt;
  ResizeNeeded;
end;

function TplDrawObject.BtnIdxFromPt(pt: TPoint; ignoreDisabled: boolean; out BtnIdx: integer): boolean;
var
  i: integer;
begin
  Result := False;
  BtnIdx := -1;
  if (csDesigning in ComponentState) or Focused then
    for i := ButtonCount - 1 downto 0 do //nb: get higher indexed btn before lower
      if PtInRect(BtnRectFromPt(BtnPoints[i], fBtnSize), pt) and (not ignoreDisabled or IsValidBtnDown(i)) then
      begin
        BtnIdx := i;
        Result := True;
        exit;
      end;
end;

procedure TplDrawObject.FontChanged(Sender: TObject);
begin
  inherited;
  fBitmap.Canvas.Font.Assign(font);
  UpdateNeeded;
end;

procedure TplDrawObject.WMEraseBkgnd(var Message: TLMEraseBkgnd);
var
  ARect: TRect;
begin
  { TODO -oTC -cLazarus_port_step2 : Find out why the background of the objects is not repainted as it should. Could be in erasebkgnd }
  //ARect := Rect(Left, Top, Left+Width, Top+Height);
  //Canvas.FillRect(ARect);
  message.Result := 1;
end;


var
  ClickedInDesigner: boolean;

procedure TplDrawObject.CMDesignHitTest(var Message: TCMDesignHitTest);
var
  pt: TPoint;

  procedure NotifyModificationToDesigner;
  begin
    if Owner is TCustomForm then
      with TCustomForm(Owner) do
        if assigned(Designer) then
          Designer.Modified;
  end;

begin
  //respond to mouse events while in the form designer
  { DONE -oTC -cLazarus_Port_Step1 : Removed call to SmallPointtoPoint, converted to Point }
  pt := Point(Message.XPos, Message.YPos);

  if (Message.Keys and MK_LBUTTON <> 0) then
  begin
    if not ClickedInDesigner and (fPressedBtnIdx < 0) and BtnIdxFromPt(pt, True, fPressedBtnIdx) then
    begin
      //button down
      invalidate;
      Message.Result := 1;
    end
    else if (fPressedBtnIdx >= 0) and (fPressedBtnIdx < ButtonCount) then
    begin
      //button moved
      if IsValidBtnMove(fPressedBtnIdx, pt) then
        InternalBtnMove(fPressedBtnIdx, pt);
      Message.Result := 1;
    end;
    ClickedInDesigner := True;
  end
  else
  begin
    //button up
    if fPressedBtnIdx >= 0 then
    begin
      NotifyModificationToDesigner;
      fPressedBtnIdx := -1;
      invalidate;
    end;
    ClickedInDesigner := False;
  end;
end;

procedure TplDrawObject.SaveToPropStrings;
var
  i: integer;
  BtnsStr: string;

  procedure ConvertBinaryToText;
  const
    BytesPerLine = 32;
  var
    i: integer;
    cnt: longint;
    Buffer: array[0..BytesPerLine - 1] of char;
    Text: array[0..BytesPerLine * 2 - 1] of char;
    outStream: TMemoryStream;
  begin
    outStream := TMemoryStream.Create;
    try
      //compress the data ...
      fDataStream.Position := 0;
      { TODO -oTC -cLazarus_Port_Step1 : TCompressionStream not found }
      //with TCompressionStream.Create(clDefault, outStream) do
      //try
      //  CopyFrom(fDataStream, 0);
      //finally
      //  Free; //must be freed to flush outStream
      //end;
      //now write the data to PropStrings ...
      outStream.Position := 0;
      AddToPropStrings('Data', '{');
      cnt := outStream.Size;
      while cnt > 0 do
      begin
        if cnt >= 32 then
          i := 32
        else
          i := cnt;
        outStream.ReadBuffer(Buffer, i);
        BinToHex(Buffer, Text, i);
        AddToPropStrings('', '  ' + copy(Text, 1, i * 2));
        Dec(cnt, i);
      end;
      AddToPropStrings('', '}');
    finally
      outStream.Free;
    end;
  end;

begin
  btnsStr:=''; // by zbyna  to clean garbage added during save
  PropStrings.Clear; //start afresh
  PropStrings.Add('[' + ClassName + ':' + Name + ']');
  for i := 0 to ButtonCount - 1 do
    with BtnPoints[i] do
      BtnsStr := BtnsStr + format('(%d,%d) ', [x, y]);

  AddToPropStrings('ButtonCount', IntToStr(ButtonCount));
  AddToPropStrings('ButtonSize', IntToStr(ButtonSize));
  AddToPropStrings('BtnPoints', BtnsStr);
  AddToPropStrings('Color', '$' + inttohex(ColorToRGB(Color), 8));
  AddToPropStrings('ColorShadow', '$' + inttohex(ColorToRGB(ColorShadow), 8));
  AddToPropStrings('Height', IntToStr(Height));
  AddToPropStrings('Left', IntToStr(Left));
  AddToPropStrings('Pen.Color', '$' + inttohex(ColorToRGB(Pen.Color), 8));
  AddToPropStrings('Pen.Style', GetEnumProp(Pen, 'Style'));
  AddToPropStrings('Pen.Width', IntToStr(Pen.Width));
  AddToPropStrings('ShadowSize', IntToStr(ShadowSize));
  AddToPropStrings('Top', IntToStr(Top));
  AddToPropStrings('Width', IntToStr(Width));
  AddToPropStrings('UseHitTest', GetEnumProp(self, 'UseHitTest'));
  if fStreamID <> '' then
    AddToPropStrings('ObjId', fStreamID);
  if assigned(fDataStream) then
    ConvertBinaryToText;
  //append to this in descendant classes
end;

procedure TplDrawObject.AddToPropStrings(const PropName, PropVal: string);
begin
  if PropName = '' then //eg when adding multiline properties
    PropStrings.Add(PropVal)
  else
    PropStrings.Add(format('%s=%s', [PropName, PropVal]));
end;

procedure TplDrawObject.GetBinaryData(var lineIdx: integer);
const
  BufferSize = 4096;
var
  cnt: integer;
  Buffer: array[0..BufferSize - 1] of char;
  hexSrc: PChar;
  inStream: TMemoryStream;
  { TODO -oTC -cLazarus_Port_Step1 : TDecompressStream not found }
  //TCQdecompStream: TDecompressionStream;
begin
  //format (nb: contained lines all indented 2 spaces) -
  //Data={
  //  compressed-ascii-hex
  //  compressed-ascii-hex
  //}
  Inc(lineIdx);
  if assigned(fDataStream) then //ie: if there's somewhere to store the data ...
  begin
    inStream := TMemoryStream.Create;
    try
      fDataStream.Clear;
      //copy binary data into temp 'inStream' ...
      while (lineIdx < PropStrings.Count) and (length(PropStrings[lineIdx]) > 4) do
      begin
        hexSrc := @PropStrings[lineIdx][3]; //ignore 2 prepended blanks
        cnt := HexToBin(hexSrc, Buffer, BufferSize);
        if cnt = 0 then
          exit; //buffer too small
        inStream.Write(Buffer, cnt);
        Inc(lineIdx);
      end;
      if inStream.Size > 0 then
      begin
        //now decompress data to fDataStream ...
        inStream.Position := 0;
        { TODO -oTC -cLazarus_Port_Step1 : TDecompressStream not found }
        //TCQ decompStream := TDecompressionStream.Create(inStream);
        //try
        //  cnt := decompStream.Read(Buffer, BufferSize);
        //  while cnt > 0 do
        //  begin
        //    fDataStream.WriteBuffer(Buffer, cnt);
        //    cnt := decompStream.Read(Buffer, BufferSize);
        //   end;
        //finally
        //  DecompStream.Free;
        //end;
        //finally notify descendant components that data was loaded ...
        BinaryDataLoaded;
      end;
    finally
      inStream.Free;
    end;
  end
  else
    //otherwise simply ignore this property ...
    while (lineIdx < PropStrings.Count) and (length(PropStrings[lineIdx]) > 4) do
      Inc(lineIdx);
end;

procedure TplDrawObject.BinaryDataLoaded;
begin
  //called by descendant objects
end;

procedure TplDrawObject.LoadFromPropStrings;
var
  i, lineIdx: integer;
  line, clsName, propName, propVal: string;
  PersistObj: TPersistent;
  ObjPropInfo: PObjPropInfo;

  procedure GetNameValuePair(str: string);
  var
    i: integer;
  begin
    i := Pos('=', str);
    propName := trim(copy(str, 1, i - 1));
    propVal := TrimNonPrintChrs(copy(str, i + 1, length(str)));
  end;

  procedure GetBtnPts(const strPts: string);
  var
    i, cp, ep, idx: integer;
    pt: TPoint;
  begin
    idx := 0;
    cp := 1;
    ep := length(strPts);
    while (cp < ep) and (idx < ButtonCount) do
    begin
      while (cp < ep) and (strPts[cp] <> '(') do
        Inc(cp);
      Inc(cp);
      i := cp;
      while (cp < ep) and (strPts[cp] <> ',') do
        Inc(cp);
      pt.X := strtointdef(copy(strPts, i, cp - i), 0);
      Inc(cp);
      i := cp;
      while (cp < ep) and (strPts[cp] <> ')') do
        Inc(cp);
      pt.Y := strtointdef(copy(strPts, i, cp - i), 0);
      if (cp > ep) then
        exit;
      BtnPoints[idx] := pt;
      Inc(idx);
    end;
  end;

begin
  if PropStrings.Count = 0 then
    exit;
  fBlockResize := True;
  try
    line := PropStrings[0];
    i := pos(':', line);
    if (line[1] <> '[') or (i = 0) then
      exit;
    line := copy(line, 2, i - 2);
    if not SameText(line, ClassName) then
      exit; //ie double check

    lineIdx := 0;
    while (lineIdx < PropStrings.Count - 1) do  //01-dec-05: -2(???) --> -1
    begin
      Inc(lineIdx);
      line := PropStrings[lineIdx];
      if (line = '') then
        continue;
      GetNameValuePair(line);
      if propName = '' then
        continue;
      i := pos('.', propName);
      try
        if (i > 1) then //ie class property (eg Pen.Width) ...
        begin
          clsName := copy(propName, 1, i - 1);
          propName := copy(propName, i + 1, 255);
          if IsPublishedProp(self, clsName) and (PropType(self, clsName) = tkClass) then
          begin
            PersistObj := TPersistent(ptrint(GetOrdProp(self, clsName)));
            if assigned(PersistObj) then
              case PropType(PersistObj, propName) of
                tkEnumeration: SetEnumProp(PersistObj, propName, propVal);
                tkInteger: SetPropValue(PersistObj, propName, StrToInt(propVal));
                tkLString: SetPropValue(PersistObj, propName, propVal);
                tkSet: SetSetProp(PersistObj, propName, propVal);
              end;
          end;
        end
        else if IsPublishedProp(self, propName) then
        begin
          case PropType(self, propName) of
            tkEnumeration: SetEnumProp(self, propName, propVal);
            // by zbyna strtoint() replace by StrToIntDef();
            tkInteger: SetPropValue(self, propName, StrToIntDef(propVal,0));
            tkLString: SetPropValue(self, propName, propVal);
            tkSet: SetSetProp(self, propName, propVal);
            tkClass:
            begin
              if assigned(ObjPropertyList) and GetObjectPropClass(Self, PropName).InheritsFrom(TplDrawObject) then
              begin
                //ie: a link to another DrawObject (eg a Connection object)
                //add this link to ObjPropertyList to fix up later ...
                new(ObjPropInfo);
                ObjPropertyList.Add(ObjPropInfo);
                ObjPropInfo^.fOwner := self;
                ObjPropInfo^.fProperty := PropName;
                ObjPropInfo^.fPropVal := PropVal; //ie streamed obj name
              end
              else if (TPersistent(ptrint(GetOrdProp(self, propName))) is TStrings) then
                GetStrings(PropStrings, TStrings(ptrint(GetOrdProp(Self, PropName))), lineIdx);
            end;
          end;
        end
        else if SameText(propName, 'BtnPoints') then
          GetBtnPts(propVal)
        else if SameText(propName, 'Data') then
          GetBinaryData(lineIdx)
        else if SameText(propName, 'ObjId') then
          fStreamID := propVal;
      except
        continue;
      end;
    end;
  finally
    fBlockResize := False;
    fResizeNeeded := False;
  end;
  fbitmap.SetSize(width,Height);
  UpdateNeeded;
  DoSaveInfo;
end;

procedure TplDrawObject.BeginTransform;
begin
  DoSaveInfo;
  SavedInfo.isTransforming := True;
  SavedInfo.RotateScreenPt := ClientToScreen(ObjectMidPoint);
end;

procedure TplDrawObject.EndTransform;
begin
  SavedInfo.isTransforming := False;
  DoSaveInfo;
end;

procedure TplDrawObject.Rotate(degrees: integer);
var
  i, dx, dy: integer;
  radians: single;
  pt: TPoint;
begin
  degrees := degrees mod 360;
  if degrees < 0 then
    Inc(degrees, 360);
  radians := degrees * pi / 180;
  with SavedInfo do
  begin
    if not isTransforming then
      raise Exception.Create('Error: Rotate() without BeginTransform().');

    if not assigned(Parent) then
      raise Exception.Create('Error: Rotate() without assigned Parent.');

    AngleInDegrees := degrees;

    dx := SavedLeft - left;
    dy := SavedTop - top;
    pt := ScreenToClient(RotateScreenPt);
    OffsetPt(pt, -dx, -dy);

    for i := 0 to ButtonCount - 1 do
    begin
      BtnPoints[i].X := SavedPts[i].X;
      BtnPoints[i].Y := SavedPts[i].Y;
    end;
    RotatePts(BtnPoints, 0, pt, radians);
    OffsetBtns(dx, dy);
  end;
  ResizeNeeded;
end;

procedure TplDrawObject.Zoom(percent: integer);
var
  l, t, w, h: integer;
begin
  if (percent < 0) or (percent > 1000) then
    exit;
  with SavedInfo do
  begin
    if not isTransforming then
      raise Exception.Create('Error: Zoom() without BeginTransform().');

    ZoomAsPercent := percent;

    w := SavedWidth * percent div 100;
    h := SavedHeight * percent div 100;
    l := SavedLeft + (SavedWidth div 2) - (w div 2);
    t := SavedTop + (SavedHeight div 2) - (h div 2);
  end;
  setbounds(l, t, w, h);
end;



// ================== TplSolid ===========================


constructor TplSolid.Create(AOwner: TComponent);
begin
  inherited;
  fCanConnect := True;
  fFilled:=False;
end;

destructor TplSolid.Destroy;
begin
  if assigned(fConnectorList) then
    FreeAndNil(fConnectorList);
  inherited;
end;

procedure TplSolid.AddConnector(Connector: TplConnector);
begin
  if not assigned(fConnectorList) then
    fConnectorList := TList.Create;
  if fConnectorList.IndexOf(Connector) < 0 then
    fConnectorList.Add(Connector);
end;

procedure TplSolid.RemoveConnector(Connector: TplConnector);
var
  idx: integer;
begin
  if not assigned(fConnectorList) then
    exit;
  idx := fConnectorList.IndexOf(Connector);
  if idx >= 0 then
    fConnectorList.Delete(idx);
end;

procedure TplSolid.SetFilled(AValue: boolean);
begin
  if fFilled=AValue then Exit;
  fFilled:=AValue;
  UpdateNeeded;
end;

procedure TplSolid.Resize;
var
  i: integer;
begin
  inherited;
  if not assigned(fConnectorList) then
    exit;
  for i := 0 to fConnectorList.Count - 1 do
    TplConnector(fConnectorList[i]).UpdateConnectionPoints(self);
end;

function TplSolid.ClosestScreenPt(FromScreenPt: TPoint): TPoint;
var
  FromPt, mp, tl, tr, bl, br: TPoint;
  angleToFromPt, angleToTopRtCnr: single;
  l, t, r, b: integer;
begin
  mp := ObjectMidpoint;
  if ButtonCount = 1 then //ie TplSolidPoints
  begin
    Result := ClientToScreen(mp);
    exit;
  end;
  FromPt := ScreenToClient(FromScreenPt);

  l := min(BtnPoints[0].X, BtnPoints[1].X);
  t := min(BtnPoints[0].Y, BtnPoints[1].Y);
  r := max(BtnPoints[0].X, BtnPoints[1].X);
  b := max(BtnPoints[0].Y, BtnPoints[1].Y);
  tl := Point(l, t);
  tr := Point(r, t);
  bl := Point(l, b);
  br := Point(r, b);

  //if the area = nil then return the midpoint...
  if PointsEqual(tr, mp) or PointsEqual(FromPt, mp) then
  begin
    Result := ClientToScreen(mp);
    exit;
  end;

  angleToFromPt := GetAnglePt2FromPt1(mp, FromPt);
  angleToTopRtCnr := GetAnglePt2FromPt1(mp, tr);

  if (angleToFromPt < angleToTopRtCnr) or (angleToFromPt > PI_MUL2 - angleToTopRtCnr) then
    IntersectionPoint(tr, br, mp, FromPt, Result)
  else if (angleToFromPt < PI - angleToTopRtCnr) then
    IntersectionPoint(tl, tr, mp, FromPt, Result)
  else if (angleToFromPt < angleToTopRtCnr + PI) then
    IntersectionPoint(tl, bl, mp, FromPt, Result)
  else
    IntersectionPoint(bl, br, mp, FromPt, Result);

  Result := ClientToScreen(Result);
end;

function TplSolid.QuadScreenPt(QuadConnect: TQuadConnection): TPoint;
var
  pt: TPoint;
begin
  case QuadConnect of
    qcRight: pt := Point(Width, Height div 2);
    qcTop: pt := Point(Width div 2, 0);
    qcLeft: pt := Point(0, Height div 2);
    else
      pt := Point(Width div 2, Height);
  end;
  Result := ClosestScreenPt(ClientToScreen(pt));
end;


// =================== TplSolidWithText ===================================


constructor TplSolidWithText.Create(AOwner: TComponent);
begin
  inherited;
  fPadding := 4;
  fStrings := TStringList.Create;
  TStringList(fStrings).OnChange := @StringsOnChange;
  ParentFont := True;
end;

destructor TplSolidWithText.Destroy;
begin
  fStrings.Free;
  inherited;
end;

procedure TplSolidWithText.SetPadding(padding: integer);
begin
  if fPadding = padding then
    exit;
  fPadding := padding;
  UpdateNeeded;
end;

procedure TplSolidWithText.SetStrings(strings: TStrings);
begin
  fStrings.Assign(strings);
end;

procedure TplSolidWithText.StringsOnChange(Sender: TObject);
begin
  UpdateNeeded;
end;

function TplSolidWithText.ResizeObjectToFitText: boolean;
begin
  //implement in descendant classes
  Result := False;
end;

function TplSolidWithText.GetAngle: integer;
begin
  Result := SavedInfo.AngleInDegrees;
  if Result > 180 then
    Dec(Result, 360);
end;

procedure TplSolidWithText.SetAngle(angle: integer);
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

procedure TplSolidWithText.RotatedTextAtPt(aCanvas: TbgraCanvas; x, y: integer; const s: string);
var
  lf: TLogFont;
  OldFontHdl, NewFontHdl: HFont;
  mp, pt: TPoint;
begin
  if s = '' then
    exit;
  { TODO -oTC -cLazarus_Port_Step2 : function GetObject(font, ...) needs to be ported! }
  //TCQ code cannot compile
  //with Canvas do
  //begin
  //  if GetObject(Font.Handle, SizeOf(lf), @lf) = 0 then exit;
  //  lf.lfEscapement := -Angle * 10;
  //  lf.lfOrientation := -Angle * 10;
  //  lf.lfOutPrecision := OUT_TT_ONLY_PRECIS;
  //  NewFontHdl := CreateFontIndirect(lf);
  //  OldFontHdl := selectObject(handle,NewFontHdl);
  //  mp := Point((BtnPoints[0].X + BtnPoints[1].X) div 2,
  //    (BtnPoints[0].Y + BtnPoints[1].Y) div 2);
  //  pt := RotatePt(Point(x,y), mp, (Angle * pi) / 180);
  //  TextOut(pt.X, pt.Y, s);
  //  selectObject(handle,OldFontHdl);
  //  DeleteObject(NewFontHdl);
  //end;
end;

procedure TplSolidWithText.Rotate(degrees: integer);
begin
  if not SavedInfo.isTransforming then
    raise Exception.Create('Error: Rotate() without BeginTransform().');
  degrees := degrees mod 360;
  if degrees < 0 then
    Inc(degrees, 360);
  if degrees = SavedInfo.AngleInDegrees then
    exit;
  SavedInfo.AngleInDegrees := degrees;
  ResizeNeeded;
  //actually rotate drawing buttons (ie indexes >1) in descendant classes
end;

procedure TplSolidWithText.DrawBtn(BtnPt: TPoint; index: integer; Pressed, LastBtn: boolean);
begin
  //TplSolidWithText objects (ie rectangles, diamonds, elipses) only need
  //2 visible design btns, but use extra buttons to aid drawing when rotated ...
  if index > 1 then
    exit;
  inherited;
end;

function TplSolidWithText.IsValidBtnDown(BtnIdx: integer): boolean;
begin
  //TplSolidWithText objects (ie rectangles, diamonds, elipses) only need
  //2 visible design btns, but use extra buttons to aid drawing when rotated ...
  Result := BtnIdx < 2;
end;

procedure TplSolidWithText.InternalBtnMove(BtnIdx: integer; NewPt: TPoint);
begin
  //this method prevents 'flipping' text objects but also assumes that
  //TplSolidWithText only ever have 2 visible design btns
  if BtnIdx = 0 then
  begin
    NewPt.X := min(NewPt.X, BtnPoints[1].X);
    NewPt.Y := min(NewPt.Y, BtnPoints[1].Y);
  end
  else
  begin
    NewPt.X := max(NewPt.X, BtnPoints[0].X);
    NewPt.Y := max(NewPt.Y, BtnPoints[0].Y);
  end;
  inherited;
end;

procedure TplSolidWithText.SaveToPropStrings;
var
  i: integer;
begin
  inherited;
  if Strings.Count > 0 then
  begin
    AddToPropStrings('Strings', '{');
    for i := 0 to Strings.Count - 1 do
      AddToPropStrings('', '  ' + Strings[i]);
    AddToPropStrings('', '}');
  end;
  if Action <> '' then
    AddToPropStrings('Action', Action);
  AddToPropStrings('Padding', IntToStr(Padding));
  AddToPropStrings('Font.Charset', IntToStr(Font.Charset));
  AddToPropStrings('Font.Color', '$' + inttohex(ColorToRGB(Font.Color), 8));
  AddToPropStrings('Font.Name', Font.Name);
  AddToPropStrings('Font.Size', IntToStr(Font.Size));
  AddToPropStrings('Font.Style', GetSetProp(Font, 'Style', False));
  AddToPropStrings('Angle', GetEnumProp(self, 'Angle'));
end;


// =================== TplBaseLine ==========================


constructor TplBaseLine.Create(AOwner: TComponent);
begin
  inherited;
  DistinctiveLastBtn := True;
end;

procedure TplBaseLine.SetArrow1(Arrow: boolean);
begin
  if fArrow1 = Arrow then
    exit;
  fArrow1 := Arrow;
  CalcMargin;
end;

procedure TplBaseLine.SetArrow2(Arrow: boolean);
begin
  if fArrow2 = Arrow then
    exit;
  fArrow2 := Arrow;
  CalcMargin;
end;

procedure TplBaseLine.CalcMargin;
var
  arrowSize: integer;
begin
  inherited;
  if not fArrow1 and not fArrow2 then
    exit;
  arrowSize := 5 + Pen.Width;
  if fMargin < arrowSize then
    fMargin := arrowSize;
  ResizeNeeded;
end;

{ DONE -oTC -cLazarus_Port_Step2 : function CreatePenHandle needs to be ported!
  removed, since not used.}
//TCQ
//function CreatePenHandle(TemplatePen: TPen): HPen;
//var
//  PatternLength: integer;
//  lbrush : LOGBRUSH;
//  userstyle : array [0..5] of DWORD;
//  gapLen, dotLen, dashLen : Integer;
//begin
//  with TemplatePen do
//  begin
//    lbrush.lbStyle := BS_SOLID;
//    lbrush.lbColor := color;
//    lbrush.lbHatch := 0;
//    PatternLength := 0;
//    gaplen := Width*3 div 2; //because rounded dots erode into gaps
//    dotLen := Width;
//    dashLen := Width*3;

//    case Style of
//      psSolid: ;
//      psDash :
//        begin
//          PatternLength:=2;
//          userstyle[0] := dashLen; userstyle[1] := gapLen;
//        end;
//      psDot:
//        begin
//          PatternLength:=2;
//          userstyle[0] := dotLen; userstyle[1] := gapLen;
//        end;
//      psDashDot:
//        begin
//          PatternLength:=4;
//          userstyle[0] := dashLen; userstyle[1] := gapLen;
//          userstyle[2] := dotLen; userstyle[3] := gapLen;
//        end;
//      psDashDotDot:
//        begin
//          PatternLength:=6;
//          userstyle[0] := dashLen; userstyle[1] := gapLen;
//          userstyle[2] := dotLen; userstyle[3] := gapLen;
//          userstyle[4] := dotLen; userstyle[5] := gapLen;
//        end;
//      psClear: ;
//    end;

//    Result := ExtCreatePen(
//      PS_GEOMETRIC or PS_USERSTYLE or PS_ENDCAP_ROUND or PS_JOIN_ROUND,
//      Width, lbrush, PatternLength, @userstyle[0]);
//  end;
//end;

{ DONE -oTC -cLazarus_Port_Step2 : In Lazarus, it's not needed to separate
  between lines 1-thick or solid or dashed. etc. So useless procedure
  DrawDottedPolyline removed. }
//TCQ: procedure DrawDottedPolyline(Canvas: TCanvas; pts: array of TPoint);
//var
//  PenHdl, OldPenHdl: HPen;
//begin
//  //Canvas.Brush.Style := bsClear; //don't think this is necessary
//  if (Canvas.Pen.Width = 1) or (Canvas.Pen.Style = psSolid) then
//    Canvas.PolyLine(pts)
//  else
//  begin
//    { TODO -oTC -cLazarus_Port_Step2 : function CreatePenHandle needs to be ported! }
//    //TCQ none of the lines below compile
//    //PenHdl := CreatePenHandle(canvas.Pen);
//    //OldPenHdl := SelectObject(canvas.Handle,PenHdl);
//    //Polyline(canvas.Handle, pts, high(pts)+1);
//    //DeleteObject(SelectObject(canvas.Handle, OldPenHdl));
//  end;
//end;

function TplBaseLine.GetButtonCount: integer;
begin
  Result := inherited ButtonCount;
end;

procedure TplBaseLine.SetButtonCount(Count: integer);
begin
  //override in descendant classes
end;

function TplBaseLine.Grow(TopEnd: boolean): boolean;
begin
  Result := False; //override in descendant classes
end;

function TplBaseLine.Shrink(TopEnd: boolean): boolean;
begin
  Result := False; //override in descendant classes
end;

procedure TplBaseLine.SaveToPropStrings;
begin
  inherited;
  if fArrow1 then
    AddToPropStrings('Arrow1', GetEnumProp(self, 'Arrow1'));
  if fArrow2 then
    AddToPropStrings('Arrow2', GetEnumProp(self, 'Arrow2'));
end;

// ======================= TplConnector ================================

constructor TplConnector.Create(AOwner: TComponent);
begin
  inherited;
  fAutoOrientation := False;
end;

destructor TplConnector.Destroy;
begin
  //'unregister' any connections ...
  SetConnection1(nil);
  SetConnection2(nil);
  inherited;
end;

procedure TplConnector.SetOrientation(orientation: TOrientation);
begin
  if fOrientation = orientation then
    exit;
  fOrientation := orientation;
  if not fBlockResize and IsConnected then //ie when loading from *.dob file
    UpdateConnectionPoints(nil);
  UpdateNeeded;
end;

procedure TplConnector.SetAutoOrientation(Value: boolean);
begin
  if fAutoOrientation = Value then
    exit;
  fAutoOrientation := Value;
  if not fBlockResize and IsConnected then //ie when loading from *.dob file
    UpdateConnectionPoints(nil);
end;

procedure TplConnector.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if (Operation <> opRemove) or not (AComponent is TplSolid) then
    exit;
  if (AComponent = fConnection1) then
    SetConnection1(nil)
  else if (AComponent = fConnection2) then
    SetConnection2(nil);
end;

function TplConnector.GetCanMove: boolean;
begin
  Result := focused and not IsConnected;
end;

procedure TplConnector.Resize;
begin
  inherited;
  if not fBlockResize and IsConnected then
    UpdateConnectionPoints(nil);
end;


procedure TplConnector.SetConnection1(Connection: TplSolid);
begin
  if (fConnection1 = Connection) or
    //don't allow both connection objects to be the same object ...
    ((Connection <> nil) and (fConnection2 = Connection)) then
    exit;

  if assigned(fConnection1) then
  begin
    fConnection1.RemoveFreeNotification(Self);
    fConnection1.RemoveConnector(self);
  end;
  fConnection1 := nil;
  if assigned(Connection) and Connection.CanConnect then
  begin
    fConnection1 := Connection;
    Connection.FreeNotification(Self);
    Connection.AddConnector(self);
    if not fBlockResize then //ie when loading from *.dob file
      UpdateConnectionPoints(Connection);
  end;
end;

procedure TplConnector.SetConnection2(Connection: TplSolid);
begin
  if (fConnection2 = Connection) or
    //don't allow both connection objects to be the same object ...
    ((Connection <> nil) and (fConnection1 = Connection)) then
    exit;

  if assigned(fConnection2) then
  begin
    fConnection2.RemoveFreeNotification(Self);
    fConnection2.RemoveConnector(self);
  end;
  fConnection2 := nil;
  if assigned(Connection) and Connection.CanConnect then
  begin
    fConnection2 := Connection;
    Connection.FreeNotification(Self);
    Connection.AddConnector(self);
    if not fBlockResize then //ie when loading from *.dob file
      UpdateConnectionPoints(Connection);
  end;
end;

procedure TplConnector.UpdateConnectionPoints(MovingConnection: TplSolid);
var
  pt: TPoint;
begin
  //nb: Self.parent needed for ClientToScreen().
  //    (Would normally only get here without a parent while loading.)
  if not assigned(Parent) then
    exit;

  //make sure connection parents are assigned otherwise quit ...
  if (assigned(fConnection1) and not assigned(fConnection1.Parent)) or (assigned(fConnection2) and not assigned(fConnection2.Parent)) then
    exit;

  if fQuadPtConnect then
    DoQuadPtConnection
  else if assigned(fConnection1) and assigned(fConnection2) then
  begin
    with fConnection2 do
      pt := fConnection1.ClosestScreenPt(ClientToScreen(ObjectMidPoint));
    BtnPoints[0] := ScreenToClient(pt);
    with fConnection1 do
      pt := fConnection2.ClosestScreenPt(ClientToScreen(ObjectMidPoint));
    BtnPoints[ButtonCount - 1] := ScreenToClient(pt);
  end
  else if assigned(fConnection1) then
  begin
    pt := fConnection1.ClosestScreenPt(ClientToScreen(BtnPoints[ButtonCount - 1]));
    BtnPoints[0] := ScreenToClient(pt);
  end
  else if assigned(fConnection2) then
  begin
    pt := fConnection2.ClosestScreenPt(ClientToScreen(BtnPoints[0]));
    BtnPoints[ButtonCount - 1] := ScreenToClient(pt);
  end;
  UpdateNonEndButtonsAfterBtnMove;
  ResizeNeeded;
end;

procedure TplConnector.DoQuadPtConnection;
var
  ScreenMp1, ScreenMp2: TPoint;
  HorzSlope: boolean;
begin
  if assigned(Connection1) then
    ScreenMp1 := Connection1.ClientToScreen(Connection1.ObjectMidPoint)
  else
  if assigned(Connection2) then
    ScreenMp2 := Connection2.ClientToScreen(Connection2.ObjectMidPoint)
  else
    ScreenMp2 := ClientToScreen(BtnPoints[ButtonCount - 1]);

  HorzSlope := SlopeLessThanOne(ScreenMp1, ScreenMp2);

  //finally move ends to appropriate connection points ...
  if HorzSlope then
  begin
    if ScreenMp1.X < ScreenMp2.X then
    begin
      if assigned(fConnection1) then
        BtnPoints[0] :=
          ScreenToClient(fConnection1.QuadScreenPt(qcRight));
      if assigned(fConnection2) then
        BtnPoints[ButtonCount - 1] :=
          ScreenToClient(fConnection2.QuadScreenPt(qcLeft));
    end
    else
    begin
      if assigned(fConnection1) then
        BtnPoints[0] :=
          ScreenToClient(fConnection1.QuadScreenPt(qcLeft));
      if assigned(fConnection2) then
        BtnPoints[ButtonCount - 1] :=
          ScreenToClient(fConnection2.QuadScreenPt(qcRight));
    end;
  end
  else
  begin
    if ScreenMp1.Y < ScreenMp2.Y then
    begin
      if assigned(fConnection1) then
        BtnPoints[0] :=
          ScreenToClient(fConnection1.QuadScreenPt(qcBottom));
      if assigned(fConnection2) then
        BtnPoints[ButtonCount - 1] :=
          ScreenToClient(fConnection2.QuadScreenPt(qcTop));
    end
    else
    begin
      if assigned(fConnection1) then
        BtnPoints[0] :=
          ScreenToClient(fConnection1.QuadScreenPt(qcTop));
      if assigned(fConnection2) then
        BtnPoints[ButtonCount - 1] :=
          ScreenToClient(fConnection2.QuadScreenPt(qcBottom));
    end;
  end;
end;

function TplConnector.IsValidBtnDown(BtnIdx: integer): boolean;
begin
  //don't allow clicking of connected ends ...
  if ((BtnIdx = 0) and assigned(fConnection1)) or ((BtnIdx = ButtonCount - 1) and assigned(fConnection2)) then
    Result := False
  else
    Result := True;
end;

procedure TplConnector.UpdateNonEndButtonsAfterBtnMove;
begin
  //override when needed in descendant classes
end;

procedure TplConnector.MouseMove(Shift: TShiftState; X, Y: integer);
begin
  inherited;
  if Moving and IsConnected then
  //should never happen, but all the same - do nothing
  else if (fPressedBtnIdx < 0) then
  //do nothing
  else if (fPressedBtnIdx = 1) and assigned(fConnection1) then
    UpdateConnectionPoints(fConnection1)
  else if (fPressedBtnIdx = ButtonCount - 2) and assigned(fConnection2) then
    UpdateConnectionPoints(fConnection2);
end;

procedure TplConnector.SaveToPropStrings;
begin
  inherited;
  //include Connections in our custom streaming ...
  if assigned(fConnection1) then
    AddToPropStrings('Connection1', inttohex(ptrint(fConnection1), 8));
  if assigned(fConnection2) then
    AddToPropStrings('Connection2', inttohex(ptrint(fConnection2), 8));
end;

procedure TplConnector.Rotate(degrees: integer);
begin
  //don't rotate if connected ...
  if not IsConnected then
    inherited;
end;

function TplConnector.IsConnected: boolean;
begin
  Result := assigned(Connection1) or assigned(Connection2);
end;

end.
