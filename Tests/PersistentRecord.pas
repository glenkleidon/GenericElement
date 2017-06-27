unit PersistentRecord;
 {
   Persistent Record Structure - Experimental.
   COPYRIGHT : Glen Kleidon 2017 - All rights reserved.
 }
interface
 uses System.Classes, System.SysUtils, System.Generics.Collections, System.Rtti, System.TypInfo;

 Type
   PElement = Pointer;
   PPersisentSource = Pointer;

   TPersistentReferenceAction = (Start, Close, Extend, Ascend, Descend);

   TPersistentSource<T> = Record
      DataIndex: integer;
      StringIndex: integer;
      Source: T;
      procedure Clear;
      function Data: string;
      function DataSize: integer;
      function Size : integer;
     private
      function NextText: string;
   end;

   TPointerStack = Record
     Parent : PElement;
     Element : PElement;
     ElementStack : TArray<PElement>;
     Procedure Clear;
     Procedure Ascend;
     Procedure Descend(const NewElement: PElement);
   end;

   TPersistentReference<T> = Record
     State : integer;
     TypeOf : TValue;
     ItemIndex: Integer;
     Size: Integer;
     NewSize: Integer;
     Stack : TPointerStack;
     Source : TPersistentSource<T>;
     Action: TPersistentReferenceAction;
     Procedure Clear;
   End;

{   TPersistentReferenceHelper = Record helper for TPersistentReference<T>
      Class function New(ASource : PPersisentSource; AType: TClass) : TPersistentReference<T>;
   end;
}
  TPersistentRecord<ElementT,PersistT> = Record
  private
    fPersist : PersistT;
  public
    Root : ElementT;
    Property Persist: PersistT Read fPersist;
    Property Constructing : TFunc<PersistT,Boolean>;
  End;

{
  TPersistentRecordHelper = Record Helper for TPersistentRecord<T>
  end;
}

  TDemoElement = record
     Name : string;
     Value : Integer;
     Elements : TArray<TDemoElement>
  end;


Procedure DemonstratePeristence;
Function ArrayOfArrays(AReference: PTPersistentReference; ASource: string): boolean;
implementation

Function ArrayOfArrays(AReference: PTPersistentReference; ASource: string): boolean;
  // Ordinarily we would publish this type, but we dont want to clutter the
  // real space.
  Type TArrayOfArrayState = (Starting, SemiColonLevel, CommaLevel, DashLevel);
  const TArrayOfArraysChars = ';,-';
  var lCurrentRecord : PTPersistentDemoRecord;
      lCurrentState : TArrayOfArrayState;
      lMaxString : integer;
      lText: string;

  function Next: string;
  var p: integer;
      index,CharPos,
      I: Integer;
  begin
   Result := '';
   CharPos := MaxInt;
   index := -1;
   for I := 1 to 3 do
   begin
     p := pos(TArrayOfArraysChars[i],ASource,AReference.StringIndex);
     if p>0 then
     begin
       if p<CharPos then
       begin
         CharPos:=p;
         index := i;
         if (p=AReference.StringIndex) then exit; //optimisation
       end;
     end;
     if index=-1 then
       CharPos := Maxint-1  // keep existing state
     else
       AReference.State := index;
     Result := copy(ASource,AReference.StringIndex,CharPos-1)
               .Replace(' ','',[rfReplaceAll])
               .Replace(#13,'',[rfReplaceAll])
               .Replace(#10,'',[rfReplaceAll])
               .Replace(#9,'' ,[rfReplaceAll]) ;
     AReference.StringIndex := CharPos+1;
   end;

  end;

  Function Count(ADelimiter: string): Integer;
  var ll,
      pp:integer;
  begin
    result := 0;
    pp := 1;
    while pos(Adelimiter,ASource,pp)>0 do
    begin
       inc(Result);
       inc(pp);
    end;
  end;

begin
  // Returns an Array of Arrays from structure '1,2-7-8,3;4,5,6';
  Result := True;
  lMaxString := ASource.Length;

  lCurrentRecord := AReference.Element;
  if AReference.Action=Start then
  Begin
     // Now, How many elements do we need to start work?
     // In this case, we could predict the number total number of elements
     // at this level.  IN other Types eg JSON or XML, you cant predict.
     // but that is OK.  So, I'll do the first level but let the rest be
     // dynamic.
     AReference.NewSize := Count(';');
     AReference.State := ord(TArrayOfArrayState.Starting);
     AReference.Action := Descend;
     Exit;
  end;
  while Areference.StringIndex<=lMaxString do
  begin
    lText := Next;
    lCurrentState := TArrayOfArrayState(AReference.State);
    case lCurrentState of
       Starting,SemiColonLevel:
       begin
       end;
       CommaLevel :
       begin
         if AReference.ItemIndex>=AReference.Size then
         begin
           AReference.Action := Hold;

         end;

       end;
       DashLevel :
       begin
       end;
    end;
  end;



end;


Procedure DemonstratePeristence;
var lRecord: TPersistentDemoRecord;
    lReference: TPersistentReference;
    lDelimitedString: String;
    lCurrentObject : PTPersistentDemoRecord;
begin
  lDelimitedString := '1,2,3-4-5,6;7,8,9-10-11-12;';
  lReference.Clear;
  lReference.Descend(@lRecord);
  lRecord.ContructFromString := ArrayOfArrays;
  while (lRecord.ContructFromString(@lReference,lDelimitedString)) do
  begin
    lCurrentObject := lReference.Element;
    case lReference.Action of
       Ascend: lReference.Ascend;
       Descend:
         begin
          if lReference.ItemIndex>=lCurrentObject.Count then
              setlength(lCurrentObject.Elements,lReference.ItemIndex+1);
          setlength(lCurrentObject[lReference.ItemIndex], lReference.Size);
          lCurrentObject := @lCurrentObject[lReference.ItemIndex];
          lReference.ItemIndex := -1;
          lReference.Descend(lCurrentObject);
          continue;
         end;
       Close:;
    end;
    setLength(lCurrentObject[lReference.ItemIndex], lReference.Size);
  end;


end;


{ TPersistentReference }

procedure TPersistentReference.Clear;
begin
   State :=0;
   TypeOf := Nil;
   ItemIndex := -1;
   Size :=0;
   NewSize :=0;
   Action := Start;

end;


{ TPersistentDemoRecord }

function TPersistentDemoRecord.GetLength: Integer;
begin
   result := length(Elements);
end;

{ TPersistentString }

procedure TPersistentString.Clear;
begin
   DataIndex :=0;
   StringIndex := 0;
   Source := '';
end;

function TPersistentString.Data: string;
begin
  result := Self.StringIndex-Self.DataIndex;
  if Result<0 then Result := 0;
end;

function TPersistentString.DataSize: integer;
begin

end;

function TPersistentString.NextText: string;
begin
  Result := Copy(Source,DataIndex,DataSize);
  DataIndex := StringIndex;
end;

{ TPointerStack }

procedure TPointerStack.Ascend;
var l:integer;
begin
   l:= length(ElementStack)-1;
   if l<0 then exit;

   setlength(ElementStack,l);
   l := l -1;
   Element := ElementStack[l];
   if l>0 then Parent := ElementStack[l-1] else Parent := Nil;
end;

procedure TPointerStack.Clear;
begin
  self.Parent := nil;
  self.Element := Nil;
  setlength(ElementStack,0);
end;

procedure TPointerStack.Descend(const NewElement: PElement);
var l: Integer;
begin
   l := length(ElementStack);
   Setlength(ElementStack,l+1);
   ElementStack[l] := NewElement;
   Element := ElementStack[l];
   if l>0 then Parent := ElementStack[l-1] else Parent := Nil;
end;

{ TPersistentReferenceHelper }

class function TPersistentReferenceHelper.New(
  const ASource: PPersisentSource): TPersistentReference;
begin
  Result.Clear;
  Result.Source := ASource;
end;

end.
