pageextension 6188523 "ForNAV Vendor Card" extends "Vendor Card"
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

                trigger OnAction()var Vend: Record Vendor;
                begin
                    Vend:=Rec;
                    Vend.SetRecFilter;
                    Report.Run(Report::"ForNAV Vendor - Label", true, false, Vend);
                end;
            }
        }
    }
}
