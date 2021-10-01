codeunit 6189426 "ForNAV - Test Restore History"
{
    // Copyright (c) 2018-2020 ForNAV ApS - All Rights Reserved
    // The intellectual work and technical concepts contained in this file are proprietary to ForNAV.
    // Unauthorized reverse engineering, distribution or copying of this file, parts hereof, or derived work, via any medium is strictly prohibited without written permission from ForNAV ApS.
    // This source code is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    Subtype = Test;

    [Test]
    [HandlerFunctions('ConfirmHandler')]
    procedure TestRestoreHistory()var FirstTimeSetup: Codeunit "ForNAV First Time Setup";
    TestLib: Codeunit "ForNAV - Test Library";
    ReportIDForInvoice: Integer;
    begin
        // [Given]
        Initialize;
        TestLib.RestoreToCRONUS;
        ReportIDForInvoice:=GetInvoiceReport;
        // [When]
        FirstTimeSetup.RUN;
        RestoreReports;
        // [Then]
        TestHistoryIsRestored(ReportIDForInvoice);
    end;
    local procedure TestHistoryIsRestored(Value: Integer)var ReportSelections: Record "Report Selections";
    begin
        ReportSelections.SetRange(ReportSelections.Usage, ReportSelections.Usage::"S.Invoice");
        ReportSelections.SetRange(ReportSelections."Report ID", Value);
        ReportSelections.FindFirst;
    end;
    local procedure Initialize()begin
        IF IsInitialized THEN EXIT;
        IsInitialized:=TRUE;
    end;
    local procedure GetInvoiceReport(): Integer var ReportSelections: Record "Report Selections";
    begin
        ReportSelections.SetRange(ReportSelections.Usage, ReportSelections.Usage::"S.Invoice");
        ReportSelections.FindFirst;
        exit(ReportSelections."Report ID");
    end;
    local procedure RestoreReports()var RestoreReportSelect: Codeunit "ForNAV Restore Report Select.";
    begin
        RestoreReportSelect.RUN;
    end;
    [ConfirmHandler]
    procedure ConfirmHandler(Question: Text[1024];
    VAR Reply: Boolean)begin
        Reply:=true;
    end;
    [MessageHandler]
    procedure MessageHandler(Value: Text)begin
    end;
    var IsInitialized: Boolean;
}
