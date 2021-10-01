Table 6188671 "ForNAV Label"
{
    fields
    {
        field(1;"No.";Code[50])
        {
            DataClassification = SystemMetadata;
        }
        field(2;"Shipment Date";Date)
        {
            Caption = 'Shipment Date';
            DataClassification = SystemMetadata;
        }
        field(3;Type;Option)
        {
            DataClassification = SystemMetadata;
            OptionMembers = Portrait, Landscape, "Price Tag";
        }
        field(4;"One Label per Package";Boolean)
        {
            DataClassification = SystemMetadata;
        }
        field(5;"From Name";Text[100])
        {
            DataClassification = SystemMetadata;
        }
        field(6;"From Name 2";Text[50])
        {
            DataClassification = SystemMetadata;
        }
        field(7;"From Address";Text[100])
        {
            DataClassification = SystemMetadata;
        }
        field(8;"From Address 2";Text[50])
        {
            DataClassification = SystemMetadata;
        }
        field(9;"From Post Code";Code[20])
        {
            DataClassification = SystemMetadata;
        }
        field(12;"From City";Text[30])
        {
            DataClassification = SystemMetadata;
        }
        field(13;"From County";Text[30])
        {
            DataClassification = SystemMetadata;
        }
        field(14;"From Country/Region Code";Code[10])
        {
            DataClassification = SystemMetadata;
        }
        field(15;"From Contact";Text[100])
        {
            DataClassification = SystemMetadata;
        }
        field(18;"Unit Price";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Price';
            DataClassification = SystemMetadata;
        }
        field(25;"Ship-to Name";Text[100])
        {
            DataClassification = SystemMetadata;
        }
        field(26;"Ship-to Name 2";Text[50])
        {
            DataClassification = SystemMetadata;
        }
        field(27;"Ship-to Address";Text[100])
        {
            DataClassification = SystemMetadata;
        }
        field(28;"Ship-to Address 2";Text[50])
        {
            DataClassification = SystemMetadata;
        }
        field(29;"Ship-to Post Code";Code[20])
        {
            DataClassification = SystemMetadata;
        }
        field(32;"Ship-to City";Text[30])
        {
            DataClassification = SystemMetadata;
        }
        field(33;"Ship-to County";Text[30])
        {
            DataClassification = SystemMetadata;
        }
        field(34;"Ship-to Country/Region Code";Code[10])
        {
            DataClassification = SystemMetadata;
        }
        field(35;"Ship-to Contact";Text[100])
        {
            DataClassification = SystemMetadata;
        }
        field(40;"Area";Code[10])
        {
            DataClassification = SystemMetadata;
        }
        field(45;"External Document No.";Text[250])
        {
            DataClassification = SystemMetadata;
        }
        field(48;"Your Reference";Text[35])
        {
            DataClassification = SystemMetadata;
        }
        field(50;Barcode;Text[250])
        {
            DataClassification = SystemMetadata;
        }
        field(60;Description;Text[250])
        {
            DataClassification = SystemMetadata;
        }
        field(61;"Description 2";Text[50])
        {
            Caption = 'Description 2';
            DataClassification = SystemMetadata;
        }
        field(70;Quantity;Decimal)
        {
            DataClassification = SystemMetadata;
        }
        field(71;"Unit Volume";Decimal)
        {
            DataClassification = SystemMetadata;
        }
        field(72;"Gross Weight";Decimal)
        {
            DataClassification = SystemMetadata;
        }
        field(73;"Net Weight";Decimal)
        {
            DataClassification = SystemMetadata;
        }
        field(80;"Units per Parcel";Decimal)
        {
            DataClassification = SystemMetadata;
        }
        field(5402;"Variant Code";Code[10])
        {
            Caption = 'Variant Code';
            DataClassification = SystemMetadata;
        }
        field(6500;"Serial No.";Code[50])
        {
            Caption = 'Serial No.';
            DataClassification = SystemMetadata;
        }
        field(6501;"Lot No.";Code[50])
        {
            Caption = 'Lot No.';
            DataClassification = SystemMetadata;
        }
        field(6502;"Warranty Date";Date)
        {
            Caption = 'Warranty Date';
            DataClassification = SystemMetadata;
        }
        field(6503;"Expiration Date";Date)
        {
            Caption = 'Expiration Date';
            DataClassification = SystemMetadata;
        }
        field(6188471;"ForNAV Design";Boolean)
        {
            Caption = 'Design', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(6188472;"ForNAV Label No.";Integer)
        {
            Caption = 'Label No.', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(6188473;"ForNAV Page No.";Integer)
        {
            Caption = 'Page No.', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(Key1;"ForNAV Label No.", "ForNAV Page No.")
        {
        }
    }
    fieldgroups
    {
    }
    procedure SetFromCompany()var CompanyInformation: Record "Company Information";
    begin
        CompanyInformation.Get;
        "From Name":=CompanyInformation.Name;
        "From Name 2":=CompanyInformation."Name 2";
        "From Address":=CompanyInformation.Address;
        "From Address 2":=CompanyInformation."Address 2";
        "From Post Code":=CompanyInformation."Post Code";
        "From City":=CompanyInformation.City;
        "From County":=CompanyInformation.County;
        "From Country/Region Code":=CompanyInformation."Country/Region Code";
        "From Contact":=CompanyInformation."Contact Person";
    end;
}
