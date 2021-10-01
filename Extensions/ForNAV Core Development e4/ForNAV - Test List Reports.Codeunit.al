codeunit 6189427 "ForNAV - Test List Reports"
{
    Subtype = Test;

    [Test]
    procedure TestCustomerList()var SendResultToAzure: Codeunit "ForNAV - Test Azure Interface";
    begin
        // [Given]
        Initialize;
        // [When]
        SendResultToAzure.SimpleSaveReport(Report::"ForNAV Customer - List", 'Lists/CustomerList');
    // [Then]
    end;
    [Test]
    procedure TestVendorList()var SendResultToAzure: Codeunit "ForNAV - Test Azure Interface";
    begin
        // [Given]
        Initialize;
        // [When]
        SendResultToAzure.SimpleSaveReport(Report::"ForNAV Vendor - List", 'Lists/VendorList');
    // [Then]
    end;
    [Test]
    procedure TestInventoryList()var TempBlob: Record "ForNAV Core Setup";
    SendResultToAzure: Codeunit "ForNAV - Test Azure Interface";
    OutStr: OutStream;
    InStr: InStream;
    begin
        // [Given]
        Initialize;
        // [When]
        SendResultToAzure.SimpleSaveReport(Report::"ForNAV Inventory - List", 'Lists/InventoryList');
    // [Then]
    end;
    [Test]
    procedure TestContactList()var TempBlob: Record "ForNAV Core Setup";
    SendResultToAzure: Codeunit "ForNAV - Test Azure Interface";
    OutStr: OutStream;
    InStr: InStream;
    begin
        // [Given]
        Initialize;
        // [When]
        SendResultToAzure.SimpleSaveReport(Report::"ForNAV Contact - List", 'Lists/ContactList');
    // [Then]
    end;
    [Test]
    procedure TestResourceList()var TempBlob: Record "ForNAV Core Setup";
    SendResultToAzure: Codeunit "ForNAV - Test Azure Interface";
    OutStr: OutStream;
    InStr: InStream;
    begin
        // [Given]
        Initialize;
        // [When]
        SendResultToAzure.SimpleSaveReport(Report::"ForNAV Resource - List", 'Lists/ResourceList');
    // [Then]
    end;
    local procedure Initialize()var InitializeTest: Codeunit "ForNAV - Test Initialize Test";
    begin
        if IsInitialized then exit;
        InitializeTest.BaseSetup;
        IsInitialized:=true;
    end;
    var IsInitialized: Boolean;
}
