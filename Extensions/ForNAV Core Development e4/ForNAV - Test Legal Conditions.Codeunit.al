Codeunit 6189424 "ForNAV - Test Legal Conditions"
{
    Subtype = Test;

    [Test]
    procedure TestLegalConditions()var Setup: Record "ForNAV Setup";
    LegalCondTranslation: Record "ForNAV Legal Cond. Translation";
    begin
        // [Given]
        Initialize;
        // [When]
        Setup.Get;
        Setup."Legal Conditions":='English';
        Setup.Modify;
        LegalCondTranslation."Language Code":='NLD';
        LegalCondTranslation."Legal Conditions":='Nederlands';
        LegalCondTranslation.Insert;
        // [Then]
        TestTranslation;
    end;
    procedure TestTranslation()var Setup: Record "ForNAV Setup";
    LegalCondTranslation: Record "ForNAV Legal Cond. Translation";
    begin
        Setup.Get;
        if Setup.GetLegalConditions('') <> 'English' then Error('Wrong Translation');
        if Setup.GetLegalConditions('NLD') <> 'Nederlands' then Error('Wrong Translation');
    end;
    local procedure Initialize()var InitializeTest: Codeunit "ForNAV - Test Initialize Test";
    begin
        if IsInitialized then exit;
        InitializeTest.BaseSetup;
        IsInitialized:=true;
    end;
    var IsInitialized: Boolean;
}
