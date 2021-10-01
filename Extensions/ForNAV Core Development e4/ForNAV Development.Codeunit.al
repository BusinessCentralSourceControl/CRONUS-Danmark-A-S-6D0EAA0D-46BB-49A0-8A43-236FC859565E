codeunit 6188800 "ForNAV Development"
{
    [EventSubscriber(ObjectType::Table, Database::"ForNAV Language Setup", 'OnBeforeGetTranslationURL', '', false, false)]
    local procedure MyProcedure(var TranslationURL: Text;
    var Handled: Boolean)begin
        TranslationURL:='https://vgblobstoragepublic.blob.core.windows.net/anveo/Translations 20190827.xlsx';
    //Handled := true;
    end;
    procedure TestSaveAsPDF()var TempBlob: Record "ForNAV Core Setup";
    OutStr: OutStream;
    InStr: InStream;
    begin
        TempBlob.Blob.CreateOutstream(OutStr);
        TempBlob.Blob.CreateInStream(InStr);
        Report.SaveAs(6188471, '', Reportformat::Pdf, OutStr);
    end;
}
