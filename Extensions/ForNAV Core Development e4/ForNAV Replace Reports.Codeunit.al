Codeunit 6188487 "ForNAV Replace Reports"
{
    trigger OnRun()begin
    end;
    [EventSubscriber(Objecttype::Codeunit, 44, 'OnAfterSubstituteReport', '', false, false)]
    local procedure ForNAVReplaceReports(ReportId: Integer;
    var NewReportId: Integer)var ReportReplacement: Record "ForNAV Report Replacement";
    begin
        if ReportReplacement.Get(ReportId, UserId)then begin
            NewReportId:=ReportReplacement."Replace-With Report ID";
            exit;
        end;
        if ReportReplacement.Get(ReportId)then begin
            NewReportId:=ReportReplacement."Replace-With Report ID";
            exit;
        end;
    end;
}
