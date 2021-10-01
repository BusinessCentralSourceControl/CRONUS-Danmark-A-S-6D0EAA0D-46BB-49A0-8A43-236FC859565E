Codeunit 6189421 "ForNAV - Test Default Setup"
{
    Subtype = Test;

    [Test]
    [HandlerFunctions('ConfirmHandler')]
    procedure TestDefaultSetup()var FirstTimeSetup: Codeunit "ForNAV First Time Setup";
    begin
        // [Given]
        CleanSetupIfExists;
        Initialize;
        // [When]
        FirstTimeSetup.Run;
        // [Then]
        TestResultInSetup;
        TestReportsAreReplaced;
        TestHistoryIsSaved;
        TestInitSetup;
    end;
    procedure TestResultInSetup()var Setup: Record "ForNAV Setup";
    CheckSetup: Record "ForNAV Check Setup";
    LabelSetup: Record "ForNAV Label Setup";
    begin
        // First test, there should be a record in the setup table
        Setup.Get;
        CheckSetup.Get;
        LabelSetup.Get;
    end;
    procedure TestReportsAreReplaced()var ReportSelections: Record "Report Selections";
    AllObj: Record AllObj;
    begin
        AllObj.SetRange("Object Type", AllObj."object type"::Report);
        AllObj.SetRange("Object Name", 'ForNAV Sales Shipment');
        AllObj.FindFirst;
        ReportSelections.SetRange(Usage, ReportSelections.Usage::"S.Shipment");
        ReportSelections.FindFirst;
        ReportSelections.TestField("Report ID", AllObj."Object ID");
    end;
    procedure TestHistoryIsSaved()var ReportSelectionHist: Record "ForNAV Report Selection Hist.";
    begin
        ReportSelectionHist.FindFirst;
    end;
    procedure TestInitSetup()var Setup: Record "ForNAV Setup";
    begin
        Setup.InitSetup;
    end;
    local procedure Initialize()var InitializeTest: Codeunit "ForNAV - Test Initialize Test";
    begin
        if IsInitialized then exit;
        IsInitialized:=true;
    end;
    [ConfirmHandler]
    procedure ConfirmHandler(Question: Text[1024];
    var Reply: Boolean)begin
        Reply:=true;
    end;
    procedure CleanSetupIfExists()var Setup: Record "ForNAV Setup";
    LabelSetup: Record "ForNAV Label Setup";
    CheckSetup: Record "ForNAV Check Setup";
    begin
        if Setup.Get then Setup.Delete;
        if LabelSetup.Get then LabelSetup.Delete;
        if CheckSetup.Get then CheckSetup.Delete;
    end;
    var IsInitialized: Boolean;
}
