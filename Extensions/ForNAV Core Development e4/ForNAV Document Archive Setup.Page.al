page 6189104 "ForNAV Document Archive Setup"
{
    PageType = Worksheet;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "ForNAV Document Archive Setup";
    Caption = 'ForNAV Document Archive Setup';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(ID;Rec."Report ID")
                {
                    ApplicationArea = All;
                }
                field(Name;Rec."Report Name")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
