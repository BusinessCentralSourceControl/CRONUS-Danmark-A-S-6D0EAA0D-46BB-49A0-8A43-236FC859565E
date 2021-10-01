Table 6188473 "ForNAV Web Service"
{
    Caption = 'Web Service', Comment='DO NOT TRANSLATE';

    fields
    {
        field(3;"Object Type";Option)
        {
            Caption = 'Object Type', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
            OptionCaption = ',,,,,Codeunit,,,Page,Query', Comment='DO NOT TRANSLATE';
            OptionMembers = , , , , , "Codeunit", , , "Page", "Query";
        }
        field(6;"Object ID";Integer)
        {
            Caption = 'Object ID', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
            TableRelation = AllObjWithCaption."Object ID" where("Object Type"=field("Object Type"));
        }
        field(9;"Service Name";Text[240])
        {
            Caption = 'Service Name', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(12;Published;Boolean)
        {
            Caption = 'Published', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(Key1;"Object Type", "Service Name")
        {
        }
        key(Key2;"Object Type", "Object ID")
        {
        }
    }
}
