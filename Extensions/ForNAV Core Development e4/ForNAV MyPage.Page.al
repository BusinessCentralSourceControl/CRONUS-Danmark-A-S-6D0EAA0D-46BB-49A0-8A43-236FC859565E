page 6188478 "ForNAV MyPage"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = AllObj;
    SourceTableView = sorting("Object Id")where("Object ID"=Filter('6188471..6189470'));

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Type;Rec."Object Type")
                {
                    ApplicationArea = All;
                }
                field(No;Rec."Object ID")
                {
                    ApplicationArea = All;
                }
                field(Name;Rec."Object Name")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()begin
                end;
            }
        }
    }
    var myInt: Integer;
// trigger OnOpenPage()
// var
//     TempBlob: Record "ForNAV Core Setup";
//     c: Codeunit "ForNAV - Test Sales Reminders";
//     r: Record "Sales Header";
// begin
//     //        c.TestCheck();
//     //c.TestStatement();
//     //        Report.Run(Report::"ForNAV Statement");
//     r.SetRange("No.", '101005');
//     Report.RunModal(6188471, false, false, r);
// end;
}
