Codeunit 6189454 "ForNAV - Test Check Report IV"
{
    Subtype = Test;

    [Test]
    [HandlerFunctions('SuggestVendorPaymentsRequestPageHandler,MessageHandler')]
    procedure TestSuggestVendorPayments()var Value: Code[20];
    begin
        // [Given]
        Initialize;
        // [When]
        Value:=CreateInvoiceWithDiscount;
        RunSuggestVendorPayments;
        DeleteJournalLines(Value);
        // [Then]
        TestJournalLineExist(Value);
    end;
    [Test]
    procedure TestCheck()var Args: Record "ForNAV Check Arguments";
    TempBlob: Record "ForNAV Core Setup";
    USCheck: Report "ForNAV US Check";
    SendResultToAzure: Codeunit "ForNAV - Test Azure Interface";
    Parameters: Text;
    OutStream: OutStream;
    InStr: InStream;
    begin
        // [Given]
        Initialize;
        // [When]
        TempBlob.Blob.CreateOutstream(OutStream);
        TempBlob.Blob.CreateInstream(InStr);
        Args."Bank Account No.":=TestLib.FindValidBank;
        USCheck.SetArgs(Args);
        USCheck.InputBankAccount;
        USCheck.SaveAs(Parameters, Reportformat::Pdf, OutStream);
        SendResultToAzure.SendFileToAzureBlobContainer(InStr, 'Check/Check4.pdf');
        // [Then]
        TestCheckprinted;
        TestCheckEntries;
    end;
    local procedure DeleteJournalLines(Value: Code[20])var GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.SetRange(GenJournalLine."Journal Template Name", TestLib.GetJournalTemplate);
        GenJournalLine.SetRange(GenJournalLine."Journal Batch Name", TestLib.GetJournalBatch);
        GenJournalLine.SetFilter(GenJournalLine."Applies-to Doc. No.", '<>%1', Value);
        GenJournalLine.DeleteAll(true);
    end;
    local procedure TestJournalLineExist(Value: Code[20])var GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.SetRange(GenJournalLine."Journal Template Name", TestLib.GetJournalTemplate);
        GenJournalLine.SetRange(GenJournalLine."Journal Batch Name", TestLib.GetJournalBatch);
        GenJournalLine.SetRange(GenJournalLine."Applies-to Doc. No.", Value);
        GenJournalLine.FindFirst;
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
    local procedure CreateInvoiceWithDiscount()Value: Code[20];
    var GenBusPstGr: Code[20];
    begin
        CreatePurchHeaderWithNumber10000(Value, GenBusPstGr);
        CreatePurchLinesWithRandomAmount(Value, GenBusPstGr);
        PostIt(Value);
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
    begin
        SuggestVendorPayments.LastPaymentDate.SETVALUE(WorkDate);
        SuggestVendorPayments.SkipExportedPayments.SETVALUE(true);
        SuggestVendorPayments.PostingDate.SETVALUE(WorkDate);
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
    //CheckLedgerEntry.TestField("Check No.", 'XXXX');
    end;
    procedure TestCheckprinted()var GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.SetRange(GenJournalLine."Journal Template Name", TestLib.GetJournalTemplate);
        GenJournalLine.SetRange(GenJournalLine."Journal Batch Name", TestLib.GetJournalBatch);
        GenJournalLine.FindSet;
        repeat GenJournalLine.TestField(GenJournalLine."Check Printed", true);
        until GenJournalLine.Next = 0;
    end;
    local procedure CreatePurchHeaderWithNumber10000(var DocNo: Code[20];
    var GenBusPstGr: Code[20])var PurchaseHeader: Record "Purchase Header";
    begin
        PurchaseHeader.Init;
        PurchaseHeader."Document Type":=PurchaseHeader."document type"::Invoice;
        PurchaseHeader.Insert(true);
        PurchaseHeader.SetHideValidationDialog(true);
        PurchaseHeader.Validate(PurchaseHeader."Pay-to Vendor No.", '10000');
        PurchaseHeader.Validate(PurchaseHeader."Buy-from Vendor No.", '10000');
        PurchaseHeader.Validate(PurchaseHeader."Vendor Invoice No.", PurchaseHeader."No.");
        PurchaseHeader.Validate(PurchaseHeader."Posting Date", WorkDate);
        PurchaseHeader.Validate(PurchaseHeader."Due Date", WorkDate);
        PurchaseHeader.Validate(PurchaseHeader."Payment Discount %", 10);
        PurchaseHeader."Posting No. Series":=PurchaseHeader."No. Series";
        PurchaseHeader.Modify(true);
        PurchaseHeader.TestField(PurchaseHeader."Gen. Bus. Posting Group");
        DocNo:=PurchaseHeader."No.";
        GenBusPstGr:=PurchaseHeader."Gen. Bus. Posting Group";
    end;
    local procedure CreatePurchLinesWithRandomAmount(DocNo: Code[20];
    GenBusPstGr: Code[20])var PurchaseLine: Record "Purchase Line";
    i: Integer;
    begin
        for i:=1 to 1 do begin
            PurchaseLine.Init;
            PurchaseLine."Document Type":=PurchaseLine."document type"::Invoice;
            PurchaseLine."Document No.":=DocNo;
            PurchaseLine."Line No.":=i * 10000;
            PurchaseLine.Insert(true);
            //SetHideValidationDialog(TRUE);
            PurchaseLine.Validate(PurchaseLine.Type, PurchaseLine.Type::"G/L Account");
            PurchaseLine.Validate(PurchaseLine."No.", FindDirectPostngAccount(GenBusPstGr));
            PurchaseLine.Validate(PurchaseLine.Quantity, 1);
            PurchaseLine.Validate(PurchaseLine."Direct Unit Cost", 60);
            PurchaseLine.Modify(true);
        end;
    end;
    local procedure PostIt(Value: Code[20])var PurchaseHeader: Record "Purchase Header";
    PurchPost: Codeunit "Purch.-Post";
    begin
        PurchaseHeader.Get(PurchaseHeader."document type"::Invoice, Value);
        PurchPost.Run(PurchaseHeader);
    end;
    local procedure FindDirectPostngAccount(Value: Code[20]): Code[20]var GLAccount: Record "G/L Account";
    GenPostingSetup: Record "General Posting Setup";
    begin
        GenPostingSetup.SetRange("Gen. Bus. Posting Group", Value);
        GenPostingSetup.FindFirst;
        GLAccount.SetRange("Direct Posting", true);
        GLAccount.SetRange("Gen. Prod. Posting Group", GenPostingSetup."Gen. Prod. Posting Group");
        GLAccount.SetFilter("VAT Prod. Posting Group", '<>%1', '');
        GLAccount.FindFirst;
        exit(GLAccount."No.");
    end;
    local procedure FindVatPordPostingGroup(): Code[20]var VATProductPostingGroup: Record "VAT Product Posting Group";
    begin
        VATProductPostingGroup.FindFirst;
        exit(VATProductPostingGroup.Code);
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
