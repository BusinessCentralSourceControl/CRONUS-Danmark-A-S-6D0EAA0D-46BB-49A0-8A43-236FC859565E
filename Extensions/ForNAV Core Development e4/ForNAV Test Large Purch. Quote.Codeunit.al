Codeunit 6189464 "ForNAV Test Large Purch. Quote"
{
    trigger OnRun()var Value: Code[20];
    begin
        Value:=CreatePurchHeaderWithNumber10000;
        CreateALotOfPurchLinesWithNumber6188471(Value);
    end;
    local procedure CreatePurchHeaderWithNumber10000(): Code[20]var PurchaseHeader: Record "Purchase Header";
    begin
        PurchaseHeader.Init;
        PurchaseHeader."Document Type":=PurchaseHeader."document type"::Quote;
        PurchaseHeader.Insert(true);
        PurchaseHeader.SetHideValidationDialog(true);
        PurchaseHeader.Validate(PurchaseHeader."Pay-to Vendor No.", '10000');
        PurchaseHeader.Validate(PurchaseHeader."Buy-from Vendor No.", '10000');
        PurchaseHeader.Modify(true);
        exit(PurchaseHeader."No.");
    end;
    local procedure CreateALotOfPurchLinesWithNumber6188471(Value: Code[20])var PurchaseLine: Record "Purchase Line";
    i: Integer;
    begin
        for i:=1 to 100 do begin
            PurchaseLine.Init;
            PurchaseLine."Document Type":=PurchaseLine."document type"::Quote;
            PurchaseLine."Document No.":=Value;
            PurchaseLine."Line No.":=i * 10000;
            PurchaseLine.Insert(true);
            PurchaseLine.Validate(PurchaseLine.Type, PurchaseLine.Type::Item);
            PurchaseLine.Validate(PurchaseLine."No.", FindValidItem);
            PurchaseLine.Validate(PurchaseLine.Quantity, 1);
            PurchaseLine.Modify(true);
        end;
    end;
    local procedure FindValidItem(): Code[20]var Item: Record Item;
    begin
        Item.FindFirst;
        exit(Item."No.");
    end;
}
