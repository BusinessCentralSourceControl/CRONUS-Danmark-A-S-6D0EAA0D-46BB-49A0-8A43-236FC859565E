Report 6188622 "ForNAV Tax Purchase Invoice"
{
    Caption = 'Purchase Invoice';
    WordLayout = './Layouts/ForNAV Tax Purchase Invoice.docx';
    DefaultLayout = Word;

    dataset
    {
        dataitem(Header;"Purch. Inv. Header")
        {
            CalcFields = "Amount Including VAT", Amount;
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Posting Date";

            column(ReportForNavId_2;2)
            {
            } // Autogenerated by ForNav - Do not delete
            column(ReportForNav_Header;ReportForNavWriteDataItem('Header', Header))
            {
            }
            column(HasDiscount;ForNAVCheckDocumentDiscount.HasDiscount(Header))
            {
            IncludeCaption = false;
            }
            dataitem(Line;"Purch. Inv. Line")
            {
                DataItemLink = "Document No."=FIELD("No.");
                DataItemLinkReference = Header;
                DataItemTableView = sorting("Document No.", "Line No.");

                column(ReportForNavId_3;3)
                {
                } // Autogenerated by ForNav - Do not delete
                column(ReportForNav_Line;ReportForNavWriteDataItem('Line', Line))
                {
                }
                trigger OnPreDataItem();
                begin
                    ReportForNav.OnPreDataItem('Line', Line);
                end;
            }
            dataitem(SalesTaxBuffer;"ForNAV Sales Tax Buffer")
            {
                DataItemTableView = sorting("Primary Key");
                UseTemporary = true;

                column(ReportForNavId_1;1)
                {
                } // Autogenerated by ForNav - Do not delete
                column(ReportForNav_SalesTaxBuffer;ReportForNavWriteDataItem('SalesTaxBuffer', SalesTaxBuffer))
                {
                }
                trigger OnPreDataItem();
                begin
                    ReportForNav.OnPreDataItem('SalesTaxBuffer', SalesTaxBuffer);
                end;
            }
            trigger OnPreDataItem();
            begin
                ReportForNav.OnPreDataItem('Header', Header);
            end;
            trigger OnAfterGetRecord();
            begin
                ChangeLanguage("Language Code");
                GetSalesTaxDetails;
                UpdateNoPrinted;
            end;
        }
    }
    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';

                    field(NoOfCopies;NoOfCopies)
                    {
                        ApplicationArea = All;
                        Caption = 'No. of Copies';
                    }
                    field(ForNavOpenDesigner;ReportForNavOpenDesigner)
                    {
                        ApplicationArea = All;
                        Caption = 'Design';
                        Visible = ReportForNavAllowDesign;

                        trigger OnValidate()begin
                            ReportForNav.LaunchDesigner(ReportForNavOpenDesigner);
                            CurrReport.RequestOptionsPage.Close();
                        end;
                    }
                }
            }
        }
        actions
        {
        }
        trigger OnOpenPage()begin
            ReportForNavOpenDesigner:=false;
        end;
    }
    trigger OnInitReport()begin
        ;
        ReportsForNavInit;
        Codeunit.Run(Codeunit::"ForNAV First Time Setup");
    end;
    trigger OnPostReport()begin
    end;
    trigger OnPreReport()begin
        ;
        ReportForNav.SetCopies('Header', NoOfCopies);
        LoadWatermark;
        ;
        ReportsForNavPre;
    end;
    var ForNAVCheckDocumentDiscount: Codeunit "ForNAV Check Document Discount";
    NoOfCopies: Integer;
    local procedure ChangeLanguage(LanguageCode: Code[10])var ForNAVSetup: Record "ForNAV Setup";
    begin
        ForNAVSetup.Get;
        if ForNAVSetup."Inherit Language Code" then CurrReport.Language(ReportForNav.GetLanguageID(LanguageCode));
    end;
    local procedure GetSalesTaxDetails()var ForNAVGetSalesTaxDetails: Codeunit "ForNAV Get Sales Tax Details";
    begin
        SalesTaxBuffer.DeleteAll;
        ForNAVGetSalesTaxDetails.GetSalesTax(Header, SalesTaxBuffer);
    end;
    local procedure UpdateNoPrinted()var ForNAVUpdateNoPrinted: Codeunit "ForNAV Update No. Printed";
    begin
        ForNAVUpdateNoPrinted.UpdateNoPrinted(Header, CurrReport.Preview);
    end;
    local procedure LoadWatermark()var ForNAVSetup: Record "ForNAV Setup";
    OutStream: OutStream;
    begin
        ForNAVSetup.Get;
        if not PrintLogo(ForNAVSetup)then exit;
        ForNAVSetup.CalcFields(ForNAVSetup."Document Watermark");
        if not ForNAVSetup."Document Watermark".Hasvalue then exit;
        ReportForNav.LoadWatermarkImage(ForNAVSetup.GetDocumentWatermark);
    end;
    procedure PrintLogo(ForNAVSetup: Record "ForNAV Setup"): Boolean begin
        if not ForNAVSetup."Use Preprinted Paper" then exit(true);
        if 'Pdf' = 'PDF' then exit(true);
        if 'Pdf' = 'Preview' then exit(true);
        exit(false);
    end;
    // --> Reports ForNAV Autogenerated code - do not delete or modify
    var ReportForNavInitialized: Boolean;
    ReportForNavShowOutput: Boolean;
    ReportForNavTotalsCausedBy: Boolean;
    ReportForNavOpenDesigner: Boolean;
    [InDataSet]
    ReportForNavAllowDesign: Boolean;
    ReportForNav: Codeunit "ForNAV Report Management";
    local procedure ReportsForNavInit()var id: Integer;
    begin
        Evaluate(id, CopyStr(CurrReport.ObjectId(false), StrPos(CurrReport.ObjectId(false), ' ') + 1));
        ReportForNav.OnInit(id, ReportForNavAllowDesign);
    end;
    local procedure ReportsForNavPre()begin
        if ReportForNav.LaunchDesigner(ReportForNavOpenDesigner)then CurrReport.Quit();
    end;
    local procedure ReportForNavSetTotalsCausedBy(value: Boolean)begin
        ReportForNavTotalsCausedBy:=value;
    end;
    local procedure ReportForNavSetShowOutput(value: Boolean)begin
        ReportForNavShowOutput:=value;
    end;
    local procedure ReportForNavInit(jsonObject: JsonObject)begin
        ReportForNav.Init(jsonObject, CurrReport.ObjectId);
    end;
    local procedure ReportForNavWriteDataItem(dataItemId: Text;
    rec: Variant): Text var values: Text;
    jsonObject: JsonObject;
    currLanguage: Integer;
    begin
        if not ReportForNavInitialized then begin
            ReportForNavInit(jsonObject);
            ReportForNavInitialized:=true;
        end;
        case(dataItemId)of 'Header': begin
            jsonObject.Add('CurrReport$Language$Integer', CurrReport.Language);
        end;
        end;
        ReportForNav.AddDataItemValues(jsonObject, dataItemId, rec);
        jsonObject.WriteTo(values);
        exit(values);
    end;
// Reports ForNAV Autogenerated code - do not delete or modify -->
}
