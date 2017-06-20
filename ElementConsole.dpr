program ElementConsole;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  GenericElements in 'GenericElements.pas';

  var strElement: TElement;
      subElement0 : TElement;
begin
  try
    { TODO -oUser -cConsole Main : Insert code here }
     strElement := 'A String';
     Writeln(string(strElement));
     SubElement0 := strElement.AddElement('An Element String');
     Writeln('Type of "'+strElement.ElementType+'" +' +
               'Value "'+strElement.Value.ToString+'" ' +
               'Element 0 "'+subElement0+'"');
     Writeln(' OR : '+strElement);
     Readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
