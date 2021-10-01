Table 6189470 "ForNAV Document Line Buffer"
{
    fields
    {
        field(1;"VAT %";Decimal)
        {
            DataClassification = SystemMetadata;
            DecimalPlaces = 0: 5;
            Editable = false;
        }
        field(2;"VAT Base";Decimal)
        {
            AutoFormatType = 1;
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(3;"VAT Amount";Decimal)
        {
            AutoFormatType = 1;
            DataClassification = SystemMetadata;
        }
        field(4;"Amount Including VAT";Decimal)
        {
            AutoFormatType = 1;
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(5;"VAT Identifier";Code[20])
        {
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(6;"Line Amount";Decimal)
        {
            AutoFormatType = 1;
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(7;"Inv. Disc. Base Amount";Decimal)
        {
            AutoFormatType = 1;
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(8;"Invoice Discount Amount";Decimal)
        {
            AutoFormatType = 1;
            DataClassification = SystemMetadata;
        }
        field(9;"VAT Calculation Type";Enum "Tax Calculation Type")
        {
            DataClassification = SystemMetadata;
            Editable = false;
        // OptionCaption = 'Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax';
        // OptionMembers = "Normal VAT","Reverse Charge VAT","Full VAT","Sales Tax";
        }
        field(10;"Tax Group Code";Code[20])
        {
            Caption = 'Tax Group Code', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
            Editable = false;
            TableRelation = "Tax Group";
        }
        field(11;Quantity;Decimal)
        {
            DataClassification = SystemMetadata;
            DecimalPlaces = 0: 5;
            Editable = false;
        }
        field(12;Modified;Boolean)
        {
            Caption = 'Modified', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(13;"Use Tax";Boolean)
        {
            Caption = 'Use Tax', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(14;"Calculated VAT Amount";Decimal)
        {
            AutoFormatType = 1;
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(15;"VAT Difference";Decimal)
        {
            AutoFormatType = 1;
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(16;Positive;Boolean)
        {
            Caption = 'Positive', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(17;"Includes Prepayment";Boolean)
        {
            Caption = 'Includes Prepayment', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(18;"VAT Clause Code";Code[20])
        {
            DataClassification = SystemMetadata;
            TableRelation = "VAT Clause";
        }
        field(19;"Tax Category";Code[20])
        {
            Caption = 'Tax Category', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(6188471;"Line No.";Integer)
        {
            DataClassification = SystemMetadata;
        }
        field(6188472;Amount;Decimal)
        {
            DataClassification = SystemMetadata;
        }
        field(6188473;"Allow Invoice Disc.";Boolean)
        {
            DataClassification = SystemMetadata;
        }
        field(6188474;"Inv. Discount Amount";Decimal)
        {
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(Key1;"Line No.")
        {
        }
    }
    procedure CreateForRecRef(var RecRef: RecordRef)var Fld: Record "Field";
    begin
        FindAndSetField(RecRef, 'Line No.', 6188471);
        Fld.SetRange(TableNo, Database::"ForNAV Document Line Buffer");
        Fld.SetFilter("No.", '<>6188471');
        Fld.FindSet;
        repeat FindAndSetField(RecRef, Fld.FieldName, Fld."No.");
        until Fld.Next = 0;
    end;
    local procedure FindAndSetField(var RecRef: RecordRef;
    FieldName: Text;
    FieldNo: Integer)var Fld: Record "Field";
    ThisRecRef: RecordRef;
    FldRef: FieldRef;
    ThisFld: FieldRef;
    begin
        Fld.SetRange(TableNo, RecRef.Number);
        Fld.SetRange(FieldName, FieldName);
        if not Fld.FindFirst then exit;
        FldRef:=RecRef.Field(Fld."No.");
        ThisRecRef.GetTable(Rec);
        ThisFld:=ThisRecRef.Field(FieldNo);
        ThisFld.Value:=FldRef.Value;
        ThisRecRef.SetTable(Rec);
        if FieldNo = 6188471 then Insert
        else
            Modify;
    end;
}
