Page 6188476 "ForNAV Setup Wizard"
{
    Caption = 'ForNAV Setup';
    PageType = NavigatePage;
    SourceTable = "ForNAV Setup";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(Control4)
            {
                Editable = false;
                ShowCaption = false;
                Visible = TopBannerVisible and not FinalStepVisible;

                field(MediaRepositoryStandardImage;MediaRepositoryStandard.Image)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ShowCaption = false;
                }
            }
            group(Control2)
            {
                Editable = false;
                ShowCaption = false;
                Visible = TopBannerVisible and FinalStepVisible;

                field(MediaRepositoryDoneImage;MediaRepositoryDone.Image)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ShowCaption = false;
                }
            }
            group(Control11)
            {
                ShowCaption = false;
                Visible = FirstStepVisible;

                group(WelcometoForNAVSetup)
                {
                    Caption = 'Welcome to ForNAV Setup';
                    Visible = FirstStepVisible;

                    group(Control9)
                    {
                        InstructionalText = 'The ForNAV report package contains several documents that are optimized to work with our designer. ';
                        ShowCaption = false;
                    }
                }
                group(Letsgo)
                {
                    Caption = 'Let''s go!';

                    group(Control6)
                    {
                        InstructionalText = 'Choose Next so you can set up the ForNAV report package.';
                        ShowCaption = false;
                    }
                }
            }
            group(Control15)
            {
                ShowCaption = false;
                Visible = FinalStepVisible;

                group(Thatsit)
                {
                    Caption = 'That''s it!';

                    group(Control12)
                    {
                        InstructionalText = 'To enable the ForNAV report package choose Finish.';
                        ShowCaption = false;
                    }
                }
            }
            group(Control21)
            {
                InstructionalText = 'Step1. Select your payment note and legal clause.';
                ShowCaption = false;
                Visible = Step1Visible;

                field(PaymentNote;Rec."Payment Note")
                {
                    ApplicationArea = All;
                }
                field(LegalConditions;Rec."Legal Conditions")
                {
                    ApplicationArea = All;
                }
            }
            group(Control1000000003)
            {
                InstructionalText = 'How to you want to print VAT on your documents?';
                ShowCaption = false;
                Visible = Step2Visible and (not IsSalesTax);

                field(VATReportType;Rec."VAT Report Type")
                {
                    ApplicationArea = All;
                    Visible = not IsSalesTax;
                }
            }
            group(Control22)
            {
                InstructionalText = 'Which check layout are you using?', Comment='DO NOT TRANSLATE';
                ShowCaption = false;
                Visible = Step2Visible and IsSalesTax;

                field(CheckLayout;CheckSetup.Layout)
                {
                    ApplicationArea = All;
                    Caption = 'Layout';
                    Visible = IsSalesTax;
                }
            }
            group(Control17)
            {
                InstructionalText = 'Do you want to replace the current report selections with the ForNAV reports?';
                ShowCaption = false;
                Visible = Step3Visible;

                field(ReplaceReports;ReplaceReports)
                {
                    ApplicationArea = All;
                    Caption = 'Replace Report Selections';
                }
            }
            group(Control30)
            {
                InstructionalText = 'Do you want to create the fields webservice?';
                ShowCaption = false;
                Visible = Step3Visible;

                field(CreateTheWebService;CreateTheWebService)
                {
                    ApplicationArea = All;
                    Caption = 'Create The ForNAV Web Services';
                }
            }
            group(Control1000000001)
            {
                InstructionalText = 'A watermark can make your reports look nicer. Do you want to import one?';
                ShowCaption = false;
                Visible = Step2Visible;

                field(ImportWatermark;WatermarkTxt)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;

                    trigger OnDrillDown()begin
                        Rec.ImportWatermarkFromClientFile(Rec.FieldNo("Document Watermark"));
                    end;
                }
                field(ImportWatermarkList;WatermarkListTxt)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;

                    trigger OnDrillDown()begin
                        Rec.ImportWatermarkFromClientFile(Rec.FieldNo("List Report Watermark"));
                    end;
                }
                field(ImportWatermarkListLandscape;WatermarkListLTxt)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;

                    trigger OnDrillDown()begin
                        Rec.ImportWatermarkFromClientFile(Rec.FieldNo("List Report Watermark (Lands.)"));
                    end;
                }
                field(ImportCompanyLogo;CompanyLogoTxt)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;

                    trigger OnDrillDown()begin
                        Rec.ImportWatermarkFromClientFile(Rec.FieldNo(Logo));
                    end;
                }
            }
        }
    }
    actions
    {
        area(processing)
        {
            action(ActionBack)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Back';
                Enabled = BackActionEnabled;
                Image = PreviousRecord;
                InFooterBar = true;

                trigger OnAction()begin
                    NextStep(true);
                end;
            }
            action(ActionNext)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Next';
                Enabled = NextActionEnabled;
                Image = NextRecord;
                InFooterBar = true;

                trigger OnAction()begin
                    NextStep(false);
                end;
            }
            action(ActionFinish)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Finish';
                Enabled = FinishActionEnabled;
                Image = Approve;
                InFooterBar = true;

                trigger OnAction()begin
                    FinishAction;
                end;
            }
        }
    }
    trigger OnInit()begin
        LoadTopBanners;
    end;
    trigger OnOpenPage()begin
        Rec.Init;
        IsSalesTax:=CheckSalesTax.CheckIsSalesTax;
        if Setup.Get then Rec.TransferFields(Setup)
        else
        begin
            Rec.CheckIsSalesTax;
            Rec."Legal Conditions":=LegalConditionsTxt;
            Rec."Payment Note":=PaymentNoteTxt;
            Rec."VAT Report Type":=Rec."vat report type"::"Multiple Lines";
        end;
        Rec.Insert;
        Step:=Step::Start;
        EnableControls(false);
    end;
    var MediaRepositoryStandard: Record "Media Repository";
    MediaRepositoryDone: Record "Media Repository";
    Setup: Record "ForNAV Setup";
    CheckSetup: Record "ForNAV Check Setup";
    LabelSetup: Record "ForNAV Label Setup";
    CheckSalesTax: Codeunit "ForNAV Is Sales Tax";
    IsSalesTax: Boolean;
    TopBannerVisible: Boolean;
    FinalStepVisible: Boolean;
    FirstStepVisible: Boolean;
    FinishActionEnabled: Boolean;
    BackActionEnabled: Boolean;
    NextActionEnabled: Boolean;
    Step1Visible: Boolean;
    Step2Visible: Boolean;
    Step3Visible: Boolean;
    ReplaceReports: Boolean;
    CreateTheWebService: Boolean;
    Step: Option Start, Step1, Step2, Step3, Finish;
    WatermarkTxt: label 'Click to import a watermark for document reports';
    WatermarkListTxt: label 'Click to import a watermark for list reports (Portrait)';
    WatermarkListLTxt: label 'Click to import a watermark for list reports (Landscape)';
    CompanyLogoTxt: label 'Click to import a company logo';
    PaymentNoteTxt: label '- You can print a payment note here -';
    LegalConditionsTxt: label '- You can print your legal conditions here -';
    local procedure LoadTopBanners()begin
        if MediaRepositoryStandard.Get('AssistedSetup-NoText-400px.png', Format(CurrentClientType)) and MediaRepositoryDone.Get('AssistedSetupDone-NoText-400px.png', Format(CurrentClientType))then TopBannerVisible:=MediaRepositoryDone.Image.Hasvalue;
    end;
    local procedure EnableControls(Backwards: Boolean)begin
        ResetControls;
        case Step of Step::Start: ShowStartStep;
        Step::Step1: ShowStep1;
        Step::Step2: ShowStep2;
        Step::Step3: ShowStep3;
        Step::Finish: ShowFinishStep;
        end;
    end;
    local procedure ShowStartStep()begin
        FirstStepVisible:=true;
        FinishActionEnabled:=false;
        BackActionEnabled:=false;
    end;
    local procedure ShowStep1()begin
        Step1Visible:=true;
    end;
    local procedure ShowStep2()begin
        Step2Visible:=true;
    end;
    local procedure ShowStep3()begin
        Step3Visible:=true;
    end;
    local procedure ShowFinishStep()begin
        FinalStepVisible:=true;
        NextActionEnabled:=false;
    end;
    local procedure ResetControls()begin
        FinishActionEnabled:=1 = 1;
        BackActionEnabled:=true;
        NextActionEnabled:=true;
        FirstStepVisible:=false;
        Step1Visible:=false;
        Step2Visible:=false;
        Step3Visible:=false;
        FinalStepVisible:=false;
    end;
    local procedure NextStep(Backwards: Boolean)begin
        if Backwards then Step:=Step - 1
        else
            Step:=Step + 1;
        EnableControls(Backwards);
    end;
    local procedure FinishAction()begin
        StoreSetup;
        SaveAssistedSetupStatus;
        CurrPage.Close;
    end;
    local procedure SaveAssistedSetupStatus()var AssistedSetup: Codeunit "Guided Experience";
    Info: ModuleInfo;
    begin
        NavApp.GetCurrentModuleInfo(Info);
        AssistedSetup.CompleteAssistedSetup(ObjectType::Page, PAGE::"ForNAV Setup Wizard");
    end;
    local procedure StoreSetup()var SetCheckSetup: Codeunit "ForNAV Check Setup";
    begin
        if not Setup.Get then begin
            Setup.Init;
            Setup.Insert;
        end;
        if not CheckSetup.Get then begin
            CheckSetup.Init;
            CheckSetup.Insert;
        end;
        if not LabelSetup.Get then begin
            LabelSetup.Init;
            LabelSetup.Insert;
        end;
        Rec.CalcFields(Logo, "Document Watermark", "List Report Watermark", "List Report Watermark (Lands.)");
        Setup.TransferFields(Rec);
        if not Setup.Logo.Hasvalue then Setup.GetCompanyLogo;
        Setup.Modify;
        if ReplaceReports then Setup.ReplaceReportSelection(true);
        if CreateTheWebService then Rec.CreateWebService;
        Setup.CreateDefaultPrinter;
        SetCheckSetup.SetCheckType(Setup, CheckSetup);
    end;
}
