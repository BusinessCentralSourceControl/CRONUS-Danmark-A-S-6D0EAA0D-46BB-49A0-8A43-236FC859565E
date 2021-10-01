Table 6188678 "ForNAV Reconcile AP to GL Buf."
{
    fields
    {
        field(10;"Account No.";Code[20])
        {
            Caption = 'No.';
            DataClassification = SystemMetadata;
        }
        field(20;"Account Name";Text[30])
        {
            Caption = 'Name';
            DataClassification = SystemMetadata;
        }
        field(30;"Debit Amount";Decimal)
        {
            Caption = 'Debit Amount';
            DataClassification = SystemMetadata;
        }
        field(40;"Credit Amount";Decimal)
        {
            Caption = 'Credit Amount';
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(Key1;"Account No.")
        {
        }
    }
    fieldgroups
    {
    }
}
