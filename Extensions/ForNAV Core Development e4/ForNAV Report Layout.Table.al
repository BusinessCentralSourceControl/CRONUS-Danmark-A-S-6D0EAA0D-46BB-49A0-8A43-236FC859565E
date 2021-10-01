table 6188483 "ForNAV Report Layout"
{
    LookupPageId = "ForNAV Report Layouts";
    DataCaptionFields = Name;

    fields
    {
        field(1;"Report ID";Integer)
        {
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(2;"Name";Text[250])
        {
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(3;"Custom Report Layout Code";Code[20])
        {
            DataClassification = SystemMetadata;

            trigger OnValidate()var CustRepLayoutOld: Record "Custom Report Layout";
            CustRepLayoutNew: Record "Custom Report Layout";
            RepLaySel: Record "Report Layout Selection";
            begin
                CustRepLayoutOld.LockTable;
                CustRepLayoutOld.Get(xRec."Custom Report Layout Code");
                CustRepLayoutOld.CalcFields(Layout);
                CustRepLayoutNew:=CustRepLayoutOld;
                CustRepLayoutNew.Code:="Custom Report Layout Code";
                CustRepLayoutNew.Insert;
                RepLaySel.SetRange("Custom Report Layout Code", xRec."Custom Report Layout Code");
                RepLaySel.ModifyAll("Custom Report Layout Code", "Custom Report Layout Code");
                CustRepLayoutOld.Delete;
            end;
        }
        field(5;Description;Text[250])
        {
            Caption = 'Description';
            DataClassification = SystemMetadata;

            trigger OnValidate()var CustRepLayout: Record "Custom Report Layout";
            begin
                CustRepLayout.LockTable;
                CustRepLayout.Get("Custom Report Layout Code");
                CustRepLayout.Description:=Description;
                CustRepLayout.Modify;
            end;
        }
        field(8;"Last Modified";DateTime)
        {
            Caption = 'Last Modified';
            FieldClass = FlowField;
            CalcFormula = lookup("Custom Report Layout"."Last Modified" where("Code"=field("Custom Report Layout Code")));
        }
        field(9;"Last Modified by User";Code[50])
        {
            Caption = 'Last Modified by User';
            FieldClass = FlowField;
            CalcFormula = lookup("Custom Report Layout"."Last Modified by User" where("Code"=field("Custom Report Layout Code")));
        }
        field(10;Activated;Boolean)
        {
            DataClassification = SystemMetadata;
        }
        field(50;"Built-in";Boolean)
        {
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(99;"Entry No.";Integer)
        {
            Editable = false;
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(PK;"Entry No.")
        {
            Clustered = true;
        }
    }
    procedure ExportLayout()var ReportLayoutExport: Codeunit "ForNAV Report Layout Export";
    begin
        ReportLayoutExport.ExportLayout(Rec);
    end;
    procedure ExportLayout(var TempBlob: Codeunit "Temp Blob")var ReportLayoutExport: Codeunit "ForNAV Report Layout Export";
    begin
        ReportLayoutExport.ExportLayout(Rec, TempBlob);
    end;
    procedure CopyLayout()var CustRepLayout: Record "Custom Report Layout";
    inStr: InStream;
    outStr: OutStream;
    begin
        if "Built-in" then begin
            CustRepLayout.InitBuiltInLayout("Report ID", CustRepLayout.Type::Word.AsInteger());
        end
        else
        begin
            CustRepLayout.Get("Custom Report Layout Code");
            CustRepLayout.CalcFields(Layout);
            CustRepLayout.Description:='ForNAV Custom Layout';
            CustRepLayout.Code:='';
            CustRepLayout.Insert(true);
        end;
    end;
    procedure CopyLayoutToOtherReport()var ReportObject: Record "ForNAV Report Object" temporary;
    ReportDataItem: Record "Report Data Items";
    CurrReportDataItem: Record "Report Data Items";
    CustRepLayout: Record "Custom Report Layout";
    GetForNAVReports: Codeunit "ForNAV Check Is ForNAV Report";
    begin
        GetForNAVReports.GetAllForNAVReports(ReportObject);
        ReportObject.Get("Report ID");
        ReportObject.Delete;
        CurrReportDataItem.SetRange("Report ID", "Report ID");
        CurrReportDataItem.FindSet;
        repeat ReportObject.FindSet;
            repeat ReportDataItem.SetRange("Report ID", ReportObject.ID);
                ReportDataItem.SetRange(Name, CurrReportDataItem.Name);
                if ReportDataItem.IsEmpty then ReportObject.Delete;
            until ReportObject.Next = 0;
        until CurrReportDataItem.Next = 0;
        Commit;
        if Page.RunModal(Page::"ForNAV Report Objects", ReportObject) <> Action::LookupOK then exit;
        if "Built-in" then begin
            CustRepLayout.InitBuiltInLayout(ReportObject.ID, CustRepLayout.Type::Word.AsInteger());
        end
        else
        begin
            CustRepLayout.Get("Custom Report Layout Code");
            CustRepLayout.CalcFields(Layout);
            CustRepLayout."Report ID":=ReportObject.ID;
            CustRepLayout.Description:='ForNAV Custom Layout';
            CustRepLayout.Code:='';
            CustRepLayout.Insert(true);
        end;
    end;
    procedure ActivateLayout()var RepLaySel: Record "Report Layout Selection";
    begin
        if "Built-in" then begin
            RepLaySel.SetRange("Report ID", "Report ID");
            RepLaySel.DeleteAll;
            Modify;
        end
        else
        begin
            if not RepLaySel.Get("Report ID", CompanyName)then begin
                RepLaySel."Report ID":="Report ID";
                RepLaySel.Insert(true);
            end;
            RepLaySel.Type:=RepLaySel.Type::"Custom Layout";
            RepLaySel."Custom Report Layout Code":="Custom Report Layout Code";
            RepLaySel.Modify;
            Activated:=true;
            Modify;
        end;
    end;
    procedure GetName(): Text var AllObj: Record AllObj;
    begin
        AllObj.Get(AllObj."Object Type"::Report, "Report ID");
        exit(AllObj."Object Name");
    end;
}
