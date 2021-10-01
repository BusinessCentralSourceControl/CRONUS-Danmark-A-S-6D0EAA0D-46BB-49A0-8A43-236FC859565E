table 6188503 "ForNAV Layout Selection"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1;"Report ID";Integer)
        {
            Caption = 'Report ID';
            DataClassification = SystemMetadata;
            TableRelation = "ForNAV Report Object";
            ValidateTableRelation = false;
            NotBlank = true;

            trigger OnValidate()begin
                CalcFields("Report Name");
            end;
        }
        field(2;"Report Name";Text[50])
        {
            Caption = 'Report Name';
            FieldClass = FlowField;
            CalcFormula = lookup(AllObj."Object Name" where("Object Type"=const(Report), "Object ID"=field("Report ID")));
            Editable = false;
        }
        field(3;"Custom Report Layout Code";Code[20])
        {
            Caption = 'Custom Report Layout Code';
            DataClassification = SystemMetadata;
            TableRelation = "Custom Report Layout" WHERE("Report ID"=FIELD("Report ID"));
        }
        field(4;"Report Layout Description";Text[250])
        {
            CalcFormula = Lookup("Custom Report Layout".Description WHERE(Code=FIELD("Custom Report Layout Code")));
            Caption = 'Report Layout Description';
            FieldClass = FlowField;
            NotBlank = true;
        }
        field(5;"Table No.";Integer)
        {
            Caption = 'Table No.';
            DataClassification = SystemMetadata;
        }
        field(7;"Field No.";Integer)
        {
            TableRelation = "ForNAV Field"."No." where("Table No."=field("Table No."));
            ValidateTableRelation = false;
            Caption = 'Field No.';
            DataClassification = SystemMetadata;

            trigger OnValidate()begin
                CalcFields("Field Name");
            end;
        }
        field(8;"Field Name";Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Field.FieldName where(TableNo=field("Table No."), "No."=field("Field No.")));
            Editable = false;
        }
        field(9;"Value";Code[50])
        {
            Caption = 'Value';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK;"Report ID", "Custom Report Layout Code", "Table No.", "Field No.")
        {
            Clustered = true;
        }
    }
}
