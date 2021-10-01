codeunit 6189150 "ForNAV Report Service"
{
    SingleInstance = true;

    local procedure GetServiceUrl(): Text var CoreSetup: Record "ForNAV Core Setup";
    redirectUrl: Text;
    httpClient: HttpClient;
    httpResponse: HttpResponseMessage;
    httpContent: HttpContent;
    is: InStream;
    statusCode: Integer;
    o: JsonObject;
    urlToken: JsonToken;
    t: Text;
    retv: Text;
    tmpBlob: Record "ForNAV Core Setup" temporary;
    begin
        if CoreSetup.get then;
        // Version 1....: 'https://fornavredirect.azurewebsites.net/api/redirect?app=reportapp&endpoint=' + UrlEncode(CoreSetup."Service Endpoint ID");
        // Development..: 'https://fornavredirect.azurewebsites.net/api/RedirectDev?app=reportapp&v=2&endpoint=' + UrlEncode(CoreSetup."Service Endpoint ID");
        redirectUrl:='https://fornavredirect.azurewebsites.net/api/redirect2?app=reportapp&v=7&endpoint=' + UrlEncode(CoreSetup."Service Endpoint ID");
        httpClient.Post(redirectUrl, httpContent, httpResponse);
        statusCode:=httpResponse.HttpStatusCode();
        if(statusCode <> 200)then error('Unable to get ForNAV service URL from redirector.');
        tmpBlob.Blob.CreateInStream(is);
        httpResponse.Content.ReadAs(is);
        is.ReadText(t);
        o.ReadFrom(t);
        httpContent.Clear();
        o.Get('url', urlToken);
        retv:=urlToken.AsValue().AsText();
        exit(retv);
    end;
    local procedure UrlEncode(uri: Text): Text var retv: Text;
    b: Char;
    i: Integer;
    AsciiValue: Integer;
    HexDigits: Text;
    begin
        retv:='';
        for i:=1 TO STRLEN(uri)do begin
            b:=uri[i];
            // Simple URL encode (within ( ) without \ / : * ? " < > | )
            // IF (b IN [36,38,40,41,43,44,59,61,64,32,35,37,123,125,94,126,91,93,96]) OR
            // Full URI encode :
            if(b in[36, 38, 43, 44, 47, 58, 59, 61, 63, 64, 32, 34, 60, 62, 35, 37, 123, 125, 124, 92, 94, 126, 91, 93, 96]) or (b >= 128)then begin
                HexDigits:='0123456789ABCDEF';
                retv:=retv + '%  ';
                EVALUATE(AsciiValue, FORMAT(b, 0, '<NUMBER>'));
                retv[STRLEN(retv) - 1]:=HexDigits[(AsciiValue DIV 16) + 1];
                retv[STRLEN(retv)]:=HexDigits[(AsciiValue MOD 16) + 1];
            end
            else
                retv:=retv + COPYSTR(uri, i, 1);
        end;
        exit(retv);
    end;
    local procedure GetResponseError(var httpResponse: HttpResponseMessage): Text var errMsg: BigText;
    p: Integer;
    tempBlob: Record "ForNAV Core Setup";
    tempBlob2: Record "ForNAV Core Setup";
    is: InStream;
    os: OutStream;
    t: Text;
    begin
        tempBlob.Blob.CreateInStream(is);
        tempBlob2.Blob.CreateOutStream(os);
        httpResponse.Content.ReadAs(is);
        CopyStream(os, is);
        tempBlob2.Blob.CreateInStream(is);
        errMsg.Read(is);
        errMsg.GetSubText(t, 1);
        p:=StrPos(t, '$$$');
        if(p > 0) and (StrLen(t) > 6)then begin
            t:=CopyStr(t, p + 3);
            p:=StrPos(t, '$$$');
            if(p > 0)then begin
                t:=CopyStr(t, 1, p - 1);
            end;
        end;
        exit(t);
    end;
    procedure Call(var json: Text;
    var CoreSetup: Record "ForNAV Core Setup")var serviceUrl: Text;
    reportGuid: Text;
    serviceBaseUrl: Text;
    httpClient: HttpClient;
    httpResponse: HttpResponseMessage;
    httpContent: HttpContent;
    is: InStream;
    os: OutStream;
    block: Integer;
    statusCode: Integer;
    readLen: Integer;
    buf2: Char;
    tempBlob: Record "ForNAV Core Setup";
    EnvironmentInformation: Codeunit "Environment Information";
    Info: ModuleInfo;
    ReportServiceRef: RecordRef;
    JsonRef: FieldRef;
    OutputRef: FieldRef;
    SettingsRef: FieldRef;
    begin
        if not EnvironmentInformation.IsSaaSInfrastructure()then begin
            if not NavApp.GetModuleInfo('2c82e6bf-102b-45e1-89b0-904f86fbd0a4', Info)then Error('Please download the ForNAV OnPrem Service app to run the ForNAV Customizable report pack OnPrem')
            else
            begin
                ReportServiceRef.Open(6189150); // "ForNAV Report Service"
                JsonRef:=ReportServiceRef.Field(2); // Json
                CoreSetup.Blob.CreateOutStream(os);
                os.WriteText(json);
                JsonRef.Value:=CoreSetup.Blob;
                SettingsRef:=ReportServiceRef.Field(4); // Settings
                SettingsRef.Value:=CoreSetup."Endpoint Settings";
                ReportServiceRef.Insert(true);
                OutputRef:=ReportServiceRef.Field(3); // Output
                CoreSetup.Blob:=OutputRef.Value;
                ReportServiceRef.Close();
                exit;
            end;
        end;
        httpContent.WriteFrom(json);
        reportGuid:=DelChr(CreateGuid(), '=', '{}-');
        serviceBaseUrl:=GetServiceUrl(); // Set endpoint to LAPTOP-LUVNNAKA to call http://localhost:59769/RunReport.ashx
        // ++++ Add apikey for security
        // ++++ Implement retry logic to handle potential downtime when service is swapping from staging to production. https://docs.microsoft.com/en-us/azure/cloud-services/cloud-services-how-to-manage-portal
        serviceUrl:=serviceBaseUrl + '?t=' + UrlEncode(TenantId()) + '&e=' + UrlEncode(CoreSetup."Service Endpoint ID") + '&s=' + UrlEncode(CoreSetup."Endpoint Settings") + '&r=' + reportGuid;
        tempBlob.Blob.CreateInStream(is);
        CoreSetup.Blob.CreateOutStream(os);
        block:=0;
        httpClient.Timeout:=300000;
        repeat httpClient.Post(serviceUrl + '&b=' + Format(block), httpContent, httpResponse);
            statusCode:=httpResponse.HttpStatusCode();
            if not((statusCode = 200) or (statusCode = 201))then begin
                error('Report service error: ' + GetResponseError(httpResponse));
            end
            else
            begin
                httpResponse.Content.ReadAs(is);
            end;
            if block = 0 then begin
                CopyStream(os, is);
            end
            else
            begin
                while not is.EOS()do begin
                    readLen:=is.Read(buf2);
                    os.Write(buf2, readLen);
                end;
            end;
            block:=block + 1;
            httpContent.Clear();
            httpContent.WriteFrom('');
        until statusCode <> 201;
    end;
}
