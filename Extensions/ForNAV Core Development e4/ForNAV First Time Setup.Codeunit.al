Codeunit 6188480 "ForNAV First Time Setup"
{
    trigger OnRun()begin
        if CheckIfSetupExists then exit;
        AskForDefault;
        RunWizardIfSetupDoesNotExist;
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ForNAV Check Is ForNAV Report", 'ForNAVFirstTimeSetup', '', true, true)]
    local procedure ExecuteFromGetAllForNAVReports()begin
        if CheckIfSetupExists then exit;
        AskForDefault;
        RunWizardIfSetupDoesNotExist;
    end;
    local procedure CheckIfSetupExists(): Boolean var Setup: Record "ForNAV Setup";
    begin
        exit(Setup.Get);
    end;
    local procedure AskForDefault()var SetDefaultsQst: label 'Do you want to setup ForNAV with default values?\If you select no, you will be taken to a step-by-step wizard to complete the setup.';
    Setup: Record "ForNAV Setup";
    CheckSetup: Record "ForNAV Check Setup";
    LabelSetup: Record "ForNAV Label Setup";
    begin
        if not Confirm(SetDefaultsQst, true)then exit;
        Setup.InitSetup;
        Setup.CreateWebService;
        Setup.ReplaceReportSelection(true);
        Setup.CreateDefaultPrinter;
        LabelSetup.InitSetup;
        CheckSetup.InitSetup;
        CheckSetup.SetDefault(Setup);
        Commit;
    end;
    local procedure RunWizardIfSetupDoesNotExist()var Setup: Record "ForNAV Setup";
    SetupWizard: Page "ForNAV Setup Wizard";
    begin
        if Setup.Get then exit;
        SetupWizard.RunModal;
        if Setup.Get then Commit;
    end;
}
