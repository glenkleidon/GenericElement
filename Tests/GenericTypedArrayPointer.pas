unit GenericTypedArrayPointer;

interface
  uses System.Classes, System.SysUtils, System.Generics.Collections,
       System.Rtti, System.TypInfo;

  Type

  PTypedArray = Pointer;

  TTypedArray = Record
     Elements : TArray<PTypedArray>;
  End;

  TTypedElement = ^TTypedArray;


implementation

end.
