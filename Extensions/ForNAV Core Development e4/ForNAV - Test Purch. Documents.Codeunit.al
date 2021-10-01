Codeunit 6189445 "ForNAV - Test Purch. Documents"
{
    Subtype = Test;

    [Test]
    [HandlerFunctions('HandleOrderConfirmationUI,HandleTaxOrderConfirmationUI')]
    procedure TestOrderConfirmation()var SendResultToAzure: Codeunit "ForNAV - Test Azure Interface";
    IsSalesTax: Codeunit "ForNAV Is Sales Tax";
    Parameters: Text;
    begin
        // [Given]
        Initialize;
        // [When]
        if IsSalesTax.CheckIsSalesTax then begin
            Parameters:=Report.RunRequestPage(Report::"ForNAV Tax Purchase Order");
            SendResultToAzure.SimpleSaveReport(Report::"ForNAV Tax Purchase Order", 'Purchase/Tax/PurchaseOrder', Parameters);
        end
        else
        begin
            Parameters:=Report.RunRequestPage(Report::"ForNAV VAT Purchase Order");
            SendResultToAzure.SimpleSaveReport(Report::"ForNAV VAT Purchase Order", 'Purchase/VAT/PurchaseOrder', Parameters);
        end;
    // [Then]
    end;
    [Test]
    [HandlerFunctions('HandlePurchaseInvoiceUI,HandleTaxPurchaseInvoiceUI')]
    procedure TestPurchaseInvoice()var SendResultToAzure: Codeunit "ForNAV - Test Azure Interface";
    IsSalesTax: Codeunit "ForNAV Is Sales Tax";
    Parameters: Text;
    begin
        // [Given]
        Initialize;
        // [When]
        if IsSalesTax.CheckIsSalesTax then begin
            Parameters:=Report.RunRequestPage(Report::"ForNAV Tax Purchase Invoice");
            SendResultToAzure.SimpleSaveReport(Report::"ForNAV Tax Purchase Invoice", 'Purchase/Tax/PurchaseInvoice', Parameters);
        end
        else
        begin
            Parameters:=Report.RunRequestPage(Report::"ForNAV VAT Purchase Invoice");
            SendResultToAzure.SimpleSaveReport(Report::"ForNAV VAT Purchase Invoice", 'Purchase/VAT/PurchaseInvoice', Parameters);
        end;
    // [Then]
    end;
    [Test]
    [HandlerFunctions('HandleCreditMemoUI,HandleTaxCreditMemoUI')]
    procedure TestCreditMemo()var SendResultToAzure: Codeunit "ForNAV - Test Azure Interface";
    IsSalesTax: Codeunit "ForNAV Is Sales Tax";
    Parameters: Text;
    begin
        // [Given]
        Initialize;
        // [When]
        if IsSalesTax.CheckIsSalesTax then begin
            Parameters:=Report.RunRequestPage(Report::"ForNAV Tax Purchase Cr. Memo");
            SendResultToAzure.SimpleSaveReport(Report::"ForNAV Tax Purchase Cr. Memo", 'Purchase/Tax/PurchaseCreditMemo', Parameters);
        end
        else
        begin
            Parameters:=Report.RunRequestPage(Report::"ForNAV VAT Purchase Cr. Memo");
            SendResultToAzure.SimpleSaveReport(Report::"ForNAV VAT Purchase Cr. Memo", 'Purchase/VAT/PurchaseCreditMemo', Parameters);
        end;
    // [Then]
    end;
    [Test]
    [HandlerFunctions('HandleQuoteUI,HandleTaxQuoteUI')]
    procedure TestQuote()var SendResultToAzure: Codeunit "ForNAV - Test Azure Interface";
    TestLargePurchQuote: Codeunit "ForNAV Test Large Purch. Quote";
    IsSalesTax: Codeunit "ForNAV Is Sales Tax";
    Parameters: Text;
    begin
        // [Given]
        Initialize;
        TestLargePurchQuote.Run;
        Commit;
        // [When]
        if IsSalesTax.CheckIsSalesTax then begin
            Parameters:=Report.RunRequestPage(Report::"ForNAV Tax Purchase Quote");
            SendResultToAzure.SimpleSaveReport(Report::"ForNAV Tax Purchase Quote", 'Purchase/Tax/PurchaseQuote', Parameters);
        end
        else
        begin
            Parameters:=Report.RunRequestPage(Report::"ForNAV VAT Purchase Quote");
            SendResultToAzure.SimpleSaveReport(Report::"ForNAV VAT Purchase Quote", 'Purchase/VAT/PurchaseQuote', Parameters);
        end;
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
    procedure HandleOrderConfirmationUI(var ReportID: Report "ForNAV VAT Purchase Order")begin
    end;
    [ReportHandler]
    procedure HandlePurchaseInvoiceUI(var ReportID: Report "ForNAV VAT Purchase Invoice")begin
    end;
    [ReportHandler]
    procedure HandleCreditMemoUI(var ReportID: Report "ForNAV VAT Purchase Cr. Memo")begin
    end;
    [ReportHandler]
    procedure HandleQuoteUI(var ReportID: Report "ForNAV VAT Purchase Quote")begin
    end;
    [ReportHandler]
    procedure HandleTaxOrderConfirmationUI(var ReportID: Report "ForNAV Tax Purchase Order")begin
    end;
    [ReportHandler]
    procedure HandleTaxPurchaseInvoiceUI(var ReportID: Report "ForNAV Tax Purchase Invoice")begin
    end;
    [ReportHandler]
    procedure HandleTaxCreditMemoUI(var ReportID: Report "ForNAV Tax Purchase Cr. Memo")begin
    end;
    [ReportHandler]
    procedure HandleTaxQuoteUI(var ReportID: Report "ForNAV Tax Purchase Quote")begin
    end;
    [StrMenuHandler]
    procedure StrMenuHandler(Options: Text[1024];
    var Choice: Integer;
    Instruction: Text[1024])begin
        Choice:=1;
    end;
    var IsInitialized: Boolean;
}
