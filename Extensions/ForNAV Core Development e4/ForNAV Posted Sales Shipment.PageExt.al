pageextension 6188530 "ForNAV Posted Sales Shipment" extends "Posted Sales Shipment"
{
    actions
    {
        addlast(Reporting)
        {
            action(ForNAVShippingLabel)
            {
                Caption = 'ForNAV Label';
                Image = PrintAcknowledgement;
                ApplicationArea = All;

                trigger OnAction()var SalesShipmentHeader: Record "Sales Shipment Header";
                begin
                    SalesShipmentHeader:=Rec;
                    SalesShipmentHeader.SetRecFilter;
                    Report.Run(Report::"ForNAV Sales Shipment Label", true, false, SalesShipmentHeader);
                end;
            }
        }
    }
}
