Table 6188480 "ForNAV Report Usage Statistics"
{
    fields
    {
        field(1;"Entry No.";Integer)
        {
            AutoIncrement = true;
            DataClassification = CustomerContent;
        }
        field(2;"Report ID";Integer)
        {
            DataClassification = SystemMetadata;
        }
        field(4;"Report Caption";Text[250])
        {
            CalcFormula = lookup(AllObjWithCaption."Object Caption" where("Object Type"=const(Report), "Object ID"=field("Report ID")));
            Caption = 'Report Caption';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5;"User ID";Code[50])
        {
            DataClassification = EndUserIdentifiableInformation;
        }
        field(6;"Date Time Printed";DateTime)
        {
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(Key1;"Entry No.")
        {
        }
    }
}
