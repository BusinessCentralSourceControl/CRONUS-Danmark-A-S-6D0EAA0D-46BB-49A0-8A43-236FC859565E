pageextension 6188576 "ForNAV Resource Card" extends "Resource Card"
{
    actions
    {
        addlast(Reporting)
        {
            action(ForNAVLabels)
            {
                Caption = 'ForNAV Label';
                Image = PrintCover;
                ApplicationArea = All;

                trigger OnAction()var Res: Record Resource;
                begin
                    Res:=Rec;
                    Res.SetRecFilter;
                    Report.Run(Report::"ForNAV Resource - Label", true, false, Res);
                end;
            }
        }
    }
}
