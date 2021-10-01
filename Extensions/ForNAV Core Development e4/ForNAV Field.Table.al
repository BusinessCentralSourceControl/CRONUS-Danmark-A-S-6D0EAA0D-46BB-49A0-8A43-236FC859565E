table 6189182 "ForNAV Field"
{
    DataClassification = ToBeClassified;
    LookupPageId = "ForNAV Fields";

    fields
    {
        field(1;"Table No.";Integer)
        {
            Caption = 'Table No.';
            DataClassification = SystemMetadata;
        }
        field(2;"No.";Integer)
        {
            Caption = 'No.';
            DataClassification = SystemMetadata;
        }
        field(3;Name;Text[50])
        {
            Caption = 'Name';
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(PK;"Table No.", "No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown;"No.", Name)
        {
        }
    }
}
