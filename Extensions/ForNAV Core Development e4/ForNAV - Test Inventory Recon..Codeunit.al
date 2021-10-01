Codeunit 6189438 "ForNAV - Test Inventory Recon."
{
    Subtype = Test;

    [Test]
    [HandlerFunctions('HandleInvReconUI')]
    procedure TestInventoryReconciliation()var SendResultToAzure: Codeunit "ForNAV - Test Azure Interface";
    Parameters: Text;
    begin
        // [Given]
        Initialize;
        // [When]
        Parameters:=Report.RunRequestPage(Report::"ForNAV Inv. to G/L Reconcile");
        SendResultToAzure.SimpleSaveReport(Report::"ForNAV Inv. to G/L Reconcile", 'Financial/InventoryToGLReconciliation', Parameters);
    // [Then]
    end;
    local procedure Initialize()var InitializeTest: Codeunit "ForNAV - Test Initialize Test";
    begin
        if IsInitialized then exit;
        InitializeTest.BaseSetup;
        Commit;
        IsInitialized:=true;
    end;
    [ReportHandler]
    procedure HandleInvReconUI(var ReportID: Report "ForNAV Inv. to G/L Reconcile")begin
    end;
    [StrMenuHandler]
    procedure StrMenuHandler(Options: Text[1024];
    var Choice: Integer;
    Instruction: Text[1024])begin
        Choice:=1;
    end;
    var IsInitialized: Boolean;
}
