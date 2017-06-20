unit GenericElements;

interface
uses System.Classes, System.SysUtils, System.Generics.Collections, System.Rtti;

type
   TElementValue = TValue;
   TJSONString = String;

   TElement = Record
     Value : TElementValue;
     Name : string;
     ElementType: string;
     Elements : TArray<TElement>;
     Methods : TArray<TFunc<TElement,TElement>>;
     Function AddElement(AElement: TElement): TElement;
     Class Operator Implicit(AString: string): TElement;
     Class Operator Implicit(AElement: TElement): string;
     Constructor Create(AString: string); overload;
     Constructor Create(AName: string; const AValue: TValue); overload;
   End;

   TElementHelper = Record Helper for TElement
     Class Function FromJSON(TJSONString: string): TElement; static;
     Class Function ToJSON(AElement: TElement): TJSONString; static;
   End;

implementation

{ TElement }

constructor TElement.Create(AString: string);
begin
  self.Name := '';
  self.Value := AString;
  Self.ElementType := self.Value.TypeInfo.Name;
end;

function TElement.AddElement(AElement: TElement): TElement;
var l:integer;
begin
   l:= length(Self.Elements);
   setlength(Self.Elements, l+1);
   self.Elements[l] := AElement;
   Self.ElementType := 'TElement';
   Result := Self.Elements[l];
end;

constructor TElement.Create(AName: string; const AValue: TValue);
begin
  Self.Name := AName;
  Self.Value := AValue;
end;


class operator TElement.Implicit(AString: string): TElement;
begin
   Result.Name := '';
   Result.Value := AString;
   Result.ElementType := Result.Value.TypeInfo.Name;
end;

class operator TElement.Implicit(AElement: TElement): string;
var lElement: TElement;
begin
  result := AElement.Value.toString;
  if Length(AElement.Elements)=0 then exit;
  for lELement in AElement.Elements do
   result := Result +  #13#10 + lElement;
end;

{ TElementHelper }

class function TElementHelper.FromJSON(TJSONString: string): TElement;
begin
  //
end;


class function TElementHelper.ToJSON(AElement: TElement): TJSONString;
begin
  //
end;

end.
