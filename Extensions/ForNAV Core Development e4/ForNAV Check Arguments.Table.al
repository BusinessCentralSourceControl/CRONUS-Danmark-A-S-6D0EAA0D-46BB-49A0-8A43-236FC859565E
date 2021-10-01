Table 6188771 "ForNAV Check Arguments"
{
    fields
    {
        field(1;"Primary Key";Code[10])
        {
            DataClassification = SystemMetadata;
        }
        field(7;"Test Print";Boolean)
        {
            Caption = 'Test Print', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(8;"Bank Account No.";Code[20])
        {
            Caption = 'Bank Account No.', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(10;"Blank Check";Boolean)
        {
            Caption = 'Blank Check', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(12;"Reprint Checks";Boolean)
        {
            Caption = 'Reprint Checks', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(20;"One Check Per Vendor";Boolean)
        {
            Caption = 'One Check Per Vendor', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(25;"Check No.";Code[20])
        {
            Caption = 'Check No.', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(Key1;"Primary Key")
        {
        }
    }
    fieldgroups
    {
    }
    procedure GetNextCheckNo(): Code[20]begin
        "Check No.":=IncStr("Check No.");
        if "Test Print" then "Check No.":='XXXX';
        exit("Check No.");
    end;
    procedure TestMandatoryFields()begin
        TestField("Bank Account No.");
        TestField("Check No.");
    end;
    procedure CreateModelFromGenJnlLn(var GenJnlLn: Record "Gen. Journal Line";
    var Model: Record "ForNAV Check Model"): Boolean var CreateCheckModel: Codeunit "ForNAV Create Check Model";
    begin
        exit(CreateCheckModel.CreateFromGenJnlLn(Rec, GenJnlLn, Model));
    end;
    procedure IncreaseCheckNoIfMultiplePages(NoOfPages: Integer)var i: Integer;
    begin
        if NoOfPages <= 1 then exit;
        for i:=2 to NoOfPages do "Check No.":=IncStr("Check No.");
    end;
}
