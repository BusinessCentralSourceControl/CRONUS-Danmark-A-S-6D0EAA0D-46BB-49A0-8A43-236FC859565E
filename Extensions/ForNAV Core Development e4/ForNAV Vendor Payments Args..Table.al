Table 6188682 "ForNAV Vendor Payments Args."
{
    fields
    {
        field(1;"Consider Discount";Boolean)
        {
            Caption = 'Consider Discount';
            DataClassification = SystemMetadata;
        }
        field(2;"Payment Date";Date)
        {
            Caption = 'Payment Date';
            DataClassification = SystemMetadata;
        }
        field(3;"Due Date Filter";Date)
        {
            Caption = 'Due Date Filter';
            DataClassification = SystemMetadata;
        }
        field(4;"Payment Discount Date";Date)
        {
            Caption = 'Payment Discount Date';
            DataClassification = SystemMetadata;
        }
        field(5;"Print Amounts in LCY";Boolean)
        {
            Caption = 'Print Amounts in LCY';
            DataClassification = SystemMetadata;
        }
        field(6;"External Document No.";Boolean)
        {
            Caption = 'External Document No.';
            DataClassification = SystemMetadata;
        }
        field(7;"Total Amount (LCY)";Decimal)
        {
            Caption = 'Total Amount (LCY)';
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(Key1;"Consider Discount")
        {
        }
    }
}
