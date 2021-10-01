Codeunit 6189433 "ForNAV - Test Rec. A/P to G/L"
{
    Subtype = Test;

    [Test]
    [HandlerFunctions('HandleReconciliationUI')]
    procedure TestReconciliationAPtoGL()var SendResultToAzure: Codeunit "ForNAV - Test Azure Interface";
    Parameters: Text;
    begin
        // [Given]
        Initialize;
        // [When]
        Parameters:=Report.RunRequestPage(Report::"ForNAV Reconcile A/P to G/L");
        SendResultToAzure.SimpleSaveReport(Report::"ForNAV Reconcile A/P to G/L", 'Financial/ReconcileAccountsPayablesToGL', Parameters);
    // [Then]
    end;
    local procedure Initialize()var InitializeTest: Codeunit "ForNAV - Test Initialize Test";
    begin
        if IsInitialized then exit;
        InitializeTest.BaseSetup;
        IsInitialized:=true;
    end;
    [ReportHandler]
    procedure HandleReconciliationUI(var ReportID: Report "ForNAV Reconcile A/P to G/L")begin
    end;
    [StrMenuHandler]
    procedure StrMenuHandler(Options: Text[1024];
    var Choice: Integer;
    Instruction: Text[1024])begin
        Choice:=1;
    end;
    var IsInitialized: Boolean;
}
