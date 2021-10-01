Table 6188774 "ForNAV Check Model"
{
    Caption = 'ForNAV Check Model', Comment='DO NOT TRANSLATE';

    fields
    {
        field(1;"Page No.";Integer)
        {
            Caption = 'Page No.', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
            InitValue = 1;
        }
        field(2;"Part No.";Option)
        {
            Caption = 'Part No.', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
            InitValue = "1";
            OptionMembers = " ", "1", "2", "3";
        }
        field(3;"Line No.";Integer)
        {
            Caption = 'Line No.', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
            InitValue = 1;
        }
        field(4;"New Page";Boolean)
        {
            Caption = 'New Page', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(6;Test;Boolean)
        {
            Caption = 'Test', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(7;Void;Boolean)
        {
            Caption = 'Void', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(8;Type;Option)
        {
            Caption = 'Type', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
            OptionMembers = " ", Check, Stub;
        }
        field(9;"Continued on Next Page";Boolean)
        {
            Caption = 'Continued on Next Page', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(10;"Check No.";Code[20])
        {
            Caption = 'Check No.', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(11;"Amount Written in Text";Text[250])
        {
            Caption = 'Amount Written in Text', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(12;"Amount in Numbers";Text[250])
        {
            Caption = 'Amount in Numbers', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(13;"Pay-to Name";Text[50])
        {
            Caption = 'Pay-to Name', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(14;"Bank Name";Text[50])
        {
            Caption = 'Bank Name', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(15;"Bank Account No.";Text[30])
        {
            Caption = 'Bank Account No.', Comment='DO NOT TRANSLATE';
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(18;"Bank Routing No.";Text[30])
        {
            Caption = 'Bank Routing No.', Comment='DO NOT TRANSLATE';
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(20;"No. of Pages";Integer)
        {
            Caption = 'No. of Pages', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
            InitValue = 1;
        }
        field(30;"Pay-to Vendor No.";Code[20])
        {
            Caption = 'Pay-to Vendor No.', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(31;"Pay-to Name 2";Text[50])
        {
            Caption = 'Pay-to Name 2', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(32;"Pay-to Address";Text[50])
        {
            Caption = 'Pay-to Address', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(33;"Pay-to Address 2";Text[50])
        {
            Caption = 'Pay-to Address 2', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(34;"Pay-to City";Text[30])
        {
            Caption = 'Pay-to City', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
            TableRelation = if("Country/Region Code"=const(''))"Post Code".City
            else if("Country/Region Code"=filter(<>''))"Post Code".City where("Country/Region Code"=field("Country/Region Code"));
            ValidateTableRelation = false;
        }
        field(35;"Pay-to Post Code";Code[20])
        {
            Caption = 'Pay-to Post Code', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
            TableRelation = if("Country/Region Code"=const(''))"Post Code".Code
            else if("Country/Region Code"=filter(<>''))"Post Code".Code where("Country/Region Code"=field("Country/Region Code"));
            ValidateTableRelation = false;
        }
        field(36;"Pay-to County";Text[30])
        {
            Caption = 'Pay-to County', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(37;"Pay-to Country/Region Code";Code[10])
        {
            Caption = 'Pay-to Country/Region Code', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
            TableRelation = "Country/Region";
        }
        field(40;Name;Text[50])
        {
            Caption = 'Name', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(41;"Name 2";Text[50])
        {
            Caption = 'Name 2', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(42;Address;Text[50])
        {
            Caption = 'Address', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(43;"Address 2";Text[50])
        {
            Caption = 'Address 2', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(44;City;Text[30])
        {
            Caption = 'City', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
            TableRelation = if("Country/Region Code"=const(''))"Post Code".City
            else if("Country/Region Code"=filter(<>''))"Post Code".City where("Country/Region Code"=field("Country/Region Code"));
            ValidateTableRelation = false;
        }
        field(45;"Post Code";Code[20])
        {
            Caption = 'Post Code', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
            TableRelation = if("Country/Region Code"=const(''))"Post Code".Code
            else if("Country/Region Code"=filter(<>''))"Post Code".Code where("Country/Region Code"=field("Country/Region Code"));
            ValidateTableRelation = false;
        }
        field(46;County;Text[30])
        {
            Caption = 'County', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(47;"Country/Region Code";Code[10])
        {
            Caption = 'Country/Region Code', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
            TableRelation = "Country/Region";
        }
        field(50;"Document Date";Date)
        {
            Caption = 'Document Date', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(55;"Document No.";Code[20])
        {
            Caption = 'Document No.', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(60;"External Document No.";Text[35])
        {
            Caption = 'External Document No.', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(65;Amount;Decimal)
        {
            Caption = 'Amount', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(70;"Discount Amount";Decimal)
        {
            Caption = 'Discount Amount', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(75;"Net Amount";Decimal)
        {
            Caption = 'Net Amount', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(80;"Document Type";Text[50])
        {
            Caption = 'Document Type', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(85;"Amount Paid";Decimal)
        {
            Caption = 'Amount Paid', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(88;"Running Total";Decimal)
        {
            Caption = 'Running Total', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(90;"Job No.";Code[20])
        {
            Caption = 'Job No.', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(95;"Currency Code";Code[10])
        {
            Caption = 'Currency Code', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(100;"Posting Date";Date)
        {
            Caption = 'Posting Date', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(110;"Micr Line";Text[100])
        {
            Caption = 'Micr Line', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(111;"Micr Line 1";Text[30])
        {
            Caption = 'Micr Line 1', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(112;"Micr Line 2";Text[30])
        {
            Caption = 'Micr Line 2', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(113;"Micr Line 3";Text[30])
        {
            Caption = 'Micr Line 3', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(120;"Check No Stub";Code[20])
        {
            Caption = 'Check No. Line', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(121;"Entry No.";Integer)
        {
            Caption = 'Entry No.', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(122;"Entry Type";Option)
        {
            Caption = 'Entry Type', Comment='DO NOT TRANSLATE';
            OptionMembers = "Customer", "Vendor";
            OptionCaption = 'Customer,Vendor', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(Key1;"Page No.", "Part No.", "Line No.")
        {
        }
    }
    procedure SetPageAndLineNo(var NextLineNo: Integer)var CheckSetup: Record "ForNAV Check Setup";
    begin
        CheckSetup.Get;
        NextLineNo+=1;
        "Part No.":=1;
        if "Line No." = CheckSetup."No. of Lines (Stub)" then begin
            "Page No."+=1;
            NextLineNo:=1;
        end;
        "Line No.":=NextLineNo;
    end;
    procedure Duplicate()var CheckSetup: Record "ForNAV Check Setup";
    begin
        CheckSetup.Get;
        if CheckSetup.Layout = CheckSetup.Layout::"3 Checks" then exit;
        "Part No.":=2;
        Insert;
        if CheckSetup.Layout = CheckSetup.Layout::"Top Check with one Stub" then exit;
        "Part No.":=3;
        Insert;
    end;
    procedure SetType()var CheckSetup: Record "ForNAV Check Setup";
    begin
        CheckSetup.Get;
        Type:=CheckSetup.GetTypeBasedOnLayout("Part No.");
    end;
    procedure SetIsNewPage()var CheckSetup: Record "ForNAV Check Setup";
    begin
        CheckSetup.Get;
        case CheckSetup.Layout of CheckSetup.Layout::"3 Checks": "New Page":="Part No." = 3;
        CheckSetup.Layout::"Top Check with one Stub": "New Page":="Part No." = 2;
        CheckSetup.Layout::"Bottom Check with one Stub": "New Page":="Part No." = 2;
        CheckSetup.Layout::"Check-Stub-Stub": "New Page":="Part No." = 3;
        CheckSetup.Layout::Other: CheckSetup.FieldError(Layout);
        CheckSetup.Layout::"Stub-Check-Stub": "New Page":="Part No." = 3;
        CheckSetup.Layout::"Stub-Stub-Check": "New Page":="Part No." = 3;
        end;
    end;
    procedure SetContinuedOnNextPage()begin
        "Continued on Next Page":="Running Total" <> "Amount Paid";
    end;
    procedure SetIsVoid()begin
        Void:="Page No." <> "No. of Pages";
    end;
    procedure SetAddress()var CompInfo: Record "Company Information";
    begin
        if Void or Test then begin
            Name:='XXXXXXXXXXXXXXXXXXXXXXXX';
            Address:='XXXXXXXXXXXXXXXXXXXXXXXX';
            "Post Code":='XXXXX';
            "Country/Region Code":='XX';
        end
        else
        begin
            CompInfo.Get;
            Name:=CompInfo.Name;
            "Name 2":=CompInfo."Name 2";
            Address:=CompInfo.Address;
            "Address 2":=CompInfo."Address 2";
            "Post Code":=CompInfo."Post Code";
            City:=CompInfo.City;
            County:=CompInfo.County;
            "Country/Region Code":=CompInfo."Country/Region Code";
        end;
    end;
    procedure VoidCheckFields()begin
        if not(Void or Test)then exit;
        "Check No.":='XXXXX';
        "Amount Written in Text":='XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
        "Amount in Numbers":='XXXXXXXXXXXXX';
        if "Micr Line" <> '' then begin
            "Micr Line 1":='XXXXXXXXXXXX';
            "Micr Line 2":='XXXXXXXXXXXX';
            "Micr Line 3":='XXXXXXXXXXXX';
            "Micr Line":="Micr Line 1" + "Micr Line 2" + "Micr Line 3";
        end;
    end;
    procedure SetPayToAddress()begin
        if Void or Test then begin
            "Pay-to Name":='XXXXXXXXXXXXXXXXXXXXXXXX';
            "Pay-to Name 2":='';
            "Pay-to Address":='XXXXXXXXXXXXXXXXXXXXXXXX';
            "Pay-to Address 2":='';
            "Pay-to Post Code":='XXXXX';
            "Pay-to County":='';
            "Pay-to Country/Region Code":='XX';
        end;
    end;
    procedure SetMICRLine()var CreateMICRString: Codeunit "ForNAV Create MICR String";
    Handled: Boolean;
    begin
        SetMICRLineEvent("Micr Line", Handled);
        if Handled then exit;
        CreateMICRString.GetMICRString(Rec);
    end;
    [IntegrationEvent(false, false)]
    local procedure SetMICRLineEvent(var Value: Text[100];
    var Handled: Boolean)begin
    end;
    procedure SetNoOfPages(NoOfStubs: Integer)var CheckSetup: Record "ForNAV Check Setup";
    begin
        CheckSetup.Get;
        if CheckSetup."No. of Lines (Stub)" = 0 then "No. of Pages":=1
        else
            "No. of Pages":=ROUND(NoOfStubs / CheckSetup."No. of Lines (Stub)", 1, '>');
    end;
}
