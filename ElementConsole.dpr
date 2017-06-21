program ElementConsole;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  GenericElements in 'GenericElements.pas';

  var strElement: TElement;
      subElement0 : TElement;
      subElementInteger: TElement;
      IntValue: Integer;
begin
  // Report Memory Leaks!! SHOULD NEVER BE ANY ////
  system.ReportMemoryLeaksOnShutdown := true;
  try
    { TODO -oUser -cConsole Main : Insert code here }
     strElement := 'A String';
     Writeln('Type of "'+strElement.ElementType+'" ' + strElement);
     SubElement0 := strElement.AddElement('An Element String');
     Writeln('Type of "'+strElement.ElementType+'" ' +
               'Value "'+strElement.Value.ToString+'" ' +
               'Element 0 "'+subElement0+'"');
     subElement0.AddElement(1);
     subElement0.AddElement(2.2);
     subElement0.AddElement(int64(3));
     subElementInteger := strElement.AddElement(1);
     Writeln('Added Permanent SubElement ' + subElementInteger);
     Writeln(' OR : '#13#10'Start ELEMENT:'#13#10
                 +strElement+#13#10':End ELEMENT');
     Writeln('SubElement0 is now :'+SubElement0);
     Readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
