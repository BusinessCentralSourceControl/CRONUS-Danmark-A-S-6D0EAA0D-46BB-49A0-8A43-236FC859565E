codeunit 6189104 "ForNAV Document Archive Mgt."
{
    Permissions = tabledata "ForNAV Document Archive"=rmi,
        tabledata "ForNAV Document History"=ri,
        tabledata "ForNAV Document Archive Setup"=rmid;

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
    local procedure Archive(var archiveCollection: List of[Integer])var archiveId: Integer;
    DataCompression: Codeunit "Data Compression";
    TempBlob: Codeunit "Temp Blob";
    is: InStream;
    os: OutStream;
    clientFileName: Text;
    hasEntries: Boolean;
    documentHistory: Record "ForNAV Document History";
    documentArchive: Record "ForNAV Document Archive";
    documentType: Integer;
    begin
        DataCompression.CreateZipArchive();
        documentArchive.SetAutoCalcFields(Document);
        foreach archiveId in archiveCollection do begin
            documentArchive.Get(archiveId);
            if documentArchive.Document.HasValue then begin
                hasEntries:=true;
                documentArchive.Document.CreateInStream(is);
                documentType:=documentArchive."Document Type";
                if(documentArchive."Document Type" = documentArchive."Document Type"::preview) or (documentArchive."Document Type" = documentArchive."Document Type"::print)then documentArchive."Document Type":=documentArchive."Document Type"::pdf;
                DataCompression.AddEntry(is, UrlEncode(documentArchive."Report Name") + '/' + UrlEncode(StrSubstNo('%1 %2.%3', documentArchive.Created, documentArchive."User ID", documentArchive."Document Type")));
                documentHistory.Create(archiveId, documentHistory."Archive Action"::Downloaded);
                documentArchive.Downloaded:=true;
                documentArchive."Document Type":=documentType;
                documentArchive.Modify();
            end;
        end;
        if hasEntries then begin
            TempBlob.CreateOutStream(os);
            DataCompression.SaveZipArchive(os);
            TempBlob.CreateInStream(is);
            clientFileName:=StrSubstNo('Document Archive %1.zip', CurrentDateTime);
            DownloadFromStream(is, '', '', '', clientFileName);
        end;
        DataCompression.CloseZipArchive();
    end;
    local procedure Purge(var archiveCollection: List of[Integer])var archiveId: Integer;
    documentHistory: Record "ForNAV Document History";
    documentArchive: Record "ForNAV Document Archive";
    begin
        foreach archiveId in archiveCollection do begin
            documentArchive.Get(archiveId);
            Clear(documentArchive.Document);
            documentArchive.Purged:=true;
            documentHistory.Create(archiveId, documentHistory."Archive Action"::Purged);
            documentArchive.Modify();
        end;
    end;
    local procedure SetAction(var documentArchive: Record "ForNAV Document Archive";
    action: Enum "ForNAV Document History Type")begin
        case action of action::Purged: documentArchive.Purged:=true;
        action::Downloaded: documentArchive.Downloaded:=true;
        end;
        documentArchive.Modify();
    end;
    procedure ArchiveAction(var selected: Record "ForNAV Document Archive";
    action: Enum "ForNAV Document History Type")var archiveCollection: List of[Integer];
    DateTimeZero: DateTime;
    documentArchive: Record "ForNAV Document Archive";
    archiveId: Integer;
    goahead: Boolean;
    goaheadlabel: Label 'Some of the selected documents have not been archived. Do you want to continue?';
    created: DateTime;
    begin
        if selected.FindFirst()then begin
            repeat case selected.Indent of 0, 1, 2: begin
                    documentArchive.SetRange(documentArchive."Report ID", selected."Report ID");
                    if selected.Indent <> 0 then documentArchive.SetRange(documentArchive.Year, selected.Year);
                    if selected.Indent = 2 then documentArchive.SetRange(documentArchive.Month, selected.Month);
                    documentArchive.SetRange(documentArchive.Indent, 3);
                    if documentArchive.FindFirst()then repeat if not archiveCollection.Contains(documentArchive."Archive ID")then archiveCollection.Add(documentArchive."Archive ID");
                        until documentArchive.Next <> 1;
                    documentArchive.Reset();
                end;
                3: if not archiveCollection.Contains(selected."Archive ID")then archiveCollection.Add(selected."Archive ID");
                end;
            until selected.Next() <> 1;
        end;
        if action = action::Purged then begin
            foreach archiveId in archiveCollection do begin
                documentArchive.Get(archiveId);
                if not documentArchive.Downloaded then if Confirm(goaheadlabel, false)then goahead:=true
                    else
                        exit;
            end;
        end;
        documentArchive.Reset();
        case action of action::Purged: begin
            Purge(archiveCollection);
            documentArchive.SetRange(documentArchive.Purged, false)end;
        action::Downloaded: begin
            Archive(archiveCollection);
            documentArchive.SetRange(documentArchive.Downloaded, false)end;
        end;
        foreach archiveId in archiveCollection do begin
            documentArchive.Get(archiveId);
            created:=documentArchive.Created;
            documentArchive.SetRange(documentArchive."Report ID", documentArchive."Report ID");
            documentArchive.SetRange(documentArchive.Year, Date2DMY(Variant2Date(created), 3));
            documentArchive.SetRange(documentArchive.Month);
            documentArchive.SetRange(documentArchive.Indent, 3);
            if not documentArchive.FindFirst()then begin
                documentArchive.SetRange(documentArchive.Indent, 1);
                if documentArchive.FindFirst()then SetAction(documentArchive, action);
            end;
            documentArchive.SetRange(documentArchive.Indent, 3);
            documentArchive.SetRange(documentArchive.Month, Date2DMY(Variant2Date(created), 2));
            if not documentArchive.FindFirst()then begin
                documentArchive.SetRange(documentArchive.Indent, 2);
                if documentArchive.FindFirst()then SetAction(documentArchive, action);
            end;
        end;
    end;
    procedure WriteToArchiveInternal(ReportID: Integer;
    ReportAction: Option SaveAsPdf, SaveAsWord, SaveAsExcel, Preview, Print, SaveAsHtml;
    copies: Integer;
    var archiveKeyWords: Text;
    is: InStream)var documentArchive: Record "ForNAV Document Archive";
    allObjWithCaption: Record AllObjWithCaption;
    archiveHistory: Record "ForNAV Document History";
    os: OutStream;
    keyWordList: List of[Text];
    tab: Text[9];
    index: Integer;
    keyWords: Text;
    keyWord: Text;
    begin
        documentArchive."Report ID":=ReportID;
        allObjWithCaption.Get(ObjectType::Report, ReportId);
        documentArchive."Report Name":=allObjWithCaption."Object Caption";
        documentArchive.SetRange(documentArchive."Report ID", ReportID);
        if not documentArchive.FindFirst()then begin
            documentArchive."Archive ID":=0;
            documentArchive.Insert();
        end;
        documentArchive.Year:=Date2DMY(Today, 3);
        documentArchive.SetRange(documentArchive.Year, documentArchive.Year);
        if not documentArchive.FindFirst()then begin
            documentArchive."Archive ID":=0;
            documentArchive.Indent:=1;
            documentArchive.Insert();
        end
        else
        begin
            documentArchive.Downloaded:=false;
            documentArchive.Purged:=false;
            documentArchive.Modify();
        end;
        documentArchive.Month:=Date2DMY(Today, 2);
        documentArchive.SetRange(documentArchive.Month, documentArchive.Month);
        if not documentArchive.FindFirst()then begin
            documentArchive."Archive ID":=0;
            documentArchive.Indent:=2;
            documentArchive.Insert();
        end
        else
        begin
            documentArchive.Downloaded:=false;
            documentArchive.Purged:=false;
            documentArchive.Modify();
        end;
        case ReportAction of ReportAction::Preview: documentArchive."Document Type":=documentArchive."Document Type"::preview;
        ReportAction::Print: documentArchive."Document Type":=documentArchive."Document Type"::print;
        ReportAction::SaveAsPdf: documentArchive."Document Type":=documentArchive."Document Type"::pdf;
        ReportAction::SaveAsWord: documentArchive."Document Type":=documentArchive."Document Type"::docx;
        ReportAction::SaveAsExcel: documentArchive."Document Type":=documentArchive."Document Type"::xlsx;
        ReportAction::SaveAsHtml: documentArchive."Document Type":=documentArchive."Document Type"::html;
        end;
        documentArchive.Copies:=copies;
        if archiveKeyWords <> '' then begin
            tab[1]:=9;
            keyWordList:=archiveKeyWords.Split(tab);
            index:=StrPos(archiveKeyWords, ':');
            foreach keyWord in keyWordList do begin
                // if keyWords = '' then
                //     keyWords := keyWord
                // else
                //     keyWords := keyWords + ';' + CopyStr(keyWord, index + 2);
                keyWords:=keyWords + CopyStr(keyWord, index + 2) + ';';
            end;
        end;
        if Strlen(keyWords) > 2000 then documentArchive.KeyWords:=CopyStr(keyWords, 1, 2000)
        else
            documentArchive.KeyWords:=keyWords;
        documentArchive.Created:=CurrentDateTime();
        documentArchive.Document.CreateOutStream(os);
        CopyStream(os, is);
        documentArchive."User ID":=Database.UserId;
        documentArchive."Archive ID":=0;
        documentArchive.Indent:=3;
        documentArchive.Insert();
        documentArchive.FindLast();
        archiveHistory.Create(documentArchive."Archive ID", archiveHistory."Archive Action"::Created);
    end;
    procedure WriteToArchive(ReportID: Integer;
    ReportAction: Option SaveAsPdf, SaveAsWord, SaveAsExcel, Preview, Print, SaveAsHtml;
    copies: Integer;
    var archiveKeyWords: Text;
    is: InStream): Boolean begin
        if GetArchiveSetup(ReportID)then begin
            WriteToArchiveInternal(ReportID, ReportAction, copies, archiveKeyWords, is);
            exit(true);
        end
        else
            exit(false);
    end;
    procedure SetArchiveSetup(reportId: Integer;
    archive: Boolean)var archiveSetup: Record "ForNAV Document Archive Setup";
    exists: Boolean;
    begin
        exists:=archiveSetup.Get(reportId);
        if archive and not exists then begin
            archiveSetup."Report ID":=reportId;
            archiveSetup.Insert();
        end
        else if not archive and exists then archiveSetup.Delete();
    end;
    procedure GetArchiveSetup(reportId: Integer): Boolean var documentArchiveSetup: Record "ForNAV Document Archive Setup";
    begin
        if documentArchiveSetup.Get(0)then exit(true)
        else if documentArchiveSetup.Get(ReportID)then exit(true)
            else
                exit(false);
    end;
    procedure GetArchiveSetup(reportId: Integer;
    var count: Integer): Boolean var archive: Record "ForNAV Document Archive";
    begin
        count:=0;
        if not GetArchiveSetup(reportId)then exit(false);
        archive.SetRange(Indent, 3);
        archive.SetRange("Report ID", reportId);
        count:=archive.Count();
        exit(true);
    end;
// procedure GetArchiveSetup(ReportId: Integer; var Details: Text)
// var
//     Archive: Record "ForNAV Document Archive";
//     Cnt: Integer;
// begin
//     GetArchiveSetup(ReportId, Cnt);
//     if Cnt > 0 then
//         Details := Format(Cnt) + ' (Copies)';
//     if Cnt = 0 then
//         if GetArchiveSetup(ReportId) then
//             Details := 'Enabled, never used'
//         else
//             Details := 'Click to enable Archive'
// end;
}
