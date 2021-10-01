Codeunit 6189434 "ForNAV - Test Payment Reports"
{
    Subtype = Test;

    [Test]
    [HandlerFunctions('HandleCustomerPaymentsUI')]
    procedure TestCustomerPayments()var SendResultToAzure: Codeunit "ForNAV - Test Azure Interface";
    Parameters: Text;
    begin
        // [Given]
        Initialize;
        // [When]
        Parameters:=Report.RunRequestPage(Report::"ForNAV Customer Payments");
        SendResultToAzure.SimpleSaveReport(Report::"ForNAV Customer Payments", 'Financial/CustomerPayments', Parameters);
    // [Then]
    end;
    [Test]
    [HandlerFunctions('HandleVendorPaymentsUI')]
    procedure TestVendorPayments()var SendResultToAzure: Codeunit "ForNAV - Test Azure Interface";
    Parameters: Text;
    begin
        // [Given]
        Initialize;
        // [When]
        Parameters:=Report.RunRequestPage(Report::"ForNAV Vendor Payments");
        SendResultToAzure.SimpleSaveReport(Report::"ForNAV Vendor Payments", 'Financial/VendorPayments', Parameters);
    // [Then]
    end;
    local procedure Initialize()var InitializeTest: Codeunit "ForNAV - Test Initialize Test";
    begin
        if IsInitialized then exit;
        InitializeTest.BaseSetup;
        IsInitialized:=true;
    end;
    [ReportHandler]
    procedure HandleCustomerPaymentsUI(var ReportID: Report "ForNAV Customer Payments")begin
    end;
    [ReportHandler]
    procedure HandleVendorPaymentsUI(var ReportID: Report "ForNAV Vendor Payments")begin
    end;
    [StrMenuHandler]
    procedure StrMenuHandler(Options: Text[1024];
    var Choice: Integer;
    Instruction: Text[1024])begin
        Choice:=1;
    end;
    var IsInitialized: Boolean;
}
