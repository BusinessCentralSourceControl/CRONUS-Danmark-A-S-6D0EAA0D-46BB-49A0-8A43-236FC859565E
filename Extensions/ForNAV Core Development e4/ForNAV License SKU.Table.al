Table 6188496 "ForNAV License SKU"
{
    Caption = 'ForNAV License SKU', Comment='DO NOT TRANSLATE';

    fields
    {
        field(1;"Entry No.";Integer)
        {
            Caption = 'Entry No.', Comment='DO NOT TRANSLATE';
            DataClassification = CustomerContent;
        }
        field(2;SKU;Text[250])
        {
            Caption = 'SKU', Comment='DO NOT TRANSLATE';
            DataClassification = CustomerContent;
        }
        field(3;Units;Integer)
        {
            Caption = 'Units', Comment='DO NOT TRANSLATE';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(Key1;"Entry No.")
        {
        }
    }
    fieldgroups
    {
    }
    procedure AddSku(Name: Text;
    Value: Integer)begin
        if FindLast then "Entry No."+=1;
        SKU:=CopyStr(Name, 1, 250);
        Units:=Value;
        Insert;
    end;
    procedure AddDataFromQuery()var UsersInPlans: Query "Users in Plans";
    Plan: Query Plan;
    UserCount: Integer;
    begin
        Plan.Open;
        while Plan.Read do begin
            UserCount:=0;
            UsersInPlans.SetRange(Plan_ID, Plan.Plan_ID);
            UsersInPlans.Open;
            while UsersInPlans.Read do UserCount+=1;
            AddSku(Plan.Plan_Name, UserCount);
        end;
    end;
}
