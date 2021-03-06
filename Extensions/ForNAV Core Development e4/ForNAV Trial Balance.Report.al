Report 6188677 "ForNAV Trial Balance"
{
    Caption = 'Trial Balance';
    WordLayout = './Layouts/ForNAV Trial Balance.docx';
    DefaultLayout = Word;

    dataset
    {
        dataitem(Args;"ForNAV Trial Balance Args.")
        {
            DataItemTableView = sorting("Show by");
            UseTemporary = true;

            column(ReportForNavId_1000000001;1000000001)
            {
            } // Autogenerated by ForNav - Do not delete
            column(ReportForNav_Args;ReportForNavWriteDataItem('Args', Args))
            {
            }
            dataitem("G/L Account";"G/L Account")
            {
                DataItemTableView = sorting("No.");
                PrintOnlyIfDetail = true;
                RequestFilterFields = "No.", "Account Type", "Date Filter", "Global Dimension 1 Filter", "Global Dimension 2 Filter", "Budget Filter";

                column(ReportForNavId_6710;6710)
                {
                } // Autogenerated by ForNav - Do not delete
                column(ReportForNav_G_LAccount;ReportForNavWriteDataItem('G_LAccount', "G/L Account"))
                {
                }
                trigger OnPreDataItem();
                begin
                    ReportForNav.OnPreDataItem('G_LAccount', "G/L Account");
                end;
                trigger OnAfterGetRecord();
                begin
                    TrialBalance.CreateForGLAccount("G/L Account", Args);
                end;
            }
            dataitem(TrialBalance;"ForNAV Trial Balance")
            {
                DataItemTableView = sorting("G/L Account No.");
                UseTemporary = true;

                column(ReportForNavId_1000000002;1000000002)
                {
                } // Autogenerated by ForNav - Do not delete
                column(ReportForNav_TrialBalance;ReportForNavWriteDataItem('TrialBalance', TrialBalance))
                {
                }
                trigger OnPreDataItem();
                begin
                    ReportForNav.OnPreDataItem('TrialBalance', TrialBalance);
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

                    field(ShowComaprison;Args."Show by")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show by';
                    }
                    group(ColumnOption)
                    {
                        Caption = 'Column Option';

                        field(NetChangeActual;Args."Net Change Actual")
                        {
                            ApplicationArea = All;
                            Caption = 'Net Change Actual';
                        }
                        field(NetChangeActualLastYear;Args."Net Change Actual Last Year")
                        {
                            ApplicationArea = All;
                            Caption = 'Net Change Actual Last Year';
                        }
                        field(Difference;Args."Variance in Changes")
                        {
                            ApplicationArea = All;
                            Caption = 'Difference';
                        }
                        field(Variance;Args."% Variance in Changes")
                        {
                            ApplicationArea = All;
                            Caption = 'Variance %';
                        }
                        field(BalanceatDateActual;Args."Balance at Date Actual")
                        {
                            ApplicationArea = All;
                            Caption = 'Balance at Date Actual';
                        }
                        field(BalanceatDateActLastYear;Args."Balance at Date Act. Last Year")
                        {
                            ApplicationArea = All;
                            Caption = 'Balance at Date Act. Last Year';
                        }
                        field(ArgsVarianceinBalances;Args."Variance in Balances")
                        {
                            ApplicationArea = All;
                            Caption = 'Difference';
                        }
                        field(Control1000000007;Args."% Variance in Balances")
                        {
                            ApplicationArea = All;
                            Caption = 'Variance %';
                        }
                    }
                    field(RoundingFactor;Args."Rounding Factor")
                    {
                        ApplicationArea = All;
                        Caption = 'Rounding Factor';
                    }
                    field(SkipAccountswithallzeroAmounts;Args."Skip Accounts with all zero")
                    {
                        ApplicationArea = All;
                        Caption = 'Skip Accounts with all zero Amounts';
                        Visible = false;
                    }
                    field(AllAmountsinLCY;Args."All Amounts in LCY")
                    {
                        ApplicationArea = All;
                        Caption = 'All Amounts in LCY';
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
            if Args.GetNoOfColumns = 0 then begin
                Args."Net Change Actual":=true;
                Args."Net Change Actual Last Year":=true;
            end;
            Args."All Amounts in LCY":=true;
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
        Args."From Date":="G/L Account".GetRangeMin("Date Filter");
        Args."To Date":="G/L Account".GetRangemax("Date Filter");
        "G/L Account".SetRange("Date Filter");
        ;
        ;
        ReportsForNavPre;
    end;
    procedure SetArgs(Value: Record "ForNAV Trial Balance Args.")begin
        Args:=Value;
    end;
    local procedure LoadWatermark()var ForNAVSetup: Record "ForNAV Setup";
    OutStream: OutStream;
    begin
        ForNAVSetup.Get;
        ForNAVSetup.CalcFields(ForNAVSetup."List Report Watermark");
        if not ForNAVSetup."List Report Watermark".Hasvalue then exit;
        ReportForNav.LoadWatermarkImage(ForNAVSetup.GetListReportWatermark);
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
            jsonObject.Add('G_LAccount$Get$Filters$Text', "G/L Account".GetFilters());
            jsonObject.Add('G_LAccount$Get$Caption$Text', "G/L Account".TableCaption());
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
