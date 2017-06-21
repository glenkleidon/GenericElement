unit GenericElementTest;

interface

uses
  {$IFNDEF DUNITX}
  TestFramework,
  {$ELSE}
  DUnitX.TestFramework,DUnitX.DUnitCompatibility,
  {$ENDIF}
  GenericElements, System.SysUtils, System.rtti, System.TypInfo
  ;

  Type
  TestGenericElement = class(TTestCase)
  private
    procedure CheckValue(AExpected, AActual:  TValue);
  public
  published
    procedure Test_Generic_interface_Implicit_To_String_passes;
    procedure Test_Generic_interface_Implicit_To_boolean_passes;
    procedure Test_Generic_interface_Implicit_To_byte_passes;
    procedure Test_Generic_interface_Implicit_To_char_passes;
    procedure Test_Generic_interface_Implicit_To_Integer_passes;
    procedure Test_Generic_interface_Implicit_To_Int64_passes;
    procedure Test_Generic_interface_Implicit_To_Extended_passes;
    procedure Test_Generic_interface_Implicit_To_Single_passes;
    procedure Test_Generic_interface_Implicit_To_Double_passes;
    procedure Test_Generic_interface_Implicit_To_Currency_passes;
  end;


implementation

{ TestGenericElement }
procedure TestGenericElement.CheckValue(AExpected, AActual:  TValue);
var lResult: boolean;
    lValue : TValue;
begin
  lResult := AActual.TryCast(AExpected.TypeInfo, lValue);
  if lResult then
  case AExpected.Kind of
    tkUnknown: ;
    tkSet: ;
    tkClass: ;
    tkMethod: ;

    tkWChar: 
       lResult := AExpected.AsType<wideChar>=lValue.AsType<wideChar>;
    tkChar : 
       lResult := AExpected.AsType<Char>=lValue.AsType<Char>;
    tkUString:
       lResult := AExpected.AsType<UnicodeString>=lValue.AsType<UnicodeString>;
    tkLString,
    tkString,
    tkWString:  lResult :=AExpected.AsString=AActual.AsString;
    
    tkVariant:  lResult :=AExpected.AsVariant=AExpected.AsVariant;

    tkEnumeration : lResult := AExpected.ToString = AExpected.ToString;
    tkInteger : lResult := AExpected.AsInteger = AActual.AsInteger;

    tkFloat,
    tkInt64 : lResult := AExpected.AsExtended = AActual.AsExtended;

    tkArray: ;
    tkRecord: ;
    tkInterface: ;
    tkDynArray: ;
    tkClassRef: ;
    tkPointer: ;
    tkProcedure: ;
  end;
  {$IFNDEF DUNITX}
    check(lResult, 'Expected:' + AExpected.toString + #13#10 +
                           'Actual  :' + AActual.ToString); 
  {$ELSE}
    Assert.IsTrue(lResult,'Expected:' + AExpected.toString + #13#10 +
                           'Actual  :' + AActual.ToString);
  {$ENDIF}
  
end;


procedure TestGenericElement.Test_Generic_interface_Implicit_To_boolean_passes;
var lElement: TElement;
    lExpected  
    , lResult : Boolean;
begin
   lExpected := true;
   lElement := lExpected;
   lResult := lElement.Value.AsBoolean;
   checkValue(lExpected, lResult);

   lExpected := false;
   lElement := lExpected;
   lResult := lElement.Value.AsBoolean;
   checkValue(lExpected, lResult);

end;

procedure TestGenericElement.Test_Generic_interface_Implicit_To_byte_passes;
var lElement: TElement;
    lExpected  
    , lResult : Byte;
begin
   lExpected := 1;
   lElement := lExpected;
   lResult := lElement.AsByte;
   checkValue(lExpected, lResult);

   lExpected := 255;
   lElement := lExpected;
   lResult := lElement.AsByte;
   checkValue(lExpected, lResult);

   lExpected := 0;
   lElement := lExpected;
   lResult := lElement.AsByte;
   checkValue(lExpected, lResult);
                               
end;

procedure TestGenericElement.Test_Generic_interface_Implicit_To_char_passes;
var lElement: TElement;
    lExpected  
    , lResult : Char;
begin
   lExpected := #1;
   lElement := lExpected;
   lResult := lElement.AsChar;
   checkValue(lExpected, lResult);

   lExpected := #257;
   lElement := lExpected;
   lResult := lElement.AsChar;
   checkValue(lExpected, lResult);

end;

procedure TestGenericElement.Test_Generic_interface_Implicit_To_Currency_passes;
var lElement: TElement;
    lExpected  
    , lResult : Currency;
begin
   lExpected := 0.01;
   lElement := lExpected;
   lResult := lElement.AsCurrency;
   checkValue(lExpected, lResult);

   lExpected := 999999.82;
   lElement := lExpected;
   lResult := lElement.AsCurrency;
   checkValue(lExpected, lResult);


end;

procedure TestGenericElement.Test_Generic_interface_Implicit_To_Double_passes;
var lElement: TElement;
    lExpected  
    , lResult : double;
begin                     
   lExpected := 0;
   lElement.Value := TValue.Empty;
   lResult := lElement.AsDouble;
   checkValue(lExpected, lResult);

   lExpected := -0.034234233333231;
   lElement := lExpected;
   lResult := lElement.AsDouble;
   checkValue(lExpected, lResult);

   lExpected := 9999991.82323332322;
   lElement := lExpected;
   lResult := lElement.asDouble;;
   checkValue(lExpected, lResult);

   lExpected := 0.3;
   lElement := lExpected;
   lResult := lElement.asDouble;
   checkValue(lExpected, lResult);

end;

procedure TestGenericElement.Test_Generic_interface_Implicit_To_Extended_passes;
var lElement: TElement;
    lExpected  
    , lResult : Extended;
begin                     
   lExpected := 0;
   lElement.Value := TValue.Empty;
   lResult := lElement.AsExtended;
   checkValue(lExpected, lResult);

   lExpected := 0;
   lElement := lExpected;
   lResult := lElement.AsExtended;
   checkValue(lExpected, lResult);

   lExpected := -9999991.3332;
   lElement := lExpected;
   lResult := lElement.AsExtended;
   checkValue(lExpected, lResult);

   lExpected := 100.098;
   lElement := lExpected;
   lResult := lElement.AsExtended;
   checkValue(lExpected, lResult);

   lExpected := MaxINt+0.223;
   lElement := lExpected;
   lResult := lElement.AsExtended;
   checkValue(lExpected, lResult);


end;

procedure TestGenericElement.Test_Generic_interface_Implicit_To_Int64_passes;
var lElement: TElement;
    lExpected  
    , lResult : Int64;
begin                     
   lExpected := 0;
   lElement.Value := TValue.Empty;
   lResult := lElement.AsInt64;
   checkValue(lExpected, lResult);

   lExpected := 0;
   lElement := lExpected;
   lResult := lElement.AsInt64;
   checkValue(lExpected, lResult);

   lExpected := -9999991;
   lElement := lExpected;
   lResult := lElement.AsInt64;
   checkValue(lExpected, lResult);

   lExpected := 100;
   lElement := lExpected;
   lResult := lElement.AsInt64;
   checkValue(lExpected, lResult);

   lExpected := MaxLongInt;
   lElement := lExpected;
   lResult := lElement.AsInt64;
   checkValue(lExpected, lResult);

end;

procedure TestGenericElement.Test_Generic_interface_Implicit_To_Integer_passes;
var lElement: TElement;
    lExpected  
    , lResult : Integer;
begin                     
   lExpected := 0;
   lElement.Value := TValue.Empty;
   lResult := lElement.AsInteger;
   checkValue(lExpected, lResult);

   lExpected := 0;
   lElement := lExpected;
   lResult := lElement.AsInteger;
   checkValue(lExpected, lResult);

   lExpected := -9999991;
   lElement := lExpected;
   lResult := lElement.AsInteger;
   checkValue(lExpected, lResult);

   lExpected := 100;
   lElement := lExpected;
   lResult := lElement.AsInteger;
   checkValue(lExpected, lResult);

   lExpected := MaxINt;
   lElement := lExpected;
   lResult := lElement.AsInteger;
   checkValue(lExpected, lResult);


end;

procedure TestGenericElement.Test_Generic_interface_Implicit_To_Single_passes;
var lElement: TElement;
    lExpected  
    , lResult : single;
begin 
   lExpected := 0;
   lElement.Value := TValue.Empty;
   lResult := lElement.AsSingle;
   checkValue(lExpected, lResult);
                       
   lExpected := -0.034234;
   lElement := lExpected;
   lResult := lElement.AsSingle;
   checkValue(lExpected, lResult);

   lExpected := 9999991.823;
   lElement := lExpected;
   lResult := lElement.asSingle;
   checkValue(lExpected, lResult);

   lExpected := 0.3;
   lElement := lExpected;
   lResult := lElement.AsSingle;
   checkValue(lExpected, lResult);

end;

procedure TestGenericElement.Test_Generic_interface_Implicit_To_String_passes;
var lElement: TElement;
    lExpected, lResult : string;
    yn:Boolean;
    b: Byte;
    c: char;
    i:integer;
    ii:int64;
    e:Extended;
    d:Double;
    s:Single;
    cu:Currency;
begin
   lExpected := 'This is a string';
   lElement := lExpected;
   lResult := lElement;
   checkValue(lExpected,lResult);
    b:=255;
    c:= #32;
    i:= maxInt;
    ii:= maxLongInt;
    e:= -128312973.232;
    d:= (22/7);
    s:= (22/7);
    cu := 0.15*3.80*100;

    yn:=false;
    lElement := yn; lExpected:='False';lresult := lElement; checkValue(lExpected,lResult);
    yn:=true;
    lElement := yn; lExpected:='True';lresult := lElement; checkValue(lExpected,lResult);


    lElement := b; lExpected := '255';lresult := lElement; checkValue(lExpected,lResult);
    lElement := c; lExpected := ' ';lresult := lElement; checkValue(lExpected,lResult);
    lElement := i; lExpected := MaxInt.ToString;lresult := lElement; checkValue(lExpected,lResult);
    lElement := ii; lExpected := MaxLongInt.ToString;lresult := lElement; checkValue(lExpected,lResult);
    lElement := e; lExpected := '-128312973.232';lresult := lElement; checkValue(lExpected,lResult);
    lElement := d; lExpected := '3.14285714285714';lresult := lElement; checkValue(lExpected,lResult);
    lElement := s; lExpected := '3.14285707473755';lresult := lElement; checkValue(lExpected,lResult);
    lElement := cu; lExpected := '57';lresult := lElement; checkValue(lExpected,lResult);
end;

initialization
  // Register any test cases with the test runner
  {$IFNDEF DUNITX}
    RegisterTest(TestGenericElement.Suite);
  {$ELSE}
   TDUnitX.RegisterTestFixture(TestGenericElement);
  {$ENDIF}


end.
