Codeunit 6189447 "ForNAV - Test Replace Reports"
{
    // Copyright (c) 2018-2020 ForNAV ApS - All Rights Reserved
    // The intellectual work and technical concepts contained in this file are proprietary to ForNAV.
    // Unauthorized reverse engineering, distribution or copying of this file, parts hereof, or derived work, via any medium is strictly prohibited without written permission from ForNAV ApS.
    // This source code is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    Subtype = Test;

    var IsInitialized: Boolean;
    [Test]
    [HandlerFunctions('ConfirmHandler')]
    procedure TestDefaultSetup()var Setup: Record "ForNAV Setup";
    begin
        // [Given]
        Initialize;
        // [When]
        Setup.Get;
        Setup.ReplaceReportSelection(false);
        // [Then]
        TestResultInSetup;
        TestReportsAreReplaced;
    end;
    procedure TestResultInSetup()var Setup: Record "ForNAV Setup";
    begin
        // First test, there should be a record in the setup table
        Setup.Get;
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
    local procedure Initialize()var InitializeTest: Codeunit "ForNAV - Test Initialize Test";
    begin
        if IsInitialized then exit;
        InitializeTest.BaseSetup;
        IsInitialized:=true;
    end;
    [ConfirmHandler]
    procedure ConfirmHandler(Question: Text[1024];
    var Reply: Boolean)begin
        Reply:=true;
    end;
}
