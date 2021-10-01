Report 6188706 "ForNAV Purchase Statistics"
{
    Caption = 'Purchase Statistics';
    UsageCategory = ReportsAndAnalysis;
    WordLayout = './Layouts/ForNAV Purchase Statistics.docx';
    DefaultLayout = Word;

    dataset
    {
        dataitem(Args;"ForNAV Statistics Args.")
        {
            UseTemporary = true;
            PrintOnlyIfDetail = true;
            DataItemTableView = sorting("Currency Code");

            column(ReportForNavId_4146;4146)
            {
            } // Autogenerated by ForNav - Do not delete
            column(ReportForNav_Args;ReportForNavWriteDataItem('Args', Args))
            {
            }
            dataitem(PurchInvoiceHeader;"Purch. Inv. Header")
            {
                CalcFields = Amount, "Amount Including VAT";
                DataItemLink = "Currency Code"=FIELD("Currency Code");
                DataItemTableView = sorting("Pay-to Vendor No.");
                RequestFilterFields = "Posting Date", "Pay-to Vendor No.", "Purchaser Code", "Payment Terms Code";

                column(ReportForNavId_5581;5581)
                {
                } // Autogenerated by ForNav - Do not delete
                column(ReportForNav_PurchInvoiceHeader;ReportForNavWriteDataItem('PurchInvoiceHeader', PurchInvoiceHeader))
                {
                }
                column(AmountLCY;Args.GetPurchInvAmountLCY(PurchInvoiceHeader))
                {
                IncludeCaption = false;
                }
                column(CostLCY;0)
                {
                IncludeCaption = false;
                }
                trigger OnPreDataItem();
                begin
                    if not Args.Invoices then CurrReport.Break;
                    // if Args."Vendor No." then
                    //	 SetCurrentkey("Pay-to Vendor No.");
                    ReportForNav.OnPreDataItem('PurchInvoiceHeader', PurchInvoiceHeader);
                end;
            }
            dataitem(PurchCrMemoHeader;"Purch. Cr. Memo Hdr.")
            {
                CalcFields = Amount, "Amount Including VAT";
                DataItemLink = "Currency Code"=FIELD("Currency Code");
                DataItemTableView = sorting("Pay-to Vendor No.");

                column(ReportForNavId_8098;8098)
                {
                } // Autogenerated by ForNav - Do not delete
                column(ReportForNav_PurchCrMemoHeader;ReportForNavWriteDataItem('PurchCrMemoHeader', PurchCrMemoHeader))
                {
                }
                column(AmountLCY_CrMemo;Args.GetPurchCrMemoAmountLCY(PurchCrMemoHeader))
                {
                IncludeCaption = false;
                }
                column(CostLCY_CrMemo;0)
                {
                IncludeCaption = false;
                }
                trigger OnPreDataItem();
                begin
                    if Args."Credit Memos" then begin
                        PurchInvoiceHeader.Copyfilter("Posting Date", "Posting Date");
                        PurchInvoiceHeader.Copyfilter("Pay-to Vendor No.", "Pay-to Vendor No.");
                        PurchInvoiceHeader.Copyfilter("Purchaser Code", "Purchaser Code");
                        PurchInvoiceHeader.Copyfilter("Payment Terms Code", "Payment Terms Code");
                        PurchInvoiceHeader.Copyfilter("Shortcut Dimension 1 Code", "Shortcut Dimension 1 Code");
                        PurchInvoiceHeader.Copyfilter("Shortcut Dimension 2 Code", "Shortcut Dimension 2 Code");
                        PurchInvoiceHeader.Copyfilter("Sell-to Customer No.", "Sell-to Customer No.");
                        PurchInvoiceHeader.Copyfilter("Location Code", "Location Code");
                        PurchInvoiceHeader.Copyfilter("Tax Area Code", "Tax Area Code");
                        PurchInvoiceHeader.Copyfilter("Responsibility Center", "Responsibility Center");
                    end
                    else
                        CurrReport.Break;
                    // if Args."Customer No." then
                    //	 SetCurrentkey("Pay-to Vendor No.");
                    ReportForNav.OnPreDataItem('PurchCrMemoHeader', PurchCrMemoHeader);
                end;
            }
            trigger OnPreDataItem();
            begin
                ReportForNav.OnPreDataItem('Args', Args);
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

                    group(Show)
                    {
                        Caption = 'Show';

                        field(Invoices;Args.Invoices)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Invoices';
                        }
                        field(CreditMemos;Args."Credit Memos")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Credit Memos';
                        }
                    }
                    group(GroupBy)
                    {
                        Caption = 'Group By';

                        field(VendorNo;Args."Vendor No.")
                        {
                            ApplicationArea = All;
                            Caption = 'Vendor No.';
                        }
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
            if not Args.Invoices and not Args."Credit Memos" then begin
                Args.Invoices:=true;
                Args."Credit Memos":=true;
            end;
        end;
    }
    trigger OnInitReport()begin
        ;
        ReportsForNavInit;
        Codeunit.Run(Codeunit::"ForNAV First Time Setup");
        Commit;
        LoadWatermark;
    end;
    trigger OnPostReport()begin
    end;
    trigger OnPreReport()begin
        if not(Args.Invoices or Args."Credit Memos")then Args.TestField(Invoices);
        ;
        Args.CreateCurrencies;
        ;
        ReportsForNavPre;
    end;
    local procedure LoadWatermark()var ForNAVSetup: Record "ForNAV Setup";
    OutStream: OutStream;
    begin
        ForNAVSetup.Get;
        ForNAVSetup.CalcFields(ForNAVSetup."List Report Watermark (Lands.)");
        if not ForNAVSetup."List Report Watermark (Lands.)".Hasvalue then exit;
        ForNAVSetup."List Report Watermark (Lands.)".CreateOutstream(OutStream);
        ReportForNav.LoadWatermarkImage(ForNAVSetup.GetListReportWatermarkLandscape);
    end;
    // --> Reports ForNAV Autogenerated code - do not delete or modify
    var ReportForNavInitialized: Boolean;
    ReportForNavShowOutput: Boolean;
    ReportForNavTotalsCausedBy: Integer;
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
    local procedure ReportForNavSetTotalsCausedBy(value: Integer)begin
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
            jsonObject.Add('PurchInvoiceHeader$Get$Filters$Text', PurchInvoiceHeader.GetFilters());
            ReportForNavInit(jsonObject);
            ReportForNavInitialized:=true;
        end;
        case(dataItemId)of end;
        ReportForNav.AddDataItemValues(jsonObject, dataItemId, rec);
        jsonObject.WriteTo(values);
        exit(values);
    end;
// Reports ForNAV Autogenerated code - do not delete or modify -->
}