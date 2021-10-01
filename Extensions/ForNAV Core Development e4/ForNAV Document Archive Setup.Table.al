table 6189104 "ForNAV Document Archive Setup"
{
    DataClassification = SystemMetadata;
    Caption = 'ForNAV Document Archive Setup';

    fields
    {
        field(1;"Report ID";Integer)
        {
            Caption = 'Id';
            DataClassification = SystemMetadata;
            TableRelation = "ForNAV Report Object";
            ValidateTableRelation = false;

            trigger OnValidate()var AllObj: Record AllObj;
            begin
                if "Report ID" <> 0 then begin
                    AllObj.Get(AllObj."Object Type"::Report, "Report ID");
                    CalcFields("Report Name");
                end
                else
                    "Report Name":='*';
            end;
        }
        field(2;"Report Name";Text[250])
        {
            Caption = 'Report Name';
            FieldClass = FlowField;
            CalcFormula = lookup(AllObj."Object Name" where("Object Type"=const(Report), "Object ID"=field("Report ID")));
            Editable = false;
        }
    }
    keys
    {
        key(PK;"Report ID")
        {
            Clustered = true;
        }
    }
}
