pageextension 6188550 "ForNAV Contact Card" extends "Contact Card"
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

                trigger OnAction()var Cont: Record Contact;
                begin
                    Cont:=Rec;
                    Cont.SetRecFilter;
                    Report.Run(Report::"ForNAV Contact - Label", true, false, Cont);
                end;
            }
        }
    }
}
