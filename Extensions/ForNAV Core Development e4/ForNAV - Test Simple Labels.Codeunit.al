codeunit 6189428 "ForNAV - Test Simple Labels"
{
    Subtype = Test;

    [Test]
    procedure TestCustomerLabel()var SendResultToAzure: Codeunit "ForNAV - Test Azure Interface";
    begin
        // [Given]
        Initialize;
        // [When]
        SendResultToAzure.SimpleSaveReport(Report::"ForNAV Customer - Label", 'Labels/CustomerLabel');
    // [Then]
    end;
    [Test]
    procedure TestVendorLabel()var SendResultToAzure: Codeunit "ForNAV - Test Azure Interface";
    begin
        // [Given]
        Initialize;
        // [When]
        SendResultToAzure.SimpleSaveReport(Report::"ForNAV Vendor - Label", 'Labels/VendorLabel');
    // [Then]
    end;
    [Test]
    procedure TestInventoryLabel()var SendResultToAzure: Codeunit "ForNAV - Test Azure Interface";
    begin
        // [Given]
        Initialize;
        // [When]
        SendResultToAzure.SimpleSaveReport(Report::"ForNAV Item - Label", 'Labels/ItemLabel');
    // [Then]
    end;
    [Test]
    procedure TestContactLabel()var SendResultToAzure: Codeunit "ForNAV - Test Azure Interface";
    begin
        // [Given]
        Initialize;
        // [When]
        SendResultToAzure.SimpleSaveReport(Report::"ForNAV Contact - Label", 'Labels/ContactLabel');
    // [Then]
    end;
    [Test]
    procedure TestResourceLabel()var SendResultToAzure: Codeunit "ForNAV - Test Azure Interface";
    begin
        // [Given]
        Initialize;
        // [When]
        SendResultToAzure.SimpleSaveReport(Report::"ForNAV Resource - Label", 'Labels/ResourceLabel');
    // [Then]
    end;
    [Test]
    procedure TestEmployeeLabel()var SendResultToAzure: Codeunit "ForNAV - Test Azure Interface";
    begin
        // [Given]
        Initialize;
        SetEmployeeAddressIfEmpty;
        // [When]
        SendResultToAzure.SimpleSaveReport(Report::"ForNAV Employee - Label", 'Labels/EmployeeLabel');
    // [Then]
    end;
    local procedure Initialize()var InitializeTest: Codeunit "ForNAV - Test Initialize Test";
    begin
        if IsInitialized then exit;
        InitializeTest.BaseSetup;
        InitializeTest.LabelSetup;
        IsInitialized:=true;
    end;
    local procedure SetEmployeeAddressIfEmpty()var Empl: Record Employee;
    Cont: Record Contact;
    begin
        if not Empl.FindSet then exit;
        if not Cont.FindSet then exit;
        repeat if Empl."Post Code" = '' then Empl."Post Code":=Cont."Post Code";
            if Empl.City = '' then Empl.City:=Cont.City;
            if Empl."Country/Region Code" = '' then Empl."Country/Region Code":=Cont."Country/Region Code";
            Empl.Modify;
            if Cont.Next = 0 then exit;
        until Empl.Next = 0;
    end;
    var IsInitialized: Boolean;
}
