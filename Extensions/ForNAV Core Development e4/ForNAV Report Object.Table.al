table 6189183 "ForNAV Report Object"
{
    DataClassification = ToBeClassified;
    LookupPageId = "ForNAV Report Objects";

    fields
    {
        field(1;"ID";Integer)
        {
            Caption = 'ID';
            DataClassification = SystemMetadata;
        }
        field(3;Name;Text[250])
        {
            Caption = 'Name';
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(PK;"ID")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown;"ID", Name)
        {
        }
    }
}
