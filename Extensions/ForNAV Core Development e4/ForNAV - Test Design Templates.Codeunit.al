Codeunit 6189446 "ForNAV - Test Design Templates"
{
    Subtype = Test;

    [Test]
    [HandlerFunctions('HyperlinkHandler')]
    procedure TestSetupFunctions()var Setup: Record "ForNAV Setup";
    begin
        // [Given]
        Initialize;
        // [When]
        Setup.Get;
        // Setup.DesignTemplatePortrait;
        // Setup.DesignTemplateLandscape;
        // Setup.DesignSalesTemplate;
        // Setup.DesignPurchaseTemplate;
        // Setup.DesignReminderTemplate;
        Setup.GetDocumentWatermark;
        Setup.GetListReportWatermark;
        Setup.GetCompanyLogo;
        Setup.DownloadWatermarks;
    // [Then]
    end;
    [Test]
    [HandlerFunctions('HyperlinkHandler')]
    procedure TestCheckSetupFunctions()var CheckSetup: Record "ForNAV Check Setup";
    begin
        // [Given]
        Initialize;
        // [When]
        CheckSetup.Get;
        //CheckSetup.DesignTemplate;
        CheckSetup.GetCheckWatermark;
        CheckSetup.Validate(Layout, CheckSetup.Layout::"3 Checks");
        CheckSetup.GetTypeBasedOnLayout(1);
        CheckSetup.Validate(Layout, CheckSetup.Layout::"Bottom Check with one Stub");
        CheckSetup.GetTypeBasedOnLayout(1);
        CheckSetup.GetTypeBasedOnLayout(2);
        CheckSetup.GetTypeBasedOnLayout(3);
        CheckSetup.Validate(Layout, CheckSetup.Layout::"Check-Stub-Stub");
        CheckSetup.GetTypeBasedOnLayout(1);
        CheckSetup.GetTypeBasedOnLayout(2);
        CheckSetup.GetTypeBasedOnLayout(3);
        CheckSetup.Validate(Layout, CheckSetup.Layout::Other);
        CheckSetup.Validate(Layout, CheckSetup.Layout::"Stub-Check-Stub");
        CheckSetup.GetTypeBasedOnLayout(1);
        CheckSetup.GetTypeBasedOnLayout(2);
        CheckSetup.GetTypeBasedOnLayout(3);
        CheckSetup.Validate(Layout, CheckSetup.Layout::"Stub-Stub-Check");
        CheckSetup.GetTypeBasedOnLayout(1);
        CheckSetup.GetTypeBasedOnLayout(2);
        CheckSetup.GetTypeBasedOnLayout(3);
        CheckSetup.Validate(Layout, CheckSetup.Layout::"Top Check with one Stub");
        CheckSetup.GetTypeBasedOnLayout(1);
        CheckSetup.GetTypeBasedOnLayout(2);
        CheckSetup.GetTypeBasedOnLayout(3);
        CheckSetup.DownloadWatermarks;
    // [Then]
    end;
    local procedure Initialize()var InitializeTest: Codeunit "ForNAV - Test Initialize Test";
    begin
        if IsInitialized then exit;
        InitializeTest.BaseSetup;
        InitializeTest.CheckSetup;
        IsInitialized:=true;
    end;
    [HyperlinkHandler]
    procedure HyperlinkHandler(Value: Text[1024])begin
    //ERROR(Value);
    end;
    var IsInitialized: Boolean;
}
