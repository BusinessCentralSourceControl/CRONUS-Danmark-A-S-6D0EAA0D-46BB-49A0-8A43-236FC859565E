page 6188800 "ForNAV Development"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(Name;'Welcome to ForNAV Development')
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
            // action(OwnReport)
            // {
            //     ApplicationArea = All;
            //     Caption = 'Own Report';
            //     RunObject = report "ForNAV 56790";
            // }
            // action(AppReport)
            // {
            //     ApplicationArea = All;
            //     Caption = 'App Report';
            //     RunObject = report "ForNAV 11014000";
            // }
            action(TEST)
            {
                ApplicationArea = All;
                Caption = 'Test';

                trigger OnAction()var Development: Codeunit 6189420;
                Translations: Codeunit "ForNAV Language Mgt.";
                begin
                    Development.DeleteAllForNAVData();
                end;
            }
            action(CreateWhseStuff)
            {
                ApplicationArea = All;
                Caption = 'Create Whse. Stuff';

                trigger OnAction()var WhseDoc: Codeunit "ForNAV Test Setup Warehouse";
                begin
                    WhseDoc.CreateSetup('FORNAV');
                    WhseDoc.CreateSalesOrder('FORNAV');
                    WhseDoc.CreatePurchaseOrder('FORNAV');
                end;
            }
        }
    }
    trigger OnOpenPage()var //  CreateReminders: Report "ForNAV Create Reminders";
    begin
    //   CreateReminders.RunModal;
    end;
}
