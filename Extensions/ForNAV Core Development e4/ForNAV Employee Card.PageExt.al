pageextension 6188520 "ForNAV Employee Card" extends "Employee Card"
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

                trigger OnAction()var Empl: Record Employee;
                begin
                    Empl:=Rec;
                    Empl.SetRecFilter;
                    Report.Run(Report::"ForNAV Employee - Label", true, false, Empl);
                end;
            }
        }
    }
}
