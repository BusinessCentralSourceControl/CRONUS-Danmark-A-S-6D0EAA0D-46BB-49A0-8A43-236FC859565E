Table 6188713 "ForNAV Inv. Valuation Args."
{
    fields
    {
        field(1;"Starting Date";Date)
        {
            Caption = 'Starting Date';
            DataClassification = SystemMetadata;
        }
        field(2;"Ending Date";Date)
        {
            Caption = 'Ending Date';
            DataClassification = SystemMetadata;
        }
        field(3;"Expected Cost";Boolean)
        {
            Caption = 'Expected Cost';
            DataClassification = SystemMetadata;
        }
        field(4;Quantity;Decimal)
        {
            Caption = 'Quantity';
            DataClassification = SystemMetadata;
        }
        field(5;Value;Decimal)
        {
            Caption = 'Value';
            DataClassification = SystemMetadata;
        }
        field(6;"Increases (LCY)";Decimal)
        {
            Caption = 'Increases (LCY)';
            DataClassification = SystemMetadata;
        }
        field(7;"Decreases (LCY)";Decimal)
        {
            Caption = 'Decreases (LCY)';
            DataClassification = SystemMetadata;
        }
        field(8;"Cost Posted to G/L";Boolean)
        {
            Caption = 'Cost Posted to G/L';
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(Key1;"Starting Date")
        {
        }
    }
    fieldgroups
    {
    }
}
