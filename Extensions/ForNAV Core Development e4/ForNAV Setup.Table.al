Table 6188471 "ForNAV Setup"
{
    Caption = 'ForNAV Setup';

    fields
    {
        field(1;"Primary Key";Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = SystemMetadata;
        }
        field(9;Region;Option)
        {
            Caption = 'Region';
            DataClassification = CustomerContent;
            ObsoleteReason = 'Too complex';
            ObsoleteState = Removed;
            OptionCaption = 'World Wide,North America,Other', Comment='DO NOT TRANSLATE';
            OptionMembers = "World Wide", "North America", Other;
        }
        field(10;"VAT Report Type";Option)
        {
            Caption = 'VAT Report Type';
            DataClassification = CustomerContent;
            OptionCaption = 'Multiple Lines,Always,Never';
            OptionMembers = "Multiple Lines", Always, Never, "N/A. (Sales Tax)";
        }
        field(14;"Inherit Language Code";Boolean)
        {
            Caption = 'Inherit Language Code';
            DataClassification = SystemMetadata;
            InitValue = true;
        }
        field(15;"Use Preprinted Paper";Boolean)
        {
            Caption = 'Use Preprinted Paper';
            DataClassification = SystemMetadata;
        }
        field(16;"Save Report Usage Statistics";Boolean)
        {
            Caption = '', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
            InitValue = true;
        }
        field(17;"Send Statistics to ForNAV";Boolean)
        {
            Caption = '', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
            InitValue = true;
        }
        field(20;Logo;Blob)
        {
            Caption = '', Comment='DO NOT TRANSLATE';
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(21;"Logo File Name";Text[250])
        {
            Caption = '', Comment='DO NOT TRANSLATE';
            DataClassification = OrganizationIdentifiableInformation;
            Editable = false;
            InitValue = 'Click to import...';
        }
        field(50;"Document Watermark File Name";Text[250])
        {
            Caption = '', Comment='DO NOT TRANSLATE';
            DataClassification = OrganizationIdentifiableInformation;
            Editable = false;
            InitValue = 'Click to import...';
        }
        field(51;"List Report Watermark File N.";Text[250])
        {
            Caption = '', Comment='DO NOT TRANSLATE';
            DataClassification = OrganizationIdentifiableInformation;
            Editable = false;
            InitValue = 'Click to import...';
        }
        field(52;"List Report W. File N. Lands.";Text[250])
        {
            Caption = '', Comment='DO NOT TRANSLATE';
            DataClassification = OrganizationIdentifiableInformation;
            Editable = false;
            InitValue = 'Click to import...';
        }
        field(60;"Document Watermark";Blob)
        {
            Caption = '', Comment='DO NOT TRANSLATE';
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(61;"List Report Watermark";Blob)
        {
            Caption = '', Comment='DO NOT TRANSLATE';
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(62;"List Report Watermark (Lands.)";Blob)
        {
            Caption = '', Comment='DO NOT TRANSLATE';
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(70;"Payment Note";Text[250])
        {
            Caption = 'Payment Note';
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(80;"Legal Conditions";Text[250])
        {
            Caption = 'Legal Conditions';
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(85;"Service Endpoint";Text[250])
        {
            Caption = 'Service Endpoint', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(86;"Endpoint Settings";Text[250])
        {
            Caption = 'Endpoint Settings', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(Key1;"Primary Key")
        {
        }
    }
    procedure InitSetup()begin
        if Get then exit;
        Init;
        Insert;
    end;
    procedure CreateDefaultPrinter()var LocalPrinter: Record "ForNAV Local Printer";
    DefaultPrinterName: Label 'Default';
    begin
        if not LocalPrinter.IsEmpty then exit;
        LocalPrinter.Init;
        LocalPrinter."Cloud Printer Name":=DefaultPrinterName;
        LocalPrinter.Description:=DefaultPrinterName;
        LocalPrinter.Insert;
    end;
    procedure ReplaceReportSelection(HideDialog: Boolean)var DoYouWantToQst: label 'Do you want to replace the current reports with the ForNAV reports?';
    ReplaceReportSel: Codeunit "ForNAV Replace Report Sel.";
    begin
        if not HideDialog then if not Confirm(DoYouWantToQst, true)then exit;
        ReplaceReportSel.Run;
    end;
    procedure DesignTemplatePortrait()var Template: Report "ForNAV Template";
    Handled: Boolean;
    begin
        OnBeforeDesignTemplate(Template.ObjectId(false), Handled);
        if Handled then exit;
        Template.RunModal;
    end;
    procedure DesignTemplateLandscape()var Template: Report "ForNAV Template - Landscape";
    Handled: Boolean;
    begin
        OnBeforeDesignTemplate(Template.ObjectId(false), Handled);
        if Handled then exit;
        Template.RunModal;
    end;
    procedure DesignSalesTemplate()var Handled: Boolean;
    SalesTemplateVAT: Report "ForNAV Sales Template";
    SalesTemplSalesTax: Report "ForNAV Sales Templ. Sales Tax";
    begin
        if CheckIsSalesTax then OnBeforeDesignTemplate(SalesTemplSalesTax.ObjectId(false), Handled)
        else
            OnBeforeDesignTemplate(SalesTemplateVAT.ObjectId(false), Handled);
        if Handled then exit;
        if CheckIsSalesTax then SalesTemplSalesTax.RunModal
        else
            SalesTemplateVAT.RunModal;
    end;
    procedure DesignPurchaseTemplate()var PurchaseTemplVAT: Report "ForNAV Purchase Template";
    PurchaseTemplTax: Report "ForNAV Tax Purchase Templ.";
    Handled: Boolean;
    begin
        if CheckIsSalesTax then OnBeforeDesignTemplate(PurchaseTemplTax.ObjectId(false), Handled)
        else
            OnBeforeDesignTemplate(PurchaseTemplVAT.ObjectId(false), Handled);
        if Handled then exit;
        if CheckIsSalesTax then PurchaseTemplTax.RunModal
        else
            PurchaseTemplVAT.RunModal;
    end;
    procedure DesignReminderTemplate()var Template: Report "ForNAV Reminder Template";
    Handled: Boolean;
    begin
        OnBeforeDesignTemplate(Template.ObjectId(false), Handled);
        if Handled then exit;
        Template.RunModal;
    end;
    procedure DesignServiceTemplate()var ServiceTemplateVAT: Report "ForNAV Service Template";
    ServiceTemplSalesTax: Report "ForNAV Service Template Tax";
    Handled: Boolean;
    begin
        if CheckIsSalesTax then OnBeforeDesignTemplate(ServiceTemplSalesTax.ObjectId(false), Handled)
        else
            OnBeforeDesignTemplate(ServiceTemplateVAT.ObjectId(false), Handled);
        if Handled then exit;
        if CheckIsSalesTax then ServiceTemplSalesTax.RunModal
        else
            ServiceTemplateVAT.RunModal;
    end;
    procedure ImportWatermarkFromClientFile(Which: Integer): Boolean var ForNAVReadWatermarks: Codeunit "ForNAV Read Watermarks";
    begin
        exit(ForNAVReadWatermarks.ReadFromFile(Rec, Which));
    end;
    procedure GetLegalConditions(LanguageCode: Code[10]): Text var LegalCondTranslation: Record "ForNAV Legal Cond. Translation";
    begin
        if LegalCondTranslation.Get(LanguageCode)then exit(LegalCondTranslation."Legal Conditions");
        exit("Legal Conditions");
    end;
    procedure DownloadWatermarks()begin
        Hyperlink('http://www.fornav.com/report-watermarks/');
    end;
    procedure DownloadDesigner()var DownloadDesigner: Codeunit "ForNAV Download Designer";
    begin
        DownloadDesigner.Run;
    end;
    procedure CreateWebService()var CreateWebServices: Codeunit "ForNAV Create Web Services";
    begin
        CreateWebServices.Run;
    end;
    procedure GetCompanyLogo()var CompanyInformation: Record "Company Information";
    begin
        CompanyInformation.Get;
        CompanyInformation.CalcFields(Picture);
        Logo:=CompanyInformation.Picture;
    end;
    procedure GetDocumentWatermark(): Text var TempBlob: Record "ForNAV Core Setup";
    begin
        CalcFields("Document Watermark");
        TempBlob.Blob:="Document Watermark";
        exit(TempBlob.ToBase64String);
    end;
    procedure GetListReportWatermark(): Text var TempBlob: Record "ForNAV Core Setup";
    begin
        CalcFields("List Report Watermark");
        TempBlob.Blob:="List Report Watermark";
        exit(TempBlob.ToBase64String);
    end;
    procedure GetListReportWatermarkLandscape(): Text var TempBlob: Record "ForNAV Core Setup";
    begin
        CalcFields("List Report Watermark (Lands.)");
        TempBlob.Blob:="List Report Watermark (Lands.)";
        exit(TempBlob.ToBase64String);
    end;
    procedure CheckIsSalesTax(): Boolean var IsSalesTax: Codeunit "ForNAV Is Sales Tax";
    begin
        exit(IsSalesTax.CheckIsSalesTax);
    end;
    procedure SendLicenseEmail()var OrderLicense: Codeunit "ForNAV Order License";
    begin
        OrderLicense.SendEmail;
    end;
    [IntegrationEvent(false, false)]
    local procedure OnBeforeDesignTemplate(ReportID: Text;
    var Handled: Boolean)begin
    end;
}
