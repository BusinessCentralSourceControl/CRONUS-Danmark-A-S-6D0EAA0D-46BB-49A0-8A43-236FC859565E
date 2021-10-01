Codeunit 6189443 "ForNAV - Test Warehouse Doc."
{
    Subtype = Test;

    [Test]
    [HandlerFunctions('HandleWarehouseShipmentUI,MessageHandler,HandleShipmentPage')]
    procedure TestWarehouseShipment()var TempBlob: Record "ForNAV Core Setup";
    SendResultToAzure: Codeunit "ForNAV - Test Azure Interface";
    CreateWhseDocuments: Codeunit "ForNAV Test Setup Warehouse";
    Parameters: Text;
    OutStr: OutStream;
    InStr: InStream;
    begin
        // [Given]
        Initialize;
        CreateWhseDocuments.CreateSetup('FORNAV');
        CreateWhseDocuments.CreateSalesOrder('FORNAV');
        // [When]
        Parameters:=Report.RunRequestPage(Report::"ForNAV Warehouse Shipment");
        TempBlob.Blob.CreateOutstream(OutStr);
        TempBlob.Blob.CreateInStream(InStr);
        Report.SaveAs(Report::"ForNAV Warehouse Shipment", Parameters, Reportformat::Pdf, OutStr);
        SendResultToAzure.SendFileToAzureBlobContainer(InStr, 'WareHouse/WarehouseShipment.pdf');
        Report.SaveAs(Report::"ForNAV Warehouse Shipment", Parameters, Reportformat::Html, OutStr);
        SendResultToAzure.SendFileToAzureBlobContainer(InStr, 'WareHouse/WarehouseShipment.html');
        Report.SaveAs(Report::"ForNAV Warehouse Shipment", Parameters, Reportformat::Word, OutStr);
        SendResultToAzure.SendFileToAzureBlobContainer(InStr, 'WareHouse/WarehouseShipment.docx');
        Report.SaveAs(Report::"ForNAV Warehouse Shipment", Parameters, Reportformat::Xml, OutStr);
        SendResultToAzure.SendFileToAzureBlobContainer(InStr, 'WareHouse/WarehouseShipment.xml');
    // [Then]
    end;
    [Test]
    [HandlerFunctions('HandleWarehouseReceiptUI,MessageHandler,HandleReceiptPage')]
    procedure TestWarehouseReceipt()var TempBlob: Record "ForNAV Core Setup";
    SendResultToAzure: Codeunit "ForNAV - Test Azure Interface";
    CreateWhseDocuments: Codeunit "ForNAV Test Setup Warehouse";
    Parameters: Text;
    OutStr: OutStream;
    InStr: InStream;
    begin
        // [Given]
        Initialize;
        CreateWhseDocuments.CreatePurchaseOrder('FORNAV');
        // [When]
        Parameters:=Report.RunRequestPage(Report::"ForNAV Warehouse Receipt");
        TempBlob.Blob.CreateOutstream(OutStr);
        TempBlob.Blob.CreateInStream(InStr);
        Report.SaveAs(Report::"ForNAV Warehouse Receipt", Parameters, Reportformat::Pdf, OutStr);
        SendResultToAzure.SendFileToAzureBlobContainer(InStr, 'WareHouse/WarehouseReceipt.pdf');
        Report.SaveAs(Report::"ForNAV Warehouse Receipt", Parameters, Reportformat::Html, OutStr);
        SendResultToAzure.SendFileToAzureBlobContainer(InStr, 'WareHouse/WarehouseReceipt.html');
        Report.SaveAs(Report::"ForNAV Warehouse Receipt", Parameters, Reportformat::Word, OutStr);
        SendResultToAzure.SendFileToAzureBlobContainer(InStr, 'WareHouse/WarehouseReceipt.docx');
        Report.SaveAs(Report::"ForNAV Warehouse Receipt", Parameters, Reportformat::Xml, OutStr);
        SendResultToAzure.SendFileToAzureBlobContainer(InStr, 'WareHouse/WarehouseReceipt.xml');
    // [Then]
    end;
    local procedure Initialize()var InitializeTest: Codeunit "ForNAV - Test Initialize Test";
    begin
        if IsInitialized then exit;
        InitializeTest.BaseSetup;
        Commit;
        IsInitialized:=true;
    end;
    [PageHandler]
    procedure HandleShipmentPage(var TestPage: Page "Warehouse Shipment")begin
        TestPage.Close;
    end;
    [PageHandler]
    procedure HandleReceiptPage(var TestPage: Page "Warehouse Receipt")begin
        TestPage.Close;
    end;
    [ReportHandler]
    procedure HandleWarehouseShipmentUI(var ReportID: Report "ForNAV Warehouse Shipment")begin
    end;
    [ReportHandler]
    procedure HandleWarehouseReceiptUI(var ReportID: Report "ForNAV Warehouse Receipt")begin
    end;
    [MessageHandler]
    procedure MessageHandler(Value: Text[1024])begin
    end;
    var IsInitialized: Boolean;
}
