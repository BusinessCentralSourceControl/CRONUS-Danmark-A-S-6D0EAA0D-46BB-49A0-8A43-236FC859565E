Table 6188691 "ForNAV Aging Buffer"
{
    fields
    {
        field(1;"Entry No.";Integer)
        {
            Caption = 'Entry No.';
            DataClassification = SystemMetadata;
        }
        field(20;"Account Type";Option)
        {
            Caption = 'Account Type';
            DataClassification = SystemMetadata;
            OptionMembers = Customer, Vendor;
        }
        field(30;"Account No.";Code[20])
        {
            Caption = 'No.';
            DataClassification = SystemMetadata;
            TableRelation = if("Account Type"=const(Customer))Customer
            else if("Account Type"=const(Vendor))Vendor;
            ValidateTableRelation = false;
        }
        field(31;"Account Name";Text[100])
        {
            Caption = 'Name';
            DataClassification = SystemMetadata;
        }
        field(35;"Credit Limit (LCY)";Decimal)
        {
            Caption = 'Credit Limit (LCY)';
            DataClassification = SystemMetadata;
        }
        field(40;"Currency Code";Code[10])
        {
            Caption = 'Currency Code';
            DataClassification = SystemMetadata;
        }
        field(50;"Document Type";Enum "Gen. Journal Document Type")
        {
            Caption = 'Document Type';
            DataClassification = SystemMetadata;
        // OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
        // OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(60;"Document No.";Code[20])
        {
            Caption = 'Document No.';
            DataClassification = SystemMetadata;
        }
        field(61;"External Document No.";Code[35])
        {
            Caption = 'External Document No.';
            DataClassification = SystemMetadata;
        }
        field(65;"Document Date";Date)
        {
            Caption = 'Document Date';
            DataClassification = SystemMetadata;
        }
        field(70;"Posting Date";Date)
        {
            Caption = 'Posting Date';
            DataClassification = SystemMetadata;
        }
        field(80;"Due Date";Date)
        {
            Caption = 'Due Date';
            DataClassification = SystemMetadata;
        }
        field(90;Amount;Decimal)
        {
            Caption = 'Amount';
            DataClassification = SystemMetadata;
        }
        field(95;"Amount (LCY)";Decimal)
        {
            Caption = 'Amount (LCY)';
            DataClassification = SystemMetadata;
        }
        field(100;Balance;Decimal)
        {
            Caption = 'Balance';
            DataClassification = SystemMetadata;
        }
        field(105;"Balance (LCY)";Decimal)
        {
            Caption = 'Balance (LCY)';
            DataClassification = SystemMetadata;
        }
        field(110;"Amount 1";Decimal)
        {
            Caption = 'Amount 1', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(115;"Amount 1 (LCY)";Decimal)
        {
            Caption = 'Amount 1 (LCY)', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(120;"Amount 2";Decimal)
        {
            Caption = 'Amount 2', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(125;"Amount 2 (LCY)";Decimal)
        {
            Caption = 'Amount 2 (LCY)', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(130;"Amount 3";Decimal)
        {
            Caption = 'Amount 3', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(135;"Amount 3 (LCY)";Decimal)
        {
            Caption = 'Amount 3 (LCY)', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(140;"Amount 4";Decimal)
        {
            Caption = 'Amount 4', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(145;"Amount 4 (LCY)";Decimal)
        {
            Caption = 'Amount 4 (LCY)', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(150;"Amount 5";Decimal)
        {
            Caption = 'Amount 5', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(155;"Amount 5 (LCY)";Decimal)
        {
            Caption = 'Amount 5 (LCY)', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(160;"Amount 6";Decimal)
        {
            Caption = 'Amount 6', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(165;"Amount 6 (LCY)";Decimal)
        {
            Caption = 'Amount 6 (LCY)', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(167;"Amount 7";Decimal)
        {
            Caption = 'Amount 7', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(170;"Amount 7 (LCY)";Decimal)
        {
            Caption = 'Amount 7 (LCY)', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(175;"Amount 8";Decimal)
        {
            Caption = 'Amount 8', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(180;"Amount 8 (LCY)";Decimal)
        {
            Caption = 'Amount 8 (LCY)', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(182;"Amount 9";Decimal)
        {
            Caption = 'Amount 9', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(185;"Amount 9 (LCY)";Decimal)
        {
            Caption = 'Amount 9 (LCY)', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(190;"Amount 10";Decimal)
        {
            Caption = 'Amount 10', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(195;"Amount 10 (LCY)";Decimal)
        {
            Caption = 'Amount 10 (LCY)', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(200;"Amount 11";Decimal)
        {
            Caption = 'Amount 11', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(205;"Amount 11 (LCY)";Decimal)
        {
            Caption = 'Amount 11 (LCY)', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(210;"Amount 12";Decimal)
        {
            Caption = 'Amount 12', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(215;"Amount 12 (LCY)";Decimal)
        {
            Caption = 'Amount 12 (LCY)', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(220;"Amount 13";Decimal)
        {
            Caption = 'Amount 13', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(225;"Amount 13 (LCY)";Decimal)
        {
            Caption = 'Amount 13 (LCY)', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(230;"Amount 14";Decimal)
        {
            Caption = 'Amount 14', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(235;"Amount 14 (LCY)";Decimal)
        {
            Caption = 'Amount 14 (LCY)', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(240;"Amount 15";Decimal)
        {
            Caption = 'Amount 15', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(245;"Amount 15 (LCY)";Decimal)
        {
            Caption = 'Amount 15 (LCY)', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(250;"Amount 16";Decimal)
        {
            Caption = 'Amount 16', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(255;"Amount 16 (LCY)";Decimal)
        {
            Caption = 'Amount 16 (LCY)', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(260;"Amount 17";Decimal)
        {
            Caption = 'Amount 17', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(265;"Amount 17 (LCY)";Decimal)
        {
            Caption = 'Amount 17 (LCY)', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(270;"Amount 18";Decimal)
        {
            Caption = 'Amount 18', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(275;"Amount 18 (LCY)";Decimal)
        {
            Caption = 'Amount 18 (LCY)', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(280;"Amount 19";Decimal)
        {
            Caption = 'Amount 19', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(285;"Amount 19 (LCY)";Decimal)
        {
            Caption = 'Amount 19 (LCY)', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(290;"Amount 20";Decimal)
        {
            Caption = 'Amount 20', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(295;"Amount 20 (LCY)";Decimal)
        {
            Caption = 'Amount 20 (LCY)', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(300;"Amount 21";Decimal)
        {
            Caption = 'Amount 21', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(305;"Amount 21 (LCY)";Decimal)
        {
            Caption = 'Amount 21 (LCY)', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(310;"Amount 22";Decimal)
        {
            Caption = 'Amount 22', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(315;"Amount 22 (LCY)";Decimal)
        {
            Caption = 'Amount 22 (LCY)', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(320;"Amount 23";Decimal)
        {
            Caption = 'Amount 23', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(325;"Amount 23 (LCY)";Decimal)
        {
            Caption = 'Amount 23 (LCY)', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(330;"Amount 24";Decimal)
        {
            Caption = 'Amount 24', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(335;"Amount 24 (LCY)";Decimal)
        {
            Caption = 'Amount 24 (LCY)', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(340;"Amount 25";Decimal)
        {
            Caption = 'Amount 25', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(345;"Amount 25 (LCY)";Decimal)
        {
            Caption = 'Amount 25 (LCY)', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(350;"Amount 26";Decimal)
        {
            Caption = 'Amount 26', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(355;"Amount 26 (LCY)";Decimal)
        {
            Caption = 'Amount 26 (LCY)', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(360;"Amount 27";Decimal)
        {
            Caption = 'Amount 27', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(365;"Amount 27 (LCY)";Decimal)
        {
            Caption = 'Amount 27 (LCY)', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(370;"Amount 28";Decimal)
        {
            Caption = 'Amount 28', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(375;"Amount 28 (LCY)";Decimal)
        {
            Caption = 'Amount 28 (LCY)', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(380;"Amount 29";Decimal)
        {
            Caption = 'Amount 29', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(385;"Amount 29 (LCY)";Decimal)
        {
            Caption = 'Amount 29 (LCY)', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(390;"Amount 30";Decimal)
        {
            Caption = 'Amount 30', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(395;"Amount 30 (LCY)";Decimal)
        {
            Caption = 'Amount 30 (LCY)', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(400;"Amount 31";Decimal)
        {
            Caption = 'Amount 31', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(405;"Amount 31 (LCY)";Decimal)
        {
            Caption = 'Amount 31 (LCY)', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(501;"Caption 1";Text[80])
        {
            Caption = 'Caption 1', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(502;"Caption 2";Text[80])
        {
            Caption = 'Caption 2', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(503;"Caption 3";Text[80])
        {
            Caption = 'Caption 3', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(504;"Caption 4";Text[80])
        {
            Caption = 'Caption 4', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(505;"Caption 5";Text[80])
        {
            Caption = 'Caption 5', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(506;"Caption 6";Text[80])
        {
            Caption = 'Caption 6', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(507;"Caption 7";Text[80])
        {
            Caption = 'Caption 7', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(508;"Caption 8";Text[80])
        {
            Caption = 'Caption 8', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(509;"Caption 9";Text[80])
        {
            Caption = 'Caption 9', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(510;"Caption 10";Text[80])
        {
            Caption = 'Caption 10', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(511;"Caption 11";Text[80])
        {
            Caption = 'Caption 11', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(512;"Caption 12";Text[80])
        {
            Caption = 'Caption 12', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(513;"Caption 13";Text[80])
        {
            Caption = 'Caption 13', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(514;"Caption 14";Text[80])
        {
            Caption = 'Caption 14', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(515;"Caption 15";Text[80])
        {
            Caption = 'Caption 15', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(516;"Caption 16";Text[80])
        {
            Caption = 'Caption 16', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(517;"Caption 17";Text[80])
        {
            Caption = 'Caption 17', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(518;"Caption 18";Text[80])
        {
            Caption = 'Caption 18', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(519;"Caption 19";Text[80])
        {
            Caption = 'Caption 19', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(520;"Caption 20";Text[80])
        {
            Caption = 'Caption 20', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(521;"Caption 21";Text[80])
        {
            Caption = 'Caption 21', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(522;"Caption 22";Text[80])
        {
            Caption = 'Caption 22', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(523;"Caption 23";Text[80])
        {
            Caption = 'Caption 23', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(524;"Caption 24";Text[80])
        {
            Caption = 'Caption 24', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(525;"Caption 25";Text[80])
        {
            Caption = 'Caption 25', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(526;"Caption 26";Text[80])
        {
            Caption = 'Caption 26', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(527;"Caption 27";Text[80])
        {
            Caption = 'Caption 27', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(528;"Caption 28";Text[80])
        {
            Caption = 'Caption 28', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(529;"Caption 29";Text[80])
        {
            Caption = 'Caption 29', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(530;"Caption 30";Text[80])
        {
            Caption = 'Caption 30', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(531;"Caption 31";Text[80])
        {
            Caption = 'Caption 31', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(Key1;"Entry No.")
        {
        }
        key(Key2;"Currency Code")
        {
        }
    }
    procedure GetAccountName()var Customer: Record Customer;
    Vendor: Record Vendor;
    begin
        case "Account Type" of "account type"::Customer: begin
            Customer.Get("Account No.");
            "Account Name":=Customer.Name;
        end;
        "account type"::Vendor: begin
            Vendor.Get("Account No.");
            "Account Name":=Vendor.Name;
        end;
        end;
    end;
    procedure SetPeriodCaptions(var Args: Record "ForNAV Aged Accounts Args.")begin
        "Caption 1":=Args."Caption 1";
        "Caption 2":=Args."Caption 2";
        "Caption 3":=Args."Caption 3";
        "Caption 4":=Args."Caption 4";
        "Caption 5":=Args."Caption 5";
        "Caption 6":=Args."Caption 6";
        "Caption 7":=Args."Caption 7";
        "Caption 8":=Args."Caption 8";
        "Caption 9":=Args."Caption 9";
        "Caption 10":=Args."Caption 10";
        "Caption 11":=Args."Caption 11";
        "Caption 12":=Args."Caption 12";
        "Caption 13":=Args."Caption 13";
        "Caption 14":=Args."Caption 14";
        "Caption 15":=Args."Caption 15";
        "Caption 16":=Args."Caption 16";
        "Caption 17":=Args."Caption 17";
        "Caption 18":=Args."Caption 18";
        "Caption 19":=Args."Caption 19";
        "Caption 20":=Args."Caption 20";
        "Caption 21":=Args."Caption 21";
        "Caption 22":=Args."Caption 22";
        "Caption 23":=Args."Caption 23";
        "Caption 24":=Args."Caption 24";
        "Caption 25":=Args."Caption 25";
        "Caption 26":=Args."Caption 26";
        "Caption 27":=Args."Caption 27";
        "Caption 28":=Args."Caption 28";
        "Caption 29":=Args."Caption 29";
        "Caption 30":=Args."Caption 30";
        "Caption 31":=Args."Caption 31";
    end;
}
