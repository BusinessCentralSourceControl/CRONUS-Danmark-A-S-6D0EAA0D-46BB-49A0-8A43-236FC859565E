pageextension 6188521 "ForNAV Customer Card" extends "Customer Card"
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

                trigger OnAction()var Cust: Record Customer;
                begin
                    Cust:=Rec;
                    Cust.SetRecFilter;
                    Report.Run(Report::"ForNAV Customer - Label", true, false, Cust);
                end;
            }
        }
    }
}
