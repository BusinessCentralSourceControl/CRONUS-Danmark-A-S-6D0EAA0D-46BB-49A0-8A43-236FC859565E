codeunit 6189402 "ForNAV Test Setup Warehouse"
{
    trigger OnRun()begin
        CreateSetup('FORNAV');
    end;
    procedure CreateSetup(LocationCode: Code[20])begin
        CreateLocation(LocationCode);
        CreateWhseEmployee(LocationCode);
        CreateNoSeries('SHP');
        CreateNoSeries('RCV');
        ChangeWarehouseSetup(LocationCode);
        ChangeInventoryPostingSetup(LocationCode);
    end;
    local procedure CreateLocation(Value: Code[20])var Location: Record Location;
    begin
        Location.Code:=Value;
        Location."Require Receive":=true;
        Location."Require Shipment":=true;
        Location.Insert;
    end;
    local procedure CreateWhseEmployee(Value: Code[20])var WhseEmpl: Record "Warehouse Employee";
    begin
        WhseEmpl."User ID":=UserId;
        WhseEmpl."Location Code":=Value;
        WhseEmpl.Insert;
    end;
    local procedure CreateNoSeries(Value: Code[20])var NoSeries: Record "No. Series";
    NoSeriesLine: Record "No. Series Line";
    begin
        NoSeries.Code:=Value;
        NoSeries."Default Nos.":=true;
        NoSeries.Insert;
        NoSeriesLine."Series Code":=Value;
        NoSeriesLine."Starting No.":=Value + '01';
        NoSeriesLine.Insert;
    end;
    local procedure ChangeWarehouseSetup(Value: Code[20]);
    var WhseSetup: Record "Warehouse Setup";
    begin
        WhseSetup.Get;
        WhseSetup."Require Receive":=true;
        WhseSetup."Require Shipment":=true;
        WhseSetup."Whse. Receipt Nos.":='RCV';
        WhseSetup."Whse. Ship Nos.":='SHP';
        WhseSetup."Posted Whse. Receipt Nos.":=WhseSetup."Whse. Receipt Nos.";
        WhseSetup."Posted Whse. Shipment Nos.":=WhseSetup."Whse. Ship Nos.";
        WhseSetup.Modify;
    end;
    local procedure ChangeInventoryPostingSetup(Value: Code[20]);
    var InvPostSetup: Record "Inventory Posting Setup";
    begin
        InvPostSetup.SetFilter("Inventory Account", '<>%1', '');
        InvPostSetup.FindFirst;
        InvPostSetup."Location Code":=Value;
        InvPostSetup.Insert;
    end;
    procedure CreateSalesOrder(Value: Code[20]);
    var SalesHeader: Record "Sales Header";
    SalesLine: Record "Sales Line";
    GetSourceDocOutbound: Codeunit "Get Source Doc. Outbound";
    Release: Codeunit "Release Sales Document";
    begin
        SalesHeader.Init;
        SalesHeader."Document Type":=SalesHeader."document type"::Order;
        SalesHeader.Insert(true);
        SalesHeader.SetHideValidationDialog(true);
        SalesHeader.Validate(SalesHeader."Bill-to Customer No.", '10000');
        SalesHeader.Validate(SalesHeader."Sell-to Customer No.", '10000');
        SalesHeader.Modify(true);
        SalesLine.Init;
        SalesLine."Document Type":=SalesHeader."document type";
        SalesLine."Document No.":=SalesHeader."No.";
        SalesLine."Line No.":=10000;
        SalesLine.Insert(true);
        SalesLine.SetHideValidationDialog(true);
        SalesLine.Validate(SalesLine.Type, SalesLine.Type::Item);
        SalesLine.Validate(SalesLine."No.", FindValidItem);
        SalesLine.Validate(SalesLine.Quantity, 1);
        SalesLine.Validate(SalesLine."Location Code", Value);
        SalesLine.Modify(true);
        Release.run(SalesHeader);
        GetSourceDocOutbound.CreateFromSalesOrder(SalesHeader);
    end;
    procedure CreatePurchaseOrder(Value: Code[20]);
    var PurchaseHeader: Record "Purchase Header";
    PurchaseLine: Record "Purchase Line";
    GetSourceDocInbound: Codeunit "Get Source Doc. Inbound";
    Release: Codeunit "Release Purchase Document";
    begin
        PurchaseHeader.Init;
        PurchaseHeader."Document Type":=PurchaseHeader."document type"::Order;
        PurchaseHeader.Insert(true);
        PurchaseHeader.SetHideValidationDialog(true);
        PurchaseHeader.Validate(PurchaseHeader."Pay-to Vendor No.", '10000');
        PurchaseHeader.Validate(PurchaseHeader."Buy-from Vendor No.", '10000');
        PurchaseHeader.Modify(true);
        PurchaseLine.Init;
        PurchaseLine."Document Type":=PurchaseHeader."Document Type";
        PurchaseLine."Document No.":=PurchaseHeader."No.";
        PurchaseLine."Line No.":=10000;
        PurchaseLine.Insert(true);
        PurchaseLine.Validate(PurchaseLine.Type, PurchaseLine.Type::Item);
        PurchaseLine.Validate(PurchaseLine."No.", FindValidItem);
        PurchaseLine.Validate(PurchaseLine.Quantity, 1);
        PurchaseLine.Validate(PurchaseLine."Location Code", Value);
        PurchaseLine.Modify(true);
        Release.run(PurchaseHeader);
        GetSourceDocInbound.CreateFromPurchOrder(PurchaseHeader);
    end;
    local procedure FindValidItem(): Code[20]var Item: Record Item;
    begin
        Item.FindFirst;
        exit(Item."No.");
    end;
}
