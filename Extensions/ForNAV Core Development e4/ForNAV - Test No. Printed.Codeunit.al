Codeunit 6189425 "ForNAV - Test No. Printed"
{
    Subtype = Test;

    [Test]
    procedure TestNoPrinted()var SalesHeader: Record "Sales Header";
    PurchaseHeader: Record "Purchase Header";
    SalesShipmentHeader: Record "Sales Shipment Header";
    SalesInvoiceHeader: Record "Sales Invoice Header";
    SalesCrMemoHeader: Record "Sales Cr.Memo Header";
    PurchRcptHeader: Record "Purch. Rcpt. Header";
    PurchInvHeader: Record "Purch. Inv. Header";
    PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
    CompanyInformation: Record "Company Information";
    UpdateNoPrinted: Codeunit "ForNAV Update No. Printed";
    xNoPrinted: Integer;
    begin
        // [Given]
        Initialize;
        // [When]
        // [Then]
        if SalesHeader.FindSet then repeat xNoPrinted:=SalesHeader."No. Printed";
                UpdateNoPrinted.UpdateNoPrinted(SalesHeader, false);
                SalesHeader.Find;
                SalesHeader.TestField(SalesHeader."No. Printed", xNoPrinted + 1);
            until SalesHeader.Next = 0;
        if SalesShipmentHeader.FindSet then repeat xNoPrinted:=SalesShipmentHeader."No. Printed";
                UpdateNoPrinted.UpdateNoPrinted(SalesShipmentHeader, false);
                SalesShipmentHeader.Find;
                SalesShipmentHeader.TestField(SalesShipmentHeader."No. Printed", xNoPrinted + 1);
            until SalesShipmentHeader.Next = 0;
        if SalesInvoiceHeader.FindSet then repeat xNoPrinted:=SalesInvoiceHeader."No. Printed";
                UpdateNoPrinted.UpdateNoPrinted(SalesInvoiceHeader, false);
                SalesInvoiceHeader.Find;
                SalesInvoiceHeader.TestField(SalesInvoiceHeader."No. Printed", xNoPrinted + 1);
            until SalesInvoiceHeader.Next = 0;
        if SalesCrMemoHeader.FindSet then repeat xNoPrinted:=SalesCrMemoHeader."No. Printed";
                UpdateNoPrinted.UpdateNoPrinted(SalesCrMemoHeader, false);
                SalesCrMemoHeader.Find;
                SalesCrMemoHeader.TestField(SalesCrMemoHeader."No. Printed", xNoPrinted + 1);
            until SalesCrMemoHeader.Next = 0;
        if PurchaseHeader.FindSet then repeat xNoPrinted:=PurchaseHeader."No. Printed";
                UpdateNoPrinted.UpdateNoPrinted(PurchaseHeader, false);
                PurchaseHeader.Find;
                PurchaseHeader.TestField(PurchaseHeader."No. Printed", xNoPrinted + 1);
            until PurchaseHeader.Next = 0;
        if PurchRcptHeader.FindSet then repeat xNoPrinted:=PurchRcptHeader."No. Printed";
                UpdateNoPrinted.UpdateNoPrinted(PurchRcptHeader, false);
                PurchRcptHeader.Find;
                PurchRcptHeader.TestField(PurchRcptHeader."No. Printed", xNoPrinted + 1);
            until PurchRcptHeader.Next = 0;
        if PurchInvHeader.FindSet then repeat xNoPrinted:=PurchInvHeader."No. Printed";
                UpdateNoPrinted.UpdateNoPrinted(PurchInvHeader, false);
                PurchInvHeader.Find;
                PurchInvHeader.TestField(PurchInvHeader."No. Printed", xNoPrinted + 1);
            until PurchInvHeader.Next = 0;
        if PurchCrMemoHdr.FindSet then repeat xNoPrinted:=PurchCrMemoHdr."No. Printed";
                UpdateNoPrinted.UpdateNoPrinted(PurchCrMemoHdr, false);
                PurchCrMemoHdr.Find;
                PurchCrMemoHdr.TestField(PurchCrMemoHdr."No. Printed", xNoPrinted + 1);
            until PurchCrMemoHdr.Next = 0;
        CompanyInformation.Get;
        asserterror UpdateNoPrinted.UpdateNoPrinted(CompanyInformation, false);
    end;
    local procedure Initialize()var InitializeTest: Codeunit "ForNAV - Test Initialize Test";
    begin
        if IsInitialized then exit;
        IsInitialized:=true;
    end;
    var IsInitialized: Boolean;
}
