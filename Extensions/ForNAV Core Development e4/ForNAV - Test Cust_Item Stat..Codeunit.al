Codeunit 6189439 "ForNAV - Test Cust/Item Stat."
{
    Subtype = Test;

    [Test]
    [HandlerFunctions('HandleCustItemStatisticsUI')]
    procedure TestCustItemStatistics()var SendResultToAzure: Codeunit "ForNAV - Test Azure Interface";
    Parameters: Text;
    begin
        // [Given]
        Initialize;
        // [When]
        Parameters:=Report.RunRequestPage(Report::"ForNAV Cust./Item Statistics");
        SendResultToAzure.SimpleSaveReport(Report::"ForNAV Cust./Item Statistics", 'Financial/CustomerItemStatistics', Parameters);
    // [Then]
    end;
    local procedure Initialize()var InitializeTest: Codeunit "ForNAV - Test Initialize Test";
    begin
        if IsInitialized then exit;
        InitializeTest.BaseSetup;
        IsInitialized:=true;
    end;
    [ReportHandler]
    procedure HandleCustItemStatisticsUI(var ReportID: Report "ForNAV Cust./Item Statistics")begin
    end;
    [StrMenuHandler]
    procedure StrMenuHandler(Options: Text[1024];
    var Choice: Integer;
    Instruction: Text[1024])begin
        Choice:=1;
    end;
    var IsInitialized: Boolean;
}
