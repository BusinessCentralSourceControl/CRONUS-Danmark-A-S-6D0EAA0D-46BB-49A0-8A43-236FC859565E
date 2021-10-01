Page 6188480 "ForNAV Report Usage Statistics"
{
    Editable = false;
    PageType = List;
    SourceTable = "ForNAV Report Usage Statistics";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ReportID;Rec."Report ID")
                {
                    ApplicationArea = All;
                }
                field(ReportCaption;Rec."Report Caption")
                {
                    ApplicationArea = All;
                }
                field(UserID;Rec."User ID")
                {
                    ApplicationArea = All;
                }
                field(DateTimePrinted;Rec."Date Time Printed")
                {
                    ApplicationArea = All;
                }
                field(EntryNo;Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
