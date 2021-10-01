pageextension 6188623 "ForNAV Simulated Prod. Orders" extends "Simulated Production Orders"
{
    actions
    {
        addlast(Reporting)
        {
            action(ForNAVProductionLabel)
            {
                Caption = 'ForNAV Label';
                Image = PrintAcknowledgement;
                ApplicationArea = All;

                trigger OnAction()var ProductionOrder: Record "Production Order";
                begin
                    ProductionOrder:=Rec;
                    ProductionOrder.SetRecFilter;
                    Report.Run(Report::"ForNAV Production Label", true, false, ProductionOrder);
                end;
            }
        }
    }
}
