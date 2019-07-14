{ This file was automatically created by Typhon IDE. Do not edit!
  This source is only used to compile and install the package.
 }

unit pl_shapes;

{$warn 5023 off : no warning about unused units}
interface

uses
  AllplShapesRegister, TplFillShapeUnit, TplShapeLineUnit, TplShapeObjects, 
  TplShapeObjectsBase, TplShapeObjectsExt, TplShapesUnit, TyphonPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('AllplShapesRegister', @AllplShapesRegister.Register);
end;

initialization
  RegisterPackage('pl_shapes', @Register);
end.
