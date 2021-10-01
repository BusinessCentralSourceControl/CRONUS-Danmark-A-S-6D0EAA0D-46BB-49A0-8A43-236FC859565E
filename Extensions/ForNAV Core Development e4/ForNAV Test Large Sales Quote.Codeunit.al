Codeunit 6189466 "ForNAV Test Large Sales Quote"
{
    trigger OnRun()var Value: Code[20];
    begin
        Value:=CreateSalesHeaderWithNumber10000;
        CreateALotOfSalesLinesWithValidItem(Value);
    end;
    local procedure CreateSalesHeaderWithNumber10000(): Code[20]var SalesHeader: Record "Sales Header";
    begin
        SalesHeader.Init;
        SalesHeader."Document Type":=SalesHeader."document type"::Quote;
        SalesHeader.Insert(true);
        SalesHeader.SetHideValidationDialog(true);
        SalesHeader.Validate(SalesHeader."Bill-to Customer No.", '10000');
        SalesHeader.Validate(SalesHeader."Sell-to Customer No.", '10000');
        SalesHeader.Modify(true);
        exit(SalesHeader."No.");
    end;
    local procedure CreateALotOfSalesLinesWithValidItem(Value: Code[20])var SalesLine: Record "Sales Line";
    i: Integer;
    begin
        for i:=1 to 100 do begin
            SalesLine.Init;
            SalesLine."Document Type":=SalesLine."document type"::Quote;
            SalesLine."Document No.":=Value;
            SalesLine."Line No.":=i * 10000;
            SalesLine.Insert(true);
            SalesLine.SetHideValidationDialog(true);
            SalesLine.Validate(SalesLine.Type, SalesLine.Type::Item);
            SalesLine.Validate(SalesLine."No.", FindValidItem);
            SalesLine.Validate(SalesLine.Quantity, 1);
            SalesLine.Modify(true);
        end;
    end;
    local procedure FindValidItem(): Code[20]var Item: Record Item;
    begin
        Item.FindFirst;
        exit(Item."No.");
    end;
}
