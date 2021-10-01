Codeunit 6189444 "ForNAV - Test Inventory Value."
{
    Subtype = Test;

    [Test]
    [HandlerFunctions('HandleInventoryValuationUI')]
    procedure TestInventoryValuation()var SendResultToAzure: Codeunit "ForNAV - Test Azure Interface";
    Parameters: Text;
    OutStream: OutStream;
    begin
        // [Given]
        Initialize;
        // [When]
        Parameters:=Report.RunRequestPage(Report::"ForNAV Inventory Valuation");
        SendResultToAzure.SimpleSaveReport(Report::"ForNAV Inventory Valuation", 'Financial/InventoryValuation', Parameters);
    // [Then]
    end;
    local procedure Initialize()var InitializeTest: Codeunit "ForNAV - Test Initialize Test";
    begin
        if IsInitialized then exit;
        InitializeTest.BaseSetup;
        IsInitialized:=true;
    end;
    [ReportHandler]
    procedure HandleInventoryValuationUI(var ReportID: Report "ForNAV Inventory Valuation")begin
    end;
    [StrMenuHandler]
    procedure StrMenuHandler(Options: Text[1024];
    var Choice: Integer;
    Instruction: Text[1024])begin
        Choice:=1;
    end;
    var IsInitialized: Boolean;
}
