Report 6188713 "ForNAV Inventory Valuation"
{
    Caption = 'Inventory Valuation';
    UsageCategory = ReportsAndAnalysis;
    WordLayout = './Layouts/ForNAV Inventory Valuation.docx';
    DefaultLayout = Word;

    dataset
    {
        dataitem(Args;"ForNAV Inv. Valuation Args.")
        {
            DataItemTableView = sorting("Starting Date");
            UseTemporary = true;

            column(ReportForNavId_42;42)
            {
            } // Autogenerated by ForNav - Do not delete
            column(ReportForNav_Args;ReportForNavWriteDataItem('Args', Args))
            {
            }
            dataitem(Item;Item)
            {
                DataItemTableView = sorting("Inventory Posting Group")where(Type=const(Inventory));
                RequestFilterFields = "No.", "Inventory Posting Group", "Statistics Group";

                column(ReportForNavId_8129;8129)
                {
                } // Autogenerated by ForNav - Do not delete
                column(ReportForNav_Item;ReportForNavWriteDataItem('Item', Item))
                {
                }
                trigger OnPreDataItem();
                begin
                    ReportForNav.OnPreDataItem('Item', Item);
                end;
                trigger OnAfterGetRecord();
                begin
                    CalcFields("Assembly BOM");
                    if Args."Ending Date" = 0D then Args."Ending Date":=Dmy2date(31, 12, 9999);
                    InventoryValuation.StartingInvoicedValue:=0;
                    InventoryValuation.StartingExpectedValue:=0;
                    InventoryValuation.StartingInvoicedQty:=0;
                    InventoryValuation.StartingExpectedQty:=0;
                    InventoryValuation.IncreaseInvoicedValue:=0;
                    InventoryValuation.IncreaseExpectedValue:=0;
                    InventoryValuation.IncreaseInvoicedQty:=0;
                    InventoryValuation.IncreaseExpectedQty:=0;
                    InventoryValuation.DecreaseInvoicedValue:=0;
                    InventoryValuation.DecreaseExpectedValue:=0;
                    InventoryValuation.DecreaseInvoicedQty:=0;
                    InventoryValuation.DecreaseExpectedQty:=0;
                    InventoryValuation.InvCostPostedToGL:=0;
                    InventoryValuation.CostPostedToGL:=0;
                    InventoryValuation.ExpCostPostedToGL:=0;
                    IsEmptyLine:=true;
                    ValueEntry.Reset;
                    ValueEntry.SetRange("Item No.", "No.");
                    ValueEntry.SetFilter("Variant Code", GetFilter("Variant Filter"));
                    ValueEntry.SetFilter("Location Code", GetFilter("Location Filter"));
                    ValueEntry.SetFilter("Global Dimension 1 Code", GetFilter("Global Dimension 1 Filter"));
                    ValueEntry.SetFilter("Global Dimension 2 Code", GetFilter("Global Dimension 2 Filter"));
                    if Args."Starting Date" > 0D then begin
                        ValueEntry.SetRange("Posting Date", 0D, CalcDate('<-1D>', Args."Starting Date"));
                        ValueEntry.CalcSums("Item Ledger Entry Quantity", "Cost Amount (Actual)", "Cost Amount (Expected)", "Invoiced Quantity");
                        AssignAmounts(ValueEntry, InventoryValuation.StartingInvoicedValue, InventoryValuation.StartingInvoicedQty, InventoryValuation.StartingExpectedValue, InventoryValuation.StartingExpectedQty, 1);
                        IsEmptyLine:=IsEmptyLine and ((InventoryValuation.StartingInvoicedValue = 0) and (InventoryValuation.StartingInvoicedQty = 0));
                        if Args."Expected Cost" then IsEmptyLine:=IsEmptyLine and ((InventoryValuation.StartingExpectedValue = 0) and (InventoryValuation.StartingExpectedQty = 0));
                    end;
                    ValueEntry.SetRange("Posting Date", Args."Starting Date", Args."Ending Date");
                    ValueEntry.SetFilter("Item Ledger Entry Type", '%1|%2|%3|%4', ValueEntry."item ledger entry type"::Purchase, ValueEntry."item ledger entry type"::"Positive Adjmt.", ValueEntry."item ledger entry type"::Output, ValueEntry."item ledger entry type"::"Assembly Output");
                    ValueEntry.CalcSums("Item Ledger Entry Quantity", "Cost Amount (Actual)", "Cost Amount (Expected)", "Invoiced Quantity");
                    AssignAmounts(ValueEntry, InventoryValuation.IncreaseInvoicedValue, InventoryValuation.IncreaseInvoicedQty, InventoryValuation.IncreaseExpectedValue, InventoryValuation.IncreaseExpectedQty, 1);
                    ValueEntry.SetRange("Posting Date", Args."Starting Date", Args."Ending Date");
                    ValueEntry.SetFilter("Item Ledger Entry Type", '%1|%2|%3|%4', ValueEntry."item ledger entry type"::Sale, ValueEntry."item ledger entry type"::"Negative Adjmt.", ValueEntry."item ledger entry type"::Consumption, ValueEntry."item ledger entry type"::"Assembly Consumption");
                    ValueEntry.CalcSums("Item Ledger Entry Quantity", "Cost Amount (Actual)", "Cost Amount (Expected)", "Invoiced Quantity");
                    AssignAmounts(ValueEntry, InventoryValuation.DecreaseInvoicedValue, InventoryValuation.DecreaseInvoicedQty, InventoryValuation.DecreaseExpectedValue, InventoryValuation.DecreaseExpectedQty, -1);
                    ValueEntry.SetRange("Posting Date", Args."Starting Date", Args."Ending Date");
                    ValueEntry.SetRange("Item Ledger Entry Type", ValueEntry."item ledger entry type"::Transfer);
                    if ValueEntry.FindSet then repeat if true in[ValueEntry."Valued Quantity" < 0, not GetOutboundItemEntry(ValueEntry."Item Ledger Entry No.")]then AssignAmounts(ValueEntry, InventoryValuation.DecreaseInvoicedValue, InventoryValuation.DecreaseInvoicedQty, InventoryValuation.DecreaseExpectedValue, InventoryValuation.DecreaseExpectedQty, -1)
                            else
                                AssignAmounts(ValueEntry, InventoryValuation.IncreaseInvoicedValue, InventoryValuation.IncreaseInvoicedQty, InventoryValuation.IncreaseExpectedValue, InventoryValuation.IncreaseExpectedQty, 1);
                        until ValueEntry.Next = 0;
                    IsEmptyLine:=IsEmptyLine and ((InventoryValuation.IncreaseInvoicedValue = 0) and (InventoryValuation.IncreaseInvoicedQty = 0));
                    IsEmptyLine:=IsEmptyLine and ((InventoryValuation.DecreaseInvoicedValue = 0) and (InventoryValuation.DecreaseInvoicedQty = 0));
                    if Args."Expected Cost" then begin
                        IsEmptyLine:=IsEmptyLine and ((InventoryValuation.IncreaseExpectedValue = 0) and (InventoryValuation.IncreaseExpectedQty = 0));
                        IsEmptyLine:=IsEmptyLine and ((InventoryValuation.DecreaseExpectedValue = 0) and (InventoryValuation.DecreaseExpectedQty = 0));
                    end;
                    ValueEntry.SetRange("Posting Date", 0D, Args."Ending Date");
                    ValueEntry.SetRange("Item Ledger Entry Type");
                    ValueEntry.CalcSums("Cost Posted to G/L", "Expected Cost Posted to G/L");
                    InventoryValuation.ExpCostPostedToGL+=ValueEntry."Expected Cost Posted to G/L";
                    InventoryValuation.InvCostPostedToGL+=ValueEntry."Cost Posted to G/L";
                    InventoryValuation.StartingExpectedValue+=InventoryValuation.StartingInvoicedValue;
                    InventoryValuation.IncreaseExpectedValue+=InventoryValuation.IncreaseInvoicedValue;
                    InventoryValuation.DecreaseExpectedValue+=InventoryValuation.DecreaseInvoicedValue;
                    InventoryValuation.CostPostedToGL:=InventoryValuation.ExpCostPostedToGL + InventoryValuation.InvCostPostedToGL;
                    if IsEmptyLine then CurrReport.Skip;
                    InventoryValuation."Item No.":="No.";
                    InventoryValuation.Description:=Description;
                    InventoryValuation."Inventory Posting Group":="Inventory Posting Group";
                    InventoryValuation.SetPrintExpectedCost(Args);
                    InventoryValuation.Insert;
                    InventoryValuation.SetRange("Item No.", "No.");
                end;
                trigger OnPostDataItem();
                begin
                    InventoryValuation.Reset;
                end;
            }
            dataitem(InventoryValuation;"ForNAV Inventory Valuation")
            {
                DataItemTableView = sorting("Inventory Posting Group");
                UseTemporary = true;

                column(ReportForNavId_1;1)
                {
                } // Autogenerated by ForNav - Do not delete
                column(ReportForNav_InventoryValuation;ReportForNavWriteDataItem('InventoryValuation', InventoryValuation))
                {
                }
                trigger OnPreDataItem();
                begin
                    ReportForNav.OnPreDataItem('InventoryValuation', InventoryValuation);
                end;
            }
            trigger OnPreDataItem();
            begin
                Insert;
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

                    field(StartingDate;Args."Starting Date")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Starting Date';
                    }
                    field(EndingDate;Args."Ending Date")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Ending Date';
                    }
                    group(Show)
                    {
                        Caption = 'Show';

                        field(IncludeExpectedCost;Args."Expected Cost")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Expected Cost';
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
            if(Args."Starting Date" = 0D) and (Args."Ending Date" = 0D)then begin
                Args."Ending Date":=WorkDate;
                Args."Expected Cost":=true;
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
        if(Args."Starting Date" = 0D) and (Args."Ending Date" = 0D)then Args."Ending Date":=WorkDate;
        if Args."Starting Date" in[0D, 00000101D]then StartDateText:=''
        else
            StartDateText:=Format(Args."Starting Date" - 1);
        ItemFilter:=Item.GetFilters;
        ;
        ;
        ReportsForNavPre;
    end;
    var ValueEntry: Record "Value Entry";
    ItemFilter: Text;
    StartDateText: Text[10];
    IsEmptyLine: Boolean;
    local procedure LoadWatermark()var ForNAVSetup: Record "ForNAV Setup";
    OutStream: OutStream;
    begin
        ForNAVSetup.Get;
        ForNAVSetup.CalcFields(ForNAVSetup."List Report Watermark (Lands.)");
        if not ForNAVSetup."List Report Watermark (Lands.)".Hasvalue then exit;
        ForNAVSetup."List Report Watermark (Lands.)".CreateOutstream(OutStream);
        ReportForNav.LoadWatermarkImage(ForNAVSetup.GetListReportWatermarkLandscape);
    end;
    local procedure AssignAmounts(ValueEntry: Record "Value Entry";
    var InvoicedValue: Decimal;
    var InvoicedQty: Decimal;
    var ExpectedValue: Decimal;
    var ExpectedQty: Decimal;
    Sign: Decimal)begin
        InvoicedValue+=ValueEntry."Cost Amount (Actual)" * Sign;
        InvoicedQty+=ValueEntry."Invoiced Quantity" * Sign;
        ExpectedValue+=ValueEntry."Cost Amount (Expected)" * Sign;
        ExpectedQty+=ValueEntry."Item Ledger Entry Quantity" * Sign;
    end;
    local procedure GetOutboundItemEntry(ItemLedgerEntryNo: Integer): Boolean var ItemApplnEntry: Record "Item Application Entry";
    ItemLedgEntry: Record "Item Ledger Entry";
    begin
        ItemApplnEntry.SetCurrentkey("Item Ledger Entry No.");
        ItemApplnEntry.SetRange("Item Ledger Entry No.", ItemLedgerEntryNo);
        if not ItemApplnEntry.FindFirst then exit(true);
        ItemLedgEntry.SetRange("Item No.", Item."No.");
        ItemLedgEntry.SetFilter("Variant Code", Item.GetFilter("Variant Filter"));
        ItemLedgEntry.SetFilter("Location Code", Item.GetFilter("Location Filter"));
        ItemLedgEntry.SetFilter("Global Dimension 1 Code", Item.GetFilter("Global Dimension 1 Filter"));
        ItemLedgEntry.SetFilter("Global Dimension 2 Code", Item.GetFilter("Global Dimension 2 Filter"));
        ItemLedgEntry."Entry No.":=ItemApplnEntry."Outbound Item Entry No.";
        exit(not ItemLedgEntry.Find);
    end;
    procedure SetStartDate(DateValue: Date)begin
        Args."Starting Date":=DateValue;
    end;
    procedure SetEndDate(DateValue: Date)begin
        Args."Ending Date":=DateValue;
    end;
    procedure InitializeRequest(NewStartDate: Date;
    NewEndDate: Date;
    NewShowExpected: Boolean)begin
        Args."Starting Date":=NewStartDate;
        Args."Ending Date":=NewEndDate;
        Args."Expected Cost":=NewShowExpected;
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
        case(dataItemId)of end;
        ReportForNav.AddDataItemValues(jsonObject, dataItemId, rec);
        jsonObject.WriteTo(values);
        exit(values);
    end;
// Reports ForNAV Autogenerated code - do not delete or modify -->
}
