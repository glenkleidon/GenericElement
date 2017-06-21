unit GenericElementTest;

interface

uses
  {$IFNDEF DUNITX}
  TestFramework,
  {$ELSE}
  DUnitX.TestFramework,DUnitX.DUnitCompatibility,
  {$ENDIF}
  GenericElements
  ;

  Type
  TestGenericElement = class(TTestCase)
  private
  public
  published
    procedure Test_Generic_interface_Implicit_To_String_passes;
  end;


implementation

{ TestGenericElement }

procedure TestGenericElement.Test_Generic_interface_Implicit_To_String_passes;
var lElement: TElement;
    lExpected, lResult : string;
begin
   lExpected := 'This is a string';
   lElement := lExpected;
   lResult := lElement;
   check(lResult = lExpected, 'Expected : '+lExpected + #13#10 +
                               'Actual   : '+Lresult);
end;

initialization
  // Register any test cases with the test runner
  {$IFNDEF DUNITX}
    RegisterTest(TestGenericElement.Suite);
  {$ELSE}
   TDUnitX.RegisterTestFixture(TestGenericElement);
  {$ENDIF}


end.
