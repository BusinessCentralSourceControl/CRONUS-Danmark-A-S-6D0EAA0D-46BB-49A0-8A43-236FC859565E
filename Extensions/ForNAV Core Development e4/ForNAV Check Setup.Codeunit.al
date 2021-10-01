Codeunit 6188481 "ForNAV Check Setup"
{
    TableNo = "ForNAV Setup";

    trigger OnRun()var CheckSetup: Record "ForNAV Check Setup";
    begin
        CreateCheckSetupRecord(CheckSetup);
        SetCheckType(Rec, CheckSetup);
    end;
    procedure CreateCheckSetupRecord(var CheckSetup: Record "ForNAV Check Setup")begin
        CheckSetup.InitSetup;
    end;
    procedure SetCheckType(Setup: Record "ForNAV Setup";
    var CheckSetup: Record "ForNAV Check Setup")var IsSalesTax: Codeunit "ForNAV Is Sales Tax";
    begin
        if IsSalesTax.CheckIsSalesTax then CheckSetup.Validate(Layout, CheckSetup.Layout::"Check-Stub-Stub")
        else
            CheckSetup.Validate(Layout, CheckSetup.Layout::" ");
        CheckSetup.Modify;
    end;
}
