Table 6189468 "ForNAV VAT Currency Buffer"
{
    fields
    {
        field(1;"Currency Code";Code[20])
        {
            Caption = 'Currency Code';
            DataClassification = SystemMetadata;
        }
        field(2;"Currency Factor";Decimal)
        {
            Caption = 'Currency Factor';
            DataClassification = SystemMetadata;
        }
        field(3;"VAT Base Amount";Decimal)
        {
            Caption = 'VAT Base Amount';
            DataClassification = SystemMetadata;
        }
        field(4;"VAT Amount";Decimal)
        {
            Caption = 'VAT Amount';
            DataClassification = SystemMetadata;
        }
        field(5;"VAT %";Decimal)
        {
            Caption = 'VAT %';
            DataClassification = SystemMetadata;
        }
        field(6;"VAT Identifier";Code[20])
        {
            Caption = 'VAT Identifier';
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(Key1;"Currency Code")
        {
        }
    }
    fieldgroups
    {
    }
    procedure InsertLine()var VATCurrency: Record "ForNAV VAT Currency Buffer";
    GLSetup: Record "General Ledger Setup";
    begin
        GLSetup.Get;
        "Currency Code":=GLSetup."LCY Code";
        VATCurrency:=Rec;
        if Find then begin
            "VAT Base Amount":="VAT Base Amount" + VATCurrency."VAT Amount";
            "VAT Amount":="VAT Amount" + VATCurrency."VAT Amount";
            Modify;
        end
        else
            Insert;
    end;
}
