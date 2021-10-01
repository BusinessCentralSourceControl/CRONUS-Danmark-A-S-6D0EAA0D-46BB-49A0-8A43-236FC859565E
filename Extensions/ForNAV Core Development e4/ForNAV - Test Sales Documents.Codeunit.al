Codeunit 6189442 "ForNAV - Test Sales Documents"
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
            Parameters:=Report.RunRequestPage(Report::"ForNAV Tax Order Confirmation");
            SendResultToAzure.SimpleSaveReport(Report::"ForNAV Tax Order Confirmation", 'Sales/Tax/OrderConfirmation', Parameters);
        end
        else
        begin
            Parameters:=Report.RunRequestPage(Report::"ForNAV VAT Order Confirmation");
            SendResultToAzure.SimpleSaveReport(Report::"ForNAV VAT Order Confirmation", 'Sales/VAT/OrderConfirmation', Parameters);
        end;
    // [Then]
    end;
    [Test]
    [HandlerFunctions('HandleSalesInvoiceUI,HandleTaxSalesInvoiceUI')]
    procedure TestSalesInvoice()var SendResultToAzure: Codeunit "ForNAV - Test Azure Interface";
    IsSalesTax: Codeunit "ForNAV Is Sales Tax";
    Parameters: Text;
    begin
        // [Given]
        Initialize;
        // [When]
        if IsSalesTax.CheckIsSalesTax then begin
            Parameters:=Report.RunRequestPage(Report::"ForNAV Tax Sales Invoice");
            SendResultToAzure.SimpleSaveReport(Report::"ForNAV Tax Sales Invoice", 'Sales/Tax/SalesInvoice', Parameters);
        end
        else
        begin
            Parameters:=Report.RunRequestPage(Report::"ForNAV VAT Sales Invoice");
            SendResultToAzure.SimpleSaveReport(Report::"ForNAV VAT Sales Invoice", 'Sales/VAT/SalesInvoice', Parameters);
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
            Parameters:=Report.RunRequestPage(Report::"ForNAV Tax Credit Memo");
            SendResultToAzure.SimpleSaveReport(Report::"ForNAV Tax Credit Memo", 'Sales/Tax/CreditMemo', Parameters);
        end
        else
        begin
            Parameters:=Report.RunRequestPage(Report::"ForNAV VAT Credit Memo");
            SendResultToAzure.SimpleSaveReport(Report::"ForNAV VAT Credit Memo", 'Sales/VAT/CreditMemo', Parameters);
        end;
    // [Then]
    end;
    [Test]
    [HandlerFunctions('HandleShipmentUI')]
    procedure TestShipment()var SendResultToAzure: Codeunit "ForNAV - Test Azure Interface";
    Parameters: Text;
    begin
        // [Given]
        Initialize;
        // [When]
        Parameters:=Report.RunRequestPage(Report::"ForNAV Sales Shipment");
        SendResultToAzure.SimpleSaveReport(Report::"ForNAV Sales Shipment", 'Sales/SalesShipment', Parameters);
    // [Then]
    end;
    [Test]
    [HandlerFunctions('HandleQuoteUI,HandleTaxQuoteUI')]
    procedure TestQuote()var SendResultToAzure: Codeunit "ForNAV - Test Azure Interface";
    TestLargeSalesQuote: Codeunit "ForNAV Test Large Sales Quote";
    IsSalesTax: Codeunit "ForNAV Is Sales Tax";
    Parameters: Text;
    begin
        // [Given]
        Initialize;
        TestLargeSalesQuote.Run;
        Commit;
        // [When]
        if IsSalesTax.CheckIsSalesTax then begin
            Parameters:=Report.RunRequestPage(Report::"ForNAV Tax Sales Quote");
            SendResultToAzure.SimpleSaveReport(Report::"ForNAV Tax Sales Quote", 'Sales/Tax/SalesQuote', Parameters);
        end
        else
        begin
            Parameters:=Report.RunRequestPage(Report::"ForNAV VAT Sales Quote");
            SendResultToAzure.SimpleSaveReport(Report::"ForNAV VAT Sales Quote", 'Sales/VAT/SalesQuote', Parameters);
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
    procedure HandleOrderConfirmationUI(var ReportID: Report "ForNAV VAT Order Confirmation")begin
    end;
    [ReportHandler]
    procedure HandleSalesInvoiceUI(var ReportID: Report "ForNAV VAT Sales Invoice")begin
    end;
    [ReportHandler]
    procedure HandleCreditMemoUI(var ReportID: Report "ForNAV VAT Credit Memo")begin
    end;
    [ReportHandler]
    procedure HandleShipmentUI(var ReportID: Report "ForNAV Sales Shipment")begin
    end;
    [ReportHandler]
    procedure HandleQuoteUI(var ReportID: Report "ForNAV VAT Sales Quote")begin
    end;
    [ReportHandler]
    procedure HandleTaxOrderConfirmationUI(var ReportID: Report "ForNAV Tax Order Confirmation")begin
    end;
    [ReportHandler]
    procedure HandleTaxSalesInvoiceUI(var ReportID: Report "ForNAV Tax Sales Invoice")begin
    end;
    [ReportHandler]
    procedure HandleTaxCreditMemoUI(var ReportID: Report "ForNAV Tax Credit Memo")begin
    end;
    [ReportHandler]
    procedure HandleTaxQuoteUI(var ReportID: Report "ForNAV Tax Sales Quote")begin
    end;
    [StrMenuHandler]
    procedure StrMenuHandler(Options: Text[1024];
    var Choice: Integer;
    Instruction: Text[1024])begin
        Choice:=1;
    end;
    var IsInitialized: Boolean;
}
