codeunit 6188502 "ForNAV Design Template"
{
    [EventSubscriber(ObjectType::Table, Database::"ForNAV Setup", 'OnBeforeDesignTemplate', '', false, false)]
    local procedure OnBeforeDesignTemplate(ReportID: Text;
    var Handled: Boolean)var MyReportID: Integer;
    begin
        if not Evaluate(MyReportID, ReportID.TrimStart('Report '))then exit;
        Handled:=DesignReport(MyReportID);
    end;
    local procedure DesignReport(ReportID: Integer): Boolean var ReportMgt: Codeunit "ForNAV Report Management";
    begin
        exit(ReportMgt.LaunchDesigner(ReportID));
    end;
}
