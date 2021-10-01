page 6189182 "ForNAV Fields"
{
    PageType = List;
    SourceTable = "ForNAV Field";
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("No.";Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Name;Rec.Name)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    trigger OnOpenPage()var Fld: Record Field;
    PlsFilterOnTableErr: Label 'Please filter on a Table first';
    begin
        if Rec.GetFilter("Table No.") = '' then Error(PlsFilterOnTableErr);
        fld.SetFilter(TableNo, Rec.GetFilter("Table No."));
        fld.FindSet;
        repeat Rec."No.":=Fld."No.";
            Rec.Name:=Fld.FieldName;
            Rec.Insert;
        until fld.Next = 0;
        Rec.FindFirst;
    end;
}
