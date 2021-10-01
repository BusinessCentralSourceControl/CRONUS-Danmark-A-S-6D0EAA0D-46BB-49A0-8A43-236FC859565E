table 6188484 "ForNAV Layout Import Worksheet"
{
    DataClassification = SystemMetadata;

    fields
    {
        field(1;"Report ID";Integer)
        {
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(2;"Report Name";Text[50])
        {
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(3;Description;Text[250])
        {
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(5;"Custom Layout Code";Code[50])
        {
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(10;"Report Exists";Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = exist(AllObj where("Object Type"=const(Report), "Object ID"=field("Report ID")));
            Editable = false;
        }
        field(12;"Existing Report Name";Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(AllObj."Object Name" where("Object Type"=const(Report), "Object ID"=field("Report ID")));
            Editable = false;
        }
        field(15;"Import Action";Option)
        {
            OptionMembers = Skip, Create, Replace;
            DataClassification = SystemMetadata;

            trigger OnValidate()begin
                CalcFields("Report Exists", "Existing Report Name");
                TestField("Report Exists");
                TestField("Existing Report Name");
            end;
        }
        field(21;Blob;Blob)
        {
            DataClassification = SystemMetadata;
            Caption = 'Blob', Comment='DO NOT TRANSLATE';
        }
    }
    keys
    {
        key(PK;"Report ID", "Custom Layout Code")
        {
            Clustered = true;
        }
    }
    procedure SetDefaultAction()var CustRepLayout: Record "Custom Report Layout";
    begin
        "Import Action":="Import Action"::Skip;
        CalcFields("Report Exists", "Existing Report Name");
        if not "Report Exists" then exit;
        "Import Action":="Import Action"::Create;
        if not CustRepLayout.Get("Custom Layout Code")then exit;
        if(CustRepLayout."Company Name" = '') or (CustRepLayout."Company Name" <> CompanyName)then begin
            "Custom Layout Code":=CustRepLayout.GetDefaultCode("Report ID");
            exit;
        end;
        if CustRepLayout."Report ID" = "Report ID" then "Import Action":="Import Action"::Replace;
    end;
    procedure ReplaceLayout()var CustRepLayout: Record "Custom Report Layout";
    RepLayoutSel: Record "Report Layout Selection";
    begin
        CustRepLayout.LockTable;
        CustRepLayout.Get("Custom Layout Code");
        CustRepLayout.Delete;
        RepLayoutSel.LockTable;
        if RepLayoutSel.Get("Report ID", CompanyName)then RepLayoutSel.Delete;
        CreateLayout;
    end;
    procedure CreateLayout()var CustRepLayout: Record "Custom Report Layout";
    RepLayoutSel: Record "Report Layout Selection";
    begin
        CustRepLayout.Init;
        CustRepLayout.Code:="Custom Layout Code";
        CustRepLayout."Report ID":="Report ID";
        CustRepLayout."Company Name":=CompanyName;
        CustRepLayout.Type:=CustRepLayout.Type::Word;
        CustRepLayout.Description:=Description;
        CustRepLayout."Last Modified by User":=UserId;
        CustRepLayout."Last Modified":=CurrentDateTime;
        CustRepLayout.Insert(true);
        CalcFields(Blob);
        CustRepLayout.Layout:=Blob;
        CustRepLayout.SetDefaultCustomXmlPart();
        CustRepLayout.Modify(true);
        if not RepLayoutSel.Get("Report ID", CompanyName)then begin
            RepLayoutSel.Init();
            RepLayoutSel."Report ID":="Report ID";
            RepLayoutSel.Type:=RepLayoutSel.Type::"Word (built-in)";
            RepLayoutSel.Insert(true);
        end;
        RepLayoutSel.Get("Report ID", CompanyName);
        RepLayoutSel."Custom Report Layout Code":="Custom Layout Code";
        RepLayoutSel.Type:=RepLayoutSel.Type::"Custom Layout";
        RepLayoutSel.Modify(true);
    end;
}
