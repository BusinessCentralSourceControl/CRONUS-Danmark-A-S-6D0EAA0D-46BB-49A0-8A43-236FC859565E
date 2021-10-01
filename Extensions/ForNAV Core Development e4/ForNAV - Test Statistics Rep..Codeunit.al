Codeunit 6189437 "ForNAV - Test Statistics Rep."
{
    Subtype = Test;

    [Test]
    [HandlerFunctions('HandleSalesStatisticsUI')]
    procedure TestSalesStatistics()var SendResultToAzure: Codeunit "ForNAV - Test Azure Interface";
    Parameters: Text;
    begin
        // [Given]
        Initialize;
        // [When]
        Parameters:=Report.RunRequestPage(Report::"ForNAV Sales Statistics");
        SendResultToAzure.SimpleSaveReport(Report::"ForNAV Sales Statistics", 'Financial/SalesStatistics', Parameters);
    // [Then]
    end;
    [Test]
    [HandlerFunctions('HandlePurchaseStatisticsUI')]
    procedure TestPurchaseStatistics()var SendResultToAzure: Codeunit "ForNAV - Test Azure Interface";
    Parameters: Text;
    begin
        // [Given]
        Initialize;
        // [When]
        Parameters:=Report.RunRequestPage(Report::"ForNAV Purchase Statistics");
        SendResultToAzure.SimpleSaveReport(Report::"ForNAV Purchase Statistics", 'Financial/PurchaseStatistics', Parameters);
    // [Then]
    end;
    local procedure Initialize()var InitializeTest: Codeunit "ForNAV - Test Initialize Test";
    begin
        if IsInitialized then exit;
        InitializeTest.BaseSetup;
        IsInitialized:=true;
    end;
    [ReportHandler]
    procedure HandleSalesStatisticsUI(var ReportID: Report "ForNAV Sales Statistics")begin
    end;
    [ReportHandler]
    procedure HandlePurchaseStatisticsUI(var ReportID: Report "ForNAV Purchase Statistics")begin
    end;
    [StrMenuHandler]
    procedure StrMenuHandler(Options: Text[1024];
    var Choice: Integer;
    Instruction: Text[1024])begin
        Choice:=1;
    end;
    var IsInitialized: Boolean;
}
