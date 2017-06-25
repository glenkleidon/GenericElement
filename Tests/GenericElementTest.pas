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
    Procedure CheckValue(AExpected, AActual:  TValue);
    Procedure CheckReference(AExpected, AActual : Pointer);
  public
  published
    procedure Test_Generic_Element_Implicit_To_String_passes;
    procedure Test_Generic_Element_Implicit_To_boolean_passes;
    procedure Test_Generic_Element_Implicit_To_byte_passes;
    procedure Test_Generic_Element_Implicit_To_char_passes;
    procedure Test_Generic_Element_Implicit_To_Integer_passes;
    procedure Test_Generic_Element_Implicit_To_Int64_passes;
    procedure Test_Generic_Element_Implicit_To_Extended_passes;
    procedure Test_Generic_Element_Implicit_To_Single_passes;
    procedure Test_Generic_Element_Implicit_To_Double_passes;
    procedure Test_Generic_Element_Implicit_To_Currency_passes;
    procedure Test_Generic_Element_Parent_Is_Expected_Parent;
    procedure Test_Generic_Element_Clone_Passes;
  end;
  Type

  TestGenericElementJson = class(TTestCase)
  private
    Procedure CheckValue(AExpected, AActual:  TValue);
    procedure CheckIsTrue(AResult: Boolean);
  public
  published
    procedure Test_Generic_Element_As_JSON_Returns_Value;
    procedure Test_Generic_Element_As_JSON_Returns_Value_Array;
    procedure Test_Generic_Element_AS_JSON_Passes;
    procedure Test_Generic_Element_From_JSON_Returns_Single_String_Element;
    procedure Test_Generic_Element_From_JSON_Returns_Single_Boolean_Element;
    procedure Test_Generic_Element_From_JSON_Returns_Single_Integer_Element;
    procedure Test_Generic_Element_From_JSON_Returns_Single_Int64_Element;
    procedure Test_Generic_Element_From_JSON_Returns_Single_Single_Element;
    procedure Test_Generic_Element_From_JSON_Returns_Single_Double_Element;
    procedure Test_Generic_Element_From_JSON_Single_Converts_Back_To_Same_String;
    procedure Test_Generic_Element_From_JSON_Returns_Integer_Arrays;
    procedure Test_Generic_Element_From_JSON_Returns_String_Arrays;
    procedure Test_Generic_Element_From_JSON_Returns_Mixed_Arrays;
    procedure Test_Generic_Element_From_JSON_Returns_Single_Object;
    procedure Test_Generic_Element_From_JSON_Returns_Multiple_Objects;
  end;


implementation

function CheckTestValue(ATestCase: TTestCase; AExpected, AActual:  TValue): boolean;
var
    lValue : TValue;
begin
  Result := AActual.TryCast(AExpected.TypeInfo, lValue);
  if Result then
  case AExpected.Kind of
    tkUnknown: ;
    tkSet: ;
    tkClass: ;
    tkMethod: ;

    tkWChar:
       Result := AExpected.AsType<wideChar>=lValue.AsType<wideChar>;
    tkChar :
       Result := AExpected.AsType<Char>=lValue.AsType<Char>;
    tkUString:
       Result := AExpected.AsType<UnicodeString>=lValue.AsType<UnicodeString>;
    tkLString,
    tkString,
    tkWString:  Result :=AExpected.AsString=AActual.AsString;

    tkVariant:  Result :=AExpected.AsVariant=AExpected.AsVariant;

    tkEnumeration : Result := AExpected.ToString = AExpected.ToString;
    tkInteger : Result := AExpected.AsInteger = AActual.AsInteger;

    tkFloat,
    tkInt64 : Result := AExpected.AsExtended = AActual.AsExtended;

    tkArray: ;
    tkRecord: ;
    tkInterface: ;
    tkDynArray: ;
    tkClassRef: ;
    tkPointer: ;//result := AExpected =AActual;
    tkProcedure: ;
  end;

  {$IFNDEF DUNITX}
    ATestCase.check(Result, 'Expected:' + AExpected.toString + #13#10 +
                           'Actual  :' + AActual.ToString);
  {$ELSE}
    Assert.IsTrue(Result,'Expected:' + AExpected.toString + #13#10 +
                           'Actual  :' + AActual.ToString);
  {$ENDIF}

end;

{ TestGenericElement }

procedure TestGenericElement.CheckReference(AExpected, AActual: Pointer);
begin
   {$IFNDEF DUNITX}
    check(
   {$ELSE}
    Assert.IsTrue(
   {$ENDIF}
    @AExpected^=@AActual^, 'Pointers do not match');

end;

procedure TestGenericElement.CheckValue(AExpected, AActual: TValue);
begin
   CheckTestValue(self, AExpected, AActual);
end;

procedure TestGenericElement.Test_Generic_Element_Clone_Passes;
var lElement,lResult: TElement;
    i:integer;
begin
   lElement := 1;
   lElement.Name := 'ONE';
   PTELement(lElement.Add).Value:=1.1;
   PTELement(lElement.Add).Value:=1.2;
   PTELement(lElement.Add).Value:=1.2;

   lResult.Clone(lElement);

   CheckValue(1,lResult.Value);
   CheckValue(lElement.Name, lResult.Name);
   CheckValue(3, lElement.Count);
   CheckValue(3, lResult.Count);
   CheckValue(lElement.ElementType, lResult.ElementType);
   CheckValue(lElement.MethodCount, lResult.MethodCount);
   for i := 0 to lElement.Count-1 do
     CheckValue(lElement.Elements[i].value,lResult.Elements[i].value);

end;

procedure TestGenericElement.Test_Generic_Element_Implicit_To_boolean_passes;
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

procedure TestGenericElement.Test_Generic_Element_Implicit_To_byte_passes;
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

procedure TestGenericElement.Test_Generic_Element_Implicit_To_char_passes;
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

procedure TestGenericElement.Test_Generic_Element_Implicit_To_Currency_passes;
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

procedure TestGenericElement.Test_Generic_Element_Implicit_To_Double_passes;
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

procedure TestGenericElement.Test_Generic_Element_Implicit_To_Extended_passes;
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

procedure TestGenericElement.Test_Generic_Element_Implicit_To_Int64_passes;
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

procedure TestGenericElement.Test_Generic_Element_Implicit_To_Integer_passes;
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

procedure TestGenericElement.Test_Generic_Element_Implicit_To_Single_passes;
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

procedure TestGenericElement.Test_Generic_Element_Implicit_To_String_passes;
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
    lExpected:='False';//yn.ToString(True);
    lElement := yn;
    lresult := lElement;
    checkValue(lExpected,lResult);

    yn:=true;
    lElement := yn; lExpected:='True';//yn.ToString(True);
    lresult := lElement;
    checkValue(lExpected,lResult);


    lElement := b; lExpected := '255';lresult := lElement; checkValue(lExpected,lResult);
    lElement := c; lExpected := ' ';lresult := lElement; checkValue(lExpected,lResult);
    lElement := i; lExpected := MaxInt.ToString;lresult := lElement; checkValue(lExpected,lResult);
    lElement := ii; lExpected := MaxLongInt.ToString;lresult := lElement; checkValue(lExpected,lResult);
    lElement := e; lExpected := '-128312973.232';lresult := lElement; checkValue(lExpected,lResult);
    lElement := d; lExpected := '3.14285714285714';lresult := lElement; checkValue(lExpected,lResult);
    lElement := s; lExpected := '3.14285707473755';lresult := lElement; checkValue(lExpected,lResult);
    lElement := cu; lExpected := '57';lresult := lElement; checkValue(lExpected,lResult);
end;

procedure TestGenericElement.Test_Generic_Element_Parent_Is_Expected_Parent;
var lExpected : TElement;
    lResult : PTElement;

begin
   lExpected := 0.01;
   lExpected.Name := 'Parent1';

   lResult := TElement.ElementParent(lExpected.addSubElement('Object1'));
   checkValue(lExpected.Value, lResult.Value);
   checkValue(lExpected.Name,  lResult.Name);

end;

{ TestGenericElementJson }

procedure TestGenericElementJson.CheckValue(AExpected, AActual: TValue);
begin
  checkTestValue(Self, AExpected, AActual);
end;

procedure TestGenericElementJson.CheckIsTrue(AResult: Boolean);
begin
  {$IFNDEF DUNITX}
    check(AResult, 'Expected to be TRUE, but was False');
  {$ELSE}
    Assert.IsTrue(AResult);
  {$ENDIF}
end;


procedure TestGenericElementJson.Test_Generic_Element_AS_JSON_Passes;
var lElement,lSubElement: TElement;
    lExpected, lResult : string;
begin
   lElement := TElement.create('Element1', TValue.Empty);
   lElement.AddElement(1);


   lSubElement := TElement.Create('SubElement1',TValue.Empty);
   lSubElement.AddElement('String1');
   lSubElement.AddElement('String2');
   lElement.AddElement(lSubElement);

   lExpected := '{"Element1":[1,{"SubElement1":["String1","String2"]}]}';
   lResult := TElement.ToJSON(lElement);
   checkvalue(lExpected,lResult);
end;

procedure TestGenericElementJson.Test_Generic_Element_As_JSON_Returns_Value;
var lElement: TElement;
    lExpected, lResult : string;
begin
   lElement := 1;
   lExpected := '1';
   lResult := TElement.ToJSON(lElement);
   checkvalue(lExpected,lResult);

   lElement := 'This is a string';
   lExpected := '"This is a string"';
   lResult := TElement.ToJSON(lElement);
   checkvalue(lExpected,lResult);

end;

procedure TestGenericElementJson.Test_Generic_Element_As_JSON_Returns_Value_Array;
var lElement: TElement;
    lExpected, lResult : string;
begin
   lElement.AddElement(1);
   lElement.AddElement(2);
   lElement.AddElement(3);

   lExpected := '[1,2,3]';
   lResult := TElement.ToJSON(lElement);
   checkvalue(lExpected,lResult);

   lElement.Clear;

   lElement.AddElement('String 1');
   lElement.AddElement('String 2');
   lElement.AddElement('String 3');
   lExpected := '["String 1","String 2","String 3"]';
   lResult := TElement.ToJSON(lElement);
   checkvalue(lExpected,lResult);

end;

procedure TestGenericElementJson.Test_Generic_Element_From_JSON_Single_Converts_Back_To_Same_String;
var lElement: TElement;
    lJSON, lJSONResult : string;
    lExpected1 : Integer;
    lExpected2 : Single;
begin
  lExpected1 := 275;
  lJSON := lExpected1.ToString;
  lElement := TElement.FromJSON(lJSON);
  lJSONResult := TElement.ToJSON(lElement);
  checkValue(lJSON,lJSONResult);

  lExpected2 := 275.35;
  lJSON := lExpected2.ToString;
  lElement := TElement.FromJSON(lJSON);
  lJSONResult := TElement.ToJSON(lElement);
  checkValue(lJSON, lJSONResult);

end;

procedure TestGenericElementJson.Test_Generic_Element_From_JSON_Returns_Integer_Arrays;
var lElement, lElement1: TElement;
    lJSON : string;
    lResult : Boolean;
    i: integer;
begin
  lJSON := '[1,2,3]';
  lElement := TElement.FromJSON(lJSON);
  checkIsTrue( lElement.Count=3);
  for i := 0 to lElement.Count-1 do
  begin
    lElement1 := lElement.Elements[i];
    lResult := lElement1.value.asInteger=i+1;
    CheckIsTrue(lResult);
  end;
end;

procedure TestGenericElementJson.Test_Generic_Element_From_JSON_Returns_Mixed_Arrays;
var lElement, lElement1: TElement;
    lJSON : string;
    lResult : Boolean;
    lExpected : string;
    lExpectedInt: integer;
    lExpectedSingle: Single;
begin
  lExpectedInt := 1;
  lExpectedSingle := 2.3;  // rounding

  lJSON := Format('["Test1","Test2",1,%s]',[lExpectedSingle.ToString]);
  lElement := TElement.FromJSON(lJSON);
  checkisTrue(lElement.Count=4);

  lExpected := 'Test1';
  lElement1 := lElement.Elements[0];
  lResult := lExpected=lElement1;
  CheckisTrue(lResult);

  lExpected := 'Test2';
  lElement1 := lElement.Elements[1];
  lResult := lExpected=lElement1;
  CheckisTrue(lResult);

  lElement1 := lElement.Elements[2];
  lResult := lExpectedInt = lElement1.AsInteger;
  CheckisTrue(lResult);

  lElement1 := lElement.Elements[3];
  lResult := lExpectedSingle = lElement1.AsSingle;
  CheckisTrue(lResult);

end;

procedure TestGenericElementJson.Test_Generic_Element_From_JSON_Returns_Multiple_Objects;
var lElement: TElement;
    lJSON,
    lResult,
    lExpectedName,
    lExpectedName0,
    lExpectedName1,
    lExpectedValue : String;
    lExpectedInt,
    lIntResult       :integer;
begin
  lJSON := '{"Test":[{"Fred":3},{"John":"Test1"}]}';

  lExpectedName := 'Test';
  lExpectedName0 := 'Fred';
  lExpectedName1 := 'John';

  lExpectedInt := 3;
  lExpectedValue := 'Test1';

  lElement := TElement.FromJSON(lJSON);

  checkIstrue(lElement.Count=2);

  CheckIsTrue(lELement.Value.IsEmpty);
  CheckIsTrue(lELement.Elements[0].Value.IsEmpty);
  CheckIsTrue(lELement.Elements[1].Value.IsEmpty);

  CheckIsTrue(lELement.Value.IsObject);
  CheckIsTrue(lELement.Elements[0].isObject);
  CheckIsTrue(lELement.Elements[1].isObject);

  CheckIsTrue(not lELement.ContainsObjects);
  checkIsTrue(lElement.Elements[0].ContainsObjects);
  checkIsTrue(lElement.Elements[1].ContainsObjects);

  checkValue(lExpectedName, lElement.Name);
  checkValue(lExpectedName0, lElement.Elements[0].Name);
  checkValue(lExpectedName1, lElement.Elements[1].Name);

  lIntResult := lElement.Elements[0].AsInteger;
  lResult := lElement.Elements[1];

  CheckIsTrue(lElement.Value.IsEmpty);
  checkValue(lExpectedInt, lIntResult);
  checkValue(lExpectedValue, lResult);

end;

procedure TestGenericElementJson.Test_Generic_Element_From_JSON_Returns_Single_Boolean_Element;
var lElement: TElement;
    lResult: Boolean;
    lJSON : string;
begin
  lJSON := 'False';
  lElement := TElement.FromJSON(lJSON);
  lResult := lElement.value.asBoolean;
  checkIsTrue(Not lResult);

  lElement.Clear;
  lJSON := 'True';
  lElement := TElement.FromJSON(lJSON);
  lResult := lElement.value.asBoolean;
  checkIsTrue( lResult);

end;

procedure TestGenericElementJson.Test_Generic_Element_From_JSON_Returns_Single_Double_Element;
var lElement: TElement;
    lJSON   : string;
    lExpected : Double;
begin
  lJSON := '2.123456678';
  lElement := TElement.FromJSON(lJSON);
  lExpected := 2.123456678;
  checkvalue(lExpected, lElement.value);
end;


procedure TestGenericElementJson.Test_Generic_Element_From_JSON_Returns_Single_Int64_Element;
var lElement: TElement;
    lJSON   : string;
    lResult : Boolean;
begin
  lJSON := '2147483700';
  lElement := TElement.FromJSON(lJSON);
  lResult := lElement.AsInt64 = 2147483700;
  checkIsTrue(lResult);
end;

procedure TestGenericElementJson.Test_Generic_Element_From_JSON_Returns_Single_Integer_Element;
var lElement: TElement;
    lJSON   : string;
    lExpected : Integer;
begin
  lJSON := '5';
  lElement := TElement.FromJSON(lJSON);
  lExpected := 5;
  checkvalue(lExpected, lElement.value);
end;

procedure TestGenericElementJson.Test_Generic_Element_From_JSON_Returns_Single_Object;
var lElement: TElement;
    lJSON   : string;
    lExpectedName : String;
    lExpectedValue,
    lResult    :integer;
begin
  lJSON := '{"Fred":3}';
  lElement := TElement.FromJSON(lJSON);

  lExpectedName := 'Fred';
  lExpectedValue := 3;
  checkvalue(lExpectedName, lElement.Name);
  lResult := lElement.Value.AsInteger;
  CheckValue(lExpectedValue,lResult);
end;

procedure TestGenericElementJson.Test_Generic_Element_From_JSON_Returns_Single_Single_Element;
var lElement: TElement;
    lJSON   : string;
    lExpected : single;
begin
  lJSON := '2.3';
  lElement := TElement.FromJSON(lJSON);
  lExpected := 2.3;
  checkvalue(lExpected, lElement.value);
end;

procedure TestGenericElementJson.Test_Generic_Element_From_JSON_Returns_Single_String_Element;
var lElement: TElement;
    lJSON, lExpected : string;
begin
  lJSON := '"ABC"';
  lElement := TElement.FromJSON(lJSON);
  lExpected := '';
  checkvalue(lExpected, lElement.Name);
  lExpected := 'ABC';
  checkvalue(lExpected, lElement.value);
end;

procedure TestGenericElementJson.Test_Generic_Element_From_JSON_Returns_String_Arrays;
var lElement, lElement1: TElement;
    lJSON : string;
    lResult : Boolean;
    lExpected : string;
    i: integer;
begin
  lJSON := '["Test1"]';
  lElement := TElement.FromJSON(lJSON);
  checkisTrue(lElement.Count=1);

  lExpected := 'Test1';
  lElement1 := lElement.Elements[0];
  lResult := lExpected=lElement1;
  CheckIsTrue(lResult);

  lElement.Clear;
  lJSON := '["Test1","Test2"]';
  lElement := TElement.FromJSON(lJSON);
  checkValue(true,lElement.Count=2);
  for i := 0 to lElement.Count-1 do
  begin
    lElement1 := lElement.Elements[i];
    lResult := 'Test'+(i+1).toString=lElement1;
    CheckisTrue(lResult);
  end;


end;

initialization
  // Register any test cases with the test runner
  {$IFNDEF DUNITX}
    RegisterTest(TestGenericElement.Suite);
    RegisterTest(TestGenericElementJson.Suite);
  {$ELSE}
   TDUnitX.RegisterTestFixture(TestGenericElement);
   TDUnitX.RegisterTestFixture(TestGenericElementJson);
  {$ENDIF}


end.
