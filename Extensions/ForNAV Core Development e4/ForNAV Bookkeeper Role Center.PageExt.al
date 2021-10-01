pageextension 6189004 "ForNAV Bookkeeper Role Center" extends "Bookkeeper Role Center"
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
