unit directum_metadata;

interface

uses classes, SQLExpr, routine_strings, SysUtils; //DBXMSSQL;

type
   TMetadataObjectType = (
    reference_type,
    document_type,
    section_type,
    actions_section_type,
    requisite_action_type,
    reference_requisite_type,
    document_requisite_type,
    view_type,
    folder_type,
    requisite_type,
    action_type,
    control_type
     );


implementation



end.
