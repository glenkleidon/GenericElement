unit GenericElements;

interface
uses System.Classes, System.SysUtils, System.Generics.Collections, System.Rtti, System.TypInfo;

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
     Class Operator Implicit(AInteger: integer): TElement;
     Class Operator Implicit(AExtended: Extended): TElement;
     Class Operator Implicit(ASingle: Single): TElement;
     Class Operator Implicit(ADouble: Double): TElement;
     Class Operator Implicit(ABoolean: Boolean): TElement;
     Class Operator Implicit(AInt64: Int64): TElement;
     Class Operator Implicit(ACurrency: Currency): TElement;
     // Outbound
     Class Operator Implicit(AElement: TElement): string;
     Constructor Create(AName: string; const AValue: TValue); overload;
   private
     procedure SetType;
   End;

   TElementMethod = Function(AElement: TElement): TElement;


   TElementHelper = Record Helper for TElement
     Class Function FromJSON(TJSONString: string): TElement; static;
     Class Function ToJSON(AElement: TElement): TJSONString; static;
   End;

implementation

{ TElement }

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


class operator TElement.Implicit(ABoolean: Boolean): TElement;
begin
  Result.Name := '';
  Result.Value := ABoolean;
  Result.setType;
end;

class operator TElement.Implicit(ADouble: Double): TElement;
begin
  Result.Name := '';
  Result.Value := ADouble;
  Result.setType;
end;

class operator TElement.Implicit(ACurrency: Currency): TElement;
begin
  Result.Name := '';
  Result.Value := ACurrency;
  Result.setType;
end;

class operator TElement.Implicit(AInt64: Int64): TElement;
begin
  Result.Name := '';
  Result.Value := AInt64;
  Result.setType;
end;

class operator TElement.Implicit(AInteger: integer): TElement;
begin
   Result.Name := '';
   Result.Value := AInteger;
   Result.SetType;
end;

class operator TElement.Implicit(AString: string): TElement;
begin
   Result.Name := '';
   Result.Value := AString;
   Result.setType;
end;

class operator TElement.Implicit(AElement: TElement): string;
var lElement: TElement;
begin
  result := AElement.Value.toString;
  if Length(AElement.Elements)=0 then exit;
  for lELement in AElement.Elements do
   result := Result +  #13#10 + lElement;
end;

class operator TElement.Implicit(AExtended: Extended): TElement;
begin
   result.Name := '';
   result.Value := AExtended;
   Result.SetType;
end;

class operator TElement.Implicit(ASingle: Single): TElement;
begin
  Result.Name := '';
  Result.Value := ASingle;
  Result.SetType;
end;

procedure TElement.SetType;
begin
  if (length(self.Methods)>0) or
     (length(self.Elements)>0) then Self.ElementType := 'TElement'
  else Self.ElementType := string(Self.Value.TypeInfo.Name);
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
