Codeunit 6189448 "ForNAV - Test Exceptions"
{
    Subtype = Test;

    [Test]
    procedure TestCheckTemporary()var Setup: Record "ForNAV Setup";
    CheckTemporary: Codeunit "ForNAV Check Temporary";
    begin
        // [Given]
        Initialize;
        // [When]
        Setup.Get;
        asserterror CheckTemporary.IsTemporary(Setup, true);
        // [Then]
        if not CheckTemporary.IsTemporary(Setup, false)then Error('Is not temporary');
    end;
    [Test]
    procedure TestValidDoc()var RecRefSetup: RecordRef;
    RecRefSalesShipmentHeader: RecordRef;
    RecRefPurchReceiptHeader: RecordRef;
    RecRefReminder: RecordRef;
    RecRefIssuedReminder: RecordRef;
    RecRefFCMemo: RecordRef;
    RecRefIssuedFCMemo: RecordRef;
    TestValidDociFace: Codeunit "ForNAV Test Valid Doc iFace";
    begin
        // [Given]
        Initialize;
        // [When]
        RecRefSetup.Open(Database::"ForNAV Setup");
        RecRefSalesShipmentHeader.Open(Database::"Sales Shipment Header");
        RecRefPurchReceiptHeader.Open(Database::"Purch. Rcpt. Header");
        RecRefReminder.Open(Database::"Reminder Header");
        RecRefIssuedReminder.Open(Database::"Issued Reminder Header");
        RecRefFCMemo.Open(Database::"Finance Charge Memo Header");
        RecRefIssuedFCMemo.Open(Database::"Issued Fin. Charge Memo Header");
        // [Then]
        asserterror TestValidDociFace.ThrowErrorIfNotValid(RecRefSetup);
        if not TestValidDociFace.CheckValid(RecRefSalesShipmentHeader)then Error('Wrong Sales Shipment Header');
        if not TestValidDociFace.CheckValid(RecRefPurchReceiptHeader)then Error('Wrong "Purch. Rcpt. Header');
        if not TestValidDociFace.CheckValid(RecRefReminder)then Error('Wrong Reminder Header');
        if not TestValidDociFace.CheckValid(RecRefIssuedReminder)then Error('Wrong Issued Reminder Header');
        if not TestValidDociFace.CheckValid(RecRefFCMemo)then Error('Wrong Finance Charge Memo Header');
        if not TestValidDociFace.CheckValid(RecRefIssuedFCMemo)then Error('Wrong Issued Fin. Charge Memo Header');
    end;
    local procedure Initialize()var InitializeTest: Codeunit "ForNAV - Test Initialize Test";
    begin
        if IsInitialized then exit;
        InitializeTest.BaseSetup;
        IsInitialized:=true;
    end;
    var IsInitialized: Boolean;
}
