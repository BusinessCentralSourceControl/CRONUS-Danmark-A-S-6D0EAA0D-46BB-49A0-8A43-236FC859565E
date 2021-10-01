Table 6188715 "ForNAV Inventory Valuation"
{
    fields
    {
        field(1;"Item No.";Code[20])
        {
            DataClassification = SystemMetadata;
        }
        field(2;"Inventory Posting Group";Code[20])
        {
            DataClassification = SystemMetadata;
        }
        field(3;"Location Code";Code[10])
        {
            DataClassification = SystemMetadata;
        }
        field(4;"Variant Code";Code[10])
        {
            DataClassification = SystemMetadata;
        }
        field(8;Description;Text[250])
        {
            DataClassification = SystemMetadata;
        }
        field(9;"Print Expected Cost";Boolean)
        {
            DataClassification = SystemMetadata;
        }
        field(10;StartingInvoicedValue;Decimal)
        {
            Caption = 'StartingInvoicedValue', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(11;StartingInvoicedQty;Decimal)
        {
            Caption = 'StartingInvoicedQty', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(12;StartingExpectedValue;Decimal)
        {
            Caption = 'StartingExpectedValue', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(13;StartingExpectedQty;Decimal)
        {
            Caption = 'StartingExpectedQty', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(14;IncreaseInvoicedValue;Decimal)
        {
            Caption = 'IncreaseInvoicedValue', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(15;IncreaseInvoicedQty;Decimal)
        {
            Caption = 'IncreaseInvoicedQty', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(16;IncreaseExpectedValue;Decimal)
        {
            Caption = 'IncreaseExpectedValue', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(17;IncreaseExpectedQty;Decimal)
        {
            Caption = 'IncreaseExpectedQty', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(18;DecreaseInvoicedValue;Decimal)
        {
            Caption = 'DecreaseInvoicedValue', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(19;DecreaseInvoicedQty;Decimal)
        {
            Caption = 'DecreaseInvoicedQty', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(20;DecreaseExpectedValue;Decimal)
        {
            Caption = 'DecreaseExpectedValue', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(21;DecreaseExpectedQty;Decimal)
        {
            Caption = 'DecreaseExpectedQty', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(22;CostPostedToGL;Decimal)
        {
            Caption = 'CostPostedToGL', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(23;InvCostPostedToGL;Decimal)
        {
            Caption = 'InvCostPostedToGL', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(24;ExpCostPostedToGL;Decimal)
        {
            Caption = 'ExpCostPostedToGL', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(Key1;"Item No.", "Location Code", "Variant Code")
        {
        }
        key(Key2;"Inventory Posting Group")
        {
        }
    }
    procedure SetPrintExpectedCost(Args: Record "ForNAV Inv. Valuation Args.")begin
        "Print Expected Cost":=PrintExpectedCost(Args);
    end;
    local procedure PrintExpectedCost(Args: Record "ForNAV Inv. Valuation Args."): Boolean begin
        if not Args."Expected Cost" then exit(false);
        if StartingExpectedQty <> StartingInvoicedQty then exit(true);
        if IncreaseExpectedQty <> IncreaseInvoicedQty then exit(true);
        if DecreaseExpectedQty <> DecreaseInvoicedQty then exit(true);
        if StartingInvoicedValue <> StartingExpectedValue then exit(true);
        if IncreaseInvoicedValue <> IncreaseExpectedValue then exit(true);
        if DecreaseInvoicedValue <> DecreaseExpectedValue then exit(true);
        exit(false);
    end;
}
