Codeunit 6188488 "ForNAV Restore Report Select."
{
    trigger OnRun()begin
        if not AskForConfirmation then exit;
        RestoreAllReportSelections;
    end;
    local procedure AskForConfirmation(): Boolean var ConfirmReplaceQst: label 'Do you want to restore all report selections to their original values?';
    begin
        exit(Confirm(ConfirmReplaceQst));
    end;
    local procedure RestoreAllReportSelections()var ReportSelectionHist: Record "ForNAV Report Selection Hist.";
    begin
        if ReportSelectionHist.FindSet then repeat ReportSelectionHist.Restore;
            until ReportSelectionHist.Next = 0;
    end;
}
