Codeunit 6189436 "ForNAV - Test Aging Reports"
{
    Subtype = Test;

    [Test]
    [HandlerFunctions('HandleCustomerAgingUI')]
    procedure TestCustomerAging()var SendResultToAzure: Codeunit "ForNAV - Test Azure Interface";
    Parameters: Text;
    begin
        // [Given]
        Initialize;
        // [When]
        Parameters:=Report.RunRequestPage(Report::"ForNAV Aged Accounts Receivbl.");
        SendResultToAzure.SimpleSaveReport(Report::"ForNAV Aged Accounts Receivbl.", 'Financial/AgedAccountsReceiables', Parameters);
    // [Then]
    end;
    [Test]
    [HandlerFunctions('HandleVendorAgingUI')]
    procedure TestVendorAging()var SendResultToAzure: Codeunit "ForNAV - Test Azure Interface";
    Parameters: Text;
    begin
        // [Given]
        Initialize;
        // [When]
        Parameters:=Report.RunRequestPage(Report::"ForNAV Aged Accounts Payables");
        SendResultToAzure.SimpleSaveReport(Report::"ForNAV Aged Accounts Payables", 'Financial/AgedAccountsPayables', Parameters);
    // [Then]
    end;
    local procedure Initialize()var InitializeTest: Codeunit "ForNAV - Test Initialize Test";
    begin
        if IsInitialized then exit;
        InitializeTest.BaseSetup;
        IsInitialized:=true;
    end;
    [ReportHandler]
    procedure HandleCustomerAgingUI(var ReportID: Report "ForNAV Aged Accounts Receivbl.")begin
    end;
    [ReportHandler]
    procedure HandleVendorAgingUI(var ReportID: Report "ForNAV Aged Accounts Payables")begin
    end;
    [StrMenuHandler]
    procedure StrMenuHandler(Options: Text[1024];
    var Choice: Integer;
    Instruction: Text[1024])begin
        Choice:=1;
    end;
    var IsInitialized: Boolean;
}
