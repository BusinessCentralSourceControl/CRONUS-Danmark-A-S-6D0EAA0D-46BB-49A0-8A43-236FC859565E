codeunit 6188503 "ForNAV Report Layout Export"
{
    procedure ExportLayout(var ReportLayout: Record "ForNAV Report Layout")var TempBlob: Codeunit "Temp Blob";
    FileMgt: Codeunit "File Management";
    begin
        ExportLayout(ReportLayout, TempBlob);
        FileMgt.BLOBExport(TempBlob, '*.fornavlayouts', true);
    end;
    procedure ExportLayout(var ReportLayout: Record "ForNAV Report Layout";
    var TempBlob: Codeunit "Temp Blob")var DataCompression: Codeunit "Data Compression";
    Layouts: List of[Text];
    begin
        ReportLayout.SetRange("Built-in", false);
        ReportLayout.FindSet;
        CreateZip(DataCompression);
        repeat GetLayoutBlob(ReportLayout."Custom Report Layout Code", TempBlob);
            if TempBlob.HasValue then begin
                AddLayoutToZip(ReportLayout."Custom Report Layout Code" + '.fornavreport', DataCompression, TempBlob);
                Layouts.Add(ReportLayout."Custom Report Layout Code");
            end;
        until ReportLayout.Next = 0;
        GetJsonToBlob(ReportLayout, TempBlob, Layouts);
        AddLayoutToZip('contents.json', DataCompression, TempBlob);
        GetCsvToBlob(ReportLayout, TempBlob, Layouts);
        AddLayoutToZip('contents.csv', DataCompression, TempBlob);
        WriteZip(DataCompression, TempBlob);
        ReportLayout.SetRange("Built-in");
    end;
    local procedure GetJsonToBlob(var ReportLayout: Record "ForNAV Report Layout";
    var TempBlob: Codeunit "Temp Blob";
    var Layouts: List of[Text]);
    var OutStr: OutStream;
    JsonArr: JsonArray;
    JsonObj: JsonObject;
    InStr: InStream;
    begin
        ReportLayout.FindSet;
        repeat if Layouts.Contains(ReportLayout."Custom Report Layout Code")then begin
                Clear(JsonObj);
                JsonObj.Add('reportID', ReportLayout."Report ID");
                JsonObj.Add('reportName', ReportLayout.GetName);
                JsonObj.Add('description', ReportLayout.Description);
                JsonObj.Add('customReportLayoutCode', ReportLayout."Custom Report Layout Code");
                JsonArr.Add(JsonObj);
            end;
        until ReportLayout.Next = 0;
        Clear(TempBlob);
        TempBlob.CreateOutStream(OutStr);
        OutStr.WriteText(Format(JsonArr));
        TempBlob.CreateInStream(InStr);
        CopyStream(OutStr, InStr)end;
    local procedure GetCsvToBlob(var ReportLayout: Record "ForNAV Report Layout";
    var TempBlob: Codeunit "Temp Blob";
    var Layouts: List of[Text]);
    var CSVBuffer: Record "CSV Buffer" temporary;
    n: Integer;
    OutStr: OutStream;
    InStr: InStream;
    begin
        ReportLayout.FindSet;
        repeat if Layouts.Contains(ReportLayout."Custom Report Layout Code")then begin
                n+=1;
                CSVBuffer.InsertEntry(n, 1, Format(ReportLayout."Report ID"));
                CSVBuffer.InsertEntry(n, 2, ReportLayout.GetName);
                CSVBuffer.InsertEntry(n, 3, ReportLayout.Description);
                CSVBuffer.InsertEntry(n, 4, ReportLayout."Custom Report Layout Code");
            end;
        until ReportLayout.Next = 0;
        Clear(TempBlob);
        CSVBuffer.SaveDataToBlob(TempBlob, ';');
    end;
    local procedure GetLayoutBlob(Code: Code[20];
    var TempBlob: Codeunit "Temp Blob")var CustRepLayout: Record "Custom Report Layout";
    begin
        Clear(TempBlob);
        CustRepLayout.Get(Code);
        CustRepLayout.GetLayoutBlob(TempBlob);
    end;
    local procedure CreateZip(var DataCompression: Codeunit "Data Compression")begin
        DataCompression.CreateZipArchive();
    end;
    local procedure AddLayoutToZip(Value: Text;
    var DataCompression: Codeunit "Data Compression";
    var TempBlob: Codeunit "Temp Blob")var InStr: InStream;
    begin
        TempBlob.CreateInStream(InStr);
        DataCompression.AddEntry(InStr, Value);
    end;
    local procedure WriteZip(var DataCompression: Codeunit "Data Compression";
    var TempBlob: Codeunit "Temp Blob")begin
        DataCompression.SaveZipArchive(TempBlob);
    end;
}
