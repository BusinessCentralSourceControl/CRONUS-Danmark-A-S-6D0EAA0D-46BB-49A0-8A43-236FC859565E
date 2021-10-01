pageextension 6188627 "ForNAV Finished Prod. Orders" extends "Finished Production Orders"
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
