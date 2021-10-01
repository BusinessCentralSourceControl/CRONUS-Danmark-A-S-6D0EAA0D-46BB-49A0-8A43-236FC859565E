Codeunit 6189435 "ForNAV - Test Sp.-Commission"
{
    Subtype = Test;

    [Test]
    [HandlerFunctions('HandleSalespersonCommissionUI')]
    procedure TestSalespersonCommission()var SendResultToAzure: Codeunit "ForNAV - Test Azure Interface";
    Parameters: Text;
    begin
        // [Given]
        Initialize;
        // [When]
        Parameters:=Report.RunRequestPage(Report::"ForNAV Salesperson-Commission");
        SendResultToAzure.SimpleSaveReport(Report::"ForNAV Salesperson-Commission", 'Financial/SalespersonCommission', Parameters);
    // [Then]
    end;
    local procedure Initialize()var InitializeTest: Codeunit "ForNAV - Test Initialize Test";
    begin
        if IsInitialized then exit;
        InitializeTest.BaseSetup;
        IsInitialized:=true;
    end;
    [ReportHandler]
    procedure HandleSalespersonCommissionUI(var ReportID: Report "ForNAV Salesperson-Commission")begin
    end;
    [StrMenuHandler]
    procedure StrMenuHandler(Options: Text[1024];
    var Choice: Integer;
    Instruction: Text[1024])begin
        Choice:=1;
    end;
    var IsInitialized: Boolean;
}
