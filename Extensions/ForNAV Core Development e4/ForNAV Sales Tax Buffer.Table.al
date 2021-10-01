Table 6189469 "ForNAV Sales Tax Buffer"
{
    Caption = 'Sales Tax Buffer', Comment='DO NOT TRANSLATE';

    fields
    {
        field(1;"Primary Key";Code[20])
        {
            Caption = 'Primary Key';
            DataClassification = SystemMetadata;
        }
        field(2;"Exempt Amount";Decimal)
        {
            Caption = '', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(3;"Taxable Amount";Decimal)
        {
            Caption = '', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(Key1;"Primary Key")
        {
        }
    }
}
