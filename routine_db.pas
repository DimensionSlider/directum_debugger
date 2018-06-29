unit routine_db;

interface

uses Messages, Dialogs, SqlExpr;

function FieldID( name:string; query:TSQLQuery ):integer;

implementation



function FieldID( name:string; query:TSQLQuery ):integer;
var
  i:integer;
  all_names:string;
begin
  result := query.FieldList.IndexOf( name );
  if result = -1 then
  begin
    result := 0;
    ShowMessage(  'Столбец не найден ' + name + #13 + 'Возможные имена: ' + #13 + query.FieldList.Text );
  end;
  
end;

end.
