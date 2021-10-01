Codeunit 6189420 "ForNAV - Test Initialize Test"
{
    procedure BaseSetup()var Setup: Record "ForNAV Setup";
    TestLib: Codeunit "ForNAV - Test Library";
    begin
        TestLib.SetAppSettings;
        if not Setup.IsEmpty then DeleteAllForNAVData;
        Setup.InitSetup;
        GetDemoData(Setup);
        ChangeEndpoint(Setup);
        Setup.Modify;
        Setup.CreateWebService;
        Setup.ReplaceReportSelection(true);
        ChangeLanguage;
    end;
    procedure LabelSetup()var Setup: Record "ForNAV Label Setup";
    begin
        Setup.InitSetup;
        Setup."Disable Warnings":=true;
        Setup.Modify;
        Setup.ReplaceReportSelection(true);
    end;
    procedure TaxSetup()var Setup: Record "ForNAV Setup";
    TestLib: Codeunit "ForNAV - Test Library";
    begin
        TestLib.SetAppSettings;
        if not Setup.IsEmpty then DeleteAllForNAVData;
        Setup.InitSetup;
        GetDemoData(Setup);
        Setup."VAT Report Type":=Setup."vat report type"::"N/A. (Sales Tax)";
        Setup.Modify;
        Setup.CreateWebService;
        Setup.ReplaceReportSelection(true);
    end;
    procedure CheckSetup()var Setup: Record "ForNAV Setup";
    CheckSetup: Record "ForNAV Check Setup";
    begin
        if not Setup.Get then BaseSetup;
        Setup.Get;
        CheckSetup.InitSetup;
        CheckSetup.Validate(Layout, CheckSetup.Layout::"Check-Stub-Stub");
        CheckSetup."MICR Encoding":=CheckSetup."MICR Encoding"::"Check No. + Routing No. + Bank Account No.";
        GetDemoDataCheck(CheckSetup);
        CheckSetup.Modify;
    end;
    procedure DeleteAllForNAVData()var Setup: Record "ForNAV Setup";
    LegalConditionTranslation: Record "ForNAV Legal Cond. Translation";
    LabelSetup: Record "ForNAV Label Setup";
    CheckSetup: Record "ForNAV Check Setup";
    RepSelHist: Record "ForNAV Report Selection Hist.";
    TestLib: Codeunit "ForNAV - Test Library";
    begin
        Setup.DeleteAll;
        LegalConditionTranslation.DeleteAll;
        LabelSetup.DeleteAll;
        CheckSetup.DeleteAll;
        RepSelHist.DeleteAll;
        TestLib.RestoreToCRONUS;
    end;
    local procedure ChangeLanguage()var CompInfo: Record "Company Information";
    begin
        CompInfo.Get;
        case CompInfo."Country/Region Code" of 'NL': GlobalLanguage:=1043;
        'DE': GlobalLanguage:=1031;
        'DK': GlobalLanguage:=1030;
        else
            GlobalLanguage:=1033;
        end;
    end;
    local procedure ChangeEndpoint(var Setup: Record "ForNAV Setup")begin
    //Setup.Validate("Service Endpoint", 'alpha');
    end;
    local procedure GetDemoData(var Setup: Record "ForNAV Setup")var Client: HttpClient;
    ResponseMessage: HttpResponseMessage;
    InStr: InStream;
    OutStr: OutStream;
    ErrorResponse: Text;
    begin
        Client.Get('https://vgblobstoragepublic.blob.core.windows.net/fornavsetup/Invoice_A4_skabelon_6.pdf', ResponseMessage);
        ResponseMessage.Content.ReadAs(InStr);
        if not ResponseMessage.IsSuccessStatusCode then begin
            ResponseMessage.Content.ReadAs(ErrorResponse);
            error('The web service returned an error message:\Status code: %1\Description: %2', ResponseMessage.HttpStatusCode, ErrorResponse);
        end;
        Setup."Document Watermark".CreateOutStream(OutStr);
        CopyStream(OutStr, InStr);
        Clear(InStr);
        Client.Get('https://vgblobstoragepublic.blob.core.windows.net/fornavsetup/A4_column_6.pdf', ResponseMessage);
        ResponseMessage.Content.ReadAs(InStr);
        if not ResponseMessage.IsSuccessStatusCode then begin
            ResponseMessage.Content.ReadAs(ErrorResponse);
            error('The web service returned an error message:\Status code: %1\Description: %2', ResponseMessage.HttpStatusCode, ErrorResponse);
        end;
        Setup."List Report Watermark".CreateOutStream(OutStr);
        CopyStream(OutStr, InStr);
        Clear(InStr);
        Client.Get('https://vgblobstoragepublic.blob.core.windows.net/fornavsetup/cronuslogo_new.pdf', ResponseMessage);
        ResponseMessage.Content.ReadAs(InStr);
        if not ResponseMessage.IsSuccessStatusCode then begin
            ResponseMessage.Content.ReadAs(ErrorResponse);
            error('The web service returned an error message:\Status code: %1\Description: %2', ResponseMessage.HttpStatusCode, ErrorResponse);
        end;
        Setup.Logo.CreateOutStream(OutStr);
        CopyStream(OutStr, InStr);
    end;
    local procedure GetDemoDataCheck(var CheckSetup: Record "ForNAV Check Setup")var Client: HttpClient;
    ResponseMessage: HttpResponseMessage;
    InStr: InStream;
    OutStr: OutStream;
    ErrorResponse: Text;
    begin
        Client.Get('https://vgblobstoragepublic.blob.core.windows.net/fornavsetup/BlueCheckStubStub.pdf', ResponseMessage);
        ResponseMessage.Content.ReadAs(InStr);
        if not ResponseMessage.IsSuccessStatusCode then begin
            ResponseMessage.Content.ReadAs(ErrorResponse);
            error('The web service returned an error message:\Status code: %1\Description: %2', ResponseMessage.HttpStatusCode, ErrorResponse);
        end;
        CheckSetup.Watermark.CreateOutStream(OutStr);
        CopyStream(OutStr, InStr);
        Clear(InStr);
        Client.Get('https://vgblobstoragepublic.blob.core.windows.net/fornavsetup/Signature.png', ResponseMessage);
        ResponseMessage.Content.ReadAs(InStr);
        if not ResponseMessage.IsSuccessStatusCode then begin
            ResponseMessage.Content.ReadAs(ErrorResponse);
            error('The web service returned an error message:\Status code: %1\Description: %2', ResponseMessage.HttpStatusCode, ErrorResponse);
        end;
        CheckSetup.Signature.CreateOutStream(OutStr);
        CopyStream(OutStr, InStr);
        Clear(InStr);
    end;
}
