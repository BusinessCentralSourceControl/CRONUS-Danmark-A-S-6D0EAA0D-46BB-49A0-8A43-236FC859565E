codeunit 6189181 "ForNAV Check Is ForNAV Report"
{
    procedure GetAllForNAVReports(var ReportObject: Record "ForNAV Report Object")begin
        GetAllForNAVReports(ReportObject, 50000, 98999999);
    end;
    procedure GetAllForNAVReports(var ReportObject: Record "ForNAV Report Object";
    FromReportID: Integer;
    ToReportID: Integer)var AllObjWithCaption: Record AllObjWithCaption;
    begin
        ForNAVFirstTimeSetup();
        AllObjWithCaption.SetRange(AllObjWithCaption."Object ID", FromReportID, ToReportID);
        AllObjWithCaption.SetRange(AllObjWithCaption."Object Type", AllObjWithCaption."object type"::Report);
        if AllObjWithCaption.FindSet then repeat if IsForNAVReport(AllObjWithCaption."Object ID")then begin
                    ReportObject.ID:=AllObjWithCaption."Object ID";
                    ReportObject.Name:=CopyStr(AllObjWithCaption."Object Caption", 1, 50);
                    ReportObject.Insert;
                end;
            until AllObjWithCaption.Next = 0;
    end;
    procedure GetZipContents(var TempBlob: Codeunit "Temp Blob";
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
    procedure IsForNAVReport(ID: Integer): Boolean begin
        exit(IsForNAVWordReport(ID));
    end;
    procedure IsForNAVWordReport(ID: Integer): Boolean var layoutStream: InStream;
    bt: BigText;
    TempBlob: Codeunit "Temp Blob";
    begin
        if not Report.WordLayout(ID, layoutStream)then exit(false);
        if not GetZipContents(tempBlob, 'docProps/custom.xml', layoutStream)then exit(false);
        TempBlob.CreateInStream(layoutStream);
        bt.Read(layoutStream);
        exit(bt.TextPos('name="DataContract"') <> 0);
    end;
    procedure IsForNAVRdlcReport(ID: Integer): Boolean var TempBlob: Record "ForNAV Language Setup";
    InStr: InStream;
    bt: BigText;
    rdlc: Text;
    begin
        if not Report.RdlcLayout(ID, InStr)then exit(false);
        bt.Read(InStr);
        rdlc:=Format(bt);
        if not(StrPos(rdlc, '<Description>') > 0)then exit(false);
        TempBlob.Blob.CreateInStream(InStr);
        exit(true);
    end;
    [IntegrationEvent(false, false)]
    local procedure ForNAVFirstTimeSetup()begin
    end;
}
