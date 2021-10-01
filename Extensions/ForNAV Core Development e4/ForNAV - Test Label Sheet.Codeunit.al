codeunit 6189430 "ForNAV - Test Label Sheet"
{
    Subtype = Test;

    [Test]
    [HandlerFunctions('HandleFilterUI')]
    procedure TestLabelSheet()var SendResultToAzure: Codeunit "ForNAV - Test Azure Interface";
    begin
        // [Given]
        Initialize;
        // [When]
        SendResultToAzure.SimpleSaveReport(Report::"ForNAV Label Sheets", 'Labels/LabelSheet');
    // [Then]
    end;
    [FilterPageHandler]
    procedure HandleFilterUI(var Record1: RecordRef): Boolean begin
        exit(true);
    end;
    local procedure Initialize()var InitializeTest: Codeunit "ForNAV - Test Initialize Test";
    begin
        if IsInitialized then exit;
        InitializeTest.BaseSetup;
        InitializeTest.LabelSetup;
        IsInitialized:=true;
    end;
    var IsInitialized: Boolean;
}
