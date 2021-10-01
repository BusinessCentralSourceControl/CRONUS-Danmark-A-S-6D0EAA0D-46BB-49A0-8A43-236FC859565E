codeunit 6189450 "ForNAV - Test Translations"
{
    Subtype = Test;

    [Test]
    procedure TestDefaultTranslation()var Translation: Record "ForNAV Language Setup";
    Translations: Codeunit "ForNAV Language Mgt.";
    TranslatedValue: Text;
    begin
        // [Given]
        Translation.DeleteAll;
        Translation.GetDefaultTranslations;
        // [When]
        TranslatedValue:=Translations.GetTranslation(1043, 'Invoice');
        // [Then]
        if TranslatedValue <> 'Factuur' then Error('Unexpected translation :' + TranslatedValue);
    end;
    [Test]
    procedure TestSpecificTranslation()var Translation: Record "ForNAV Language Setup";
    Translations: Codeunit "ForNAV Language Mgt.";
    TranslatedValue: Text;
    begin
        // [Given]
        Translation.DeleteAll;
        Translation.Init;
        Translation.Validate("Language Code", 'NLD');
        Translation.Validate("Table No.", 18);
        Translation.Validate("Field No.", 1);
        Translation."Translate To":='Nummer';
        Translation.Insert(true);
        // [When]
        TranslatedValue:=Translations.GetTranslation(1043, 18, 1);
        // [Then]
        if TranslatedValue <> 'Nummer' then Error('Unexpected translation :' + TranslatedValue);
    end;
}
