Codeunit 6189423 "ForNAV - Test VAT Buffer"
{
    Subtype = Test;

    [Test]
    procedure TestCreateVATAmoutLine()begin
        // [Given]
        Initialize;
        // [When]
        // [Then]
        TestVATBuffer;
    end;
    procedure TestVATBuffer()var SalesHeader: Record "Sales Header";
    SalesInvoiceHeader: Record "Sales Invoice Header";
    VATAmountLine: Record "VAT Amount Line" temporary;
    GetVatAmountLines: Codeunit "ForNAV Get Vat Amount Lines";
    begin
        if SalesHeader.FindSet then repeat GetVatAmountLines.GetVatAmountLines(SalesHeader, VATAmountLine);
            until SalesHeader.Next = 0;
        if SalesInvoiceHeader.FindSet then repeat GetVatAmountLines.GetVatAmountLines(SalesInvoiceHeader, VATAmountLine);
            until SalesInvoiceHeader.Next = 0;
    end;
    local procedure Initialize()var InitializeTest: Codeunit "ForNAV - Test Initialize Test";
    begin
        if IsInitialized then exit;
        IsInitialized:=true;
    end;
    var IsInitialized: Boolean;
}
