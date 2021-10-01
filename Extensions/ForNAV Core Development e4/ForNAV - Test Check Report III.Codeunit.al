Codeunit 6189453 "ForNAV - Test Check Report III"
{
    Subtype = Test;

    [Test]
    [HandlerFunctions('SuggestVendorPaymentsRequestPageHandler,MessageHandler')]
    procedure TestSuggestVendorPayments()begin
        // [Given]
        Initialize;
        // [When]
        RunSuggestVendorPayments;
        // [Then]
        TestJournalLinesExist;
    end;
    [Test]
    //    [HandlerFunctions('StrMenuHandler')]
    procedure TestCheck()var Args: Record "ForNAV Check Arguments";
    TempBlob: Record "ForNAV Core Setup";
    USCheck: Report "ForNAV US Check";
    Parameters: Text;
    OutStream: OutStream;
    begin
        // [Given]
        Initialize;
        // [When]
        TempBlob.Blob.CreateOutstream(OutStream);
        Args."Bank Account No.":=TestLib.FindValidBank;
        Args."Test Print":=true;
        USCheck.SetArgs(Args);
        USCheck.InputBankAccount;
        USCheck.SaveAs(Parameters, Reportformat::Pdf, OutStream);
        // [Then]
        TestCheckprinted;
        TestCheckEntries;
    end;
    procedure TestJournalLinesExist()var GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.SetRange(GenJournalLine."Journal Template Name", TestLib.GetJournalTemplate);
        GenJournalLine.SetRange(GenJournalLine."Journal Batch Name", TestLib.GetJournalBatch);
        GenJournalLine.FindSet;
        repeat GenJournalLine.TestField(GenJournalLine."Check Printed", false);
            GenJournalLine.TestField(GenJournalLine."Bank Payment Type", GenJournalLine."Bank Payment Type"::"Computer Check".AsInteger());
        until GenJournalLine.Next = 0;
    end;
    procedure RunSuggestVendorPayments()var GenJournalLine: Record "Gen. Journal Line";
    SuggestVendorPayments: Report "Suggest Vendor Payments";
    BalAccType: Option "G/L Account", Customer, Vendor, "Bank Account";
    BankPmtType: Option " ", "Computer Check", "Manual Check", "Electronic Payment", "Electronic Payment-IAT";
    begin
        GenJournalLine.SetRange(GenJournalLine."Journal Template Name", TestLib.GetJournalTemplate);
        GenJournalLine.SetRange(GenJournalLine."Journal Batch Name", TestLib.GetJournalBatch);
        GenJournalLine."Journal Template Name":=TestLib.GetJournalTemplate;
        GenJournalLine."Journal Batch Name":=TestLib.GetJournalBatch;
        SuggestVendorPayments.SetGenJnlLine(GenJournalLine);
        Commit;
        SuggestVendorPayments.Run;
    end;
    local procedure Initialize()var InitializeTest: Codeunit "ForNAV - Test Initialize Test";
    begin
        if IsInitialized then exit;
        InitializeTest.TaxSetup;
        InitializeTest.CheckSetup;
        Commit;
        IsInitialized:=true;
    end;
    [RequestPageHandler]
    procedure SuggestVendorPaymentsRequestPageHandler(var SuggestVendorPayments: TestRequestPage "Suggest Vendor Payments")var BalAccType: Option "G/L Account", Customer, Vendor, "Bank Account";
    BankPmtType: Option " ", "Computer Check", "Manual Check", "Electronic Payment", "Electronic Payment-IAT";
    Test: Variant;
    begin
        SuggestVendorPayments.LastPaymentDate.SETVALUE(Today + 1000);
        SuggestVendorPayments.SkipExportedPayments.SETVALUE(true);
        SuggestVendorPayments.PostingDate.SETVALUE(Today + 1000);
        SuggestVendorPayments.StartingDocumentNo.SETVALUE('FORNAV01');
        SuggestVendorPayments.BalAccountType.SETVALUE(Balacctype::"Bank Account");
        SuggestVendorPayments.BalAccountNo.SETVALUE(TestLib.FindValidBank);
        SuggestVendorPayments.BankPaymentType.SETVALUE(Bankpmttype::"Computer Check");
        SuggestVendorPayments.NewDocNoPerLine.SETVALUE(false);
        SuggestVendorPayments.OK.INVOKE;
    end;
    [MessageHandler]
    procedure MessageHandler(Value: Text[1024])begin
    end;
    procedure TestCheckEntries()var CheckLedgerEntry: Record "Check Ledger Entry";
    begin
        if CheckLedgerEntry.Count <> 1 then Error('Too many Check Ledger Entries...');
        CheckLedgerEntry.FindFirst;
        CheckLedgerEntry.TestField("Check No.", 'XXXX');
    end;
    procedure TestCheckprinted()var GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.SetRange(GenJournalLine."Journal Template Name", TestLib.GetJournalTemplate);
        GenJournalLine.SetRange(GenJournalLine."Journal Batch Name", TestLib.GetJournalBatch);
        GenJournalLine.FindSet;
        repeat GenJournalLine.TestField(GenJournalLine."Check Printed", false);
        until GenJournalLine.Next = 0;
    end;
    [StrMenuHandler]
    procedure StrMenuHandler(Options: Text[1024];
    var Choice: Integer;
    Instruction: Text[1024])begin
        Choice:=1;
    end;
    var TestLib: Codeunit "ForNAV - Test Library";
    IsInitialized: Boolean;
}
