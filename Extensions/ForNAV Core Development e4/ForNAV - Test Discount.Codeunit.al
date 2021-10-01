Codeunit 6189422 "ForNAV - Test Discount"
{
    Subtype = Test;

    [Test]
    procedure TestDiscountForDocument()begin
        // [Given]
        Initialize;
        // [When]
        // [Then]
        TestDiscountExpected;
    end;
    procedure TestDiscountExpected()var SalesHeader: Record "Sales Header";
    SalesLine: Record "Sales Line";
    CheckDocumentDiscount: Codeunit "ForNAV Check Document Discount";
    begin
        if SalesHeader.FindSet then repeat SalesLine.SetRange("Document No.", SalesHeader."No.");
                SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                SalesLine.SetFilter("Line Discount %", '<>0');
                if SalesLine.IsEmpty then begin
                    if CheckDocumentDiscount.HasDiscount(SalesHeader)then Error('No Discount expected for record ' + Format(SalesHeader));
                end
                else
                begin
                    if not CheckDocumentDiscount.HasDiscount(SalesHeader)then Error('Discount expected for record ' + Format(SalesHeader));
                end;
            until SalesHeader.Next = 0;
    end;
    local procedure Initialize()var InitializeTest: Codeunit "ForNAV - Test Initialize Test";
    begin
        if IsInitialized then exit;
        IsInitialized:=true;
    end;
    var IsInitialized: Boolean;
}
