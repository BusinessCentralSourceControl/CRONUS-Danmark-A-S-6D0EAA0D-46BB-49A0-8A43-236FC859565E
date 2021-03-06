Report 6188681 "ForNAV Customer Payments"
{
    Caption = 'Customer Payments';
    UsageCategory = ReportsAndAnalysis;
    WordLayout = './Layouts/ForNAV Customer Payments.docx';
    DefaultLayout = Word;

    dataset
    {
        dataitem(CustLedgerEntry;"Cust. Ledger Entry")
        {
            CalcFields = "Remaining Amt. (LCY)", "Amount (LCY)";
            DataItemTableView = sorting("Customer No.", "Document Type", "Posting Date")where("Document Type"=filter(Payment|"Credit Memo"));
            RequestFilterFields = "Posting Date", "Global Dimension 1 Code", "Global Dimension 2 Code", "Salesperson Code", "Customer No.";

            column(ReportForNavId_8503;8503)
            {
            } // Autogenerated by ForNav - Do not delete
            column(ReportForNav_CustLedgerEntry;ReportForNavWriteDataItem('CustLedgerEntry', CustLedgerEntry))
            {
            }
            dataitem(TempAppliedCustLedgEntry;"Cust. Ledger Entry")
            {
                CalcFields = "Original Amt. (LCY)", "Amount (LCY)";
                DataItemTableView = sorting("Entry No.");
                UseTemporary = true;

                column(ReportForNavId_1000000000;1000000000)
                {
                } // Autogenerated by ForNav - Do not delete
                column(ReportForNav_TempAppliedCustLedgEntry;ReportForNavWriteDataItem('TempAppliedCustLedgEntry', TempAppliedCustLedgEntry))
                {
                }
                trigger OnPreDataItem();
                begin
                    SetFilter("Salesperson Code", SalespersonFilterString);
                    ReportForNav.OnPreDataItem('TempAppliedCustLedgEntry', TempAppliedCustLedgEntry);
                end;
                trigger OnAfterGetRecord();
                begin
                    CalcFields("Remaining Amt. (LCY)", "Amount (LCY)");
                end;
            }
            trigger OnPreDataItem();
            begin
                SetRange("Salesperson Code");
                ReportForNav.OnPreDataItem('CustLedgerEntry', CustLedgerEntry);
            end;
            trigger OnAfterGetRecord();
            begin
                CalcFields("Amount (LCY)");
                GetAppliedCustEntries(CustLedgerEntry, true);
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
        Commit;
        LoadWatermark;
    end;
    trigger OnPostReport()begin
    end;
    trigger OnPreReport()begin
        SalespersonFilterString:=CustLedgerEntry.GetFilter("Salesperson Code");
        ;
        ;
        ReportsForNavPre;
    end;
    var SalespersonFilterString: Text;
    local procedure LoadWatermark()var ForNAVSetup: Record "ForNAV Setup";
    OutStream: OutStream;
    begin
        ForNAVSetup.Get;
        ForNAVSetup.CalcFields(ForNAVSetup."List Report Watermark (Lands.)");
        if not ForNAVSetup."List Report Watermark (Lands.)".Hasvalue then exit;
        ForNAVSetup."List Report Watermark (Lands.)".CreateOutstream(OutStream);
        ReportForNav.LoadWatermarkImage(ForNAVSetup.GetListReportWatermarkLandscape);
    end;
    procedure GetAppliedCustEntries(CustLedgEntry: Record "Cust. Ledger Entry";
    UseLCY: Boolean)var DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
    PmtDtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
    PmtCustLedgEntry: Record "Cust. Ledger Entry";
    ClosingCustLedgEntry: Record "Cust. Ledger Entry";
    AmountToApply: Decimal;
    AppliedDtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
    begin
        TempAppliedCustLedgEntry.Reset;
        TempAppliedCustLedgEntry.DeleteAll;
        DtldCustLedgEntry.SetCurrentkey("Cust. Ledger Entry No.");
        DtldCustLedgEntry.SetRange("Cust. Ledger Entry No.", CustLedgEntry."Entry No.");
        DtldCustLedgEntry.SetRange(Unapplied, false);
        if DtldCustLedgEntry.Find('-')then repeat if DtldCustLedgEntry."Cust. Ledger Entry No." = DtldCustLedgEntry."Applied Cust. Ledger Entry No." then begin
                    AppliedDtldCustLedgEntry.Init;
                    AppliedDtldCustLedgEntry.SetCurrentkey("Applied Cust. Ledger Entry No.", "Entry Type");
                    AppliedDtldCustLedgEntry.SetRange("Applied Cust. Ledger Entry No.", DtldCustLedgEntry."Applied Cust. Ledger Entry No.");
                    AppliedDtldCustLedgEntry.SetRange("Entry Type", AppliedDtldCustLedgEntry."entry type"::Application);
                    AppliedDtldCustLedgEntry.SetRange(Unapplied, false);
                    if AppliedDtldCustLedgEntry.Find('-')then repeat if AppliedDtldCustLedgEntry."Cust. Ledger Entry No." <> AppliedDtldCustLedgEntry."Applied Cust. Ledger Entry No." then begin
                                if ClosingCustLedgEntry.Get(AppliedDtldCustLedgEntry."Cust. Ledger Entry No.")then begin
                                    TempAppliedCustLedgEntry:=ClosingCustLedgEntry;
                                    if UseLCY then TempAppliedCustLedgEntry."Amount to Apply":=-AppliedDtldCustLedgEntry."Amount (LCY)"
                                    else
                                        TempAppliedCustLedgEntry."Amount to Apply":=-AppliedDtldCustLedgEntry.Amount;
                                    if TempAppliedCustLedgEntry.Insert then;
                                end;
                            end;
                        until AppliedDtldCustLedgEntry.Next = 0;
                end
                else
                begin
                    if ClosingCustLedgEntry.Get(DtldCustLedgEntry."Applied Cust. Ledger Entry No.")then begin
                        TempAppliedCustLedgEntry:=ClosingCustLedgEntry;
                        if UseLCY then TempAppliedCustLedgEntry."Amount to Apply":=DtldCustLedgEntry."Amount (LCY)"
                        else
                            TempAppliedCustLedgEntry."Amount to Apply":=DtldCustLedgEntry.Amount;
                        if TempAppliedCustLedgEntry.Insert then;
                    end;
                end;
            until DtldCustLedgEntry.Next = 0;
        if CustLedgEntry."Closed by Entry No." <> 0 then begin
            if ClosingCustLedgEntry.Get(CustLedgEntry."Closed by Entry No.")then begin
                TempAppliedCustLedgEntry:=ClosingCustLedgEntry;
                if UseLCY then TempAppliedCustLedgEntry."Amount to Apply":=-CustLedgEntry."Closed by Amount (LCY)"
                else
                    TempAppliedCustLedgEntry."Amount to Apply":=-CustLedgEntry."Closed by Amount";
                if TempAppliedCustLedgEntry.Insert then;
            end;
        end;
        ClosingCustLedgEntry.Reset;
        ClosingCustLedgEntry.SetCurrentkey("Closed by Entry No.");
        ClosingCustLedgEntry.SetRange("Closed by Entry No.", CustLedgEntry."Entry No.");
        if ClosingCustLedgEntry.Find('-')then repeat TempAppliedCustLedgEntry:=ClosingCustLedgEntry;
                if UseLCY then TempAppliedCustLedgEntry."Amount to Apply":=ClosingCustLedgEntry."Closed by Amount (LCY)"
                else
                    TempAppliedCustLedgEntry."Amount to Apply":=ClosingCustLedgEntry."Closed by Amount";
                if TempAppliedCustLedgEntry.Insert then;
            until ClosingCustLedgEntry.Next = 0;
        if TempAppliedCustLedgEntry.IsEmpty then begin
            TempAppliedCustLedgEntry.Init;
            TempAppliedCustLedgEntry."Entry No.":=0;
            TempAppliedCustLedgEntry."Salesperson Code":=CustLedgEntry."Salesperson Code";
            TempAppliedCustLedgEntry.Insert;
        //  ApplicationExist := FALSE;
        end;
    // ELSE
    //  ApplicationExist := TRUE;
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
            jsonObject.Add('CustLedgerEntry$Get$Filters$Text', CustLedgerEntry.GetFilters());
            jsonObject.Add('CustLedgerEntry$Get$Caption$Text', CustLedgerEntry.TableCaption());
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
