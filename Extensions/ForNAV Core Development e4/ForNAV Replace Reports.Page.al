Page 6188487 "ForNAV Replace Reports"
{
    ApplicationArea = All;
    Caption = 'ForNAV Replace With Report';
    PageType = List;
    SourceTable = "ForNAV Report Replacement";
    UsageCategory = Administration;

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
                field(UserID;Rec."User-ID")
                {
                    ApplicationArea = All;
                }
                field(ReplaceWithReportID;Rec."Replace-With Report ID")
                {
                    ApplicationArea = All;
                }
                field(ReportName;Rec."Report Name")
                {
                    ApplicationArea = All;
                }
                field(ReplaceWithReportName;Rec."Replace-With Report Name")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(processing)
        {
            action(UseForNAV)
            {
                ApplicationArea = All;
                Caption = 'Use ForNAV';
                Image = Default;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()begin
                    Rec.CreateForNAVDefaultReportReplacement;
                end;
            }
            action(Test)
            {
                ApplicationArea = All;
                Caption = 'Test Print';
                Image = TestReport;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()begin
                    Rec.TestReport;
                end;
            }
        }
    }
}
