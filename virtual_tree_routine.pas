unit virtual_tree_routine;

interface
  uses directum_metadata;

type
 PVSTRecord = ^TVSTRecord;
 TVSTRecord = record
  node_type : TMetadataObjectType;
  number    : Integer;
  object_pointer: Pointer;
  text      : string;

  column1 : string;
  column2 : string;
  column3 : string;
 end;




implementation

end.
