Codeunit 6188500 "ForNAV Replace Report Sel."
{
    trigger OnRun()var DefaultReportSelection: Record "ForNAV Report Selection Hist." temporary;
    begin
        GetDefaults(DefaultReportSelection);
        Replace(DefaultReportSelection);
    end;
    var "Object": Record "ForNAV Object" temporary;
    procedure GetDefaults(var DefaultReportSelection: Record "ForNAV Report Selection Hist.")var Dlg: Dialog;
    begin
        Dlg.Open('#1#####################################');
        Dlg.Update(1, 'Create Object Buffer');
        CreateBuffer;
        ReplaceSalesOrderConfirmation(DefaultReportSelection);
        Dlg.Update(1, 'Sales Order Confirmation');
        ReplaceSalesInvoice(DefaultReportSelection);
        Dlg.Update(1, 'Sales Invoice');
        ReplaceProFormaInvoice(DefaultReportSelection);
        Dlg.Update(1, 'Pro Forma Invoice');
        ReplaceDraftInvoice(DefaultReportSelection);
        Dlg.Update(1, 'Draft Invoice');
        ReplaceSalesCreditMemo(DefaultReportSelection);
        Dlg.Update(1, 'Sales Credit Memo');
        ReplaceSalesShipment(DefaultReportSelection);
        Dlg.Update(1, 'Sales Shipment');
        ReplaceSalesQuote(DefaultReportSelection);
        Dlg.Update(1, 'Sales Quote');
        ReplacePickList(DefaultReportSelection);
        Dlg.Update(1, 'Picking List');
        ReplacePurchaseOrder(DefaultReportSelection);
        Dlg.Update(1, 'Purchase Order');
        ReplacePurchaseInvoice(DefaultReportSelection);
        Dlg.Update(1, 'Purchase Invoice');
        ReplacePurchaseQuote(DefaultReportSelection);
        Dlg.Update(1, 'Purchase Quote');
        ReplacePurchaseCreditMemo(DefaultReportSelection);
        Dlg.Update(1, 'Purchase Credit Memo');
        ReplaceCheck(DefaultReportSelection);
        Dlg.Update(1, 'Check');
        ReplaceStatement(DefaultReportSelection);
        Dlg.Update(1, 'Statement');
        ReplaceReminder(DefaultReportSelection);
        Dlg.Update(1, 'Reminder');
        ReplaceReminderTest(DefaultReportSelection);
        Dlg.Update(1, 'Reminder Test');
        ReplaceFinanceChargeMemo(DefaultReportSelection);
        Dlg.Update(1, 'Finance Charge Memo');
        ReplaceFinanceChargeMemoTest(DefaultReportSelection);
        Dlg.Update(1, 'Finance Charge Memo Test');
        ReplaceServiceOrder(DefaultReportSelection);
        Dlg.Update(1, 'Service Order');
        ReplaceServiceInvoice(DefaultReportSelection);
        Dlg.Update(1, 'Service Invoice');
        ReplaceServiceCreditMemo(DefaultReportSelection);
        Dlg.Update(1, 'Service Credit Memo');
        ReplaceServiceShipment(DefaultReportSelection);
        Dlg.Update(1, 'Service Shipment');
        ReplaceServiceQuote(DefaultReportSelection);
        Dlg.Update(1, 'Service Quote');
        ReplaceWarehouseReceipt(DefaultReportSelection);
        Dlg.Update(1, 'Warehouse Shipment');
        ReplaceWarehouseShipment(DefaultReportSelection);
        Dlg.Update(1, 'Warehouse Receipt');
        ReplacePostedWarehouseReceipt(DefaultReportSelection);
        Dlg.Update(1, 'Warehouse Shipment');
        ReplacePostedWarehouseShipment(DefaultReportSelection);
        Dlg.Update(1, 'Warehouse Receipt');
    end;
    local procedure Replace(var DefaultReportSelection: Record "ForNAV Report Selection Hist.")var ReportSelections: Record "Report Selections";
    AllObj: Record AllObj;
    RecRef: RecordRef;
    FldRef: FieldRef;
    Usge: Integer;
    begin
        if DefaultReportSelection.FindSet then repeat if DefaultReportSelection.Origin = 77 then Usge:=DefaultReportSelection.Usage
                else
                    Usge:=DefaultReportSelection."Usage (Warehouse)";
                AllObj.SetRange("Object Type", AllObj."object type"::Table);
                AllObj.SetRange("Object ID", DefaultReportSelection.Origin);
                if AllObj.FindFirst then begin
                    RecRef.Open(DefaultReportSelection.Origin);
                    FldRef:=RecRef.Field(DefaultReportSelection.FieldNo(DefaultReportSelection.Usage));
                    FldRef.SetRange(Usge);
                    if RecRef.FindSet then repeat SaveHistory(DefaultReportSelection.Origin, Usge, RecRef.Field(3).Value, RecRef.Field(2).Value);
                        until RecRef.Next = 0;
                    DeleteExisting(RecRef);
                    FldRef.Value:=DefaultReportSelection.Usage;
                    FldRef:=RecRef.Field(DefaultReportSelection.FieldNo(DefaultReportSelection.Sequence));
                    FldRef.Value:=DefaultReportSelection.Sequence;
                    FldRef:=RecRef.Field(DefaultReportSelection.FieldNo(DefaultReportSelection."Report ID"));
                    FldRef.Value:=DefaultReportSelection."Report ID";
                    if DefaultReportSelection.Origin = 77 then begin
                        FldRef:=RecRef.Field((DefaultReportSelection.FieldNo(DefaultReportSelection."Use for Email Body")));
                        FldRef.Value:=false;
                    end;
                    RecRef.Insert;
                    RecRef.Close;
                end;
            until DefaultReportSelection.Next = 0;
    end;
    local procedure ReplaceSalesOrderConfirmation(var DefaultReportSelection: Record "ForNAV Report Selection Hist.")begin
        DefaultReportSelection.Usage:=DefaultReportSelection.Usage::"S.Order";
        DefaultReportSelection.Sequence:='1';
        DefaultReportSelection."Report ID":=FindReportID('Order Confirmation', GetPrefix);
        DefaultReportSelection.Origin:=77;
        DefaultReportSelection.Insert;
    end;
    local procedure ReplaceSalesInvoice(var DefaultReportSelection: Record "ForNAV Report Selection Hist.")begin
        DefaultReportSelection.Usage:=DefaultReportSelection.Usage::"S.Invoice";
        DefaultReportSelection.Sequence:='1';
        DefaultReportSelection."Report ID":=FindReportID('Sales Invoice', GetPrefix);
        DefaultReportSelection.Insert;
    end;
    local procedure ReplaceProFormaInvoice(var DefaultReportSelection: Record "ForNAV Report Selection Hist.")begin
        DefaultReportSelection.Usage:=DefaultReportSelection.Usage::"Pro Forma S. Invoice";
        DefaultReportSelection.Sequence:='1';
        DefaultReportSelection."Report ID":=FindReportID('Pro Forma Invoice', GetPrefix);
        DefaultReportSelection.Insert;
    end;
    local procedure ReplaceDraftInvoice(var DefaultReportSelection: Record "ForNAV Report Selection Hist.")begin
        DefaultReportSelection.Usage:=DefaultReportSelection.Usage::"S.Invoice Draft";
        DefaultReportSelection.Sequence:='1';
        DefaultReportSelection."Report ID":=FindReportID('Draft Invoice', GetPrefix);
        DefaultReportSelection.Insert;
    end;
    local procedure ReplaceSalesCreditMemo(var DefaultReportSelection: Record "ForNAV Report Selection Hist.")begin
        DefaultReportSelection.Usage:=DefaultReportSelection.Usage::"S.Cr.Memo";
        DefaultReportSelection.Sequence:='1';
        DefaultReportSelection."Report ID":=FindReportID('Credit Memo', GetPrefix);
        DefaultReportSelection.Insert;
    end;
    local procedure ReplaceSalesShipment(var DefaultReportSelection: Record "ForNAV Report Selection Hist.")begin
        DefaultReportSelection.Usage:=DefaultReportSelection.Usage::"S.Shipment";
        DefaultReportSelection.Sequence:='1';
        DefaultReportSelection."Report ID":=FindReportID('Sales Shipment', '');
        DefaultReportSelection.Insert;
    end;
    local procedure ReplaceSalesQuote(var DefaultReportSelection: Record "ForNAV Report Selection Hist.")begin
        DefaultReportSelection.Usage:=DefaultReportSelection.Usage::"S.Quote";
        DefaultReportSelection.Sequence:='1';
        DefaultReportSelection."Report ID":=FindReportID('Sales Quote', GetPrefix);
        DefaultReportSelection.Insert;
    end;
    local procedure ReplacePickList(var DefaultReportSelection: Record "ForNAV Report Selection Hist.")begin
        DefaultReportSelection.Usage:=DefaultReportSelection.Usage::"S.Order Pick Instruction";
        DefaultReportSelection.Sequence:='1';
        DefaultReportSelection."Report ID":=FindReportID('Picking List', '');
        DefaultReportSelection.Insert;
    end;
    local procedure ReplacePurchaseOrder(var DefaultReportSelection: Record "ForNAV Report Selection Hist.")begin
        DefaultReportSelection.Usage:=DefaultReportSelection.Usage::"P.Order";
        DefaultReportSelection.Sequence:='1';
        DefaultReportSelection."Report ID":=FindReportID('Purchase Order', GetPrefix);
        DefaultReportSelection.Insert;
    end;
    local procedure ReplacePurchaseQuote(var DefaultReportSelection: Record "ForNAV Report Selection Hist.")begin
        DefaultReportSelection.Usage:=DefaultReportSelection.Usage::"P.Quote";
        DefaultReportSelection.Sequence:='1';
        DefaultReportSelection."Report ID":=FindReportID('Purchase Quote', GetPrefix);
        DefaultReportSelection.Insert;
    end;
    local procedure ReplacePurchaseInvoice(var DefaultReportSelection: Record "ForNAV Report Selection Hist.")begin
        DefaultReportSelection.Usage:=DefaultReportSelection.Usage::"P.Invoice";
        DefaultReportSelection.Sequence:='1';
        DefaultReportSelection."Report ID":=FindReportID('Purchase Invoice', GetPrefix);
        DefaultReportSelection.Insert;
    end;
    local procedure ReplacePurchaseCreditMemo(var DefaultReportSelection: Record "ForNAV Report Selection Hist.")begin
        DefaultReportSelection.Usage:=DefaultReportSelection.Usage::"P.Cr.Memo";
        DefaultReportSelection.Sequence:='1';
        DefaultReportSelection."Report ID":=FindReportID('Purchase Cr. Memo', GetPrefix);
        DefaultReportSelection.Insert;
    end;
    local procedure ReplaceCheck(var DefaultReportSelection: Record "ForNAV Report Selection Hist.")begin
        DefaultReportSelection.Usage:=DefaultReportSelection.Usage::"B.Check";
        DefaultReportSelection.Sequence:='1';
        DefaultReportSelection."Report ID":=FindReportID('US Check', '');
        DefaultReportSelection.Insert;
    end;
    local procedure ReplaceStatement(var DefaultReportSelection: Record "ForNAV Report Selection Hist.")begin
        DefaultReportSelection.Usage:=DefaultReportSelection.Usage::"C.Statement";
        DefaultReportSelection.Sequence:='1';
        DefaultReportSelection."Report ID":=FindReportID('Statement', '');
        DefaultReportSelection.Insert;
    end;
    local procedure ReplaceReminder(var DefaultReportSelection: Record "ForNAV Report Selection Hist.")begin
        DefaultReportSelection.Usage:=DefaultReportSelection.Usage::Reminder;
        DefaultReportSelection.Sequence:='1';
        DefaultReportSelection."Report ID":=FindReportID('Reminder', '');
        DefaultReportSelection.Insert;
    end;
    local procedure ReplaceReminderTest(var DefaultReportSelection: Record "ForNAV Report Selection Hist.")begin
        DefaultReportSelection.Usage:=DefaultReportSelection.Usage::"Rem.Test";
        DefaultReportSelection.Sequence:='1';
        DefaultReportSelection."Report ID":=FindReportID('Reminder Test', '');
        DefaultReportSelection.Insert;
    end;
    local procedure ReplaceFinanceChargeMemo(var DefaultReportSelection: Record "ForNAV Report Selection Hist.")begin
        DefaultReportSelection.Usage:=DefaultReportSelection.Usage::"Fin.Charge";
        DefaultReportSelection.Sequence:='1';
        DefaultReportSelection."Report ID":=FindReportID('Finance Charge Memo', '');
        DefaultReportSelection.Insert;
    end;
    local procedure ReplaceFinanceChargeMemoTest(var DefaultReportSelection: Record "ForNAV Report Selection Hist.")begin
        DefaultReportSelection.Usage:=DefaultReportSelection.Usage::"F.C.Test";
        DefaultReportSelection.Sequence:='1';
        DefaultReportSelection."Report ID":=FindReportID('Finance Charge Memo T.', '');
        DefaultReportSelection.Insert;
    end;
    local procedure ReplaceServiceOrder(var DefaultReportSelection: Record "ForNAV Report Selection Hist.")begin
        DefaultReportSelection.Usage:=DefaultReportSelection.Usage::"SM.Order";
        DefaultReportSelection.Sequence:='1';
        DefaultReportSelection."Report ID":=FindReportID('Service Order', GetPrefix);
        DefaultReportSelection.Insert;
    end;
    local procedure ReplaceServiceInvoice(var DefaultReportSelection: Record "ForNAV Report Selection Hist.")begin
        DefaultReportSelection.Usage:=DefaultReportSelection.Usage::"SM.Invoice";
        DefaultReportSelection.Sequence:='1';
        DefaultReportSelection."Report ID":=FindReportID('Service Invoice', GetPrefix);
        DefaultReportSelection.Insert;
    end;
    local procedure ReplaceServiceCreditMemo(var DefaultReportSelection: Record "ForNAV Report Selection Hist.")begin
        DefaultReportSelection.Usage:=DefaultReportSelection.Usage::"SM.Credit Memo";
        DefaultReportSelection.Sequence:='1';
        DefaultReportSelection."Report ID":=FindReportID('Service Cr. Memo', GetPrefix);
        DefaultReportSelection.Insert;
    end;
    local procedure ReplaceServiceShipment(var DefaultReportSelection: Record "ForNAV Report Selection Hist.")begin
        DefaultReportSelection.Usage:=DefaultReportSelection.Usage::"SM.Shipment";
        DefaultReportSelection.Sequence:='1';
        DefaultReportSelection."Report ID":=FindReportID('Service Shipment', '');
        DefaultReportSelection.Insert;
    end;
    local procedure ReplaceServiceQuote(var DefaultReportSelection: Record "ForNAV Report Selection Hist.")begin
        DefaultReportSelection.Usage:=DefaultReportSelection.Usage::"SM.Quote";
        DefaultReportSelection.Sequence:='1';
        DefaultReportSelection."Report ID":=FindReportID('Service Quote', GetPrefix);
        DefaultReportSelection.Insert;
    end;
    local procedure ReplaceWarehouseReceipt(var DefaultReportSelection: Record "ForNAV Report Selection Hist.")begin
        DefaultReportSelection."Usage (Warehouse)":=DefaultReportSelection."usage (warehouse)"::Receipt;
        DefaultReportSelection.Usage:=DefaultReportSelection."Usage (Warehouse)";
        // "Report Selection Usage".FromInteger("Usage (Warehouse)");
        DefaultReportSelection.Sequence:='1';
        DefaultReportSelection."Report ID":=FindReportID('Warehouse Receipt', '');
        DefaultReportSelection.Origin:=7355;
        DefaultReportSelection.Insert;
    end;
    local procedure ReplaceWarehouseShipment(var DefaultReportSelection: Record "ForNAV Report Selection Hist.")begin
        DefaultReportSelection."Usage (Warehouse)":=DefaultReportSelection."usage (warehouse)"::Shipment;
        DefaultReportSelection.Usage:=DefaultReportSelection."Usage (Warehouse)";
        // "Report Selection Usage".FromInteger("Usage (Warehouse)");
        DefaultReportSelection.Sequence:='1';
        DefaultReportSelection."Report ID":=FindReportID('Warehouse Shipment', '');
        DefaultReportSelection.Origin:=7355;
        DefaultReportSelection.Insert;
    end;
    local procedure ReplacePostedWarehouseReceipt(var DefaultReportSelection: Record "ForNAV Report Selection Hist.")begin
        DefaultReportSelection."Usage (Warehouse)":=DefaultReportSelection."usage (warehouse)"::"Posted Receipt";
        DefaultReportSelection.Usage:=DefaultReportSelection."Usage (Warehouse)";
        // "Report Selection Usage".FromInteger("Usage (Warehouse)");
        DefaultReportSelection.Sequence:='1';
        DefaultReportSelection."Report ID":=FindReportID('Posted Warehouse Rec.', '');
        DefaultReportSelection.Origin:=7355;
        DefaultReportSelection.Insert;
    end;
    local procedure ReplacePostedWarehouseShipment(var DefaultReportSelection: Record "ForNAV Report Selection Hist.")begin
        DefaultReportSelection."Usage (Warehouse)":=DefaultReportSelection."usage (warehouse)"::"Posted Shipment";
        DefaultReportSelection.Usage:=DefaultReportSelection."Usage (Warehouse)";
        // "Report Selection Usage".FromInteger("Usage (Warehouse)");
        DefaultReportSelection.Sequence:='1';
        DefaultReportSelection."Report ID":=FindReportID('Posted Warehouse Shipm.', '');
        DefaultReportSelection.Origin:=7355;
        DefaultReportSelection.Insert;
    end;
    local procedure FindReportID(ReportName: Text;
    Prefix: Text): Integer begin
        Object.SetCurrentkey(Object.Name);
        Object.SetRange(Object.Name, 'ForNAV ' + Prefix + ReportName);
        Object.FindFirst;
        exit(Object.ID);
    end;
    local procedure GetPrefix(): Text var ForNAVSetup: Record "ForNAV Setup";
    begin
        ForNAVSetup.Get;
        if ForNAVSetup.CheckIsSalesTax then exit('Tax ');
        exit('VAT ');
    end;
    local procedure CreateBuffer()var AllObjWithCaption: Record AllObjWithCaption;
    begin
        AllObjWithCaption.SetRange(AllObjWithCaption."Object Type", AllObjWithCaption."object type"::Report);
        if AllObjWithCaption.FindSet then repeat Object.ID:=AllObjWithCaption."Object ID";
                Object.Name:=AllObjWithCaption."Object Name";
                Object.Insert;
            until AllObjWithCaption.Next = 0;
    end;
    local procedure SaveHistory(Origin: Integer;
    Usage: Integer;
    ReportID: Variant;
    Sequence: Variant)var ReportSelectionHist: Record "ForNAV Report Selection Hist.";
    begin
        if Origin = 77 then ReportSelectionHist.SetRange(Usage, Usage)
        else
            ReportSelectionHist.SetRange("Usage (Warehouse)", Usage);
        ReportSelectionHist.SetRange(Origin, Origin);
        if not ReportSelectionHist.IsEmpty then exit;
        ReportSelectionHist.Usage:=Usage; // "Report Selection Usage".FromInteger(Usage);
        ReportSelectionHist."Usage (Warehouse)":=Usage;
        ReportSelectionHist.Origin:=Origin;
        ReportSelectionHist.Sequence:=Sequence;
        ReportSelectionHist."Report ID":=ReportID;
        ReportSelectionHist.Insert;
    end;
    local procedure DeleteExisting(var ReportSelections: RecordRef)begin
        ReportSelections.DeleteAll;
    end;
}
