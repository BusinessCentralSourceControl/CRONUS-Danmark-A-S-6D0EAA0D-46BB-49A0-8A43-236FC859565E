Codeunit 6188691 "ForNAV Customer Aging"
{
    procedure GetAging(var Cust: Record Customer;
    var AgingBuffer: Record "ForNAV Aging Buffer";
    var Args: Record "ForNAV Aged Accounts Args.")var CurrAgingBuffer: Record "ForNAV Aging Buffer" temporary;
    TempCurrency: Record Currency temporary;
    begin
        GetAgingWithCurrency(Cust, AgingBuffer, CurrAgingBuffer, Args, TempCurrency);
    end;
    procedure GetAgingWithCurrency(var Cust: Record Customer;
    var AgingBuffer: Record "ForNAV Aging Buffer";
    var CurrAgingBuffer: Record "ForNAV Aging Buffer";
    var Args: Record "ForNAV Aged Accounts Args.";
    var TempCurrency: Record Currency temporary)begin
        ClearData(AgingBuffer);
        GetBasedOnDetailedEntry(Cust, Args);
        GetBasedOnOpenEntry(Cust, Args);
        CreateAgingBuffer(Cust, AgingBuffer, CurrAgingBuffer, Args, TempCurrency);
    end;
    local procedure GetBasedOnDetailedEntry(var Cust: Record Customer;
    var Args: Record "ForNAV Aged Accounts Args.")var DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
    CustLedgEntry: Record "Cust. Ledger Entry";
    begin
        DetailedCustLedgEntry.SetCurrentkey(DetailedCustLedgEntry."Customer No.", DetailedCustLedgEntry."Posting Date", DetailedCustLedgEntry."Entry Type", DetailedCustLedgEntry."Currency Code");
        DetailedCustLedgEntry.SetRange(DetailedCustLedgEntry."Customer No.", Cust."No.");
        DetailedCustLedgEntry.SetRange(DetailedCustLedgEntry."Entry Type", DetailedCustLedgEntry."entry type"::Application);
        DetailedCustLedgEntry.SetRange(DetailedCustLedgEntry."Posting Date", 0D, Args."Ending Date");
        DetailedCustLedgEntry.SetFilter(DetailedCustLedgEntry."Posting Date", '%1..', Args."Ending Date" + 1);
        if DetailedCustLedgEntry.FindSet then repeat if CustLedgEntry.Get(DetailedCustLedgEntry."Cust. Ledger Entry No.")then if CustLedgEntry.Open then begin
                        CustLedgEntry.SetRange("Date Filter", 0D, Args."Ending Date");
                        CustLedgEntry.CalcFields("Remaining Amount");
                        if CustLedgEntry."Remaining Amount" <> 0 then InsertTemp(CustLedgEntry);
                    end;
            until DetailedCustLedgEntry.Next = 0;
    end;
    local procedure GetBasedOnOpenEntry(var Cust: Record Customer;
    var Args: Record "ForNAV Aged Accounts Args.")var CustLedgEntry: Record "Cust. Ledger Entry";
    begin
        CustLedgEntry.SetCurrentkey(CustLedgEntry."Customer No.", CustLedgEntry.Open, CustLedgEntry.Positive, CustLedgEntry."Due Date", CustLedgEntry."Currency Code");
        CustLedgEntry.SetRange(CustLedgEntry."Customer No.", Cust."No.");
        CustLedgEntry.SetRange(CustLedgEntry.Open, true);
        if Args."Aging By" = Args."aging by"::"Posting Date" then begin
            CustLedgEntry.SetRange(CustLedgEntry."Posting Date", 0D, Args."Ending Date");
            CustLedgEntry.SetRange(CustLedgEntry."Date Filter", 0D, Args."Ending Date");
        end;
        if CustLedgEntry.FindSet then repeat if Args."Aging By" = Args."aging by"::"Posting Date" then begin
                    CustLedgEntry.CalcFields(CustLedgEntry."Remaining Amt. (LCY)");
                    if CustLedgEntry."Remaining Amt. (LCY)" <> 0 then InsertTemp(CustLedgEntry);
                end
                else
                    InsertTemp(CustLedgEntry);
            until CustLedgEntry.Next = 0;
    end;
    local procedure CreateAgingBuffer(var Cust: Record Customer;
    var AgingBuffer: Record "ForNAV Aging Buffer";
    var CurrAgingBuffer: Record "ForNAV Aging Buffer";
    var Args: Record "ForNAV Aged Accounts Args.";
    var TempCurrency: Record Currency temporary)var DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
    AgingCalculation: Codeunit "ForNAV Aging Calculation";
    PeriodIndex: Integer;
    begin
        if TempCustLedgEntry.FindSet then repeat AgingBuffer.Init;
                AgingBuffer."Entry No.":=TempCustLedgEntry."Entry No.";
                AgingBuffer."Account No.":=TempCustLedgEntry."Customer No.";
                AgingBuffer.GetAccountName;
                AgingBuffer."Credit Limit (LCY)":=Cust."Credit Limit (LCY)";
                if not Args."Print Amounts in LCY" then AgingBuffer."Currency Code":=AgingCalculation.GetCurrencyCode(TempCustLedgEntry."Currency Code");
                AgingBuffer."Document No.":=TempCustLedgEntry."Document No.";
                AgingBuffer."External Document No.":=TempCustLedgEntry."External Document No.";
                AgingBuffer."Document Type":=TempCustLedgEntry."Document Type";
                AgingBuffer."Document Date":=TempCustLedgEntry."Document Date";
                AgingBuffer."Posting Date":=TempCustLedgEntry."Posting Date";
                AgingBuffer."Due Date":=TempCustLedgEntry."Due Date";
                DetailedCustLedgEntry.SetRange("Cust. Ledger Entry No.", TempCustLedgEntry."Entry No.");
                if DetailedCustLedgEntry.FindSet then repeat if(DetailedCustLedgEntry."Entry Type" = DetailedCustLedgEntry."entry type"::"Initial Entry") and (TempCustLedgEntry."Posting Date" > Args."Ending Date") and (Args."Aging By" <> Args."aging by"::"Posting Date")then begin
                            if TempCustLedgEntry."Document Date" <= Args."Ending Date" then DetailedCustLedgEntry."Posting Date":=TempCustLedgEntry."Document Date"
                            else if(TempCustLedgEntry."Due Date" <= Args."Ending Date") and (Args."Aging By" = Args."aging by"::"Due Date")then DetailedCustLedgEntry."Posting Date":=TempCustLedgEntry."Due Date";
                        end;
                        if(DetailedCustLedgEntry."Posting Date" <= Args."Ending Date") or (TempCustLedgEntry.Open and (Args."Aging By" = Args."aging by"::"Due Date") and (TempCustLedgEntry."Due Date" > Args."Ending Date") and (TempCustLedgEntry."Posting Date" <= Args."Ending Date"))then begin
                            if DetailedCustLedgEntry."Entry Type" in[DetailedCustLedgEntry."entry type"::"Initial Entry", DetailedCustLedgEntry."entry type"::"Unrealized Loss", DetailedCustLedgEntry."entry type"::"Unrealized Gain", DetailedCustLedgEntry."entry type"::"Realized Loss", DetailedCustLedgEntry."entry type"::"Realized Gain", DetailedCustLedgEntry."entry type"::"Payment Discount", DetailedCustLedgEntry."entry type"::"Payment Discount (VAT Excl.)", DetailedCustLedgEntry."entry type"::"Payment Discount (VAT Adjustment)", DetailedCustLedgEntry."entry type"::"Payment Tolerance", DetailedCustLedgEntry."entry type"::"Payment Discount Tolerance", DetailedCustLedgEntry."entry type"::"Payment Tolerance (VAT Excl.)", DetailedCustLedgEntry."entry type"::"Payment Tolerance (VAT Adjustment)", DetailedCustLedgEntry."entry type"::"Payment Discount Tolerance (VAT Excl.)", DetailedCustLedgEntry."entry type"::"Payment Discount Tolerance (VAT Adjustment)"]then begin
                                if not Args."Print Amounts in LCY" then AgingBuffer.Amount+=DetailedCustLedgEntry.Amount
                                else
                                    AgingBuffer.Amount+=DetailedCustLedgEntry."Amount (LCY)";
                                AgingBuffer."Amount (LCY)"+=DetailedCustLedgEntry."Amount (LCY)";
                            end;
                            if DetailedCustLedgEntry."Posting Date" <= Args."Ending Date" then begin
                                if not Args."Print Amounts in LCY" then AgingBuffer.Balance+=DetailedCustLedgEntry.Amount
                                else
                                    AgingBuffer.Balance+=DetailedCustLedgEntry."Amount (LCY)";
                                AgingBuffer."Balance (LCY)"+=DetailedCustLedgEntry."Amount (LCY)";
                            end;
                        end;
                    until DetailedCustLedgEntry.Next = 0;
                if AgingBuffer.Balance <> 0 then begin
                    case Args."Aging By" of Args."aging by"::"Due Date": PeriodIndex:=Args.GetPeriodIndex(AgingBuffer."Due Date");
                    Args."aging by"::"Posting Date": PeriodIndex:=Args.GetPeriodIndex(AgingBuffer."Posting Date");
                    Args."aging by"::"Document Date": begin
                        if AgingBuffer."Document Date" > Args."Ending Date" then begin
                            AgingBuffer.Balance:=0;
                            AgingBuffer."Balance (LCY)":=0;
                            AgingBuffer."Document Date":=AgingBuffer."Posting Date";
                        end;
                        PeriodIndex:=Args.GetPeriodIndex(AgingBuffer."Document Date");
                    end;
                    end;
                    AgingCalculation.MoveValuesToPeriod(AgingBuffer, PeriodIndex);
                    AgingBuffer.SetPeriodCaptions(Args);
                    AgingBuffer.Insert;
                    if not Args."Print Amounts in LCY" then AgingCalculation.UpdateCurrencyTotals(AgingBuffer, CurrAgingBuffer, TempCurrency);
                end;
            until TempCustLedgEntry.Next = 0;
    end;
    local procedure InsertTemp(var CustLedgEntry: Record "Cust. Ledger Entry")begin
        if TempCustLedgEntry.Get(CustLedgEntry."Entry No.")then exit;
        TempCustLedgEntry:=CustLedgEntry;
        TempCustLedgEntry.Insert;
    end;
    local procedure ClearData(var AgingBuffer: Record "ForNAV Aging Buffer")begin
        AgingBuffer.Reset;
        AgingBuffer.DeleteAll;
        TempCustLedgEntry.Reset;
        TempCustLedgEntry.DeleteAll;
    end;
    var TempCustLedgEntry: Record "Cust. Ledger Entry" temporary;
}
