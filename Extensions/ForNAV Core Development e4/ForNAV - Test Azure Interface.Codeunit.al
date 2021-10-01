Codeunit 6189401 "ForNAV - Test Azure Interface"
{
    procedure SendFileToAzureBlobContainer(var TempBlob: Codeunit "Temp Blob";
    AzureBlobURL: Text): Boolean var InStr: InStream;
    begin
        TempBlob.CreateInStream(InStr);
        SendFileToAzureBlobContainer(InStr, AzureBlobURL);
    end;
    procedure SendFileToAzureBlobContainer(var InStr: InStream;
    AzureBlobURL: Text): Boolean var Content: HttpContent;
    Headers: HttpHeaders;
    Client: HttpClient;
    ResponseMessage: HttpResponseMessage;
    ResponseText: text;
    begin
        Content.WriteFrom(InStr);
        Content.GetHeaders(Headers);
        Headers.Remove('x-ms-blob-type');
        Headers.Add('x-ms-blob-type', 'BlockBlob');
        if AzureBlobURL.Contains('pdf') or AzureBlobURL.Contains('csv')then Headers.Remove('x-ms-blob-content-type');
        if AzureBlobURL.Contains('pdf')then Headers.Add('x-ms-blob-content-type', 'application/pdf');
        if AzureBlobURL.Contains('csv')then Headers.Add('x-ms-blob-content-type', 'text/csv');
        if not Client.Put(GetAzureURL(AzureBlobURL), Content, ResponseMessage)then begin
            ResponseMessage.Content().ReadAs(ResponseText);
            error('The web service returned an error message:\' + 'Status code: %1' + 'Description: %2', ResponseMessage.HttpStatusCode, ResponseText);
        end;
        exit(true);
    end;
    procedure SimpleSaveReport(ReportID: Integer;
    ReportName: Text;
    RecRef: RecordRef)var TempBlob: Record "ForNAV Core Setup";
    OutStr: OutStream;
    InStr: InStream;
    begin
        TempBlob.Blob.CreateOutstream(OutStr);
        TempBlob.Blob.CreateInStream(InStr);
        Report.SaveAs(ReportID, '', Reportformat::Pdf, OutStr, RecRef);
        SendFileToAzureBlobContainer(InStr, ReportName + '.pdf');
        Report.SaveAs(ReportID, '', Reportformat::Html, OutStr, RecRef);
        SendFileToAzureBlobContainer(InStr, ReportName + '.html');
        Report.SaveAs(ReportID, '', Reportformat::Word, OutStr, RecRef);
        SendFileToAzureBlobContainer(InStr, ReportName + '.docx');
        Report.SaveAs(ReportID, '', Reportformat::Xml, OutStr, RecRef);
        SendFileToAzureBlobContainer(InStr, ReportName + '.xml');
    end;
    procedure SimpleSaveReport(ReportID: Integer;
    ReportName: Text)begin
        SimpleSaveReport(ReportID, ReportName, '');
    end;
    procedure SimpleSaveReport(ReportID: Integer;
    ReportName: Text;
    Parameters: Text)var TempBlob: Record "ForNAV Core Setup";
    OutStr: OutStream;
    InStr: InStream;
    begin
        TempBlob.Blob.CreateOutstream(OutStr);
        TempBlob.Blob.CreateInStream(InStr);
        Report.SaveAs(ReportID, '', Reportformat::Pdf, OutStr);
        SendFileToAzureBlobContainer(InStr, ReportName + '.pdf');
        if StrPos(ReportName.ToLower, 'invoice') = 0 then begin //* Performance issue on large reports
            Report.SaveAs(ReportID, '', Reportformat::Html, OutStr);
            SendFileToAzureBlobContainer(InStr, ReportName + '.html');
            Report.SaveAs(ReportID, '', Reportformat::Word, OutStr);
            SendFileToAzureBlobContainer(InStr, ReportName + '.docx');
        end;
        Report.SaveAs(ReportID, '', Reportformat::Xml, OutStr);
        SendFileToAzureBlobContainer(InStr, ReportName + '.xml');
    end;
    local procedure GetAzureURL(Value: Text): Text var Folder: Text;
    begin
        case true of Value.EndsWith('pdf'): Folder:='pdf/';
        Value.EndsWith('xml'): Folder:='xml/';
        Value.EndsWith('docx'): Folder:='word/';
        Value.EndsWith('html'): Folder:='html/';
        end;
        exit('https://reportpacktest.blob.core.windows.net/automatedtest/' + GetLocalization + Folder + Value + '?sv=2019-02-02&ss=b&srt=sco&sp=rwdlac&se=2025-03-30T17:32:28Z&st=2020-03-30T09:32:28Z&spr=https&sig=JABXfQm233T%2F5maoLg0Dq2D1Eb0DRdaCLQVOlGbK35M%3D')end;
    local procedure GetLocalization(): Text var CompInfo: Record "Company Information";
    begin
        CompInfo.Get;
        if CompInfo."Country/Region Code" = '' then exit('');
        exit(CompInfo."Country/Region Code" + '/');
    end;
}
