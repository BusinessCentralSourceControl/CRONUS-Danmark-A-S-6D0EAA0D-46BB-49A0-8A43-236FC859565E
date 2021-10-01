codeunit 6188506 "ForNAV Get ForNAV Reports"
{
    procedure GetForNAVReports(var Reports: Record "ForNAV Reports")var ReportObject: Record "ForNAV Report Object" temporary;
    CheckIsForNAVReport: Codeunit "ForNAV Check Is ForNAV Report";
    begin
        Codeunit.Run(Codeunit::"ForNAV First Time Setup");
        CheckIsForNAVReport.GetAllForNAVReports(ReportObject);
        ReportObject.SetRange("ID", 50000, 99999);
        if ReportObject.FindSet then repeat CreateRecord(ReportObject, Reports);
            until ReportObject.Next = 0;
        ReportObject.SetRange("ID", 6188471, 6189471);
        if ReportObject.FindSet then repeat CreateRecord(ReportObject, Reports);
            until ReportObject.Next = 0;
        ReportObject.SetRange("ID", 1000000, 6188470);
        if ReportObject.FindSet then repeat CreateRecord(ReportObject, Reports);
            until ReportObject.Next = 0;
        ReportObject.SetRange("ID", 6189471, 98999999);
        if ReportObject.FindSet then repeat CreateRecord(ReportObject, Reports);
            until ReportObject.Next = 0;
    end;
    local procedure CreateRecord(var ReportObject: Record "ForNAV Report Object";
    var Reports: Record "ForNAV Reports")var ArchiveSetup: Codeunit "ForNAV Document Archive Mgt.";
    begin
        Reports.Init;
        Reports.ID:=ReportObject.ID;
        Reports.Name:=ReportObject.Name;
        Reports.Category:=Reports.GetCategory;
        Reports."Archive Enabled":=ArchiveSetup.GetArchiveSetup(Reports.ID);
        ArchiveSetup.GetArchiveSetup(Reports.ID, Reports.Archived);
        Reports.GetCurrentReportLayout;
        if Reports.IsValidForLocalization(Reports.ID) and Reports.ShowReportInList then Reports.Insert;
    end;
}
