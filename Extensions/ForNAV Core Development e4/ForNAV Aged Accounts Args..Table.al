Table 6188690 "ForNAV Aged Accounts Args."
{
    fields
    {
        field(1;"Print Amounts in LCY";Boolean)
        {
            Caption = 'Print Amounts in LCY';
            DataClassification = SystemMetadata;
        }
        field(2;"Ending Date";Date)
        {
            Caption = 'Ending Date';
            DataClassification = SystemMetadata;
        }
        field(3;"Aging By";Option)
        {
            Caption = 'Aging Band by';
            DataClassification = SystemMetadata;
            OptionCaption = 'Due Date,Posting Date,Document Date';
            OptionMembers = "Due Date", "Posting Date", "Document Date";
        }
        field(4;"Period Length";DateFormula)
        {
            Caption = 'Period Length';
            DataClassification = SystemMetadata;
        }
        field(5;"Print Details";Boolean)
        {
            Caption = 'Print Details';
            DataClassification = SystemMetadata;
        }
        field(6;"Heading Type";Option)
        {
            Caption = 'Heading Type';
            DataClassification = SystemMetadata;
            OptionMembers = "Date Interval", "Number of Days";
        }
        field(7;"New Page Per Customer";Boolean)
        {
            Caption = 'New Page Per Customer';
            DataClassification = SystemMetadata;
        }
        field(9;"Period Start Date";Date)
        {
            Caption = 'Period Start Date';
            DataClassification = SystemMetadata;
        }
        field(12;"Currency Code";Code[10])
        {
            Caption = 'Currency Code';
            DataClassification = SystemMetadata;
        }
        field(13;"Column Count";Integer)
        {
            Caption = 'Column Count';
            DataClassification = SystemMetadata;
            MaxValue = 31;
            MinValue = 1;
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
        key(Key1;"Print Amounts in LCY")
        {
        }
    }
    var PeriodStartDate: array[31]of Date;
    PeriodEndDate: array[31]of Date;
    procedure CalcDates()var i: Integer;
    PeriodLength2: DateFormula;
    DateFormulaCannotBeUserErr: label 'The Date Formula %1 cannot be used';
    Text032: label '-%1', Comment='DO NOT TRANSLATE';
    begin
        Evaluate(PeriodLength2, StrSubstNo(Text032, "Period Length"));
        if "Aging By" = "aging by"::"Due Date" then begin
            PeriodEndDate[1]:=Dmy2date(31, 12, 9999);
            PeriodStartDate[1]:="Ending Date" + 1;
        end
        else
        begin
            PeriodEndDate[1]:="Ending Date";
            PeriodStartDate[1]:=CalcDate(PeriodLength2, "Ending Date" + 1);
        end;
        for i:=2 to "Column Count" do begin
            PeriodEndDate[i]:=PeriodStartDate[i - 1] - 1;
            PeriodStartDate[i]:=CalcDate(PeriodLength2, PeriodEndDate[i] + 1);
        end;
        PeriodStartDate[i]:=0D;
        for i:=1 to "Column Count" do if PeriodEndDate[i] < PeriodStartDate[i]then Error(DateFormulaCannotBeUserErr, "Period Length");
        CreateHeadings;
    end;
    procedure GetPeriodIndex(Date: Date): Integer var i: Integer;
    begin
        for i:=1 to "Column Count" do if Date in[PeriodStartDate[i] .. PeriodEndDate[i]]then exit(i);
    end;
    local procedure CreateHeadings()var HeaderText: array[31]of Text;
    i: Integer;
    NotDueTxt: label 'Not Due';
    BeforeTxt: label 'Before';
    DaysTxt: label 'days';
    MoreThanTxt: label 'More than';
    begin
        if "Aging By" = "aging by"::"Due Date" then begin
            HeaderText[1]:=NotDueTxt;
            i:=2;
        end
        else
            i:=1;
        while i < "Column Count" do begin
            if "Heading Type" = "heading type"::"Date Interval" then HeaderText[i]:=StrSubstNo('%1\..%2', PeriodStartDate[i], PeriodEndDate[i])
            else
                HeaderText[i]:=StrSubstNo('%1 - %2 %3', "Ending Date" - PeriodEndDate[i] + 1, "Ending Date" - PeriodStartDate[i] + 1, DaysTxt);
            i:=i + 1;
        end;
        if "Heading Type" = "heading type"::"Date Interval" then HeaderText["Column Count"]:=StrSubstNo('%1 \%2', BeforeTxt, PeriodStartDate[i - 1])
        else
            HeaderText["Column Count"]:=StrSubstNo('%1 \%2 %3', MoreThanTxt, "Ending Date" - PeriodStartDate[i - 1] + 1, DaysTxt);
        "Caption 1":=HeaderText[1];
        "Caption 2":=HeaderText[2];
        "Caption 3":=HeaderText[3];
        "Caption 4":=HeaderText[4];
        "Caption 5":=HeaderText[5];
        "Caption 6":=HeaderText[6];
        "Caption 7":=HeaderText[7];
        "Caption 8":=HeaderText[8];
        "Caption 9":=HeaderText[9];
        "Caption 10":=HeaderText[10];
        "Caption 11":=HeaderText[11];
        "Caption 12":=HeaderText[12];
        "Caption 13":=HeaderText[13];
        "Caption 14":=HeaderText[14];
        "Caption 15":=HeaderText[15];
        "Caption 16":=HeaderText[16];
        "Caption 17":=HeaderText[17];
        "Caption 18":=HeaderText[18];
        "Caption 19":=HeaderText[19];
        "Caption 20":=HeaderText[20];
        "Caption 21":=HeaderText[21];
        "Caption 22":=HeaderText[22];
        "Caption 23":=HeaderText[23];
        "Caption 24":=HeaderText[24];
        "Caption 25":=HeaderText[25];
        "Caption 26":=HeaderText[26];
        "Caption 27":=HeaderText[27];
        "Caption 28":=HeaderText[28];
        "Caption 29":=HeaderText[29];
        "Caption 30":=HeaderText[30];
        "Caption 31":=HeaderText[31];
    end;
}
