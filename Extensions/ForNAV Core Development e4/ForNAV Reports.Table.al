Table 6188475 "ForNAV Reports"
{
    Caption = 'ForNAV Report';

    fields
    {
        field(1;Category;Enum "ForNAV Report Category")
        {
            Caption = 'Category';
            DataClassification = SystemMetadata;
        // OptionCaption = 'Other,Sales,Purchase,Finance,Template,Example,Warehouse,Inventory,Label,Service,My Report,App Report';
        // OptionMembers = Other,Sales,Purchase,Finance,Template,Example,Warehouse,Inventory,Label,Service,"My Report","App Report";
        }
        field(2;ID;Integer)
        {
            Caption = 'Id';
            BlankZero = true;
            DataClassification = SystemMetadata;
        }
        field(10;Name;Text[250])
        {
            Caption = 'Name';
            DataClassification = SystemMetadata;
        }
        field(12;"Layout";Enum "ForNAV Layout")
        {
            DataClassification = SystemMetadata;
        // OptionMembers = " ","Built-in","Created","Activated","Defined Externally";
        // OptionCaption = ' ,Built-in,Created,Activated,Defined Externally';
        }
        field(16;"Has Custom Report Layout";Boolean)
        {
            // ObsoleteState = Removed;
            // ObsoleteReason = 'Replaced by function HasCustomReportLayout';
            // ObsoleteTag = 'ForNAV 6.0.0.2';
            FieldClass = FlowField;
            CalcFormula = exist("Custom Report Layout" where("Report ID"=field("ID")));
            Editable = false;
            Caption = 'Has Custom Report Layout', Comment='DO NOT TRANSLATE';
        }
        field(20;"Custom Report Layout Activated";Boolean)
        {
            // ObsoleteState = Removed;
            // ObsoleteReason = 'Replaced by function CustomReportLayoutActivated';
            // ObsoleteTag = 'ForNAV 6.0.0.2';
            FieldClass = FlowField;
            CalcFormula = exist("Report Layout Selection" where("Report ID"=field("ID"), Type=const(2)));
            Editable = false;
            Caption = 'Custom Report Layout Activated', Comment='DO NOT TRANSLATE';
        }
        field(25;Description;Text[250])
        {
            DataClassification = SystemMetadata;
            Editable = false;
            Caption = 'Description';
        }
        field(30;Printer;Text[250])
        {
            DataClassification = SystemMetadata;
            Editable = false;
            Caption = 'Printer';
        }
        field(35;"Archive Enabled";Boolean)
        {
            DataClassification = SystemMetadata;
            Editable = true;
            Caption = 'Archive Enabled';

            trigger OnValidate()var archiveSetup: Codeunit "ForNAV Document Archive Mgt.";
            begin
                if ID <> 0 then archiveSetup.SetArchiveSetup(ID, "Archive Enabled")
                else
                    "Archive Enabled":=false;
            end;
        }
        field(40;Archived;Integer)
        {
            DataClassification = SystemMetadata;
            Editable = true;
            Caption = 'Archived';
        }
        field(99;Indent;Integer)
        {
            DataClassification = SystemMetadata;
            Editable = false;
            Caption = 'Indent', Comment='DO NOT TRANSLATE';
        }
    }
    keys
    {
        key(Key1;Category, ID)
        {
        }
        key(Key2;ID)
        {
        }
    }
    procedure DesignReport()var ReportMgt: Codeunit "ForNAV Report Management";
    begin
        ReportMgt.LaunchDesigner(ID);
    end;
    procedure GetCategory(): Enum "ForNav Report Category" var AllObj: Record AllObj;
    begin
        if ID < 100000 then exit(Category::"My Report");
        if(ID < 6188471) or (ID > 6189470)then exit(Category::"App Report");
        AllObj.SetRange("Object Type", AllObj."Object Type"::Report);
        AllObj.SetRange("Object ID", ID);
        AllObj.FindFirst;
        if StrPos(AllObj."Object Name", 'Templ') <> 0 then exit(Category::Template);
        if StrPos(AllObj."Object Name", 'Service') <> 0 then exit(Category::Service);
        if(StrPos(AllObj."Object Name", 'Label') <> 0) or (StrPos(AllObj."Object Name", 'Price Tag') <> 0)then exit(Category::Label);
        if StrPos(AllObj."Object Name", 'Example') <> 0 then exit(Category::Example);
        if StrPos(AllObj."Object Name", 'Warehouse') <> 0 then exit(Category::Warehouse);
        if StrPos(AllObj."Object Name", 'Purch') <> 0 then exit(Category::Purchase);
        if(StrPos(AllObj."Object Name", 'Order Confirmation') <> 0) or (StrPos(AllObj."Object Name", 'Draft') <> 0) or (StrPos(AllObj."Object Name", 'Pro Forma') <> 0) or (StrPos(AllObj."Object Name", 'Sales') <> 0) or (StrPos(AllObj."Object Name", 'Salesperson') <> 0) or (StrPos(AllObj."Object Name", 'Credit Memo') <> 0) or (StrPos(AllObj."Object Name", 'Picking List') <> 0)then exit(Category::Sales);
        if(StrPos(AllObj."Object Name", 'Inventory') <> 0) or (StrPos(AllObj."Object Name", 'Item') <> 0)then exit(Category::Finance);
        if(StrPos(AllObj."Object Name", 'Top 10') <> 0) or (StrPos(AllObj."Object Name", 'Balance') <> 0) or (StrPos(AllObj."Object Name", 'Reconcile') <> 0) or (StrPos(AllObj."Object Name", 'Payments') <> 0) or (StrPos(AllObj."Object Name", 'Statement') <> 0) or (StrPos(AllObj."Object Name", 'Reminder') <> 0) or (StrPos(AllObj."Object Name", 'Finance') <> 0) or (StrPos(AllObj."Object Name", 'Aged Accounts') <> 0)then exit(Category::Finance);
    end;
    procedure IsValidForLocalization(Value: Integer): Boolean var AllObj: Record AllObj;
    IsSalesTax: Codeunit "ForNAV Is Sales Tax";
    begin
        if Category = Category::Example then exit(false);
        AllObj.Get(AllObj."Object Type"::Report, Value);
        if(StrPos(AllObj."Object Name", 'US Check') <> 0) and (NOT IsSalesTax.CheckIsSalesTax)then exit(false);
        if not(Category in[Category::Service, Category::Sales, Category::Purchase, Category::Template])then exit(true);
        if(StrPos(AllObj."Object Name", 'VAT') <> 0) and (IsSalesTax.CheckIsSalesTax)then exit(false);
        if(StrPos(AllObj."Object Name", 'Tax') <> 0) and (NOT IsSalesTax.CheckIsSalesTax)then exit(false);
        exit(true);
    end;
    procedure ShowReportInList(): Boolean begin
        exit(not(ID in[6188669, 6188670, 6188671, 6189470]));
    end;
    procedure DeactivateLayout()var RepLaySel: Record "Report Layout Selection";
    begin
        RepLaySel.SetRange("Report ID", "ID");
        RepLaySel.DeleteAll;
        Modify;
    end;
    procedure GetCurrentReportLayout()var RepLaySel: Record "Report Layout Selection";
    ExistNotActivated: Label 'A custom layout exists, but it is not activated. Click here to select a layout';
    CreateNew: Label 'Built-in Layout. Click here to create a new layout';
    begin
        Case true of ID = 0: Layout:=Layout::" ";
        CustomReportLayoutActivated(): begin
            RepLaySel.SetRange("Report ID", "ID");
            RepLaySel.SetRange("Company Name", CompanyName);
            RepLaySel.SetRange(Type, RepLaySel.Type::"Custom Layout");
            RepLaySel.SetAutoCalcFields("Report Layout Description");
            if RepLaySel.IsEmpty then RepLaySel.SetFilter("Company Name", '%1', '');
            RepLaySel.FindFirst();
            Description:=RepLaySel."Report Layout Description";
            Layout:=Layout::Activated;
        end;
        HasCustomReportLayout() and (not CustomReportLayoutActivated()): begin
            Description:=ExistNotActivated;
            Layout:=Layout::Created;
        end;
        else
            Description:=CreateNew;
            Layout:=Layout::"Built-in";
        end;
        OnAfterGetCurrentReportLayout(Rec);
    end;
    procedure DeActivateAllLayouts()var RepLaySel: Record "Report Layout Selection";
    begin
        RepLaySel.SetRange("Report ID", ID);
        RepLaySel.SetFilter("Company Name", '%1|%2', '', CompanyName);
        RepLaySel.DeleteAll;
    end;
    procedure ActivateOrShowLayout()var CustRepLayout: Record "Custom Report Layout";
    RepLaySel: Record "Report Layout Selection";
    begin
        CustRepLayout.SetRange("Report ID", ID);
        if CustRepLayout.Count > 1 then begin
            ShowForNAVLayouts;
        end
        else
        begin
            CustRepLayout.FindFirst;
            RepLaySel.SetRange("Report ID", "ID");
            RepLaySel.SetRange("Company Name", CompanyName);
            if RepLaySel.IsEmpty then RepLaySel.SetFilter("Company Name", '%1', '');
            if not RepLaySel.FindFirst then begin
                RepLaySel."Report ID":=ID;
                RepLaySel."Company Name":='';
                RepLaySel.Insert;
            end;
            RepLaySel.Type:=RepLaySel.Type::"Custom Layout";
            RepLaySel."Custom Report Layout Code":=CustRepLayout.Code;
            RepLaySel.Modify;
        end;
    end;
    procedure ShowForNAVLayouts()var ReportLayout: Record "ForNAV Report Layout" temporary;
    begin
        ReportLayout.SetRange("Report ID", ID);
        Page.RunModal(0, ReportLayout);
    end;
    procedure DrillDownDescription()begin
        case Layout of Layout::" ": exit;
        Layout::Activated, Layout::"Built-in": DesignReport();
        Layout::Created: ShowForNAVLayouts();
        else
            OnDrillDownDescription(Rec);
        end;
        Rec.Modify;
    end;
    procedure HasCustomReportLayout(): Boolean var CustomReportLayout: Record "Custom Report Layout";
    begin
        CustomReportLayout.SetFilter("Company Name", '%1|%2', '', CompanyName);
        CustomReportLayout.SetRange("Report ID", ID);
        exit(CustomReportLayout.FindFirst());
    end;
    procedure CustomReportLayoutActivated(): Boolean var ReportLayoutSelection: Record "Report Layout Selection";
    CustomReportLayout: Record "Custom Report Layout";
    begin
        ReportLayoutSelection.SetFilter("Company Name", '%1|%2', '', CompanyName);
        ReportLayoutSelection.SetRange("Report ID", ID);
        ReportLayoutSelection.SetRange(Type, ReportLayoutSelection.Type::"Custom Layout");
        exit(ReportLayoutSelection.FindFirst() and CustomReportLayout.Get(ReportLayoutSelection."Custom Report Layout Code"));
    end;
    [IntegrationEvent(false, false)]
    local procedure OnAfterGetCurrentReportLayout(var ForNAVReports: Record "ForNAV Reports")begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnDrillDownDescription(var ForNAVReports: Record "ForNAV Reports")begin
    end;
}
