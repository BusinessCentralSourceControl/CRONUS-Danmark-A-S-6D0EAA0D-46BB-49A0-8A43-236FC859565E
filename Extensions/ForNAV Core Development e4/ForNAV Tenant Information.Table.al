Table 6188495 "ForNAV Tenant Information"
{
    Caption = 'ForNAV Tenant Information', Comment='DO NOT TRANSLATE';

    fields
    {
        field(1;"Primary Key";Code[10])
        {
            Caption = 'Primary Key', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(2;ID;Text[250])
        {
            Caption = 'ID', Comment='DO NOT TRANSLATE';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(3;"Active Directory ID";Text[250])
        {
            Caption = 'Active Directory ID', Comment='DO NOT TRANSLATE';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(4;Name;Text[250])
        {
            Caption = 'Name', Comment='DO NOT TRANSLATE';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(5;"Is Sandbox";Boolean)
        {
            Caption = 'Is Sandbox', Comment='DO NOT TRANSLATE';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(6;"Is Production";Boolean)
        {
            Caption = 'Is Production', Comment='DO NOT TRANSLATE';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(7;"Platform Version";Text[250])
        {
            Caption = 'Platform Version', Comment='DO NOT TRANSLATE';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(8;"Application Family";Text[250])
        {
            Caption = 'Application Family', Comment='DO NOT TRANSLATE';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(9;"Application Version";Text[250])
        {
            Caption = 'Application Version', Comment='DO NOT TRANSLATE';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(10;"Environment Name";Text[250])
        {
            Caption = 'Environment Name', Comment='DO NOT TRANSLATE';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(11;"Domain Name";Text[250])
        {
            Caption = 'Domain Name', Comment='DO NOT TRANSLATE';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(12;"Report Pack Version";Text[50])
        {
            Caption = 'Report Pack Version', Comment='DO NOT TRANSLATE';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(13;"Business Central Version";Text[50])
        {
            Caption = 'Business Central Version', Comment='DO NOT TRANSLATE';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(6188471;TryGetFieldID;Integer)
        {
            Caption = 'TryGetFieldID', Comment='DO NOT TRANSLATE';
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
    procedure GetInfo()begin
        Insert;
        Commit;
        TryPopulateField(FieldNo(ID));
        TryPopulateField(FieldNo(ID));
        TryPopulateField(FieldNo("Active Directory ID"));
        TryPopulateField(FieldNo(Name));
        TryPopulateField(FieldNo("Is Sandbox"));
        TryPopulateField(FieldNo("Is Production"));
        TryPopulateField(FieldNo("Platform Version"));
        TryPopulateField(FieldNo("Application Family"));
        TryPopulateField(FieldNo("Application Version"));
        TryPopulateField(FieldNo("Environment Name"));
        TryPopulateField(FieldNo("Domain Name"));
        TryPopulateField(FieldNo("Report Pack Version"));
        TryPopulateField(FieldNo("Business Central Version"));
    end;
    local procedure TryPopulateField(Value: Integer)begin
        TryGetFieldID:=Value;
        if Codeunit.Run(Codeunit::"ForNAV Tenant Information", Rec)then begin
            Modify;
            Commit;
        end;
    end;
}
