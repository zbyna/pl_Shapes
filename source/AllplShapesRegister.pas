{**********************************************************************
                PilotLogic Software House.
  
 Package pl_Shapes.pkg
 This unit is part of CodeTyphon Studio (http://www.pilotlogic.com/)
***********************************************************************}

unit AllplShapesRegister;


interface

 uses
  Classes,SysUtils,TypInfo,lresources,PropEdits,ComponentEditors,
  //...........................
  TplShapeObjects,TplShapeObjectsExt,
  TplFillShapeUnit,
  TplShapesUnit,
  TplShapeLineUnit;

procedure Register;

implementation

{$R AllplShapesRegister.res}

//==========================================================
procedure Register;
begin

  RegisterComponents('Shapes', [TplFillShape,
                                TplShapeLine,
                                TplSquareShape,TplRoundSquareShape,TplRectShape,TplRoundRectShape,
                                TplEllipseShape, TplCircleShape,
                                TplTriangleShape,TplRectangleShape,
                                TplParallelogramShape,
                                TplTrapezoidShape,TplPentagonShape,TplHexagonShape,TplOctagonShape,
                                TplStarShape,TplBubbleShape]);


  RegisterComponents('Shapes Objects',
    [TplLine, TplLLine, TplZLine, TplBezier, TplText, TplSolidPoint, TplDrawPicture, TplRectangle,
    TplDiamond, TplEllipse, TplArc, TplPolygon, TplStar, TplSolidArrow, TplSolidBezier,
    TplTextBezier, TplRandomPoly,TplDrawObjectComposite]);
end;

end.
