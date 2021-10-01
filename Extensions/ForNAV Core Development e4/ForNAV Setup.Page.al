Page 6188471 "ForNAV Setup"
{
    ApplicationArea = All;
    Caption = 'ForNAV Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "ForNAV Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(Text)
            {
                Caption = 'Text';

                field(PaymentNote;Rec."Payment Note")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
                field(LegalConditions;Rec."Legal Conditions")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
            }
            group(Logo)
            {
                Caption = 'Logo';

                field(LogoFileName;Rec."Logo File Name")
                {
                    ApplicationArea = All;
                    Caption = 'Logo';

                    trigger OnDrillDown()var TempBlob: Codeunit "Temp Blob";
                    //                        ClientFileName: Text;
                    //                        is: InStream;
                    //                        os: OutStream;
                    begin
                        // Rec.CalcFields(Logo);
                        // if Rec."Logo File Name" <> 'Click to import...' then begin
                        //     TempBlob.FromRecord(Rec, Rec.FieldNo(Logo));
                        //                            TempBlob.CreateOutStream(os);
                        //                            TempBlob.CreateInStream(is);
                        //                            ClientFileName := 'Watermark.pdf';
                        //                            DownloadFromStream(is, '', '', '', ClientFileName);
                        // end else
                        Rec.ImportWatermarkFromClientFile(Rec.FieldNo(Logo));
                        Rec.Modify;
                    end;
                }
                field(DocumentWatermark;Rec."Document Watermark File Name")
                {
                    ApplicationArea = All;
                    Caption = 'Document Watermark';
                    Editable = false;

                    trigger OnDrillDown()var TempBlob: Codeunit "Temp Blob";
                    //                        ClientFileName: Text;
                    //                        is: InStream;
                    //                        os: OutStream;
                    begin
                        // Rec.CalcFields("Document Watermark");
                        // if Rec."Document Watermark File Name" <> 'Click to import...' then begin
                        //     TempBlob.FromRecord(Rec, Rec.FieldNo("Document Watermark"));
                        //                            TempBlob.CreateOutStream(os);
                        //                            TempBlob.CreateInStream(is);
                        //                            ClientFileName := 'Watermark.pdf';
                        //                            DownloadFromStream(is, '', '', '', ClientFileName);
                        // end else
                        Rec.ImportWatermarkFromClientFile(Rec.FieldNo("Document Watermark"));
                        Rec.Modify;
                    end;
                }
                field(ListReportWatermarkPortrait;Rec."List Report Watermark File N.")
                {
                    ApplicationArea = All;
                    Caption = 'List Report Watermark (Portrait)';

                    trigger OnDrillDown()var TempBlob: Codeunit "Temp Blob";
                    //                        ClientFileName: Text;
                    //                        is: InStream;
                    //                        os: OutStream;
                    begin
                        // Rec.CalcFields("List Report Watermark");
                        // if Rec."List Report Watermark File N." <> 'Click to import...' then begin
                        //     TempBlob.FromRecord(Rec, Rec.FieldNo("List Report Watermark"));
                        //                            TempBlob.CreateOutStream(os);
                        //                            TempBlob.CreateInStream(is);
                        //                            ClientFileName := 'Watermark.pdf';
                        //                            DownloadFromStream(is, '', '', '', ClientFileName);
                        // end else
                        Rec.ImportWatermarkFromClientFile(Rec.FieldNo("List Report Watermark"));
                        Rec.Modify;
                    end;
                }
                field(ListReportWatermarkLandscape;Rec."List Report W. File N. Lands.")
                {
                    ApplicationArea = All;
                    Caption = 'List Report Watermark (Landscape)';

                    trigger OnDrillDown()var TempBlob: Codeunit "Temp Blob";
                    //                        ClientFileName: Text;
                    //                        is: InStream;
                    //                        os: OutStream;
                    begin
                        // Rec.CalcFields("List Report Watermark (Lands.)");
                        // if Rec."List Report W. File N. Lands." <> 'Click to import...' then begin
                        //     TempBlob.FromRecord(Rec, Rec.FieldNo("List Report Watermark (Lands.)"));
                        //                            TempBlob.CreateOutStream(os);
                        //                            TempBlob.CreateInStream(is);
                        //                            ClientFileName := 'Watermark.pdf';
                        //                            DownloadFromStream(is, '', '', '', ClientFileName);
                        // end else
                        Rec.ImportWatermarkFromClientFile(Rec.FieldNo("List Report Watermark (Lands.)"));
                        Rec.Modify;
                    end;
                }
            }
            group(General)
            {
                Caption = 'General';

                field(InheritLanguageCode;Rec."Inherit Language Code")
                {
                    ApplicationArea = All;
                }
                field(UsePreprintedPaper;Rec."Use Preprinted Paper")
                {
                    ApplicationArea = All;
                }
                field(ServiceEndpoint;Rec."Service Endpoint")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                }
                field(EndpointSettings;Rec."Endpoint Settings")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                }
            }
            group("Tax Setup")
            {
                Caption = 'Tax Setup';

                field(VATReportType;Rec."VAT Report Type")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            part(TenantInformation;"ForNAV Tenant Information")
            {
                ApplicationArea = All;
                Caption = 'Tenant Information', Comment='DO NOT TRANSLATE';
                Visible = ShowLicenseDetails;
            }
            // part(LicenseSku; "ForNAV License SKU")
            // {
            //     ApplicationArea = All;
            //     Caption = 'License SKU', Comment = 'DO NOT TRANSLATE';
            //     Visible = ShowLicenseDetails;
            // }
            systempart(MyNotes;MyNotes)
            {
                ApplicationArea = All;
            }
            systempart(RecordLinks;Links)
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        area(processing)
        {
            action(OrderLicenseViaEmail)
            {
                ApplicationArea = All;
                Caption = 'Order License Via Email';
                Image = Email;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()begin
                    Rec.SendLicenseEmail end;
            }
            group(Watermark)
            {
                Caption = 'Watermark';

                action(DownloadWatermark)
                {
                    ApplicationArea = All;
                    Caption = 'Download Watermark';
                    Image = Link;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()begin
                        Rec.DownloadWatermarks;
                    end;
                }
            }
            group(Delete)
            {
                Caption = 'Delete';

                action(DeleteDocWatermark)
                {
                    ApplicationArea = All;
                    Caption = 'Document Watermark';
                    Image = Delete;

                    trigger OnAction()var AreYouSureQst: label 'Are you sure you want to clear %1?';
                    begin
                        if not Confirm(AreYouSureQst, false, Rec.FieldCaption("Document Watermark"))then exit;
                        Rec."Document Watermark File Name":='Click to import...';
                        Clear(Rec."Document Watermark");
                        Rec.Modify;
                    end;
                }
                action(DeleteListWatermark)
                {
                    ApplicationArea = All;
                    Caption = 'List Report Watermark Portrait';
                    Image = Delete;

                    trigger OnAction()var AreYouSureQst: label 'Are you sure you want to clear %1?';
                    begin
                        if not Confirm(AreYouSureQst, false, Rec.FieldCaption("List Report Watermark"))then exit;
                        Rec."List Report Watermark File N.":='Click to import...';
                        Clear(Rec."List Report Watermark");
                        Rec.Modify;
                    end;
                }
                action(DeleteListWatermarkLandscape)
                {
                    ApplicationArea = All;
                    Caption = 'List Report Watermark Landscape';
                    Image = Delete;

                    trigger OnAction()var AreYouSureQst: label 'Are you sure you want to clear %1?';
                    begin
                        if not Confirm(AreYouSureQst, false, Rec.FieldCaption("List Report Watermark (Lands.)"))then exit;
                        Rec."List Report W. File N. Lands.":='Click to import...';
                        Clear(Rec."List Report Watermark (Lands.)");
                        Rec.Modify;
                    end;
                }
                action(DeleteLogo)
                {
                    ApplicationArea = All;
                    Caption = 'Logo';
                    Image = Delete;

                    trigger OnAction()var AreYouSureQst: label 'Are you sure you want to clear %1?';
                    begin
                        if not Confirm(AreYouSureQst, false, Rec.FieldCaption(Logo))then exit;
                        Rec."Logo File Name":='Click to import...';
                        Clear(Rec.Logo);
                        Rec.Modify;
                    end;
                }
            }
            group(ForNAV)
            {
                Caption = 'ForNAV', Comment='DO NOT TRANSLATE';

                action(ReplaceReports)
                {
                    ApplicationArea = All;
                    Caption = 'Replace Report Selections';
                    Image = SwitchCompanies;
                    RunObject = Page "ForNAV Report Selection";
                }
                action(FileStorage)
                {
                    ApplicationArea = All;
                    Caption = 'File Storage';
                    Image = Picture;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page "ForNAV File Storage";
                }
                action(Language)
                {
                    ApplicationArea = All;
                    Caption = 'Language';
                    Image = Language;
                    RunObject = page "ForNAV Language Setup";
                }
            }
            group(Template)
            {
                Caption = 'Template';

                action(DesignTemplatePortrait)
                {
                    ApplicationArea = All;
                    Caption = 'Design General Template (Portrait)';
                    Image = UnitOfMeasure;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()begin
                        Rec.DesignTemplatePortrait;
                    end;
                }
                action(DesignTemplateLandscape)
                {
                    ApplicationArea = All;
                    Caption = 'Design General Template (Landscape)';
                    Image = VATPostingSetup;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()begin
                        Rec.DesignTemplateLandscape;
                    end;
                }
                action(DesignSalesTemplate)
                {
                    ApplicationArea = All;
                    Caption = 'Design Sales Template';
                    Image = Design;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()begin
                        Rec.DesignSalesTemplate;
                    end;
                }
                action(DesignPurchaseTemplate)
                {
                    ApplicationArea = All;
                    Caption = 'Design Purchase Template';
                    Image = DesignCodeBehind;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()begin
                        Rec.DesignPurchaseTemplate;
                    end;
                }
                action(DesignReminderTemplate)
                {
                    ApplicationArea = All;
                    Caption = 'Design Reminder Template';
                    Image = CreateElectronicReminder;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()begin
                        Rec.DesignReminderTemplate;
                    end;
                }
                action(DesignServiceTemplate)
                {
                    ApplicationArea = All;
                    Caption = 'Design Service Template';
                    Image = DepositSlip;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()begin
                        Rec.DesignServiceTemplate;
                    end;
                }
            }
        }
        area(navigation)
        {
            action(LocalPrinters)
            {
                ApplicationArea = All;
                Caption = 'Local Printers';
                Image = Print;
                RunObject = page "ForNAV Local Printers";
            }
            action(PaymentTranslations)
            {
                ApplicationArea = All;
                Caption = 'ForNAV Payment Note Translations';
                Image = Translations;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Page "ForNAV Paym. Note Translation";
            }
            action(LegalTranslations)
            {
                ApplicationArea = All;
                Caption = 'ForNAV Legal Condition Translations';
                Image = Translations;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Page "ForNAV Legal Cond. Translation";
            }
            action(Archive)
            {
                ApplicationArea = All;
                Caption = 'Archive';
                Image = Archive;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Page "ForNAV Document Archive Setup";
            }
        }
    }
    trigger OnOpenPage()var EnvironmentInformation: Codeunit "Environment Information";
    begin
        Rec.InitSetup;
        ShowLicenseDetails:=EnvironmentInformation.IsSaaSInfrastructure();
    end;
    var[InDataSet]
    ShowLicenseDetails: Boolean;
}
