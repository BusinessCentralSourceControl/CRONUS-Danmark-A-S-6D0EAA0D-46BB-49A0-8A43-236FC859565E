codeunit 6189102 "ForNAV Cloud Web Service"
{
    TableNo = "ForNAV Core Setup";

    procedure GetLayoutByName(reportName: Text;
    var layout: Text;
    var layoutType: Integer): Boolean var allObj: Record AllObj;
    begin
        layout:='';
        layoutType:=0;
        allObj.SetRange("Object Type", allObj."Object Type"::Report);
        allObj.SetRange("Object Name", reportName);
        if allObj.FindFirst()then exit(GetLayoutById(allObj."Object ID", layout, layoutType))
        else
            exit(false);
    end;
    procedure GetLayoutById(reportId: Integer;
    var layout: Text;
    var layoutType: Integer): Boolean var reportLayoutSelection: Record "Report Layout Selection";
    customReportLayout: Record "Custom Report Layout";
    is: InStream;
    os: OutStream;
    tempBlob: Record "ForNAV Core Setup";
    begin
        layout:='';
        layoutType:=0;
        if reportLayoutSelection.Get(reportId, CompanyName) and (reportLayoutSelection.Type = reportLayoutSelection.Type::"Custom Layout")then begin
            if customReportLayout.Get(reportLayoutSelection."Custom Report Layout Code") and (customReportLayout.Type = customReportLayout.Type::Word)then begin
                customReportLayout.CalcFields(Layout);
                if customReportLayout.Layout.HasValue then begin
                    tempBlob.Blob:=customReportLayout.Layout;
                    layout:=tempBlob.ToBase64String();
                    layoutType:=2; // Word
                    exit(true);
                end;
            end;
        end;
        if Report.WordLayout(reportId, is)then begin
            tempBlob.Blob.CreateOutStream(os);
            CopyStream(os, is);
            layout:=tempBlob.ToBase64String();
            layoutType:=2; // Word
            exit(true);
        end;
        exit(false);
    end;
    procedure ClearReportLayoutSelection(reportNo: Integer)var layoutSelection: Record "Report Layout Selection";
    begin
        layoutSelection.SetRange(layoutSelection."Report ID", reportNo);
        layoutSelection.DeleteAll;
    end;
    procedure SaveLayout("Code": Code[20];
    "Report ID": Integer;
    "Company Name": Text;
    Base64Layout: Text;
    var ServerMessge: Text;
    DesignerBuild: Integer;
    ActivateLayout: Boolean): Boolean var "layout": Text;
    tmpBlob: Record "ForNAV Core Setup";
    customLayout: Record "Custom Report Layout";
    xmlBlob: Record "ForNAV Core Setup";
    is: InStream;
    os: OutStream;
    isNew: Boolean;
    layoutSelection: Record "Report Layout Selection";
    begin
        // Save the layout to the 9650 Custom Report Layout
        tmpBlob.FromBase64String(Base64Layout);
        // Check if the code is blank
        if code = '' then error('Code cannot be blank when you save a layout.');
        if customLayout.Get(Code)then isNew:=false
        else
            isNew:=true;
        // Create custom layout if code is blank
        if isNew then begin
            customLayout.Init;
            customLayout.Code:=Code;
            customLayout."Report ID":="Report ID";
            customLayout."Company Name":="Company Name";
            customLayout.Type:=customLayout.Type::Word;
            if ActivateLayout then customLayout.Description:='ForNAV Custom Layout'
            else
                customLayout.Description:='ForNAV BC preview (report ' + Format("Report ID") + ') ' + GetTimeStamp;
        end;
        customLayout."Last Modified by User":=UserId;
        customLayout."Last Modified":=CreateDateTime(Today, Time);
        // Make sure the custom layout exist before importing a new layout
        if isNew then customLayout.Insert(true)
        else
            customLayout.Modify(true);
        customLayout.Layout:=tmpBlob.Blob;
        //customLayout.SetLayoutBlob(tmpBlob);
        customLayout.SetDefaultCustomXmlPart();
        customLayout.Modify(true);
        // Make sure there is a record in the layout selection table for this report
        if not layoutSelection.Get("Report ID", "Company Name")then begin
            layoutSelection.Init();
            layoutSelection."Report ID":="Report ID";
            layoutSelection.Type:=layoutSelection.Type::"Word (built-in)";
            layoutSelection.Insert(true);
        end;
        // Activate layout
        if ActivateLayout then begin
            layoutSelection.Get("Report ID", "Company Name");
            layoutSelection."Custom Report Layout Code":=Code;
            layoutSelection.Type:=layoutSelection.Type::"Custom Layout";
            layoutSelection.Modify(true);
        end;
        Commit;
        // If the code is blank a new one is created
        ServerMessge:='Success updating custom layout ' + Code;
        exit(true);
    end;
    procedure DownloadBuiltinLayout(reportNo: Integer;
    var base64Layout: Text): Boolean var iStream: InStream;
    forNAVReportManagement: Codeunit "ForNAV Report Management";
    begin
        if Report.WordLayout(reportNo, iStream)then begin
            base64Layout:=forNAVReportManagement.ToBase64String(iStream);
            exit(true);
        end
        else
            exit(false);
    end;
    local procedure GetTimeStamp(): Text begin
        exit(Format(Time, 0, 9) + ' | ' + Format(Today, 0, 9));
    end;
    procedure DownloadApp(appId: Guid;
    var base64App: text): Boolean var ExtensionMgt: Codeunit "Extension Management";
    TempBlob: Codeunit "Temp Blob";
    Ok: Boolean;
    InsStr: InStream;
    Base64: Codeunit "Base64 Convert";
    InstalledApp: Record "NAV App Installed App";
    begin
        if InstalledApp.Get(appId)then begin
            Ok:=ExtensionMgt.GetExtensionSource(InstalledApp."Package ID", TempBlob);
            if Ok then begin
                TempBlob.CreateInStream(InsStr);
                Base64App:=Base64.ToBase64(InsStr);
                exit(true);
            end;
        end;
    end;
    procedure UploadApp(paramAppId: Guid;
    Base64App: Text;
    var ServerMessage: Text): Boolean var CoreSetup: Record "ForNAV Core Setup";
    InstalledApp: Record "NAV App Installed App";
    begin
        if InstalledApp.Get(paramAppId)then CoreSetup."Primary Key":='1';
        CoreSetup.FromBase64String(Base64App);
        if Codeunit.Run(Codeunit::"ForNAV Cloud Web Service", CoreSetup)then exit(true)
        else
        begin
            ServerMessage:=GetLastErrorText();
            exit(false);
        end;
    end;
    trigger OnRun()var InStr: InStream;
    ExtensionMgt: Codeunit "Extension Management";
    begin
        Rec.Blob.CreateInStream(InStr);
        if Rec."Primary Key" <> '' then ExtensionMgt.UploadExtensionToVersion(InStr, 1033, "Extension Deploy To"::"Next minor version")
        else
            ExtensionMgt.UploadExtension(InStr, 1033);
    end;
}
