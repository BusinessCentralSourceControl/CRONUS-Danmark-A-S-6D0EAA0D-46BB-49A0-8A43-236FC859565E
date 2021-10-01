codeunit 6189429 "ForNAV - Test Complex Labels"
{
    Subtype = Test;

    [Test]
    [HandlerFunctions('HandleShipmentLabelUI')]
    procedure TestShipmentLabelPortrait()var SalesShpmntHdr: Record "Sales Shipment Header";
    LabelArgs: Record "ForNAV Label Args." temporary;
    LabelSetup: Record "ForNAV Label Setup";
    SendResultToAzure: Codeunit "ForNAV - Test Azure Interface";
    SalesShipmentLabel: Report "ForNAV Sales Shipment Label";
    InStr: InStream;
    begin
        // [Given]
        Initialize;
        LabelArgs."Print to Stream":=true;
        LabelSetup.Get;
        LabelSetup.Orientation:=LabelSetup.Orientation::Portrait;
        LabelSetup.Modify;
        // [When]
        SalesShpmntHdr.FindFirst;
        SalesShpmntHdr.SetRecFilter;
        SalesShipmentLabel.SetArgs(LabelArgs);
        SalesShipmentLabel.SetTableView(SalesShpmntHdr);
        SalesShipmentLabel.RunModal;
        SalesShipmentLabel.GetArgs(LabelArgs);
        LabelArgs.CalcFields(Blob);
        LabelArgs.Blob.CreateInstream(InStr);
        SendResultToAzure.SendFileToAzureBlobContainer(InStr, 'Labels/SalesShipmentLabelPortrait' + '.pdf');
    // [Then]
    end;
    [Test]
    [HandlerFunctions('HandleShipmentLabelUI')]
    procedure TestShipmentLabelLandscape()var SalesShpmntHdr: Record "Sales Shipment Header";
    LabelSetup: Record "ForNAV Label Setup";
    LabelArgs: Record "ForNAV Label Args." temporary;
    SendResultToAzure: Codeunit "ForNAV - Test Azure Interface";
    SalesShipmentLabel: Report "ForNAV Sales Shipment Label";
    InStr: InStream;
    begin
        // [Given]
        Initialize;
        LabelArgs."Print to Stream":=true;
        LabelSetup.Get;
        LabelSetup.Orientation:=LabelSetup.Orientation::Landscape;
        LabelSetup.Modify;
        // [When]
        SalesShpmntHdr.FindFirst;
        SalesShpmntHdr.SetRecFilter;
        SalesShipmentLabel.SetArgs(LabelArgs);
        SalesShipmentLabel.SetTableView(SalesShpmntHdr);
        SalesShipmentLabel.RunModal;
        SalesShipmentLabel.GetArgs(LabelArgs);
        LabelArgs.CalcFields(Blob);
        LabelArgs.Blob.CreateInstream(InStr);
        SendResultToAzure.SendFileToAzureBlobContainer(InStr, 'Labels/SalesShipmentLabelLandscape' + '.pdf');
    // [Then]
    end;
    [RequestPageHandler]
    procedure HandleShipmentLabelUI(var SalesShipmentLabel: TestRequestPage "ForNAV Sales Shipment Label")begin
        SalesShipmentLabel.OK.Invoke;
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
