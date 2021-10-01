Codeunit 6188489 "ForNAV Save Report Statistics"
{
    trigger OnRun()begin
    end;
    [EventSubscriber(Objecttype::Codeunit, 44, 'OnAfterSubstituteReport', '', false, false)]
    local procedure ForNAVSaveReportStatistics(ReportId: Integer;
    var NewReportId: Integer)var ReportUsageMgt: Codeunit "ForNAV Report Usage Mgt.";
    begin
        ReportUsageMgt.AddToBuffer(ReportId);
    end;
}
