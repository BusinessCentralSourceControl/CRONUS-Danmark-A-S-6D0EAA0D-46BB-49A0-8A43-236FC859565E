pageextension 6188625 "ForNAV Firm Planned Prod. Ord." extends "Firm Planned Prod. Orders"
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
