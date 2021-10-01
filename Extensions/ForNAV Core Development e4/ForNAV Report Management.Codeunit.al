codeunit 6189100 "ForNAV Report Management"
{
    var jsonInitObject: JsonObject;
    JsonAttributes: Dictionary of[Text, Text];
    ReportSchema: Dictionary of[Text, Text];
    DataItemId: Text;
    Contracts: Dictionary of[text, JsonObject];
    RecIds: Dictionary of[text, RecordId];
    CountryFormat: List of[Text];
    Country: Record "Country/Region";
    MasterReports: List of[Text];
    MasterRecords: Dictionary of[Text, Text];
    Records: Dictionary of[Text, JsonToken];
    LCY: Text;
    WatermarkImage: Text;
    DataItemCopies: Integer;
    DataItemCopiesId: Text;
    DataItemNewPagePerRecord: Boolean;
    DataItemNewPagePerRecordId: Text;
    ReportNumber: Integer;
    ReportLanguage: Integer;
    AppendPdfs: Text;
    PrependPdfs: Text;
    ArchiveDataItemId: Text;
    ArchiveKey: Text;
    SetNewPage: Boolean;
    SetNewPageWithoutTransportTotals: Boolean;
    HasTranslations: Boolean;
    HasForNavSetupTranslation: Boolean;
    procedure ConvertLayout(var TempBlob: Codeunit "Temp Blob"): Boolean var InStr: InStream;
    f, g: File;
    StartAuthorIndex: Integer;
    EndAuthorIndex: Integer;
    Rdl: Text;
    Line: Text;
    BigRdl: Text;
    Len: Integer;
    Base64: Text;
    Base64Convert: Codeunit "Base64 Convert";
    OutStr: OutStream;
    begin
        TempBlob.CreateInStream(InStr);
        InStr.Read(Rdl, 2);
        if Rdl = 'PK' then begin
        // Ok for cloud
        end
        else
        begin
            while InStr.Read(Line) > 0 do Rdl+=Line;
            StartAuthorIndex:=Rdl.IndexOf('<Author>');
            EndAuthorIndex:=Rdl.IndexOf('</Author');
            if Rdl.StartsWith('<?xml') and (StartAuthorIndex > 0) and (EndAuthorIndex > 0)then begin
                StartAuthorIndex+=StrLen('<Author>');
                Base64:=Rdl.Substring(StartAuthorIndex, EndAuthorIndex - StartAuthorIndex);
                if not Base64.StartsWith('UEsD')then exit(false);
                TempBlob.CreateOutStream(OutStr);
                Base64Convert.FromBase64(Base64, OutStr);
            end
            else
                exit(false);
        end;
        exit(true);
    end;
    procedure NewPageWithoutTransportTotals()begin
        SetNewPageWithoutTransportTotals:=true;
    end;
    procedure NewPage()begin
        SetNewPage:=true;
    end;
    procedure WriteDesignPackage(os: OutStream;
    type: Text;
    session: Record "ForNAV Cloud Report Sessions";
    customCode: Text;
    reportNo: Integer)var chr: Char;
    serviceUrl: Text;
    previewUrl: Text;
    webserviceUrl: Text;
    begin
        chr:=13;
        serviceUrl:=GetUrl(CLIENTTYPE::Api, CompanyName, OBJECTTYPE::Page, 6189112);
        previewUrl:=GetUrl(CLIENTTYPE::Current, CompanyName, OBJECTTYPE::Page, 6189100, session);
        webserviceUrl:=GetUrl(CLIENTTYPE::SOAP, CompanyName, OBJECTTYPE::Codeunit, 6189102);
        if webServiceUrl = '' then begin
            CreateWebService;
            webServiceUrl:=GetUrl(CLIENTTYPE::SOAP, CompanyName, OBJECTTYPE::Codeunit, 6189102);
        end;
        os.WriteText('V3');
        os.WriteText(Format(chr, 0, '<CHAR>'));
        // Session ID
        os.WriteText(session."Session ID");
        os.WriteText(Format(chr, 0, '<CHAR>'));
        // Preview layout code
        os.WriteText(session.PreviewLayoutCode);
        os.WriteText(Format(chr, 0, '<CHAR>'));
        // Service URL
        os.WriteText(serviceUrl);
        os.WriteText(Format(chr, 0, '<CHAR>'));
        // Preview URL
        os.WriteText(previewUrl);
        os.WriteText(Format(chr, 0, '<CHAR>'));
        // Seb Service URL
        os.WriteText(webserviceUrl);
        os.WriteText(Format(chr, 0, '<CHAR>'));
        // Custom Layout Code
        os.WriteText(customCode);
        os.WriteText(Format(chr, 0, '<CHAR>'));
        // Report No
        os.WriteText(Format(reportNo, 0, 9));
        os.WriteText(Format(chr, 0, '<CHAR>'));
        // Company Name
        os.WriteText(CompanyName);
        os.WriteText(Format(chr, 0, '<CHAR>'));
        // package type
        os.WriteText(type);
        os.WriteText(Format(chr, 0, '<CHAR>'));
        // Servername
        os.WriteText(Format(chr, 0, '<CHAR>'));
        // Databasename
        os.WriteText(Format(chr, 0, '<CHAR>'));
        // finsql
        os.WriteText(Format(chr, 0, '<CHAR>'));
    end;
    procedure CreateSession(reportNo: Integer;
    var session: Record "ForNAV Cloud Report Sessions")begin
        // Remove old sessions
        session.Init();
        session.SetRange(Created, CreateDateTime(0D, 0T), CreateDateTime(CalcDate('<-2D>'), 0T));
        session.DeleteAll(false);
        // Create new session
        session.Init;
        session."Session ID":=CreateGuid;
        session.Created:=CURRENTDATETIME;
        session."Report ID":=reportNo;
        session.PreviewLayoutCode:=GetUniqueCustomLayoutCode();
        session.Insert;
    end;
    procedure DownloadDesignPackage(packagetype: Text): Boolean var AllObj: Record AllObj;
    packageBlob: Record "ForNAV Core Setup";
    serviceUrl: Text;
    previewUrl: Text;
    webserviceUrl: Text;
    session: Record "ForNAV Cloud Report Sessions";
    os: OutStream;
    tempBlob: Record "ForNAV Core Setup";
    is: InStream;
    downloadStream: InStream;
    chr: Char;
    customCode: Code[20];
    CustomReportLayout: Record "Custom Report Layout";
    fileName: Text;
    begin
        packageBlob.Blob.CreateOutStream(os, TextEncoding::UTF8);
        case packagetype of 'Word': begin
            CreateSession(ReportNumber, session);
            // Remove old preview layouts
            CustomReportLayout.Init();
            CustomReportLayout.SetRange("Last Modified", CreateDateTime(0D, 0T), CreateDateTime(CalcDate('<-2D>'), 0T));
            CustomReportLayout.SetFilter(Description, 'ForNAV BC preview *');
            CustomReportLayout.DeleteAll();
            Commit;
            if GetWordLayout(ReportNumber, tempBlob, customCode)then begin
                WriteDesignPackage(os, 'Word', session, customCode, ReportNumber);
                tempBlob.Blob.CreateInStream(is);
                CopyStream(os, is);
            end
            else
                exit;
        end;
        'New': begin
            AllObj.SetRange(AllObj."Object Type", AllObj."Object Type"::Report);
            AllObj.SetRange(AllObj."Object ID", 56789, 99999);
            ReportNumber:=56789;
            if AllObj.FindFirst then begin
                while ReportNumber = AllObj."Object ID" do begin
                    ReportNumber+=1;
                    AllObj.next();
                    if AllObj."Object ID" = 99999 then error('there is no numbers left in the freerange to create a new report');
                end;
            end;
            CreateSession(ReportNumber, session);
            Commit;
            WriteDesignPackage(os, 'New', session, '', ReportNumber);
        end;
        'DefaultSettings': WriteDesignPackage(os, 'DefaultSettings', session, '', ReportNumber)end;
        packageBlob.Blob.CreateInStream(downloadStream);
        fileName:=FORMAT(ReportNumber) + '.fornavdesign';
        DownloadFromStream(downloadStream, '', '', '', fileName);
    end;
    procedure DownloadDesignNewReportPackage()begin
        DownloadDesignPackage('New');
    end;
    procedure DownloadDesignerDefaultSettings()begin
        DownloadDesignPackage('DefaultSettings');
    end;
    procedure AddSku(var array: JsonArray;
    SkuPartNumber: Text;
    ConsumedUnits: Integer)var jsonObject: jsonObject;
    begin
        jsonObject.Add('SkuPartNumber', SkuPartNumber);
        jsonObject.Add('ConsumedUnits', ConsumedUnits);
        array.Add(jsonObject.AsToken());
    end;
    procedure LicenceInformation(): Text var jsonObject: jsonObject;
    result: text;
    array: JsonArray;
    tenantMgmt: Codeunit "Azure AD Tenant";
    tenantInfo: Codeunit "Tenant Information";
    aadLicenses: Codeunit "Azure AD Licensing";
    begin
        jsonObject.Add('BcTenantId', tenantInfo.GetTenantId());
        jsonObject.Add('AadTenantId', tenantMgmt.GetAadTenantId());
        if(tenantMgmt.GetAadTenantId() <> 'common')then begin
            jsonObject.Add('AadTenantDomain', tenantMgmt.GetAadTenantDomainName());
            aadLicenses.ResetSubscribedSKU();
            while(aadLicenses.NextSubscribedSKU())do begin
                AddSku(array, aadLicenses.SubscribedSKUPartNumber(), aadLicenses.SubscribedSKUConsumedUnits());
            end;
        end;
        jsonObject.Add('Skus', array);
        jsonObject.WriteTo(result);
        exit(result);
    end;
    local procedure AddRecId(var recName: Text;
    recId: RecordId): Boolean begin
        if RecIds.ContainsKey(recName)then begin
            RecIds.Set(recName, recId);
            exit(false);
        end
        else
        begin
            RecIds.Add(recName, recId);
            exit(true);
        end;
    end;
    local procedure GetRecRef(recordName: Text;
    var recRef: RecordRef)var recordToken: JsonToken;
    tableNoToken: JsonToken;
    tableNo: Integer;
    recId: RecordId;
    begin
        if not Records.ContainsKey(recordName)then Error('Table %1 does not exist');
        Records.Get(recordName, recordToken);
        recordToken.AsObject().Get('No', tableNoToken);
        tableNo:=tableNoToken.AsValue().AsInteger();
        recRef.Open(tableNo);
        if RecIds.ContainsKey(recordName)then begin
            RecIds.Get(recordName, recId);
            if not recRef.Get(recId)then RecIds.Remove(recordName);
        end;
    end;
    procedure Encode(value: Text): Text begin
        exit(value.Replace('\', '\\').Replace('"', '\"'));
    end;
    procedure SetAppendPdf(dataItemId: Text;
    stream: InStream)var tempBlob: Record "ForNAV Core Setup";
    oStream: OutStream;
    begin
        tempBlob.Blob.CREATEOUTSTREAM(oStream);
        CopyStream(oStream, stream);
        AppendPdfs+=dataItemId + '$' + tempBlob.ToBase64String() + ',';
    end;
    procedure SetPrependPdf(dataItemId: Text;
    stream: InStream)var tempBlob: Record "ForNAV Core Setup";
    oStream: OutStream;
    begin
        tempBlob.Blob.CREATEOUTSTREAM(oStream);
        CopyStream(oStream, stream);
        PrependPdfs+=dataItemId + '$' + tempBlob.ToBase64String() + ',';
    end;
    procedure SetCopies(dataItemId: Text;
    copies: integer)begin
        DataItemCopiesId:=dataItemId;
        DataItemCopies:=copies;
    end;
    procedure SetNewPagePerRecord(dataItemId: Text;
    newPagePerRecord: Boolean)begin
        DataItemNewPagePerRecordId:=dataItemId;
        DataItemNewPagePerRecord:=newPagePerRecord;
    end;
    procedure LoadWatermarkImage(WatermarkImageBase64: Text)begin
        WatermarkImage:=WatermarkImageBase64;
    end;
    procedure AddTotal(var globalJsonObject: JsonObject;
    name: Text;
    value: Variant)var decimalValue: Decimal;
    begin
        if value.IsDecimal then begin
            decimalValue:=value;
            globalJsonObject.Add(name + '$Total$Decimal', decimalValue);
        end end;
    local procedure AddSchemaColumn(var globalJsonObject: JsonObject;
    prefix: Text;
    name: Text;
    datatype: Text;
    isRecord: Boolean)begin
        if isRecord then name:=prefix + name;
        if not ReportSchema.ContainsKey(prefix + '£' + name)then begin
            ReportSchema.Add(prefix + '£' + name, datatype);
            globalJsonObject.Add(name + '$Type$Text', datatype);
        end;
    end;
    local procedure AddDecimalFormatterSchemaColumn(var globalJsonObject: JsonObject;
    name: Text;
    decimalFormatter: Text)var dataType: Text;
    begin
        dataType:='Decimal' + decimalFormatter;
        if not ReportSchema.ContainsKey('£' + name)then begin
            ReportSchema.Add('£' + name, dataType);
            globalJsonObject.Add(name + '$Type', datatype);
        end;
    end;
    local procedure LocalCurrency(FieldType: Integer): Text var RecRef: RecordRef;
    FieldNo: Integer;
    begin
        if LCY = '' then begin
            RecRef.Open(98); // GL setup
            RecRef.AddLoadFields(71);
            RecRef.FindFirst();
            case FieldType of -2: FieldNo:=71;
            -3: FieldNo:=162;
            -4: FieldNo:=163;
            end;
            LCY:=Format(RecRef.Field(FieldNo).Value()); // LCY
        end;
        exit(LCY)end;
    local procedure GetCustomAddressLineFormatJson(var CustomAddressFormatLine: Record "Custom Address Format Line";
    var CompanyInformationLineFields: JsonArray)var CompanyInformationLineField: JsonObject;
    begin
        CompanyInformationLineField.Add('FieldNo', CustomAddressFormatLine."Field ID");
        CompanyInformationLineField.Add('Separator', CustomAddressFormatLine."Separator");
        CompanyInformationLineFields.Add(CompanyInformationLineField);
    end;
    local procedure GetCustomAddressLineFormatJson(var CustomAddressFormat: Record "Custom Address Format";
    var CompanyInformationField: JsonObject)var CustomAddressFormatLine: Record "Custom Address Format Line";
    CompanyInformationLineFields: JsonArray;
    begin
        CustomAddressFormatLine.SetCurrentKey("Country/Region Code", "Line No.", "Field Position");
        CustomAddressFormatLine.SetRange("Country/Region Code", CustomAddressFormat."Country/Region Code");
        CustomAddressFormatLine.SetRange("Line No.", CustomAddressFormat."Line No.");
        if CustomAddressFormatLine.FindFirst()then repeat GetCustomAddressLineFormatJson(CustomAddressFormatLine, CompanyInformationLineFields);
            until CustomAddressFormatLine.Next() <> 1;
        CompanyInformationField.Add('LineFormat', CompanyInformationLineFields)end;
    local procedure GetCustomAddressFormatJson(CustomAddressFormat: Record "Custom Address Format";
    var CompanyInformationFields: JsonArray)var CompanyInformationField: JsonObject;
    begin
        CompanyInformationField.Add('FieldNo', CustomAddressFormat."Field ID");
        if CustomAddressFormat."Field ID" = 0 then GetCustomAddressLineFormatJson(CustomAddressFormat, CompanyInformationField);
        CompanyInformationFields.Add(CompanyInformationField);
    end;
    local procedure GetCustomAddressFormatJson(var CountryCode: Code[10]): text var CustomAddressFormat: Record "Custom Address Format";
    CompanyInformationFields: JsonArray;
    CompanyInformationFieldsJson: Text;
    begin
        CustomAddressFormat.SetCurrentKey("Country/Region Code", "Line Position");
        CustomAddressFormat.SetRange("Country/Region Code", CountryCode);
        if CustomAddressFormat.FindFirst()then repeat GetCustomAddressFormatJson(CustomAddressFormat, CompanyInformationFields);
            until CustomAddressFormat.Next() <> 1;
        CompanyInformationFields.WriteTo(CompanyInformationFieldsJson);
        exit(CompanyInformationFieldsJson);
    end;
    local procedure AddCountryFormat(var globalJsonObject: JsonObject;
    countryCode: Text)var AddressFormat: Integer;
    ContactAddressFormat: Integer;
    CountryName: Text;
    GLSetup: Record "General Ledger Setup";
    encodedCountryCode: Text;
    i: Integer;
    charAsUint: Integer;
    charAsUintText: Text;
    customAddressFormatJson: Text;
    begin
        if not CountryFormat.Contains(countryCode)then begin
            if(countryCode = '') or (not Country.Get(countryCode))then begin
                GLSetup.GET;
                ContactAddressFormat:=GLSetup."Local Cont. Addr. Format";
                AddressFormat:=GLSetup."Local Address Format";
                CountryName:=countryCode;
            end
            else
            begin
                ContactAddressFormat:=Country."Contact Address Format";
                AddressFormat:=Country."Address Format";
                CountryName:=Country.Name;
                if Country."Address Format" = Country."Address Format"::Custom then customAddressFormatJson:=GetCustomAddressFormatJson(Country.Code);
            end;
            CountryFormat.Add(countryCode);
            for i:=1 to StrLen(countryCode)do begin
                if((CountryCode[i] >= 'A') and (CountryCode[i] >= 'Z')) or ((CountryCode[i] >= 'a') and (CountryCode[i] >= 'z')) or ((CountryCode[i] >= '0') and (CountryCode[i] >= '9'))then encodedCountryCode:=encodedCountryCode + CountryCode[i]
                else
                begin
                    charAsUint:=CountryCode[i];
                    charAsUintText:=Format(charAsUint, 0, '<Standard Format,2>');
                    encodedCountryCode:=encodedCountryCode + '$' + PadStr('', 5 - StrLen(charAsUintText), '0') + charAsUintText;
                end;
            end;
            globalJsonObject.Add('CountryFormat$' + encodedCountryCode + '$Text', StrSubstNo('%1£%2£%3£%4', AddressFormat, ContactAddressFormat, CountryName, customAddressFormatJson));
        end;
    end;
    procedure AddMasterReport(var globalJsonObject: JsonObject;
    var name: Text;
    definition: Text;
    contract: Text)var i: Integer;
    validName: Text;
    c: Char;
    begin
        if not MasterReports.Contains(name)then begin
            MasterReports.Add(name);
            for i:=1 to StrLen(name)do if((name[i] >= 'a') and (name[i] <= 'z')) or ((name[i] >= 'A') and (name[i] <= 'Z')) or ((name[i] >= '0') and (name[i] <= '9'))then validName+=name[i];
            globalJsonObject.Add('MasterReport$' + validName + '$Text', definition)end;
    end;
    procedure AddValue(var jsonFieldObject: JsonObject;
    fieldRef: FieldRef;
    name: Text)var integerValue: Integer;
    decimalValue: Decimal;
    booleanValue: Boolean;
    dateValue: Date;
    timeValue: Time;
    dateTimeValue: DateTime;
    blobValue: Record "ForNAV Core Setup";
    optionValue: Integer;
    mediaRec: Record "Tenant Media";
    mediasetRec: Record "Tenant Media Set";
    guid: Guid;
    oStream: OutStream;
    begin
        case fieldRef.Type()of FieldType::Integer: begin
            integerValue:=fieldRef.Value;
            name+='$Integer';
            if not jsonFieldObject.Contains(name)then jsonFieldObject.Add(name, integerValue);
        end;
        FieldType::Decimal: begin
            decimalValue:=fieldRef.Value;
            name+='$Decimal';
            if not jsonFieldObject.Contains(name)then jsonFieldObject.Add(name, decimalValue);
        end;
        FieldType::Boolean: begin
            booleanValue:=fieldRef.Value;
            name+='$Boolean';
            if not jsonFieldObject.Contains(name)then jsonFieldObject.Add(name, booleanValue);
        end;
        FieldType::Date: begin
            dateValue:=fieldRef.Value;
            name+='$Date';
            if not jsonFieldObject.Contains(name)then jsonFieldObject.Add(name, dateValue);
        end;
        FieldType::Time: begin
            timeValue:=fieldRef.Value;
            name+='$Time';
            if not jsonFieldObject.Contains(name)then jsonFieldObject.Add(name, timeValue);
        end;
        FieldType::DateTime: begin
            dateTimeValue:=fieldRef.Value;
            name+='$DateTime';
            if not jsonFieldObject.Contains(name)then jsonFieldObject.Add(name, dateTimeValue);
        end;
        FieldType::Blob, FieldType::Media, FieldType::MediaSet: begin
            if fieldRef.Type() = FieldType::Blob then blobValue.Blob:=fieldRef.Value
            else if fieldRef.Type() = FieldType::Media then begin
                    guid:=fieldRef.Value;
                    if mediaRec.GET(guid)then blobValue.Blob:=mediaRec.Content;
                end
                else
                begin // Mediaset
                    guid:=fieldRef.Value;
                    mediasetRec.SETRANGE(mediasetRec.ID, guid);
                    if mediasetRec.FINDFIRST then begin
                        blobValue.Blob.CREATEOUTSTREAM(oStream);
                        mediasetRec."Media ID".EXPORTSTREAM(oStream);
                    end;
                end;
            name+='$Text';
            if not jsonFieldObject.Contains(name)then if blobValue.Blob.HasValue()then jsonFieldObject.Add(name, blobValue.ToBase64String())
                else
                    jsonFieldObject.Add(name, '');
        end;
        else
        begin
            if fieldRef.Type() = FieldType::Option then begin
                if not jsonFieldObject.Contains(name + '$Option$Integer')then begin
                    optionValue:=fieldRef.Value;
                    jsonFieldObject.Add(name + '$Option$Integer', optionValue);
                    jsonFieldObject.Add(name + '$OptionString$Text', fieldRef.OptionMembers());
                    jsonFieldObject.Add(name + '$OptionCaption$Text', fieldRef.OptionCaption());
                end;
            end;
            name+='$Text';
            if not jsonFieldObject.Contains(name)then jsonFieldObject.Add(name, format(fieldRef.Value));
        end;
        end;
    end;
    procedure AddReferences(contract: JsonObject;
    recRef: RecordRef)var fieldsToken: JsonToken;
    fieldToken: JsonToken;
    fieldNo: Integer;
    fieldName: Text;
    begin
        if contract.Get('Fields', fieldsToken)then begin
            foreach fieldName in fieldsToken.AsObject().Keys()do begin
                fieldsToken.AsObject().Get(fieldName, fieldToken);
                fieldNo:=fieldToken.AsValue().AsInteger();
                if recRef.FieldExist(fieldNo)then if recRef.Field(fieldNo).Class = FieldClass::Normal then recRef.AddLoadFields(fieldNo);
            end;
        end;
    end;
    procedure AddDataItemReferences(dataItemId: text;
    recRef: RecordRef)var dataItemContract: JsonObject;
    keyName: Text;
    begin
        if Contracts.ContainsKey(dataItemId)then begin
            dataItemContract:=Contracts.Get(dataItemId);
            AddReferences(dataItemContract, recRef);
            foreach keyName in MasterReports do begin
                if Contracts.ContainsKey(keyName + '$' + dataItemId)then begin
                    dataItemContract:=Contracts.Get(keyName + '$' + dataItemId);
                    AddReferences(dataItemContract, recRef);
                end;
            end;
        end
        else
            Error('The dataitem %1 does not exist - please contact your partner', dataItemId)end;
    procedure AddRecordReferences(recordName: text;
    contract: JsonObject;
    recRef: RecordRef)var keyName: Text;
    masterReportRecordToken: JsonToken;
    begin
        AddReferences(contract, recRef);
        foreach keyName in MasterReports do begin
            if Records.ContainsKey(keyName + '$' + recordName)then begin
                Records.Get(keyName + '$' + recordName, masterReportRecordToken);
                AddReferences(masterReportRecordToken.AsObject(), recRef);
            end;
        end;
    end;
    procedure AddDataItemValues(var jsonFieldObject: JsonObject;
    dataItemId: text;
    rec: Variant)var recRef: RecordRef;
    dataItemContract: JsonObject;
    keyName: Text;
    languageToken: JsonToken;
    AllObjWithCaption: Record AllObjWithCaption;
    RecordName: Text;
    begin
        if jsonFieldObject.Contains('CurrReport$Language$Integer')then begin
            jsonFieldObject.Get('CurrReport$Language$Integer', languageToken);
            if ReportLanguage <> languageToken.AsValue().AsInteger()then begin
                ReportLanguage:=languageToken.AsValue().AsInteger();
                AllObjWithCaption.Get(AllObjWithCaption."Object Type"::Report, ReportNumber);
                jsonFieldObject.Add('CurrReport$Caption$Text', GetReportCaption(AllObjWithCaption, ReportLanguage, ReportNumber));
                AddCaptions(jsonFieldObject);
            end;
        end;
        if SetNewPageWithoutTransportTotals then begin
            jsonFieldObject.Add('DataItem$$NewPageWithoutTransportTotals$Boolean', true);
            SetNewPageWithoutTransportTotals:=false;
        end;
        if SetNewPage then begin
            jsonFieldObject.Add('DataItem$$NewPage$Boolean', true);
            SetNewPage:=false;
        end;
        if Contracts.ContainsKey(dataItemId)then begin
            recRef.GetTable(rec);
            if(ArchiveDataItemId = '') or (ArchiveDataItemId = dataItemId)then begin
                ArchiveDataItemId:=dataItemId;
                if not jsonFieldObject.Contains('CurrReport$ArchiveKey$Text')then jsonFieldObject.Add('CurrReport$ArchiveKey$Text', Format(recRef.RecordId))
                else
                    jsonFieldObject.Replace('CurrReport$ArchiveKey$Text', 'buh');
            end;
            AddRecId(dataItemId, recRef.RecordId);
            dataItemContract:=Contracts.Get(dataItemId);
            AddValues(jsonFieldObject, dataItemId, recRef, dataItemContract, false);
            foreach keyName in MasterReports do begin
                if Contracts.ContainsKey(keyName + '$' + dataItemId)then begin
                    dataItemContract:=Contracts.Get(keyName + '$' + dataItemId);
                    AddValues(jsonFieldObject, dataItemId, recRef, dataItemContract, false);
                end;
            end;
        end;
    end;
    procedure AddAdditionalValues(var jsonFieldObject: JsonObject;
    dataItemId: text;
    rec: Variant)var recRef: RecordRef;
    dataItemContract: JsonObject;
    keyName: Text;
    begin
        if Contracts.ContainsKey(dataItemId)then begin
            recRef.GetTable(rec);
            AddRecId(dataItemId, recRef.RecordId);
            dataItemContract:=Contracts.Get(dataItemId);
            AddValues(jsonFieldObject, dataItemId, recRef, dataItemContract, true);
            foreach keyName in MasterReports do begin
                if Contracts.ContainsKey(keyName + '$' + dataItemId)then begin
                    dataItemContract:=Contracts.Get(keyName + '$' + dataItemId);
                    AddValues(jsonFieldObject, dataItemId, recRef, dataItemContract, true);
                end;
            end;
        end;
    end;
    procedure AddTranslations(var jsonObject: JsonObject;
    translations: JsonArray)var translationToken: JsonToken;
    forNavTranslations: Codeunit "ForNAV Language Mgt.";
    translation: Text;
    translationKey: text;
    begin
        if HasTranslations then begin
            foreach translationToken in translations do begin
                translation:=forNavTranslations.GetTranslation(ReportLanguage, translationToken.AsValue().AsText());
                if translation <> '' then begin
                    translationKey:='Translation$' + Format(ReportLanguage) + '$' + translationToken.AsValue().AsText() + '$Text';
                    if not jsonObject.Contains(translationKey)then jsonObject.Add(translationKey, translation)end;
            end;
        end;
    end;
    procedure GetName(var recName: Text;
    fieldName: Text;
    isRecord: Boolean): Text begin
        if isRecord then exit(recName + '$' + fieldName)
        else
            exit('$' + fieldName);
    end;
    procedure GetLookupTranslation(tableNo: Integer;
    code: Variant): Text;
    var translationRecRef: RecordRef;
    Language: Codeunit Language;
    i: Integer;
    lcid: Integer;
    begin
        case tableNo of 3: tableNo:=462; // Payment terms
        9: tableNo:=11; // Country/Region
        10: tableNo:=463; // Shipment terms
        27: tableNo:=30; // Item
        204: tableNo:=5402; // Unit of measure
        289: tableNo:=466; // Payment Method
        292: tableNo:=1052; // Reminder terms
        318: tableNo:=316; // Tax Area
        320: tableNo:=327; // Tax Jurestiction
        348: tableNo:=388; // Dimensions
        560: tableNo:=561; // VAT Clause
        7500: tableNo:=7502; // Item Attribute
        7501: tableNo:=7503; // Item Attribute Value
        else
            exit('');
        end;
        translationRecRef.Open(tableNo);
        translationRecRef.Field(1).SetRange(code);
        translationRecRef.AddLoadFields(3);
        lcid:=ReportLanguage;
        for i:=1 to 2 do begin
            case translationRecRef.Field(2).Type of FieldType::Integer: translationRecRef.Field(2).SetRange(lcid);
            FieldType::Code: translationRecRef.Field(2).SetRange(Language.GetLanguageCode(lcid));
            else
                error('Error in translation lookup for %1 - invalid key field %2', translationRecRef.Name, translationRecRef.Field(2).Type);
            end;
            if translationRecRef.FindFirst()then exit(translationRecRef.Field(3).Value);
            lcid:=language.GetParentLanguageId(ReportLanguage);
            if lcid = ReportLanguage then exit('');
        end;
        exit('');
    end;
    local procedure AddForNavSetupTranslations(var jsonFieldObject: JsonObject;
    fieldno: Integer;
    var RecName: Text;
    var RecRef: RecordRef;
    fieldname: Text;
    IsRecord: Boolean)var language: Record Language;
    translationRef: RecordRef;
    fieldref: FieldRef;
    jsonName: Text;
    begin
        RecRef.AddLoadFields(fieldno);
        fieldRef:=RecRef.Field(fieldno);
        if fieldNo = 80 then translationRef.Open(6188472) // Legal condition translation
        else
            translationRef.Open(6188476); // Payment note translation
        language.SetRange(language."Windows Language ID", ReportLanguage);
        if(translationRef.Count > 0) and language.FindFirst()then begin
            HasForNavSetupTranslation:=true;
            translationRef.Field(2).SetRange(language.Code);
            translationRef.AddLoadFields(80);
            if translationRef.FindFirst()then fieldRef:=translationRef.Field(80)end;
        jsonName:=GetName(RecName, fieldName, IsRecord);
        if jsonFieldObject.Contains(jsonName + '$Text')then jsonFieldObject.Remove(jsonName + '$Text');
        AddValue(jsonFieldObject, fieldRef, jsonName);
        translationRef.Close();
    end;
    procedure AddValues(var jsonFieldObject: JsonObject;
    recName: Text;
    var recRef: RecordRef;
    contract: JsonObject;
    isRecord: Boolean)var contractType: Text;
    fieldRef: FieldRef;
    fieldsToken: JsonToken;
    fieldToken: JsonToken;
    fieldName: Text;
    fieldNo: Integer;
    tableNoToken: JsonToken;
    fieldNoToken: JsonToken;
    lookupNoToken: JsonToken;
    value: Variant;
    calcFieldToken: JsonToken;
    getFilterToken: JsonToken;
    lookupName: Text;
    lookupRecRef: RecordRef;
    fieldCaptionName: Text;
    fieldsUsed: Dictionary of[Integer, Text];
    lookupTableNo: Integer;
    lookupTranslation: Text;
    begin
        foreach contractType in contract.Keys()do begin
            contract.Get(contractType, fieldsToken);
            case contractType of 'FieldCaptions': if RecRef.Number = 6188677 then begin //  Database::"ForNAV Trial Balance"
                    foreach fieldName in fieldsToken.AsObject().Keys()do begin
                        fieldsToken.AsObject().Get(fieldName, fieldToken);
                        fieldNo:=fieldToken.AsValue().AsInteger();
                        if recRef.FieldExist(fieldNo)then begin
                            fieldRef:=recRef.Field(fieldNo);
                            fieldCaptionName:=recName + '$FieldCaptions$' + fieldName + '$Text';
                            if jsonFieldObject.Contains(fieldCaptionName)then jsonFieldObject.Replace(fieldCaptionName, GetFieldCaption(recRef, fieldRef))
                            else
                                jsonFieldObject.Add(fieldCaptionName, GetFieldCaption(recRef, fieldRef));
                        end;
                    end;
                end;
            'Fields': begin
                foreach fieldName in fieldsToken.AsObject().Keys()do begin
                    fieldsToken.AsObject().Get(fieldName, fieldToken);
                    fieldNo:=fieldToken.AsValue().AsInteger();
                    if not fieldsUsed.ContainsKey(fieldNo)then fieldsUsed.Add(fieldNo, fieldName);
                    if recRef.FieldExist(fieldNo)then begin
                        fieldRef:=recRef.Field(fieldNo);
                        if(recRef.Number() = 6188471) and ((fieldNo = 70) or (fieldNo = 80))then AddForNavSetupTranslations(jsonFieldObject, fieldNo, recName, recRef, fieldName, isRecord)
                        else
                        begin
                            if fieldRef.Relation() = 9 then // Country/Region
 AddCountryFormat(jsonFieldObject, Format(fieldRef.Value));
                            if(fieldRef.Type() = FieldType::Date) or (fieldRef.Type() = FieldType::Time) or (fieldRef.Type() = FieldType::Option)then AddSchemaColumn(jsonFieldObject, RecName, '$' + fieldName, format(fieldRef.Type()), isRecord)
                            else if(fieldRef.Type() = FieldType::Blob) or (fieldRef.Type() = FieldType::Media) or (fieldRef.Type() = FieldType::MediaSet)then AddSchemaColumn(jsonFieldObject, RecName, '$' + fieldName, 'BLOB', isRecord);
                            AddValue(jsonFieldObject, fieldRef, GetName(RecName, fieldName, IsRecord));
                        end;
                    end;
                end;
            end;
            'FieldLookups': begin
                foreach fieldName in fieldsToken.AsObject().Keys()do begin
                    fieldsToken.AsObject().Get(fieldName, fieldToken);
                    fieldToken.AsObject().Get('TableNo', tableNoToken);
                    fieldToken.AsObject().Get('FieldNo', fieldNoToken);
                    fieldToken.AsObject().Get('LookupNo', lookupNoToken);
                    if recRef.FieldExist(fieldNoToken.AsValue().AsInteger())then begin
                        fieldRef:=recRef.Field(fieldNoToken.AsValue().AsInteger());
                        value:=fieldRef.Value();
                        lookupTableNo:=tableNoToken.AsValue().AsInteger();
                        lookupRecRef.Open(lookupTableNo);
                        if IsRecord then lookupName:=RecName + '$FieldLookups$' + fieldName
                        else
                            lookupName:='$FieldLookups$' + fieldName;
                        case lookupNoToken.AsValue().AsInteger()of -1: // Table Caption
 if not jsonFieldObject.Contains(lookupName + '$Text')then jsonFieldObject.Add(lookupName + '$Text', GetTableCaption(lookuprecRef));
                        -2, -3, -4: // CurrencyCode
 if Format(value) = '' then begin
                                if not jsonFieldObject.Contains(lookupName + '$Text')then jsonFieldObject.Add(lookupName + '$Text', LocalCurrency(lookupNoToken.AsValue().AsInteger()))end
                            else
                                AddValue(jsonFieldObject, fieldRef, lookupName)
                        else
                        begin
                            lookupTranslation:=GetLookupTranslation(lookupTableNo, value);
                            if lookupTranslation = '' then begin
                                fieldRef:=lookupRecRef.KeyIndex(1).FieldIndex(1);
                                fieldRef.SetRange(value);
                                lookupRecRef.AddLoadFields(lookupNoToken.AsValue().AsInteger());
                                if lookupRecRef.FindFirst()then;
                                fieldRef:=lookupRecRef.Field(lookupNoToken.AsValue().AsInteger());
                                if(fieldRef.Type() = FieldType::Date) or (fieldRef.Type() = FieldType::Time)then AddSchemaColumn(jsonFieldObject, '', recName + '$FieldLookups$' + fieldName, format(fieldRef.Type()), false);
                                AddValue(jsonFieldObject, fieldRef, lookupName);
                            end
                            else
                            begin
                                if not jsonFieldObject.Contains(lookupName + '$Text')then jsonFieldObject.Add(lookupName + '$Text', lookupTranslation);
                            end;
                        end;
                        end;
                        lookupRecRef.Close();
                    end;
                end;
            end;
            'CalcFields', 'AutoCalcFields': begin
                foreach calcFieldToken in fieldsToken.AsArray()do begin
                    if recRef.FieldExist(calcFieldToken.AsValue().AsInteger())then begin
                        fieldRef:=recRef.Field(calcFieldToken.AsValue().AsInteger());
                        fieldRef.CalcField();
                        if(contractType <> 'AutoCalcFields') and fieldsUsed.Get(fieldRef.Number(), fieldName)then // Mark
 AddValue(jsonFieldObject, fieldRef, GetName(recName, fieldName, IsRecord) + '$Calculated');
                    end;
                end;
            end;
            'GetCalls': GetRecords(jsonFieldObject, recName, recRef, fieldsToken.AsArray());
            'Translations': AddTranslations(jsonFieldObject, fieldsToken.AsArray());
            'Children': GetChildren(jsonFieldObject, fieldsToken.AsArray(), recRef, false);
            end;
        end;
    end;
    procedure AddCurrReportValues(var jsonFieldObject: JsonObject)var propName: Text;
    currReportObject: JsonObject;
    propToken: JsonToken;
    begin
        if Contracts.ContainsKey('CurrReport')then begin
            Contracts.Get('CurrReport', currReportObject);
            foreach propName in currReportObject.Keys()do begin
                currReportObject.Get(propName, propToken);
            end;
        end;
    end;
    procedure PagePlaceHolder(): Text begin
        exit('<ReportsForNavPageNo>');
    end;
    local procedure CreateDataSet(var JsonBuilder: TextBuilder;
    var globalJsonObject: JsonObject;
    xmlNode: XmlElement)var i: Integer;
    children: XmlNodeList;
    child: XmlNode;
    xmlAttribute: XmlAttribute;
    reportName: Text;
    begin
        AddCurrReportValues(globalJsonObject);
        children:=xmlNode.GetChildElements();
        for i:=1 to children.Count do begin
            children.Get(i, child);
            //            if (child.IsXmlElement) then begin
            case(child.AsXmlElement().Name)of 'DataItem': begin
                if(DataItemId <> '')then AppendJsonObject(JsonBuilder, globalJsonObject);
                child.AsXmlElement.Attributes.Get('name', '', xmlAttribute);
                DataItemId:=xmlAttribute.Value.Replace('_', '');
                CreateDataSet(JsonBuilder, globalJsonObject, child.AsXmlElement);
                AppendJsonObject(JsonBuilder, globalJsonObject);
            end;
            'Columns', 'DataItems': CreateDataSet(JsonBuilder, globalJsonObject, child.AsXmlElement);
            'Column': begin
                AddJson(globalJsonObject, child.AsXmlElement);
            end;
            end;
        //end;
        end;
    end;
    local procedure AddJsonObject(var globalJsonObject: JsonObject;
    var name: Text;
    var value: text;
    datatype: enum ForNav_DataType)var decimalValue: Decimal;
    integerValue: Integer;
    dateTimeValue: DateTime;
    begin
        if globalJsonObject.Contains(name)then exit;
        case(datatype)of ForNav_DataType::tDecimal: begin
            Evaluate(decimalValue, value, 9);
            globalJsonObject.Add(name, decimalValue);
        end;
        ForNav_DataType::tText, ForNav_DataType::tDate, ForNav_DataType::tTime: globalJsonObject.Add(name, value);
        ForNav_DataType::tBoolean: if(value = 'True') or (value = 'true')then globalJsonObject.Add(name, true)
            else
                globalJsonObject.Add(name, false);
        ForNav_DataType::tInteger: begin
            Evaluate(integerValue, value, 9);
            globalJsonObject.Add(name, integerValue);
        end;
        ForNav_DataType::tDateTime: begin
            Evaluate(dateTimeValue, value, 9);
            globalJsonObject.Add(name, dateTimeValue);
        end;
        end end;
    local procedure AddJsonAttribute(var globalJsonObject: JsonObject;
    name: Text;
    value: text;
    datatype: enum ForNav_DataType)var valueName: Text;
    begin
        if name[1] = '$' then valueName:=DataItemId + name
        else
            valueName:=name;
        if JsonAttributes.ContainsKey(valueName)then begin
            if JsonAttributes.Get(valueName) <> value then AddJsonObject(globalJsonObject, name, value, datatype)
            else if(datatype = ForNav_DataType::tDecimal) and (value <> '0')then AddJsonObject(globalJsonObject, name, value, datatype);
        end
        else
        begin
            AddJsonObject(globalJsonObject, name, value, datatype);
        end;
        if(name <> 'DataItem$$Children') and (name <> 'DataItem$$Sieblings')then JsonAttributes.Set(valueName, value)end;
    local procedure AddDataItemJson(var globalJsonObject: JsonObject;
    value: Text)var dataItemObject: JsonObject;
    begin
        dataItemObject.ReadFrom(value);
        AddDataItemJson(globalJsonObject, dataItemObject);
    end;
    local procedure AddDataItemJson(var globalJsonObject: JsonObject;
    dataItemObject: JsonObject)var propKey: Text;
    propToken: JsonToken;
    index: Integer;
    datatype: enum ForNav_DataType;
    name: Text;
    dateValue: Date;
    timeValue: Time;
    value: Text;
    begin
        propToken:=dataItemObject.AsToken();
        //        propToken.ReadFrom(value);
        foreach propKey in dataItemObject.Keys()do begin
            index:=propKey.LastIndexOf('$');
            case(propKey.Substring(index + 1))of 'Boolean': dataType:=ForNav_DataType::tBoolean;
            'Integer': dataType:=ForNav_DataType::tInteger;
            'Decimal': dataType:=ForNav_DataType::tDecimal;
            'Date': dataType:=ForNav_DataType::tDate;
            'Time': dataType:=ForNav_DataType::tTime;
            'DateTime': dataType:=ForNav_DataType::tDateTime;
            'Text': dataType:=ForNav_DataType::tText;
            'Pre': dataType:=ForNav_DataType::tPre;
            'Post': dataType:=ForNav_DataType::tPost;
            else
                Error('ReportsForNav: Failed to evaluate name %1 value %2', propKey, value);
            end;
            if(datatype = ForNav_DataType::tPost) or (datatype = ForNav_DataType::tPre)then begin
                name:=propKey;
                datatype:=ForNav_DataType::tBoolean;
            end
            else
                name:=propKey.Substring(1, index - 1);
            dataItemObject.Get(propKey, propToken);
            value:=Format(propToken.AsValue().AsText());
            AddJsonAttribute(globalJsonObject, name, value, datatype);
        end;
    end;
    local procedure AddJson(var globalJsonObject: JsonObject;
    xmlElement: XmlElement)var xmlAttribute: XmlAttribute;
    name: Text;
    value: Text;
    datatype: enum ForNav_DataType;
    decimalValue: Decimal;
    begin
        xmlElement.Attributes.Get('name', '', xmlAttribute);
        name:=xmlAttribute.Value;
        value:=xmlElement.InnerText();
        //        if name.StartsWith('ReportForNav_') then
        //            if DataItemId.StartsWith(name.Substring(StrLen('ReportForNav_') + 1).Replace('_', '')) then
        //                DataItemId := name.Substring(StrLen('ReportForNav_') + 1);
        //        if name = 'ReportForNav_' + DataItemId then begin
        if name.StartsWith('ReportForNav_') and value.StartsWith('{')then begin
            DataItemId:=name.Substring(StrLen('ReportForNav_') + 1);
            AddDataItemJson(globalJsonObject, value)end
        else
        begin
            if(xmlElement.Attributes.Get('decimalformatter', '', xmlAttribute))then begin
                datatype:=ForNav_DataType::tDecimal;
                AddDecimalFormatterSchemaColumn(globalJsonObject, name, xmlAttribute.Value);
            end
            else if(value = 'True') or (value = 'False')then begin
                    datatype:=ForNav_DataType::tBoolean;
                end
                else if value.EndsWith(' 12:00:00 AM')then begin
                        datatype:=ForNav_DataType::tDate;
                        value:=value.Substring(1, StrLen(value) - StrLen(' 12:00:00 AM'));
                    end;
            if((datatype = ForNav_DataType::tDecimal) or (datatype = ForNav_DataType::tInteger)) and (StrLen(value) > 2)then begin
                Evaluate(decimalValue, value);
                value:=Format(decimalValue, 0, 9);
            end;
            AddJsonAttribute(globalJsonObject, name, value, datatype);
        end;
    end;
    local procedure AppendJsonObject(var JsonBuilder: TextBuilder;
    var globalJsonObject: JsonObject)var values: Text;
    objKey: Text;
    ArchiveKeyToken: JsonToken;
    tab: Text[9];
    begin
        globalJsonObject.WriteTo(values);
        if DataItemId <> '' then begin
            if globalJsonObject.Contains('CurrReport$ArchiveKey')then begin
                tab[1]:=9;
                globalJsonObject.Get('CurrReport$ArchiveKey', ArchiveKeyToken);
                if ArchiveKey = '' then ArchiveKey:=ArchiveKeyToken.AsValue().AsText()
                else
                    ArchiveKey:=ArchiveKey + tab + ArchiveKeyToken.AsValue().AsText();
                globalJsonObject.Remove('CurrReport$ArchiveKey');
            end;
            JsonBuilder.Append('    {"');
            JsonBuilder.Append(DataItemId);
            JsonBuilder.Append('":');
            JsonBuilder.Append(values);
            JsonBuilder.AppendLine('},');
            Clear(globalJsonObject);
        end;
        DataItemId:='';
    end;
    procedure IsForNavPreview(): Boolean;
    var ReportLayoutSelection: Record "Report Layout Selection";
    begin
        EXIT(ReportLayoutSelection.GetTempLayoutSelected <> '');
    end;
    procedure GetWordLayout(reportNo: Integer;
    var tempBlob: Record "ForNAV Core Setup";
    var customCode: Code[20]): Boolean var CustomReportLayout: Record "Custom Report Layout";
    ReportLayoutSelection: Record "Report Layout Selection";
    os: OutStream;
    is: InStream;
    f: File;
    layoutCode: Code[20];
    begin
        if ReportLayoutSelection.HasCustomLayout(reportNo) = 2 then begin
            layoutCode:=ReportLayoutSelection.GetTempLayoutSelected();
            if layoutCode = '' then layoutCode:=ReportLayoutSelection."Custom Report Layout Code";
            if CustomReportLayout.Get(layoutCode)then begin
                CustomReportLayout.CalcFields(Layout);
                if CustomReportLayout.Layout.HasValue then begin
                    customCode:=layoutCode;
                    CustomReportLayout.Layout.CreateInStream(is);
                    tempBlob.Blob.CreateOutStream(os);
                    CopyStream(os, is);
                    exit(true);
                end;
            end;
        end;
        if REPORT.WordLayout(reportNo, is)then begin
            customCode:=GetUniqueCustomLayoutCode();
            tempBlob.Blob.CreateOutStream(os);
            CopyStream(os, is);
            exit(true);
        end;
    end;
    procedure GetUniqueCustomLayoutCode(): Code[20];
    var retv: Code[20];
    begin
        retv:=CopyStr(DelChr(CreateGuid(), '=', '{}-'), 1, 20);
        exit(retv);
    end;
    procedure GetDesignPackage(reportNo: Integer;
    var packageBlob: Record "ForNAV Core Setup"): Boolean var serviceUrl: Text;
    tempBlob: Record "ForNAV Core Setup";
    os: OutStream;
    is: InStream;
    chr: Char;
    customCode: Code[20];
    previewUrl: Text;
    webserviceUrl: Text;
    session: Record "ForNAV Cloud Report Sessions";
    ReportLayoutSelection: Record "Report Layout Selection";
    CustomReportLayout: Record "Custom Report Layout";
    begin
        // Remove old sessions
        session.Init();
        session.SetRange(Created, CreateDateTime(0D, 0T), CurrentDateTime - (3600 * 24 * 10));
        session.DeleteAll(false);
        // Remove old preview layouts
        CustomReportLayout.Init();
        CustomReportLayout.SetRange("Last Modified", CreateDateTime(0D, 0T), CurrentDateTime - 600);
        CustomReportLayout.SetFilter(Description, 'ForNAV BC preview *');
        CustomReportLayout.DeleteAll();
        // Create new session
        session.Init;
        session."Session ID":=CreateGuid;
        session.Created:=CURRENTDATETIME;
        session."Report ID":=reportNo;
        session.PreviewLayoutCode:=GetUniqueCustomLayoutCode();
        session.Insert;
        // Make sure there is a record in the report selection table 
        if not ReportLayoutSelection.Get(reportNo, CompanyName)then begin
            ReportLayoutSelection.Init();
            ReportLayoutSelection."Report ID":=reportNo;
            ReportLayoutSelection.Type:=ReportLayoutSelection.Type::"Word (built-in)";
            ReportLayoutSelection.Insert(true);
        end;
        Commit;
        serviceUrl:=GetUrl(CLIENTTYPE::Api, CompanyName, OBJECTTYPE::Page, 6189112);
        previewUrl:=GetUrl(CLIENTTYPE::Current, CompanyName, OBJECTTYPE::Page, 6189100, session);
        webserviceUrl:=GetUrl(CLIENTTYPE::SOAP, CompanyName, OBJECTTYPE::Codeunit, 6189102);
        if webServiceUrl = '' then begin
            CreateWebService;
            WebServiceUrl:=GetUrl(CLIENTTYPE::SOAP, CompanyName, OBJECTTYPE::Codeunit, 6189102);
        end;
        chr:=13;
        if GetWordLayout(reportNo, tempBlob, customCode)then begin
            packageBlob.Blob.CreateOutStream(os, TextEncoding::UTF8);
            os.WriteText('V2');
            os.WriteText(Format(chr, 0, '<CHAR>'));
            // Session ID
            os.WriteText(session."Session ID");
            os.WriteText(Format(chr, 0, '<CHAR>'));
            // Preview layout code
            os.WriteText(session.PreviewLayoutCode);
            os.WriteText(Format(chr, 0, '<CHAR>'));
            // Service URL
            os.WriteText(serviceUrl);
            os.WriteText(Format(chr, 0, '<CHAR>'));
            // Preview URL
            os.WriteText(previewUrl);
            os.WriteText(Format(chr, 0, '<CHAR>'));
            // Seb Service URL
            os.WriteText(webserviceUrl);
            os.WriteText(Format(chr, 0, '<CHAR>'));
            // Custom Layout Code
            os.WriteText(customCode);
            os.WriteText(Format(chr, 0, '<CHAR>'));
            // Report No
            os.WriteText(Format(reportNo, 0, 9));
            os.WriteText(Format(chr, 0, '<CHAR>'));
            // Company Name
            os.WriteText(CompanyName);
            os.WriteText(Format(chr, 0, '<CHAR>'));
            tempBlob.Blob.CreateInStream(is);
            CopyStream(os, is);
            //  f.CREATE('c:\temp\xx.docx');
            //  f.CREATEOUTSTREAM(os);
            //  tempBlob.Blob.CREATEINSTREAM(is);
            //  COPYSTREAM(os, is);
            //  f.CLOSE;
            exit(true);
        end;
    end;
    procedure LaunchDesigner(openDesigner: Boolean): Boolean;
    var ForNAVCoreSetup: Record "ForNAV Core Setup" temporary;
    fileName: Text;
    is: InStream;
    begin
        if openDesigner and not IsForNavPreview()then begin
            if GetDesignPackage(ReportNumber, ForNAVCoreSetup)then begin
                ForNAVCoreSetup.Blob.CREATEINSTREAM(is);
                fileName:=FORMAT(ReportNumber) + '.fornavdesign';
                DOWNLOADFROMSTREAM(is, '', '', '', fileName);
            end;
            exit(true);
        end;
    end;
    procedure LaunchDesigner(): Boolean;
    var ForNAVCoreSetup: Record "ForNAV Core Setup" temporary;
    fileName: Text;
    is: InStream;
    begin
        if not IsForNavPreview then begin
            if GetDesignPackage(ReportNumber, ForNAVCoreSetup)then begin
                ForNAVCoreSetup.Blob.CREATEINSTREAM(is);
                fileName:=FORMAT(ReportNumber) + '.fornavdesign';
                DOWNLOADFROMSTREAM(is, '', '', '', fileName);
            end;
            exit(true);
        end;
    end;
    procedure LaunchDesigner(ReportID: Integer): Boolean;
    var ForNAVCoreSetup: Record "ForNAV Core Setup" temporary;
    fileName: Text;
    is: InStream;
    begin
        if not IsForNavPreview then begin
            if GetDesignPackage(ReportID, ForNAVCoreSetup)then begin
                ForNAVCoreSetup.Blob.CREATEINSTREAM(is);
                fileName:=FORMAT(ReportID) + '.fornavdesign';
                DOWNLOADFROMSTREAM(is, '', '', '', fileName);
            end;
            exit(true);
        end;
    end;
    procedure LaunchDesigner(ReportID: Integer;
    IgnoreIsPreview: Boolean): Boolean;
    var ForNAVCoreSetup: Record "ForNAV Core Setup" temporary;
    fileName: Text;
    is: InStream;
    begin
        if GetDesignPackage(ReportID, ForNAVCoreSetup)then begin
            ForNAVCoreSetup.Blob.CREATEINSTREAM(is);
            fileName:=FORMAT(ReportID) + '.fornavdesign';
            DOWNLOADFROMSTREAM(is, '', '', '', fileName);
        end;
        exit(true);
    end;
    local procedure GetProperty(nodes: XmlNodeList;
    name: Text): Text var nodeNo: Integer;
    propertyElement: XmlElement;
    propertyAttribute: XmlAttribute;
    propertyNode: XmlNode;
    retv: Text;
    begin
        for nodeNo:=1 to nodes.Count do begin
            nodes.Get(nodeNo, propertyNode);
            propertyElement:=propertyNode.AsXmlElement();
            if propertyElement.Attributes().Get('name', propertyAttribute)then if propertyAttribute.Value = name then exit(propertyElement.InnerText);
        end;
    end;
    local procedure Init(var jsonFieldObject: JsonObject;
    reportNo: Integer;
    name: Text;
    isMaster: Boolean)var ReportLayoutSelection: Record "Report Layout Selection";
    CustomReportLayout: Record "Custom Report Layout";
    startPos: Integer;
    iStream: InStream;
    reportLayout: Text;
    dataContract: Text;
    CoreSetup: Record "ForNAV Core Setup";
    document: XmlDocument;
    rootElement: XmlElement;
    layoutNode: XmlNode;
    dataContractNode: XmlNode;
    layoutStream: InStream;
    CustomLayoutID: Text;
    propertyNodes: XmlNodeList;
    TempLayout: Text;
    begin
        ReportLanguage:=GlobalLanguage;
        // Check if a temporary layout is selected for the main report.
        // The temporary layout is set when a custom layout is run without being selected in the 
        // Report Layout Selection table.
        if not isMaster and (ReportLayoutSelection.GetTempLayoutSelected <> '')then CustomLayoutID:=ReportLayoutSelection.GetTempLayoutSelected
        else
        begin
            TempLayout:=ReportLayoutSelection.GetTempLayoutSelected;
            ReportLayoutSelection.SetTempLayoutSelected('');
            if ReportLayoutSelection.HasCustomLayout(reportNo) = 2 then // Get the custom Word layout if there is one.
 CustomLayoutID:=ReportLayoutSelection."Custom Report Layout Code";
            ReportLayoutSelection.SetTempLayoutSelected(TempLayout);
        end;
        if CustomLayoutID <> '' then begin
            CustomReportLayout.Get(CustomLayoutID);
            CustomReportLayout.TESTFIELD(Type, CustomReportLayout.Type::Word.AsInteger());
            CustomReportLayout.CALCFIELDS(Layout);
            CustomReportLayout.Layout.CREATEINSTREAM(layoutStream);
        end
        else
        begin
            // Get the built-in layout.
            Report.WordLayout(reportNo, layoutStream);
        end;
        if not CoreSetup.GetZipContents('docProps/custom.xml', layoutStream)then begin
            if isMaster then Error('Error loading master report %1 (%2). No valid layout found. Please check your layouts folder or custom layout selection.', name, reportNo)
            else
                Error('No layout found for report %1 (%2). Please check your layouts folder or custom layout selection.', name, reportNo);
        end;
        CoreSetup.Blob.CreateInStream(iStream);
        XmlDocument.ReadFrom(iStream, document);
        document.GetRoot(rootElement);
        propertyNodes:=rootElement.GetChildElements();
        reportLayout:=GetProperty(propertyNodes, 'Document');
        if reportLayout = '' then Error('No layout found in XML for report %1 (%2). Please check your layouts folder or custom layout selection.', name, reportNo);
        dataContract:=GetProperty(propertyNodes, 'DataContract');
        if dataContract = '' then Error('No data contract found in XML for report %1 (%2). Please check your layouts folder or custom layout selection.', name, reportNo);
        if isMaster then begin
            AddMasterReport(jsonFieldObject, name, reportLayout, dataContract);
            ReadContract(jsonFieldObject, dataContract, name, true);
        end
        else
        begin
            ReadContract(jsonFieldObject, Format(dataContract), name, false);
            jsonFieldObject.Add('CurrReport$Definition$Text', reportLayout);
        end;
    end;
    procedure OnInit(reportNo: Integer;
    var allowDesign: Boolean)var ReportLayoutSelection: Record "Report Layout Selection";
    allObjects: Record AllObj;
    begin
        allObjects.Get(ObjectType::Report, reportNo);
        OnInit(reportNo, allObjects."Object Name", allowDesign);
    end;
    procedure OnInit(reportNo: Integer;
    reportName: Text;
    var allowDesign: Boolean)var ReportLayoutSelection: Record "Report Layout Selection";
    allObjects: Record AllObj;
    begin
        ReportNumber:=reportNo;
        allowDesign:=not IsForNavPreview() and ReportLayoutSelection.WRITEPERMISSION;
        Init(jsonInitObject, reportNo, reportName, false);
        AddCaptions(jsonInitObject);
    end;
    procedure Init(var jsonFieldObject: JsonObject;
    name: Text)begin
        ReportLanguage:=GlobalLanguage;
        Init(jsonFieldObject);
    end;
    procedure Init(var jsonFieldObject: JsonObject)var initToken: JsonToken;
    jsonKey: Text;
    begin
        foreach jsonKey in jsonInitObject.Keys do begin
            jsonInitObject.Get(jsonKey, initToken);
            jsonFieldObject.Add(jsonKey, initToken);
        end;
        if WatermarkImage <> '' then jsonFieldObject.Add('CurrReport$WatermarkImage$Text', WatermarkImage);
        if DataItemCopiesId <> '' then jsonFieldObject.Add(StrSubstNo('DataItem$%1$Copies$Integer', DataItemCopiesId), DataItemCopies);
        if DataItemNewPagePerRecordId <> '' then jsonFieldObject.Add(StrSubstNo('DataItem$%1$NewPagePerRecord$Boolean', DataItemNewPagePerRecordId), DataItemNewPagePerRecord);
        if StrLen(AppendPdfs) > 0 then jsonFieldObject.Add('CurrReport$AppendPdfs$Text', AppendPdfs);
        if StrLen(PrependPdfs) > 0 then jsonFieldObject.Add('CurrReport$PrependPdfs$Text', PrependPdfs);
    end;
    procedure AddCaptions(var jsonFieldObject: JsonObject;
    recName: Text;
    var recRef: RecordRef;
    contract: JsonObject)var fieldRef: FieldRef;
    fieldsToken: JsonToken;
    fieldToken: JsonToken;
    fieldName: Text;
    fieldNo: Integer;
    fieldCaptionName: Text;
    index: Integer;
    Language: Codeunit "ForNAV Language Mgt.";
    begin
        HasTranslations:=Language.HasTranslations();
        if contract.Get('FieldCaptions', fieldsToken)then begin
            foreach fieldName in fieldsToken.AsObject().Keys()do begin
                fieldsToken.AsObject().Get(fieldName, fieldToken);
                fieldNo:=fieldToken.AsValue().AsInteger();
                if recRef.FieldExist(fieldNo)then begin
                    fieldRef:=recRef.Field(fieldNo);
                    fieldCaptionName:=recName + '$FieldCaptions$' + fieldName + '$Text';
                    if jsonFieldObject.Contains(fieldCaptionName)then jsonFieldObject.Replace(fieldCaptionName, GetFieldCaption(recRef, fieldRef))
                    else
                        jsonFieldObject.Add(fieldCaptionName, GetFieldCaption(recRef, fieldRef));
                end;
            end;
        end;
    end;
    procedure AddDataItemCaptions(var jsonFieldObject: JsonObject;
    dataItemId: text;
    dataItemContract: JsonObject)var recRef: RecordRef;
    tableNoToken: JsonToken;
    tableNo: Integer;
    begin
        dataItemContract.Get('No', tableNoToken);
        tableNo:=tableNoToken.AsValue().AsInteger();
        recRef.Open(tableNo, true);
        AddCaptions(jsonFieldObject, dataItemId, recRef, dataItemContract);
        recRef.Close();
    end;
    procedure AddRecordCaptions(var jsonFieldObject: JsonObject;
    recordName: text)var recordContract: JsonToken;
    recRef: RecordRef;
    dataItemContract: JsonObject;
    masterReportName: Text;
    masterReportRecordToken: JsonToken;
    tableNoToken: JsonToken;
    tableNo: Integer;
    begin
        Records.Get(recordName, recordContract);
        recordContract.AsObject().Get('No', tableNoToken);
        tableNo:=tableNoToken.AsValue().AsInteger();
        recRef.Open(tableNo);
        foreach masterReportName in MasterReports do begin
            if Records.ContainsKey(masterReportName + '$' + recordName)then begin
                Records.Get(masterReportName + '$' + recordName, masterReportRecordToken);
                AddCaptions(jsonFieldObject, recordName, recRef, masterReportRecordToken.AsObject());
            end;
        end;
        AddCaptions(jsonFieldObject, recordName, recRef, recordContract.AsObject());
        if(tableNo = 6188471) and HasForNavSetupTranslation then begin
            RecRef.FindFirst();
            AddForNavSetupTranslations(jsonFieldObject, 80, RecordName, recRef, 'LegalConditions', true);
            AddForNavSetupTranslations(jsonFieldObject, 70, RecordName, recRef, 'PaymentNote', true);
        end;
        recRef.Close();
    end;
    procedure OnPreDataItem(dataItemid: Text;
    recRef: RecordRef): Boolean var contract: JsonObject;
    fieldsToken: JsonToken;
    filterGroup: Integer;
    hasView: Boolean;
    begin
        if not Contracts.Get(dataItemid, contract)then exit;
        if contract.Get('DataItemView', fieldsToken)then begin
            filterGroup:=recRef.FilterGroup();
            recRef.FilterGroup(2);
            recRef.SetView(fieldsToken.AsValue().AsText());
            recRef.FilterGroup(filterGroup);
            hasView:=true;
        end;
        if not RecIds.ContainsKey(dataItemid)then AddDataItemReferences(dataItemId, recRef);
        exit(hasView);
    end;
    procedure OnPreDataItem(dataItemid: Text;
    rec: Variant)var recRef: RecordRef;
    begin
        recRef.GetTable(rec);
        OnPreDataItem(dataItemid, recRef);
    end;
    procedure AddCaptions(var jsonFieldObject: JsonObject)var recordName: Text;
    dataItemName: Text;
    keyName: Text;
    dataItemContract: JsonObject;
    begin
        foreach recordName in Records.Keys do begin
            if StrPos(recordName, '$') = 0 then AddRecordCaptions(jsonFieldObject, recordName);
        end;
    end;
    var FieldsTable: Record "Field";
    local procedure MapField(fromTableNo: Integer;
    value: JsonValue;
    toTableNo: Integer)begin
        FieldsTable.Reset();
        if FieldsTable.Get(fromTableNo, value.AsInteger())then begin
            FieldsTable.SetRange(FieldsTable.TableNo, toTableNo);
            FieldsTable.SetRange(FieldsTable.FieldName, FieldsTable.FieldName);
            if FieldsTable.FindFirst()then begin
                value.SetValue(FieldsTable."No.");
                exit;
            end;
        end;
        value.SetValue(99999999);
    end;
    local procedure MapContract(dataItemId: Text;
    contract: JsonObject)var contractType: Text;
    fieldsToken: JsonToken;
    fieldToken: JsonToken;
    fieldName: Text;
    fieldNo: Integer;
    calcFieldToken: JsonToken;
    toTableNo: Integer;
    fromTableNo: Integer;
    dataItemToken: JsonToken;
    begin
        foreach contractType in contract.Keys()do begin
            contract.Get(contractType, fieldsToken);
            case contractType of 'Fields', 'FieldCaptions', 'FieldLookups', 'GetFilter': begin
                foreach fieldName in fieldsToken.AsObject().Keys()do begin
                    fieldsToken.AsObject().Get(fieldName, fieldToken);
                    if contractType = 'FieldLookups' then fieldToken.AsObject().Get('FieldNo', fieldToken);
                    MapField(fromTableNo, fieldToken.AsValue(), toTableNo);
                end;
            end;
            'CalcFields': begin
                foreach calcFieldToken in fieldsToken.AsArray()do begin
                    MapField(fromTableNo, calcFieldToken.AsValue(), toTableNo);
                end;
            end;
            'No': begin
                if not Contracts.ContainsKey(dataItemId)then exit;
                fromTableNo:=fieldsToken.AsValue().AsInteger();
                Contracts.Get(dataItemId).Get('No', dataItemToken);
                toTableNo:=dataItemToken.AsValue().AsInteger();
                if fromTableNo = toTableNo then exit;
            end;
            end;
        end;
    end;
    local procedure GetRecord(var globalJsonObject: JsonObject;
    recordName: Text;
    var dataItemRecName: Text;
    var dataItemRecRef: RecordRef;
    params: JsonArray)var recordToken: JsonToken;
    tableNoToken: JsonToken;
    tableNo: Integer;
    recRef: RecordRef;
    masterReportName: Text;
    masterReportRecordToken: JsonToken;
    param: JsonToken;
    paramType: Text;
    paramValue: JsonToken;
    recKey: KeyRef;
    fieldRecRefFieldNo: Integer;
    index: Integer;
    found: Boolean;
    fieldRecRef: RecordRef;
    fieldRecName: Text;
    filter: Text;
    fieldRef: FieldRef;
    reset: Boolean;
    next: Boolean;
    hasRecord: Boolean;
    link: JsonToken;
    linkElement: Text;
    fromField: Integer;
    toField: Integer;
    linkToken: JsonToken;
    resetIfNotFound: Boolean;
    // recKeyRef : KeyRef;
    // keyFieldIndex : Integer;
    begin
        if not Records.Get(recordName, recordToken)then Error('Javascript record %1 is not defined in the ForNAV layout - please contact your partner', recordName);
        recordToken.AsObject().Get('No', tableNoToken);
        tableNo:=tableNoToken.AsValue().AsInteger();
        recRef.Open(tableNo);
        recKey:=recRef.KeyIndex(1);
        foreach param in params do begin
            param.AsObject().Keys().Get(1, paramType);
            param.AsObject().Get(paramType, paramValue);
            case paramType of 'Record': begin
                fieldRecName:=paramValue.AsValue().AsText();
                if fieldRecName <> dataItemRecName then begin
                    GetRecRef(fieldRecName, fieldRecRef);
                    hasRecord:=true;
                end
                else
                    hasRecord:=false;
            end;
            'TableView': begin
                recRef.FilterGroup(2);
                recRef.SetView(paramValue.AsValue().AsText());
                recRef.FilterGroup(0);
                resetIfNotFound:=true;
            end;
            'DataItemLink': begin
                recRef.FilterGroup(4);
                foreach link in paramValue.AsArray()do begin
                    foreach linkElement in link.AsObject().Keys()do begin
                        link.AsObject().Get(linkElement, linkToken);
                        case linkElement of 'From': fromField:=linkToken.AsValue().AsInteger();
                        'To': toField:=linkToken.AsValue().AsInteger();
                        end;
                    end;
                    if recRef.FieldExist(toField)then recRef.Field(toField).SetRange(dataItemRecRef.Field(fromField).Value)
                    else
                        reset:=true;
                end;
                recRef.FilterGroup(0);
                resetIfNotFound:=true;
            end;
            'Filter': SetRangeOrFilter(recref, paramValue.AsArray(), true);
            'Range': SetRangeOrFilter(recref, paramValue.AsArray(), false);
            'Field': begin
                index+=1;
                fieldRecRefFieldNo:=paramValue.AsValue().AsInteger();
                if fieldRecRefFieldNo = 0 then exit;
                if hasRecord then begin
                    recKey.FieldIndex(index).SetRange(fieldRecRef.Field(fieldRecRefFieldNo).Value());
                    fieldRecRef.Close();
                end
                else
                    recKey.FieldIndex(index).SetRange(dataItemRecRef.Field(fieldRecRefFieldNo).Value());
            end;
            'Integer': begin
                index+=1;
                recKey.FieldIndex(index).SetRange(paramValue.AsValue().AsInteger());
            end;
            'Text': begin
                index+=1;
                recKey.FieldIndex(index).SetRange(paramValue.AsValue().AsText());
            end;
            'Boolean': begin
                index+=1;
                recKey.FieldIndex(index).SetRange(paramValue.AsValue().AsBoolean());
            end;
            'Decimal': begin
                index+=1;
                recKey.FieldIndex(index).SetRange(paramValue.AsValue().AsDecimal());
            end;
            'Reset': reset:=true;
            'Next': next:=true;
            end;
        end;
        if reset then begin
            recRef.Reset();
            found:=true;
        end
        else
        begin
            if next then begin
                recRef.Close();
                GetRecRef(recordName, recref);
                found:=recRef.Next() = 1;
            end
            else
            begin
                if not RecIds.ContainsKey(recordName)then AddRecordReferences(recordName, recordToken.AsObject(), recref);
                found:=recRef.FindFirst();
                if not found and resetIfNotFound then begin
                    recRef.Close();
                    recRef.Open(tableNo);
                end;
            end;
        end;
        if globalJsonObject.Contains(StrSubstNo('%1$GetRecord$Boolean', recordName))then globalJsonObject.Remove(StrSubstNo('%1$GetRecord$Boolean', recordName));
        globalJsonObject.Add(StrSubstNo('%1$GetRecord$Boolean', recordName), found);
        if found or resetIfNotFound then begin
            foreach masterReportName in MasterReports do begin
                if Records.ContainsKey(masterReportName + '$' + recordName)then begin
                    Records.Get(masterReportName + '$' + recordName, masterReportRecordToken);
                    AddValues(globalJsonObject, recordName, recRef, masterReportRecordToken.AsObject(), true);
                end;
            end;
            AddValues(globalJsonObject, recordName, recRef, recordToken.AsObject(), true);
            if found and not reset then AddRecId(recordName, recRef.RecordId);
        end;
        recRef.Close();
    end;
    local procedure SetRangeOrFilter(recRef: RecordRef;
    params: JsonArray;
    setFilter: Boolean)var param: JsonToken;
    paramType: Text;
    paramValue: JsonToken;
    fieldRecRef: RecordRef;
    fieldRecRefFieldNo: Integer;
    fromValue: Variant;
    toValue: Variant;
    index: Integer;
    fieldNo: Integer;
    begin
        foreach param in params do begin
            param.AsObject().Keys().Get(1, paramType);
            param.AsObject().Get(paramType, paramValue);
            if index = 0 then fieldNo:=paramValue.AsValue().AsInteger()
            else
            begin
                case paramType of 'Record': begin
                    GetRecRef(paramValue.AsValue().AsText(), fieldRecRef);
                    index-=1;
                end;
                'Field': begin
                    fieldRecRefFieldNo:=paramValue.AsValue().AsInteger();
                    if index = 2 then toValue:=fieldRecRef.Field(fieldRecRefFieldNo).Value()
                    else
                        fromValue:=fieldRecRef.Field(fieldRecRefFieldNo).Value();
                    fieldRecRef.Close();
                end;
                'Integer': if index = 2 then toValue:=paramValue.AsValue().AsInteger()
                    else
                        fromValue:=paramValue.AsValue().AsInteger();
                'Text': if index = 2 then toValue:=paramValue.AsValue().AsText()
                    else
                        fromValue:=paramValue.AsValue().AsText();
                'Boolean': if index = 2 then toValue:=paramValue.AsValue().AsBoolean()
                    else
                        fromValue:=paramValue.AsValue().AsBoolean();
                'Decimal': if index = 2 then toValue:=paramValue.AsValue().AsDecimal()
                    else
                        fromValue:=paramValue.AsValue().AsDecimal();
                end;
            end;
            index+=1;
        end;
        if setFilter then recRef.Field(fieldNo).SetFilter(fromValue)
        else
        begin
            if index < 3 then toValue:=fromValue;
            recRef.Field(fieldNo).SetRange(fromValue, toValue);
        end;
    end;
    local procedure GetRecords(var globalJsonObject: JsonObject;
    var dataItemRecName: Text;
    var dataItemRecRef: RecordRef;
    getcalls: JsonArray)var recordName: Text;
    getCall: JsonToken;
    call: JsonToken;
    begin
        foreach getCall in getCalls do begin
            getCall.AsObject().Keys().Get(1, recordName);
            getCall.AsObject().Get(recordName, call);
            GetRecord(globalJsonObject, recordName, dataItemRecName, dataItemRecRef, call.AsArray());
        end;
    end;
    local procedure AddChild(array: JsonArray;
    var recRef: RecordRef;
    childDataItemId: Text)var childJsonObject: JsonObject;
    childJsonObject2: JsonObject;
    begin
        AddDataItemValues(childJsonObject, childDataItemId, recRef);
        AddDataItemJson(childJsonObject2, childJsonObject);
        array.Add(childJsonObject2);
    end;
    local procedure AddChild(var childJsonObject: JsonObject;
    var recRef: RecordRef;
    childDataItemId: Text;
    maxIteration: Integer)var array: JsonArray;
    no: Integer;
    begin
        AddDataItemReferences(childDataItemId, recRef);
        if recRef.FindFirst()then begin
            repeat AddRecId(childDataItemId, recRef.RecordId);
                AddChild(array, recRef, childDataItemId);
                no+=1;
            until(no >= maxIteration) or (recRef.Next() <> 1)end;
        if array.Count <> 0 then ChildJsonObject.Add(childDataItemId, array);
    end;
    local procedure GetChild(var childJsonObject: JsonObject;
    child: JsonToken;
    var dataItemRecRef: RecordRef;
    reportChildren: Boolean)var contractKey: Text;
    childDataItemId: Text;
    dataItemView: Text;
    childToken: JsonToken;
    linkToken: JsonToken;
    recRef: RecordRef;
    link: JsonToken;
    linkElement: Text;
    dataItemLinkRecRef: RecordRef;
    fromField: Integer;
    toField: Integer;
    childArray: JsonArray;
    maxIteration: Integer;
    tableNoToken: JsonToken;
    tableNo: Integer;
    dataItemContract: JsonObject;
    begin
        maxIteration:=2147483647;
        foreach contractKey in child.AsObject().Keys do begin
            child.AsObject().Get(contractKey, childToken);
            case contractKey of 'DataItem': childDataItemId:=childToken.AsValue().AsText();
            'Record': begin
                if not Contracts.ContainsKey(childDataItemId)then exit;
                dataItemContract:=Contracts.Get(childDataItemId);
                dataItemContract.Get('No', tableNoToken);
                tableNo:=tableNoToken.AsValue().AsInteger();
                recRef.Open(tableNo);
            end;
            'MaxIteration': maxIteration:=childToken.AsValue().AsInteger();
            'DataItemView': recRef.SetView(childToken.AsValue().AsText());
            'DataItemLinkReference': if childToken.AsValue().AsText() = DataItemId then dataItemLinkRecRef:=dataItemRecRef
                else
                    GetRecRef(childToken.AsValue().AsText(), dataItemLinkRecRef);
            'DataItemLink': begin
                foreach link in childToken.AsArray()do begin
                    foreach linkElement in link.AsObject().Keys()do begin
                        link.AsObject().Get(linkElement, linkToken);
                        case linkElement of 'From': fromField:=linkToken.AsValue().AsInteger();
                        'To': toField:=linkToken.AsValue().AsInteger();
                        end;
                    end;
                    recRef.Field(toField).SetRange(dataItemLinkRecRef.Field(fromField).Value);
                end;
                dataItemLinkRecRef.Close();
            end;
            end;
        end;
        AddChild(childJsonObject, recRef, childDataItemId, maxIteration);
        recRef.Close();
    end;
    local procedure GetChildren(var globalJsonObject: JsonObject;
    children: JsonArray;
    var dataItemRecRef: RecordRef;
    reportChildren: Boolean)var child: JsonToken;
    childJsonObject: JsonObject;
    childJsonObjectAsText: Text;
    begin
        foreach child in children do begin
            GetChild(childJsonObject, child, dataItemRecRef, reportChildren);
        end;
        if childJsonObject.Keys.Count <> 0 then begin
            childJsonObject.WriteTo(childJsonObjectAsText);
            if reportChildren then globalJsonObject.Add('DataItem$$Sieblings$Text', childJsonObjectAsText)
            else
                globalJsonObject.Add('DataItem$$Children$Text', childJsonObjectAsText);
        end;
    end;
    local procedure ReadContract(var globalJsonObject: JsonObject;
    textContract: Text;
    reportName: Text;
    isMasterReport: Boolean)var contract: JsonObject;
    token: JsonToken;
    dataItemId: Text;
    dataItemToken: JsonToken;
    contractKey: Text;
    recordToken: JsonToken;
    recordName: Text;
    tableNoToken: JsonToken;
    tableNo: Integer;
    recRef: RecordRef;
    masterReportToken: JsonToken;
    layoutStream: InStream;
    bigLayout: BigText;
    masterReportNo: Integer;
    masterReportName: Text;
    allObjects: Record AllObjWithCaption;
    jsonMasterReportObject: JsonObject;
    recordJsonArray: JsonArray;
    recordsJsonObject: JsonObject;
    masterReportsJsonObjects: JsonObject;
    masterReportRecordToken: JsonToken;
    recordKey: Text;
    debug: Text;
    isObject: boolean;
    contractToken: JsonToken;
    contractVersion: Integer;
    paramsToken: JsonToken;
    masterRecordKey: Text;
    begin
        contract.ReadFrom(textContract);
        contract.Get('DataContract', token);
        foreach contractKey in token.AsObject().Keys()do begin
            token.AsObject().Get(contractKey, contractToken);
            case contractKey of 'Version': contractVersion:=contractToken.AsValue().AsInteger();
            'DataItems': begin
                foreach dataitemId in contractToken.AsObject().Keys()do begin
                    contractToken.AsObject().Get(dataitemId, dataItemToken);
                    if isMasterReport then begin
                        MapContract(dataItemId, dataItemToken.AsObject());
                        Contracts.Add(reportName + '$' + dataItemId, dataItemToken.AsObject());
                        Records.Add(reportName + '$' + dataItemId, dataItemToken);
                    end
                    else
                    begin
                        Contracts.Add(dataItemId, dataItemToken.AsObject());
                        Records.Add(dataItemId, dataItemToken);
                    end;
                end;
            end;
            'Records': begin
                foreach recordName in contractToken.AsObject().Keys()do begin
                    contractToken.AsObject().Get(recordName, recordToken);
                    recordToken.AsObject().Get('No', tableNoToken);
                    if isMasterReport then begin
                        if not MasterRecords.ContainsKey(recordName)then MasterRecords.Add(recordName, reportName);
                        Records.Add(reportName + '$' + recordName, recordToken)end
                    else
                    begin
                        Records.Add(recordName, recordToken);
                        if MasterRecords.ContainsKey(recordName)then MasterRecords.Remove(recordName);
                        if not globalJsonObject.Contains(StrSubstNo('%1$GetRecord$Boolean', recordName))then begin
                            if contractVersion < 1 then begin
                                tableNo:=tableNoToken.AsValue().AsInteger();
                                recRef.Open(tableNo);
                                globalJsonObject.Add(StrSubstNo('%1$GetRecord$Boolean', recordName), recRef.FindFirst());
                                foreach masterReportName in MasterReports do begin
                                    if Records.ContainsKey(masterReportName + '$' + recordName)then begin
                                        Records.Get(masterReportName + '$' + recordName, masterReportRecordToken);
                                        AddValues(globalJsonObject, recordName, recRef, masterReportRecordToken.AsObject(), true);
                                    end;
                                end;
                                AddValues(globalJsonObject, recordName, recRef, recordToken.AsObject(), true);
                                recRef.Close();
                            end
                            else if recordToken.AsObject().Contains('Params')then begin
                                    recordToken.AsObject().Get('Params', paramsToken);
                                    GetRecord(globalJsonObject, recordName, recordName, recRef, paramsToken.AsArray());
                                end;
                        end;
                    end;
                end;
            end;
            'MasterReports': // Comes before 'Records'
 if not IsMasterReport then begin
                    foreach masterReportToken in contractToken.AsArray()do begin
                        masterReportName:=masterReportToken.AsValue().AsText();
                        if not Evaluate(masterReportNo, masterReportName)then begin
                            allObjects.SetRange(allObjects."Object Name", masterReportName);
                            allObjects.SetRange(allObjects."Object Type", allObjects."Object Type"::Report);
                            if not allObjects.FindFirst()then Error('Master report %1 not found', masterReportName);
                            masterReportNo:=allObjects."Object ID";
                        end;
                        Init(globalJsonObject, masterReportNo, masterReportName, true);
                    end;
                end;
            'Translations': AddTranslations(globalJsonObject, contractToken.AsArray());
            'Children': GetChildren(globalJsonObject, contractToken.AsArray(), recRef, true);
            end;
        end;
        if not isMasterReport then begin
            foreach recordName in MasterRecords.Keys()do begin
                masterRecordKey:=MasterRecords.Get(recordName) + '$' + recordName;
                if not Records.ContainsKey(recordName)then begin
                    recordToken:=Records.Get(masterRecordKey);
                    Records.Add(recordName, recordToken);
                    Records.Remove(masterRecordKey);
                end;
                if not globalJsonObject.Contains(StrSubstNo('%1$GetRecord$Boolean', recordName))then begin
                    if recordToken.AsObject().Contains('Params')then begin
                        recordToken.AsObject().Get('Params', paramsToken);
                        GetRecord(globalJsonObject, recordName, recordName, recRef, paramsToken.AsArray());
                    end;
                end;
            end;
        end;
    end;
    local procedure Base64Encode(s: Text): Text var tempBlob: Record "ForNAV Core Setup";
    os: OutStream;
    begin
        tempBlob.Blob.CreateOutStream(os);
        os.WriteText(s);
        exit(tempBlob.ToBase64String());
    end;
    procedure SetAllowHttpClient(production: Boolean;
    sandbox: Boolean;
    newValue: Boolean)var NAVAppSetting: Record "NAV App Setting";
    EnvInfo: Codeunit "Environment Information";
    AppInfo: ModuleInfo;
    begin
        if not sandbox and EnvInfo.IsSandbox()then exit;
        if not production and EnvInfo.IsProduction()then exit;
        NavApp.GetCurrentModuleInfo(AppInfo);
        NAVAppSetting."App ID":=AppInfo.Id;
        NAVAppSetting."Allow HttpClient Requests":=newValue;
        if not NAVAppSetting.Insert()then NAVAppSetting.Modify();
    end;
    local procedure TimeZone(): Text;
    var UserPersonalization: Record "User Personalization";
    begin
        UserPersonalization.Get(Database.UserSecurityId);
        exit(UserPersonalization."Time Zone");
    end;
    local procedure GetJsonDataSet(ReportID: Integer;
    ReportAction: Text;
    var reportDataset: XmlElement;
    var localPrinterName: Text;
    var localPrinterSetttings: Text;
    var pfdBase64: Text): Text var JsonBuilder: TextBuilder;
    allObjWithCaptions: Record AllObjWithCaption;
    globalJsonObject: JsonObject;
    AppModuleInfo: ModuleInfo;
    tenantMgt: Codeunit "Environment Information";
    begin
        JsonBuilder.AppendLine('{');
        JsonBuilder.Append('  CurrReport: {');
        JsonBuilder.Append('Version:2,');
        allObjWithCaptions.Get(ObjectType::Report, ReportID);
        JsonBuilder.Append(StrSubstNo('Caption:"%1",', Encode(GetReportCaption(allObjWithCaptions, GlobalLanguage, ReportID))));
        JsonBuilder.Append(StrSubstNo('Name:"%1",', Encode(allObjWithCaptions."Object Name")));
        JsonBuilder.Append(StrSubstNo('No:"%1",', allObjWithCaptions."Object ID"));
        JsonBuilder.Append(StrSubstNo('ReportAction:"%1",', ReportAction));
        if(localPrinterName <> '') and (CurrentClientType() = ClientType::Web)then JsonBuilder.Append(StrSubstNo('PrinterName:"%1",', Encode(localPrinterName)));
        if localPrinterSetttings <> '' then JsonBuilder.Append(StrSubstNo('LocalPrinterSettings:%1,', localPrinterSetttings));
        JsonBuilder.Append(StrSubstNo('Localization:"%1",', tenantMgt.GetApplicationFamily()));
        JsonBuilder.Append(StrSubstNo('GlobalLanguage:%1,', GlobalLanguage));
        JsonBuilder.Append(StrSubstNo('DecimalFormat:"%1",', 1111.11));
        JsonBuilder.Append(StrSubstNo('DateFormat:"%1",', 19800506D));
        JsonBuilder.Append(StrSubstNo('TimeFormat:"%1",', 233059T));
        JsonBuilder.Append(StrSubstNo('TimeZone:"%1",', TimeZone()));
        JsonBuilder.Append(StrSubstNo('UserId:"%1",', Encode(UserId)));
        JsonBuilder.Append(StrSubstNo('CompanyName:"%1",', Encode(CompanyName)));
        JsonBuilder.Append(StrSubstNo('SerialNumber:"%1",', SerialNumber()));
        if tenantMgt.IsSaaSInfrastructure()then JsonBuilder.Append(StrSubstNo('License:%1,', LicenceInformation()));
        if NavApp.GetCurrentModuleInfo(AppModuleInfo)then JsonBuilder.Append(StrSubstNo('AppVersion:"%1",', AppModuleInfo.AppVersion));
        if NavApp.GetModuleInfo('63ca2fa4-4f03-4f2b-a480-172fef340d3f', AppModuleInfo)then JsonBuilder.Append(StrSubstNo('BCVersion:"%1.%2",', AppModuleInfo.AppVersion.Major, AppModuleInfo.AppVersion.Minor));
        JsonBuilder.AppendLine('  },');
        if pfdBase64 = '' then begin
            JsonBuilder.AppendLine('  DataSet:[');
            globalJsonObject.Add('CurrReport$Today', CreateDateTime(Today, Time));
            CreateDataSet(JsonBuilder, globalJsonObject, reportDataset);
            if(DataItemId <> '')then AppendJsonObject(JsonBuilder, globalJsonObject);
            JsonBuilder.AppendLine('  ],');
        end
        else
            JsonBuilder.Append(StrSubstNo('Pdf:"%1",', pfdBase64));
        JsonBuilder.AppendLine('}');
        exit(JsonBuilder.ToText());
    end;
    [EventSubscriber(ObjectType::CodeUnit, Codeunit::"Document Report Mgt.", 'OnBeforeMergeDocument', '', false, false)]
    local procedure OnBeforeMergeDocument(ReportID: Integer;
    ReportAction: Option SaveAsPdf, SaveAsWord, SaveAsExcel, Preview, Print, SaveAsHtml;
    InStrXmlData: InStream;
    PrinterName: Text;
    OutStream: OutStream;
    var Handled: Boolean;
    IsFileNameBlank: Boolean)var reportDataset: XmlElement;
    nameAttr: XmlAttribute;
    is: InStream;
    clientFileName: Text;
    xmlAttribute: XmlAttribute;
    CoreSetup: Record "ForNAV Core Setup";
    localPrinterName: Text;
    localPrinterSetttings: Text;
    isLocalPrinter: Boolean;
    dummyTempBlob: Record "ForNAV Core Setup";
    dummyIs: InStream;
    dummyClientFileName: Text;
    documentArchive: Codeunit "ForNAV Document Archive Mgt.";
    Service: Codeunit "ForNAV Report Service";
    JsonDataSet: Text;
    pfdBase64: Text;
    IsPrintService: Boolean;
    IsExcelPrint: Boolean;
    begin
        if not GetForNavDataSet(InStrXmlData, reportDataset)then exit;
        if CoreSetup.get then;
        if(ReportAction = ReportAction::Print) and (PrinterName <> '')then begin
            if PrinterName = ExcelPrinterName then begin
                IsExcelPrint:=true;
                ReportAction:=ReportAction::SaveAsExcel;
            end
            else
            begin
                GetLocalPrinter(PrinterName, localPrinterName, localPrinterSetttings, IsPrintService);
                if localPrinterName <> '' then begin
                    // PrinterName := localPrinterName;
                    isLocalPrinter:=true;
                end;
            end;
        end;
        JsonDataSet:=GetJsonDataSet(ReportId, Format(ReportAction), reportDataset, localPrinterName, localPrinterSetttings, pfdBase64);
        Service.Call(JsonDataSet, CoreSetup);
        CoreSetup.Blob.CreateInStream(is);
        if documentArchive.WriteToArchive(ReportID, ReportAction, DataItemCopies, ArchiveKey, is)then CoreSetup.Blob.CreateInStream(is);
        if IsFileNameBlank or ((PrinterName <> '') and (CurrentClientType() = ClientType::Web))then begin
            reportDataset.Attributes.Get('name', '', xmlAttribute);
            clientFileName:=xmlAttribute.Value;
            case ReportAction of ReportAction::SaveAsWord: clientFileName+='.docx';
            ReportAction::SaveAsExcel: begin
                clientFileName+='.xlsx';
                if IsExcelPrint then begin
                    dummyTempBlob.Blob.CreateInStream(dummyIs);
                    DownloadFromStream(dummyIs, '', '', '', dummyClientFileName); // to block printer dialog
                end;
            end;
            ReportAction::SaveAsHtml: clientFileName+='.html'
            else
            begin
#if LocalPrintService if(IsPrintService)then begin
                    CreateLocalPrintJob(ReportID, PrinterName, localPrinterName, localPrinterSetttings, is);
                    Handled:=true;
                    exit;
                end;
#endif if isLocalPrinter and (CurrentClientType() = ClientType::Web)then begin
                    dummyTempBlob.Blob.CreateInStream(dummyIs);
                    DownloadFromStream(dummyIs, '', '', '', dummyClientFileName); // to block printer dialog
                    clientFileName+='.fornavprint' end
                else
                    clientFileName+='.pdf';
            end;
            end;
            DownloadFromStream(is, '', '', '', clientFileName);
        end
        else
            CopyStream(OutStream, is);
        Handled:=true;
    end;
    procedure GetLanguageID(LanguageCode: code[10]): Integer;
    var Language: Codeunit Language;
    begin
        exit(language.GetLanguageIdOrDefault(LanguageCode));
    end;
    procedure AutoFormat(Decimal: Decimal;
    AutoFormatExpr: Text;
    AutoFormatType: Integer;
    BlankNumbers: Text): Text var autoFormatManagement: Codeunit "Auto Format";
    AutoFormat: Enum "Auto Format";
    begin
        case BlankNumbers of 'BlankNeg': if Decimal < 0 then exit('');
        'BlankNegAndZero': if Decimal <= 0 then exit('');
        'BlankZero': if Decimal = 0 then exit('');
        'BlankZeroAndPos': if Decimal >= 0 then exit('');
        'BlankPos': if Decimal > 0 then exit('');
        end;
        AutoFormat:="Auto Format".FromInteger(AutoFormatType);
        exit(Format(Decimal, 0, autoFormatManagement.ResolveAutoFormat(AutoFormat, AutoFormatExpr)));
    end; //
    procedure CreateWebService()var WebService: Record "Tenant Web Service";
    begin
        WebService."Object Type":=WebService."Object Type"::Codeunit;
        WebService."Object ID":=6189102;
        WebService."Service Name":='ForNavBc';
        WebService.Insert;
        WebService.validate(Published, true);
        WebService.Modify;
        Commit;
    end;
    procedure ToBase64String(var iStream: InStream): Text var CoreSetup: Record "ForNAV Core Setup";
    OutStream: OutStream;
    begin
        CoreSetup.Blob.CreateOutstream(OutStream);
        CopyStream(OutStream, iStream);
        exit(CoreSetup.ToBase64String);
    end;
    procedure GetForNavDataSet(InStr: InStream;
    var reportDataset: XmlElement): Boolean var xmlDoc: XmlDocument;
    readOptions: XmlReadOptions;
    begin
        readOptions.PreserveWhitespace:=true;
        XmlDocument.ReadFrom(InStr, readOptions, xmlDoc);
        XmlDoc.GetRoot(reportDataset);
        exit(Format(reportDataset).Contains('ReportForNav_'));
    end;
    local procedure GetFieldCaption(recRef: RecordRef;
    fieldRef: FieldRef)Value: Text var Translations: Codeunit "ForNAV Language Mgt.";
    begin
        if HasTranslations then begin
            Value:=Translations.GetTranslation(ReportLanguage, ReportNumber, recRef.Number, fieldRef.Number);
            if Value <> '' then exit(Value);
            Value:=Translations.GetTranslation(ReportLanguage, fieldRef.Name);
            if Value <> '' then exit(Value);
        end;
        exit(fieldRef.Caption());
    end;
    local procedure GetTableCaption(recRef: RecordRef)Value: Text var Translations: Codeunit "ForNAV Language Mgt.";
    begin
        if HasTranslations then begin
            Value:=Translations.GetTranslation(ReportLanguage, ReportNumber, recRef.Number, 0);
            if Value <> '' then exit(Value);
            Value:=Translations.GetTranslation(ReportLanguage, 0, recRef.Number, 0);
            if Value <> '' then exit(Value);
            Value:=Translations.GetTranslation(ReportLanguage, recRef.Name);
            if Value <> '' then exit(Value);
        end;
        exit(recRef.Caption());
    end;
    local procedure GetReportCaption(var allObjWithCaptions: Record AllObjWithCaption;
    Language: Integer;
    ReportNumber: Integer)Value: Text var Translations: Codeunit "ForNAV Language Mgt.";
    begin
        if Translations.HasTranslations()then begin
            Value:=Translations.GetTranslation(Language, ReportNumber, 0, 0);
            if Value <> '' then exit(Value);
            Value:=Translations.GetTranslation(Language, allObjWithCaptions."Object Name");
            if Value <> '' then exit(Value);
        end;
        exit(allObjWithCaptions."Object Caption");
    end;
    procedure SetLanguage(var jsonObj: JsonObject;
    CurrLanguageId: Integer)var allObjWithCaptions: Record AllObjWithCaption;
    begin
        AllObjWithCaptions.Get(allObjWithCaptions."Object Type"::Report, ReportNumber);
        jsonObj.Add('CurrReport$Language$Integer', CurrLanguageId);
        jsonObj.Add('CurrReport$Caption$Text', GetReportCaption(AllObjWithCaptions, CurrLanguageId, ReportNumber));
        ReportLanguage:=CurrLanguageId;
    end;
    [IntegrationEvent(false, false)]
    procedure GetLocalPrinter(CloudPrinterName: Text[250];
    var LocalPrinterName: Text;
    var PrinterSettings: Text;
    var IsPrintService: Boolean)begin
    end;
    [IntegrationEvent(false, false)]
    procedure CreateLocalPrintJob(ReportId: Integer;
    CloudPrinterName: Text[250];
    var LocalPrinterName: Text;
    var PrinterSettings: Text;
    var DocumentStream: InStream)begin
    end;
    [EventSubscriber(ObjectType::CodeUnit, Codeunit::ReportManagement, 'OnMergeDocumentReport', '', false, false)]
    local procedure OnMergeDocumentReport(ObjectType: Option "Report", "Page";
    ObjectID: Integer;
    ReportAction: Option SaveAsPdf, SaveAsWord, SaveAsExcel, Preview, Print, SaveAsHtml;
    XmlData: InStream;
    FileName: Text;
    var printDocumentStream: OutStream;
    var IsHandled: Boolean)var emailPrinters: Record "Email Printer Settings";
    begin
        if(ObjectType = ObjectType::Report) and (ReportAction = ReportAction::Print) and emailPrinters.Get(fileName)then begin
            OnBeforeMergeDocument(ObjectID, ReportAction::Print, XmlData, '', printDocumentStream, IsHandled, false);
        end;
    end;
    local procedure GetZipContents(var TempBlob: Codeunit "Temp Blob";
    Value: Text;
    var InStr: InStream): Boolean var OutStr: OutStream;
    DataCompression: Codeunit "Data Compression";
    ZipEntryList: List of[Text];
    ZipEntryLength: Integer;
    begin
        DataCompression.OpenZipArchive(InStr, false);
        TempBlob.CreateOutStream(OutStr);
        DataCompression.GetEntryList(ZipEntryList);
        if not ZipEntryList.Contains(Value)then exit(false);
        DataCompression.ExtractEntry(Value, OutStr, ZipEntryLength);
        exit(true);
    end;
    local procedure IsForNAVWordReport(ID: Integer): Boolean var layoutStream: InStream;
    bt: BigText;
    TempBlob: Codeunit "Temp Blob";
    begin
        if ID < 50000 then exit(false);
        if(ID >= 6188471) and (ID <= 6189471)then exit(true);
        if not Report.WordLayout(ID, layoutStream)then exit(false);
        if not GetZipContents(tempBlob, 'docProps/custom.xml', layoutStream)then exit(false);
        TempBlob.CreateInStream(layoutStream);
        bt.Read(layoutStream);
        exit(bt.TextPos('name="DataContract"') <> 0);
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Reporting Triggers", 'OnDocumentPrintReady', '', false, false)]
    local procedure OnDocumentPrintReady(ObjectType: Option "Report", "Page";
    ObjectID: Integer;
    ObjectPayload: JsonObject;
    DocumentStream: InStream;
    var Success: Boolean);
    var FileName, ObjectName: Text;
    PrinterName, localPrinterName, localPrinterSetttings: Text;
    PrinterNameToken, ObjectNameToken: JsonToken;
    reportDataset: XmlElement;
    Service: Codeunit "ForNAV Report Service";
    JsonDataSet, pfdBase64: Text;
    CoreSetup: Record "ForNAV Core Setup";
    is: InStream;
    Base64Convert: Codeunit "Base64 Convert";
    IsPrintService: Boolean;
    begin
        if ObjectType = ObjectType::Report then if not IsForNAVWordReport(ObjectID)then begin
                ObjectPayload.Get('printername', PrinterNameToken);
                PrinterName:=PrinterNameToken.AsValue().AsText();
                GetLocalPrinter(PrinterName, localPrinterName, localPrinterSetttings, IsPrintService);
                if localPrinterName <> '' then begin
#if LocalPrintService if(IsPrintService)then CreateLocalPrintJob(ObjectID, PrinterName, localPrinterName, localPrinterSetttings, DocumentStream)
                    else
#endif begin
                        pfdBase64:=Base64Convert.ToBase64(DocumentStream);
                        JsonDataSet:=GetJsonDataSet(ObjectID, 'EncodePdf', reportDataset, localPrinterName, localPrinterSetttings, pfdBase64);
                        Service.Call(JsonDataSet, CoreSetup);
                        CoreSetup.Blob.CreateInStream(is);
                        ObjectPayload.Get('objectname', ObjectNameToken);
                        ObjectName:=ObjectNameToken.AsValue().AsText();
                        FileName+=ObjectName + '.fornavprint';
                        DownloadFromStream(is, '', '', '', FileName);
                    end;
                    Success:=true;
                end;
            end;
    end;
    var ExcelPrinterName: Label 'Excel - ForNAV';
    [EventSubscriber(ObjectType::Codeunit, CodeUnit::ReportManagement, 'OnAfterSetupPrinters', '', false, false)]
    local procedure OnAfterSetupPrinters(var Printers: Dictionary of[Text[250], JsonObject]);
    var PayLoad: JsonObject;
    begin
        if not Printers.ContainsKey(ExcelPrinterName)then begin
            PayLoad.ReadFrom('{ "version":1, "papertrays": [ { "papersourcekind":"Upper", "paperkind":"A4"  }  ] }');
            Printers.Add(ExcelPrinterName, PayLoad);
        end;
    end;
}
