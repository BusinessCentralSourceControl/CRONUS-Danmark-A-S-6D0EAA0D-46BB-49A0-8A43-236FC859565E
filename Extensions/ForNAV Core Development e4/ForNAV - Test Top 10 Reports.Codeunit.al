Codeunit 6189432 "ForNAV - Test Top 10 Reports"
{
    Subtype = Test;

    [Test]
    [HandlerFunctions('HandleCustomerTop10UI')]
    procedure TestCustomerTop10()var SendResultToAzure: Codeunit "ForNAV - Test Azure Interface";
    Parameters: Text;
    begin
        // [Given]
        Initialize;
        // [When]
        Parameters:=Report.RunRequestPage(Report::"ForNAV Customer Top 10 List");
        SendResultToAzure.SimpleSaveReport(Report::"ForNAV Customer Top 10 List", 'Financial/CustomerTop10List', Parameters);
    // [Then]
    end;
    [Test]
    [HandlerFunctions('HandleVendorTop10UI')]
    procedure TestVendorTop10()var SendResultToAzure: Codeunit "ForNAV - Test Azure Interface";
    Parameters: Text;
    begin
        // [Given]
        Initialize;
        // [When]
        Parameters:=Report.RunRequestPage(Report::"ForNAV Vendor Top 10 List");
        SendResultToAzure.SimpleSaveReport(Report::"ForNAV Vendor Top 10 List", 'Financial/VendorTop10List', Parameters);
    // [Then]
    end;
    local procedure Initialize()var InitializeTest: Codeunit "ForNAV - Test Initialize Test";
    begin
        if IsInitialized then exit;
        InitializeTest.BaseSetup;
        IsInitialized:=true;
    end;
    [ReportHandler]
    procedure HandleCustomerTop10UI(var ReportID: Report "ForNAV Customer Top 10 List")begin
    end;
    [ReportHandler]
    procedure HandleVendorTop10UI(var ReportID: Report "ForNAV Vendor Top 10 List")begin
    end;
    var IsInitialized: Boolean;
}
