pageextension 6189003 "ForNAV Acc. R. Adm. RC" extends "Acc. Receivables Adm. RC"
{
    actions
    {
        addlast(Sections)
        {
            group(ForNAV)
            {
                Caption = 'Reports ForNAV';

                //          action(ForNAVAllReports)
                //           {
                //                Caption = 'All Reports';
                //                 ApplicationArea = All;
                //                   RunObject = page "ForNAV Reports";
                //                }
                action(ForNAVStandardReports)
                {
                    Caption = 'Standard Reports';
                    ApplicationArea = All;
                    RunObject = page "ForNAV Reports";
                    RunPageView = where(ID=filter(0|6188471..6189470));
                }
                action(ForNAVMyReports)
                {
                    Caption = 'My Reports';
                    ApplicationArea = All;
                    RunObject = page "ForNAV Reports";
                    RunPageView = where(ID=filter(0|50000..99999));
                }
                action(ForNAVAddOnReports)
                {
                    Caption = 'App Reports';
                    ApplicationArea = All;
                    RunObject = page "ForNAV Reports";
                    RunPageView = where(ID=filter(0|1000000..6188470|6189471..98999999));
                }
            }
        }
    }
}
