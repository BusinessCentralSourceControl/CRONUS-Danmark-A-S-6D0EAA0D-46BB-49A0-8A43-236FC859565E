Codeunit 6189467 "ForNAV Crte. Purch. Inv. Check"
{
    trigger OnRun()var Value: Code[20];
    i: Integer;
    begin
        for i:=1 to 30 do begin
            Value:=CreatePurchHeaderWithNumber10000;
            CreatePurchLinesWithRandomAmount(Value);
            PostIt(Value);
        end;
    end;
    local procedure CreatePurchHeaderWithNumber10000(): Code[20]var PurchaseHeader: Record "Purchase Header";
    begin
        PurchaseHeader.Init;
        PurchaseHeader."Document Type":=PurchaseHeader."document type"::Invoice;
        PurchaseHeader.Insert(true);
        PurchaseHeader.SetHideValidationDialog(true);
        PurchaseHeader.Validate(PurchaseHeader."Pay-to Vendor No.", '10000');
        PurchaseHeader.Validate(PurchaseHeader."Buy-from Vendor No.", '10000');
        PurchaseHeader.Validate(PurchaseHeader."Vendor Invoice No.", PurchaseHeader."No.");
        PurchaseHeader.Validate(PurchaseHeader."Posting Date", PurchaseHeader."Posting Date" - 30);
        PurchaseHeader.Modify(true);
        exit(PurchaseHeader."No.");
    end;
    local procedure CreatePurchLinesWithRandomAmount(Value: Code[20])var PurchaseLine: Record "Purchase Line";
    i: Integer;
    begin
        for i:=1 to 1 do begin
            PurchaseLine.Init;
            PurchaseLine."Document Type":=PurchaseLine."document type"::Invoice;
            PurchaseLine."Document No.":=Value;
            PurchaseLine."Line No.":=i * 10000;
            PurchaseLine.Insert(true);
            //SetHideValidationDialog(TRUE);
            PurchaseLine.Validate(PurchaseLine.Type, PurchaseLine.Type::"G/L Account");
            PurchaseLine.Validate(PurchaseLine."No.", FindDirectPostngAccount);
            PurchaseLine.Validate(PurchaseLine.Quantity, 1);
            PurchaseLine.Validate(PurchaseLine."Direct Unit Cost", 60);
            PurchaseLine.Modify(true);
        end;
    end;
    local procedure PostIt(Value: Code[20])var PurchaseHeader: Record "Purchase Header";
    PurchPost: Codeunit "Purch.-Post";
    begin
        PurchaseHeader.Get(PurchaseHeader."document type"::Invoice, Value);
        PurchPost.Run(PurchaseHeader);
    end;
    local procedure FindDirectPostngAccount(): Code[20]var GLAccount: Record "G/L Account";
    begin
        //exit('8110'); DK
        exit('40100');
        GLAccount.SetRange("Direct Posting", true);
        GLAccount.SetFilter("VAT Prod. Posting Group", '<>%1', '');
        GLAccount.FindFirst;
        exit(GLAccount."No.");
    end;
    local procedure FindVatPordPostingGroup(): Code[20]var VATProductPostingGroup: Record "VAT Product Posting Group";
    begin
        VATProductPostingGroup.FindFirst;
        exit(VATProductPostingGroup.Code);
    end;
}
