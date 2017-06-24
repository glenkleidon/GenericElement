unit GenericElements;

interface
uses System.Classes, System.SysUtils, System.Generics.Collections, System.Rtti, System.TypInfo;

type
   TElementValue = TValue;
   TJSONString = String;
   PElement = Pointer;

   TElement = Record
   private
    fName: string;
    procedure SetType;
    function GetName: string;
    procedure SetName(const Value: string);
    function GetParent: TElement;
    procedure SetParent(const Value: TElement);
    function GetElement(AName: string): TElement;
    function getAsPtr: PElement;
    function GetIsEmpty: boolean;
   public
     fParent : PElement;
     Value : TElementValue;
     ElementType: string;
     Elements: TArray<TElement>;
     Methods : TArray<TFunc<TElement,TElement>>;
     IsMetaData: boolean;
     Procedure Clone(const AElementToClone: TElement);
     function Add : PElement;
     Function Clear: TElement;
     Function ClearElements: TElement;
     Function ClearMethods: TElement;
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
     Function AddElement(AElement: TElement):PElement;
     Function AddSubElement(AElement: TElement):PElement;
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
     Property Parent : TElement read GetParent write SetParent;
     Property Element[AName: string] : TElement read GetElement;
     Property AsPointer : PElement read GetAsPtr;
     Property IsEmpty: boolean read GetIsEmpty;
   End;

   TElementMethod = Function(AElement: TElement): TElement;
   PTElement = ^TElement;

   TJsonEncodingOptions = (Default, AsArray, AsObjects,
                              ArrayOfObjecs, ObjectsWithArrays);

   TElementHelper = Record Helper for TElement
     Class Function FromJSON(AJSON: TJSONString): TElement; static;
     Class Function ToJSON(AElement: TElement; AIncludeMeta: boolean=false; AEncodingOptions: TJsonEncodingOptions=Default): TJSONString; static;
   End;

Function JSONEncode(ATExt: String):String;
Function JSONDecode(AText: String):String;

implementation
   uses System.strUtils;
{ TElement }
Function JSONEncode(AText: String):String;
begin
  result := AText;
end;

Function JSONDecode(AText: String):String;
begin
  result := AText;
end;

function TElement.Add: PElement;
var l: integer;
begin
   l:= length(Self.Elements);
   setlength(Self.Elements, l+1);
   self.Elements[l].fParent := @Self;
   Result := @self.Elements[l];
end;

Function TElement.AddElement(AElement: TElement):PElement;
var lELement: ^TElement;
begin
  Result := @Self;
  lElement := Add;
  lElement.Clone(AElement);
end;

function TElement.AddSubElement(AElement: TElement): PElement;
var lELement: ^TElement;
begin
  Result := Add;
  lElement := Result;
  lElement.Clone(AElement);
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

function TElement.Clear: TElement;
begin
  fName := '';
  ElementType := '';
  fParent := nil;
  Value := nil;
  IsMetaData := false;
  setlength(Elements,0);
  setlength(Methods,0);
end;

function TElement.ClearElements: TElement;
begin
  setlength(Elements,0);
end;

function TElement.ClearMethods: TElement;
begin
  setlength(Methods,0);
end;

procedure TElement.Clone(const AElementToClone: TElement);
Var i,lMax:integer;
begin
  Self.Name := AElementToClone.Name;
  Self.Value := AElementToClone.Value;
  Self.IsMetaData := AElementToClone.IsMetaData;
  self.ElementType := AElementToClone.ElementType;

// Elements
  SetLength(Self.Elements,AElementToClone.Count);
  lMax := Self.Count-1;
  for i := 0 to lMax do
     Self.Elements[i].Clone(AElementToClone.Elements[i]);

  SetLength(Self.Methods,AElementToClone.MethodCount);
  lMax := Self.MethodCount-1;
  for i := 0 to lMax do
     Self.Methods[i] := AElementToClone.Methods[i];



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

function TElement.getAsPtr: PElement;
begin
  result := @self;
end;

function TElement.GetElement(AName: string): TElement;
begin

end;

function TElement.GetIsEmpty: boolean;
begin
  result := (Value.IsEmpty) and
            (Count=0) and
            (MethodCount=0);
end;

function TElement.GetName: string;
begin
  Result := Self.fName;
end;

function TElement.GetParent: TElement;
var lParent: ^TElement;
begin
   lParent := fParent;
   result := lParent^;
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
  result := length(Self.Methods);
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
begin
  self.fName := Value;
  if TryStrToFloat(Value,lNum) then self.fName:='_'+Value;
end;

procedure TElement.SetParent(const Value: TElement);
begin
   self.fParent := @Value;
end;

procedure TElement.SetType;
begin
  if (length(self.Methods)>0) or
     (length(self.Elements)>0) then Self.ElementType := 'TElement'
  else Self.ElementType := string(Self.Value.TypeInfo.Name);
end;

{ TElementHelper }


class function TElementHelper.FromJSON(AJSON: TJSONString): TElement;
Type TJSONState = (Nothing, InObject, InArray, InData, InQuote);
const JSONCHARS = '":{}[]';
var
    P,Q,C,JLength : Integer;
    lElement : PTElement;
    JSONCharIndex: Integer;
    JState: TJSONState;
    Text: string;
    lStack: TStack<TJSONState>;

    Function NextChar: Boolean;
    var ch : char;
        llPos, llMin,i: integer;
    begin
      // finds the next JSON Control Character
      Result := false;
      if (P>JLength) then exit;

      if JState=TJSONState.InQuote then
      begin
        JSONCharIndex := 1;
        Q := posex('"',AJSON,P);
        if Q>0 then Result := True;
        exit;
      end;
      llMin := MaxInt;
      JSONCharIndex := 0;
      for i := 1 to 6 do
      begin
        ch := JSONCHars[i];
        llPos := posex(ch,AJSON,P);
        if (llpos>0) and (llPOS<llMin) then
        begin
          llMin := llPos;
          JSONCharIndex := i;
          if (llPos=P) then break;   // optomisation
        end;
      end;
      if JSONCharIndex>0 Then
      begin
       Q := llPOS;
       Result := true;
      end;
    end;

    Procedure AddUnquotedText;
    Var lList:TStringlist;
        sol,s: String;
        lp: integer;
        lSingle: Single;
        lDouble: Double;
        lNumber: Extended;
    begin
     if Text.Length>0 then
     begin
       // if there is NON white space, then this is Ordinal or Number
       // data - need to add all separated by Commas to the current elements.
       lList:=TStringlist.Create;
       try
         lList.Delimiter := ',';
         lList.DelimitedText := Text;
         for sol in lList do
         begin
           s := sol.Replace(' ','',[rfReplaceAll])
                 .Replace(#13,'',[rfReplaceAll])
                 .Replace(#10,'',[rfReplaceAll])
                 .Replace(#9 ,'',[rfReplaceAll]);
           if (s.ToLower='false') then
              lElement.AddElement(false)
           else if (s.ToLower='true') then
              lElement.AddElement(true)
           else
           begin
             lp :=pos('.',s);
             if lp>0 then
             begin
               if TryStrToFloat(s,lDouble) then
               begin
                 if (s.Length-lp-1) > 6 then
                   lElement.AddElement(lDouble)
                 else
                 begin
                  if tryStrToFloat(s,lSingle) then
                    lElement.AddElement(lSingle)
                  else
                    lElement.AddElement(lDouble);
                 end;
               end else
               begin
                 // JSON Error;
               end;
             end else if TryStrToFloat(s,lNumber) then
             begin
               if (lNumber<MaxInt) and (lNumber>-MaxInt) then
               begin
                  lElement.AddElement(StrToInt(s));
               end else lElement.AddElement(lNumber);
             end else
             begin
               //JSONError;
             end;
           end;
         end;

       finally
         freeandnil(lList);
       end;
     end
    end;

begin
   P:=1;
   JLength := AJSON.Length;
   lElement := Nil;
   lStack := TStack<TJSONState>.Create;
   try
     lStack.Push(TJSONState.Nothing);
     while NextChar do
     begin
       c:= Q-P;
       Text := Copy(AJSON, P, C);
       p := Q;
       JState := lStack.Peek;
       case JSONCharIndex of
         1 : // QUOTE - need to add a string to the current Element
             begin
               if (JState=InQuote) then
               begin
                 lStack.Pop;
                 JState := lStack.Peek;
                 case Jstate of
                   TJSONState.Nothing:
                     Begin
                       if lElement=nil then
                       begin
                         lElement := @Result;
                         Result := JSONDecode(Text);
                       end
                       else lElement.AddElement(JSONDecode(Text));
                     end;
                   TJSONState.InObject:
                     lElement.Name := JSONDecode(text);
                   TJSONState.InData:
                     begin
                       JState := lStack.Peek;
                       if JState<>InObject then
                       begin
                         // Faulty JSON..
                       end
                       else
                       begin
                         lELement.value := JSONDecode(Text);
                       end;
                     end;
                   TJSONState.InArray:
                      lElement.AddElement(JSONDecode(Text));
                 else
                   Begin
                     // Faulty JSON..
                   end;
                 end;
               end else
               begin
                 JState := TJSONState.InQuote;
                 lStack.Push(TJSONState.InQuote);
               end;
             end;
         2 : // DataStart
             begin
               // Waiting for Data element.
               if (JState<>TJSONState.InObject) or (lElement=nil) or (lElement.Name.Length=0) then
               begin
                 // Faulty JSON
               end;
               lStack.Push(TJSONState.InData);
             end;
         3 : // Left Brace
             begin
               // Starting New Object
               if not (Jstate in [Nothing, InData, InArray]) then
               begin
                 // JSON Error
               end else if text.Length>0 then
               begin
                  // check for Data - probably OK to ignore it though
               end else
               begin
                 if lElement=nil then
                    lElement := @Result
                 else
                    lElement := lElement.Add;
                 lStack.Push(TJSONState.InObject);
               end;
             end;
         4 : // Right Brace
             begin
               // End of an Object
               lStack.Pop;
               lElement := lElement.Parent.AsPointer;
             end;
         5 : // Left Square Bracket
             begin
               // Starting a new Array
               // Indicates that we need to use the Elements to Add new data
               AddUnquotedText;
               lStack.Push(TJSONState.InArray);
             end;
         6 : // Right Square Bracket
             begin
               // Ending an Array
               // Indicates we need to stop using this Element, and return
               // to the parent object
               AddUnquotedText;
               lStack.Pop;
               lElement := lElement.Parent.AsPointer;
             end;
       end; // case
       inc(P);
     end;
     if P=1 then
     begin
       lElement := @Result;
       Text := AJSON;
       AddUnquotedText;
       if Result.Count=1 then
       begin
         Result.value := Result.Elements[0].Value;
       end else Result.Clear;
     end;
   finally
     Freeandnil(lStack);
   end;


end;


class function TElementHelper.ToJSON(AElement: TElement; AIncludeMeta: boolean;
   AEncodingOptions: TJsonEncodingOptions): TJSONString;
var lSb : TStringBuilder;
    lEndchars, lSeparator : string;
    lElement : TElement;
    lHasName: boolean;
begin
  Result := '';
  if (not(AIncludeMeta) and AElement.isMetaData) then exit;

  lHasName :=  Trim(AElement.Name).length>0;

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
    if (AElement.Count>1) then
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
    lSeparator := '';
    for lElement in AElement.Elements do
    begin
       // need a to go one layer deeper here so we
       // can pass the same builder into each iteration,
       // but for now we'll return the string
       lSb.Append(lSeparator);
       lSb.Append(lElement.ToJSON(lElement, AIncludeMeta));
       lSeparator := ',';
    end;
    lsb.Append(lEndChars);
    Result := lSb.ToString();
  finally
    freeandnil(lSb);
  end;

end;

end.
