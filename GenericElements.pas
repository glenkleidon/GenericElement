unit GenericElements;

interface
uses System.Classes, System.SysUtils, System.Generics.Collections, System.Rtti, System.TypInfo;

type
   TElementValue = TValue;
   TJSONString = String;

   TElement = Record
   private
    fName: string;
    procedure SetType;
    function GetName: string;
    procedure SetName(const Value: string);
   public
     Value : TElementValue;
     ElementType: string;
     Elements : TArray<TElement>;
     Methods : TArray<TFunc<TElement,TElement>>;
     IsMetaData: boolean;
     Parent : Pointer;
     Function AddElement(AElement: TElement): TElement;
     Function AddSubElement(AElement: TElement): TElement;
     Function AsByte:Byte;  // no implicit casting
     Function AsChar:Char;
     Function AsSingle: Single;
     Function AsDouble: Double;
     Function AsCurrency: Currency;
     Function AsExtended: Extended;
     Function AsInteger: Integer;
     Function AsInt64: Int64;
     Function Count : integer;
     Function MethodCount: integer;
     Function MetadataCount: integer;
     Class Operator Implicit(AChar : char): TElement;
     Class Operator Implicit(AByte : byte): TElement;
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
     Property Name : string read GetName write SetName;
   End;

   TElementMethod = Function(AElement: TElement): TElement;


   TElementHelper = Record Helper for TElement
     Class Function FromJSON(TJSONString: string): TElement; static;
     Class Function ToJSON(AElement: TElement; AIncludeMeta: boolean=false): TJSONString; static;
   End;

implementation

{ TElement }

function TElement.AddSubElement(AElement: TElement): TElement;
var l:integer;
begin
   l:= length(Self.Elements);
   AElement.Parent := @self;
   setlength(Self.Elements, l+1);
   self.Elements[l] := AElement;
   Self.ElementType := 'TElement';
   Result := Self.Elements[l]; // in case in the future, that might include
                               // cloning step
end;

function TElement.AddElement(AElement: TElement): TElement;
begin
  result := self;
  addSubElement(AElement);
end;

function TElement.AsByte: Byte;
begin
  Result := 0;
  Value.TryAsType<byte>(Result);
end;

function TElement.AsChar: Char;
begin
  result := #0;
  Value.TryAsType<char>(Result);
end;

function TElement.AsCurrency: Currency;
begin
  result := 0;
  Value.TryAsType<Currency>(Result);
end;

function TElement.AsDouble: Double;
begin
  result := 0;
  Value.TryAsType<Double>(Result);
end;

function TElement.AsExtended: Extended;
begin
  result := 0;
  Value.TryAsType<Extended>(Result);
end;

function TElement.AsInt64: Int64;
begin
  result := 0;
  Value.TryAsType<Int64>(Result);
end;

function TElement.AsInteger: Integer;
begin
  result := 0;
  Value.TryAsType<Integer>(Result);
end;

function TElement.AsSingle: Single;
begin
  result := 0;
  Value.TryAsType<Single>(Result);
end;

function TElement.Count: integer;
begin
  result := length(Self.Elements);
end;

constructor TElement.Create(AName: string; const AValue: TValue);
begin
  Self.Name := AName;
  Self.Value := AValue;
end;


function TElement.GetName: string;
begin
  Result := Self.Name;
end;

class operator TElement.Implicit(ABoolean: Boolean): TElement;
begin
  Result.Name := '';
  Result.Value := ABoolean;
  Result.setType;
  Result.ElementType:='Boolean';
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

function TElement.MetadataCount: integer;
var lElement: TElement;
begin
  Result := 0;
  for lElement in Elements do
    if lElement.IsMetaData then inc(Result);
end;

function TElement.MethodCount: integer;
begin
  self.Count
end;

class operator TElement.Implicit(AChar: char): TElement;
begin
  result.Name := '';
  result.Value := Achar;
  Result.SetType;
end;

class operator TElement.Implicit(AByte: byte): TElement;
begin
  Result.Name := '';
  Result.Value := AByte;
  Result.SetType;
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

procedure TElement.SetName(const Value: string);
var lNum: single;
    lValue: string;
begin
  self.fName := Value;
  if TryStrToFloat(Value,lNum) then self.fName:='_'+Value;
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


class function TElementHelper.ToJSON(AElement: TElement; AIncludeMeta: boolean): TJSONString;
var lSb : TStringBuilder;
    lEndchars : string;
    lElement : TElement;
    lHasName, lHasElements: boolean;
begin
  Result := '';
  if not (AIncludeMeta and AElement.isMetaData) then exit;

  lHasName :=  Trim(AElement.Name).length>0;
  lHasElements := AElement.Count>0;

  if (AElement.ElementType.ToLower='boolean') or
     (AElement.Value.Kind in [tkInteger,tkFloat,tkInt64]) then
  begin
    // Dont need quotes.
    Result := AElement;
  end else
  if AElement.Value.Kind in [tkVariant] then
  begin
    // quite possibly a variant array....
  end else
  begin
    if not AElement.Value.IsEmpty then
        Result := '"'+string(AElement)+'"';
  end;

  if (Not lhasName) and
     (
       (AElement.Count=0) or
       ((Not AIncludeMeta) and (AElement.MetadataCount=AElement.Count))
      )
  Then exit;

  if (lHasName) then
  begin
    lSb := TStringBuilder.Create('{"'+AElement.Name+'":');
    lEndChars := '}';
    if (lHasElements) then
    begin
      lsb.append('[');
      lEndChars := ']'+lEndChars;
    end;
  end else
  begin
    lSb := TStringBuilder.Create('[');
    lEndChars := ']' ;
  end;

  try
    for lElement in AElement.Elements do
    begin
       // need a to go one layer deeper here so we
       // can pass the same builder into each iteration,
       // but for now we'll return the string
       lSb.Append(lElement.ToJSON(lElement, AIncludeMeta));
    end;
    lsb.Append(lEndChars);
    Result := lSb.ToString();
  finally
    freeandnil(lSb);
  end;

end;

end.
