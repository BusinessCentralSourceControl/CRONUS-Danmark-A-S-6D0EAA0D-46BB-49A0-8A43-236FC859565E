Codeunit 6189449 "ForNAV - Test Notification"
{
    Subtype = Test;

    [Test]
    procedure TestNotification()var Notifications: Codeunit "ForNAV Notifications";
    begin
        // [Given]
        // [When]
        Notifications.Run;
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
