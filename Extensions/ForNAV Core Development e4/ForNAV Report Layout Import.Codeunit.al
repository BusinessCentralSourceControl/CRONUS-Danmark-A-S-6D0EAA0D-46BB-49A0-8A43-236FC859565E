codeunit 6188504 "ForNAV Report Layout Import"
{
    trigger OnRun()begin
        ImportLayout;
    end;
    local procedure ImportLayout()var ImportWorksheet: Record "ForNAV Layout Import Worksheet" temporary;
    TempBlobList: Codeunit "Temp Blob List";
    Contents: Text;
    begin
        Contents:=GetJsonFromZipFile(TempBlobList);
        if Contents = '' then exit;
        CreateImportWorksheet(ImportWorksheet, Contents, TempBlobList);
        ShowImportMessageAndOpenWorksheet(ImportWorksheet);
    end;
    procedure ExecuteWorksheet(var ImportWorksheet: Record "ForNAV Layout Import Worksheet")begin
        ImportWorksheet.findset;
        repeat case ImportWorksheet."Import Action" of ImportWorksheet."Import Action"::Create: ImportWorksheet.CreateLayout;
            ImportWorksheet."Import Action"::Replace: ImportWorksheet.ReplaceLayout;
            end;
        until ImportWorksheet.next = 0;
    end;
    local procedure CreateImportWorksheet(var ImportWorksheet: Record "ForNAV Layout Import Worksheet";
    Contents: Text;
    TempBlobList: Codeunit "Temp Blob List")var TempBlob: Codeunit "Temp Blob";
    OutStr: OutStream;
    InStr: InStream;
    JsonArr: JsonArray;
    JsonRow: JsonToken;
    JsonField: JsonToken;
    i: Integer;
    ReportManagement: Codeunit "ForNAV Report Management";
    LayoutFormatError: Label 'The layout needs to be upgraded in order to import. Please load and save the layout using the ForNAV designer before exporting the layout';
    begin
        JsonArr.ReadFrom(Contents);
        foreach JsonRow in JsonArr do begin
            JsonRow.AsObject().Get('reportID', JsonField);
            ImportWorksheet."Report ID":=JsonField.AsValue.AsInteger;
            JsonRow.AsObject().Get('description', JsonField);
            ImportWorksheet.Description:=JsonField.AsValue.AsText;
            JsonRow.AsObject().Get('reportName', JsonField);
            ImportWorksheet."Report Name":=JsonField.AsValue.AsText;
            JsonRow.AsObject().Get('customReportLayoutCode', JsonField);
            ImportWorksheet."Custom Layout Code":=JsonField.AsValue.AsCode;
            ImportWorksheet.SetDefaultAction;
            ImportWorksheet.Blob.CreateOutStream(OutStr);
            i+=1;
            TempBlobList.Get(i, TempBlob);
            if not ReportManagement.ConvertLayout(TempBlob)then Error(LayoutFormatError);
            TempBlob.CreateInStream(InStr);
            CopyStream(OutStr, InStr);
            ImportWorksheet.Insert;
        end;
    end;
    local procedure ShowImportMessageAndOpenWorksheet(var ImportWorksheet: Record "ForNAV Layout Import Worksheet")begin
        Commit;
        page.RunModal(page::"ForNAV Layout Import Worksheet", ImportWorksheet)end;
    local procedure GetJsonFromZipFile(var TempBlobList: Codeunit "Temp Blob List")Contents: Text;
    var FileMgt: Codeunit "File Management";
    TempBlob: Codeunit "Temp Blob";
    DataCompression: Codeunit "Data Compression";
    InStr: InStream;
    OutStr: OutStream;
    EntryList: List of[Text];
    ZipEntry: Text;
    Len: Integer;
    begin
        if FileMgt.BLOBImportWithFilter(TempBlob, 'Import ForNAV Layouts', '*.fornavlayouts', 'ForNAV Layouts (*.fornavlayouts)|*.fornavlayouts', 'ForNAV Layouts (*.fornavlayouts)|*.fornavlayouts') = '' then exit;
        TempBlob.CreateInStream(InStr);
        DataCompression.OpenZipArchive(InStr, false);
        DataCompression.GetEntryList(EntryList);
        foreach ZipEntry in EntryList do if ZipEntry.EndsWith('.fornavreport')then AddZipToTempBlob(ZipEntry, DataCompression, TempBlobList);
        Clear(TempBlob);
        TempBlob.CreateOutStream(OutStr);
        DataCompression.ExtractEntry('contents.json', OutStr, Len);
        TempBlob.CreateInStream(InStr);
        InStr.ReadText(Contents);
    end;
    local procedure AddZipToTempBlob(EntryName: Text;
    var DataCompression: Codeunit "Data Compression";
    var TempBlobList: Codeunit "Temp Blob List")var TempBlob: Codeunit "Temp Blob";
    OutStr: OutStream;
    i: Integer;
    begin
        TempBlob.CreateOutStream(OutStr);
        DataCompression.ExtractEntry(EntryName, OutStr, i);
        TempBlobList.Add(TempBlob);
    end;
    local procedure TestZipContents(var TempBlob: Codeunit "Temp Blob")var DataCompression: Codeunit "Data Compression";
    InStr: InStream;
    EntryList: List of[Text];
    ZipEntry: Text;
    begin
        TempBlob.CreateInStream(InStr);
        DataCompression.OpenZipArchive(InStr, false);
        DataCompression.GetEntryList(EntryList);
        foreach ZipEntry in EntryList do Message(ZipEntry);
    end;
}
