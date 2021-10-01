codeunit 6188505 "ForNAV Report Layout Mgt."
{
    procedure CreateBuffer(var ReportLayout: Record "ForNAV Report Layout")var CustRepLayout: Record "Custom Report Layout";
    RepLaySel: Record "Report Layout Selection";
    IsForNAVReport: Codeunit "ForNAV Check Is ForNAV Report";
    AllObjWithCaption: Record AllObjWithCaption;
    ID: Integer;
    begin
        if ReportLayout.GetFilter(ReportLayout."Report ID") <> '' then begin
            CustRepLayout.SetFilter("Report ID", ReportLayout.GetFilter(ReportLayout."Report ID"));
            if Evaluate(ID, ReportLayout.GetFilter(ReportLayout."Report ID"))then begin
                ReportLayout.Init;
                ReportLayout."Entry No."+=1;
                ReportLayout."Report ID":=ID;
                AllObjWithCaption.Get(AllObjWithCaption."Object Type"::Report, ID);
                ReportLayout.Name:=AllObjWithCaption."Object Caption";
                ReportLayout."Custom Report Layout Code":='BUILT-IN ' + Format(ReportLayout."Report ID");
                ReportLayout.Description:='Built-In Layout';
                ReportLayout.Activated:=true;
                ReportLayout."Built-in":=true;
                ReportLayout.Insert;
                RepLaySel.SetRange("Report ID", ReportLayout."Report ID");
                RepLaySel.SetRange("Company Name", CompanyName);
                if RepLaySel.IsEmpty then RepLaySel.SetFilter("Company Name", '%1', '');
                if RepLaySel.FindFirst then ReportLayout.Activated:=false;
                ReportLayout.Modify;
            end;
        end;
        CustRepLayout.SetFilter("Company Name", '%1|%2', '', CompanyName);
        if CustRepLayout.FindSet then repeat if IsForNAVReport.IsForNAVReport(CustRepLayout."Report ID")then begin
                    ReportLayout.Init;
                    ReportLayout."Entry No."+=1;
                    ReportLayout."Report ID":=CustRepLayout."Report ID";
                    AllObjWithCaption.Get(AllObjWithCaption."Object Type"::Report, ReportLayout."Report ID");
                    ReportLayout.Name:=AllObjWithCaption."Object Caption";
                    ReportLayout."Custom Report Layout Code":=CustRepLayout.Code;
                    ReportLayout.Description:=CustRepLayout.Description;
                    ReportLayout.Insert;
                    RepLaySel.SetRange("Report ID", ReportLayout."Report ID");
                    RepLaySel.SetRange("Company Name", CompanyName);
                    if RepLaySel.IsEmpty then RepLaySel.SetFilter("Company Name", '%1', '');
                    if RepLaySel.FindFirst then ReportLayout.Activated:=ReportLayout."Custom Report Layout Code" = RepLaySel."Custom Report Layout Code";
                    ReportLayout.Modify;
                end;
            until CustRepLayout.Next = 0;
    end;
    procedure CloneDefaultLayout(ReportID: Integer)var AllObjWithCaption: Record AllObjWithCaption;
    CustRepLayout: Record "Custom Report Layout";
    TempBlob: Codeunit "Temp Blob";
    InStr: InStream;
    OutStr: OutStream;
    BuiltInTxt: Label 'Built-in layout';
    CopyOfTxt: Label 'Copy of %1';
    begin
        AllObjWithCaption.Get(AllObjWithCaption."Object Type"::Report, ReportID);
        CustRepLayout.Init();
        CustRepLayout."Report ID":=ReportID;
        CustRepLayout.Type:=CustRepLayout.Type::Word;
        CustRepLayout.Description:=CopyStr(StrSubstNo(CopyOfTxt, BuiltInTxt), 1, MaxStrLen(AllObjWithCaption."Object Caption"));
        CustRepLayout."Built-In":=false;
        CustRepLayout.Code:=StrSubstNo('%1-000001', ReportID);
        CustRepLayout.Insert(true);
        TempBlob.CreateOutStream(OutStr);
        if REPORT.WordLayout(ReportID, InStr)then CopyStream(OutStr, InStr);
        CustRepLayout.SetLayoutBlob(TempBlob);
        CustRepLayout.Modify;
    end;
    procedure ClearAllForNAVLayouts()var CustRepLayout: Record "Custom Report Layout";
    RepLayoutSelection: Record "Report Layout Selection";
    begin
        CustRepLayout.SetRange("Report ID", 6188471, 6189470);
        CustRepLayout.DeleteAll;
        RepLayoutSelection.SetRange("Report ID", 6188471, 6189470);
        RepLayoutSelection.DeleteAll;
    end;
    procedure GetReportsWithSameDataSet(ReportID: Integer;
    var ReportIDs: list of[Integer])var ReportDataItem: Record "Report Data Items";
    CurrReportDataItem: Record "Report Data Items";
    ReportObject: Record "ForNAV Report Object";
    IsForNAVReport: Codeunit "ForNAV Check Is ForNAV Report";
    DataSetIsMatch: Boolean;
    begin
        CurrReportDataItem.SetRange(CurrReportDataItem."Report ID", ReportID);
        CurrReportDataItem.FindSet;
        repeat DataSetIsMatch:=false;
            ReportDataItem.SetRange("Indentation Level", CurrReportDataItem."Indentation Level");
            ReportDataItem.SetRange(Name, CurrReportDataItem.Name);
            if ReportDataItem.FindFirst then DataSetIsMatch:=true
            else
                DataSetIsMatch:=false;
        until CurrReportDataItem.Next = 0;
    end;
}
