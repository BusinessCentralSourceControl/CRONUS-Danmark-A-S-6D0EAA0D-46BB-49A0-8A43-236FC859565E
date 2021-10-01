Codeunit 6188677 "ForNAV Trial Balance"
{
    procedure GetDataFromGLAccount(var TrialBalance: Record "ForNAV Trial Balance";
    var GLAccount: Record "G/L Account";
    var Args: Record "ForNAV Trial Balance Args.")var PriorFromDate: Date;
    PriorToDate: Date;
    begin
        PriorFromDate:=CalcDate('<-1Y>', Args."From Date" + 1) - 1;
        PriorToDate:=CalcDate('<-1Y>', Args."To Date" + 1) - 1;
        GLAccount.SetRange("Date Filter", Args."From Date", Args."To Date");
        if not Args."All Amounts in LCY" then begin
            GLAccount.CalcFields("Additional-Currency Net Change", "Add.-Currency Balance at Date");
            TrialBalance."Net Change Actual":=GLAccount."Additional-Currency Net Change";
            TrialBalance."Balance at Date Actual":=GLAccount."Add.-Currency Balance at Date";
        end
        else
        begin
            GLAccount.CalcFields("Net Change", "Balance at Date");
            TrialBalance."Net Change Actual":=GLAccount."Net Change";
            TrialBalance."Balance at Date Actual":=GLAccount."Balance at Date";
        end;
        if Args."Show by" = Args."show by"::Budget then begin
            GLAccount.CalcFields("Budgeted Amount", "Budget at Date");
            TrialBalance."Net Change Actual Last Year":=GLAccount."Budgeted Amount";
            TrialBalance."Balance at Date Act. Last Year":=GLAccount."Budget at Date";
        end
        else
        begin
            GLAccount.SetRange("Date Filter", PriorFromDate, PriorToDate);
            if not Args."All Amounts in LCY" then begin
                GLAccount.CalcFields("Additional-Currency Net Change", "Add.-Currency Balance at Date");
                TrialBalance."Net Change Actual Last Year":=GLAccount."Additional-Currency Net Change";
                TrialBalance."Balance at Date Act. Last Year":=GLAccount."Add.-Currency Balance at Date";
            end
            else
            begin
                GLAccount.CalcFields("Net Change", "Balance at Date");
                TrialBalance."Net Change Actual Last Year":=GLAccount."Net Change";
                TrialBalance."Balance at Date Act. Last Year":=GLAccount."Balance at Date";
            end;
        end;
        if Args."Variance in Changes" or Args."% Variance in Changes" then TrialBalance."Variance in Changes":=TrialBalance."Net Change Actual" - TrialBalance."Net Change Actual Last Year";
        if Args."% Variance in Changes" and (TrialBalance."Net Change Actual Last Year" <> 0)then TrialBalance."% Variance in Changes":=TrialBalance."Variance in Changes" / TrialBalance."Net Change Actual Last Year" * 100;
        if Args."Variance in Balances" or Args."% Variance in Balances" then TrialBalance."Variance in Balances":=TrialBalance."Balance at Date Actual" - TrialBalance."Balance at Date Act. Last Year";
        if Args."% Variance in Balances" and (TrialBalance."Balance at Date Act. Last Year" <> 0)then TrialBalance."% Variance in Balances":=TrialBalance."Variance in Balances" / TrialBalance."Balance at Date Act. Last Year" * 100;
    end;
}
