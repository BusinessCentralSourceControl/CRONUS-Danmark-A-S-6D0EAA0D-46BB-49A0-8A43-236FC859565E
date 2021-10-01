Report 6188678 "ForNAV Reconcile A/P to G/L"
{
    Caption = 'Reconcile AP to GL';
    UsageCategory = ReportsAndAnalysis;
    WordLayout = './Layouts/ForNAV Reconcile AP to GL.docx';
    DefaultLayout = Word;

    dataset
    {
        dataitem(Integer;Integer)
        {
            DataItemTableView = sorting(Number)where(Number=filter(1));
            MaxIteration = 1;

            column(ReportForNavId_1000000002;1000000002)
            {
            } // Autogenerated by ForNav - Do not delete
            column(ReportForNav_Integer;ReportForNavWriteDataItem('Integer', Integer))
            {
            }
            dataitem("Purchase Line";"Purchase Line")
            {
                DataItemTableView = where("Document Type"=const(Order));
                RequestFilterFields = "Document No.", "Buy-from Vendor No.", Type, "No.", "Location Code", "Posting Group", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code";

                column(ReportForNavId_6547;6547)
                {
                } // Autogenerated by ForNav - Do not delete
                column(ReportForNav_PurchaseLine;ReportForNavWriteDataItem('PurchaseLine', "Purchase Line"))
                {
                }
                trigger OnPreDataItem();
                begin
                    SetFilter("Amt. Rcd. Not Invoiced", '<>0');
                    ReportForNav.OnPreDataItem('PurchaseLine', "Purchase Line");
                end;
                trigger OnAfterGetRecord();
                var Vendor: Record Vendor;
                VendorPostingGroup: Record "Vendor Posting Group";
                GenPostingSetup: Record "General Posting Setup";
                begin
                    if Vendor.Get("Buy-from Vendor No.")then if not VendorPostingGroup.Get(Vendor."Vendor Posting Group")then VendorPostingGroup.Init;
                    AddToTable(VendorPostingGroup."Payables Account", -"Amt. Rcd. Not Invoiced (LCY)");
                    if Type = Type::"G/L Account" then AddToTable("No.", "Amt. Rcd. Not Invoiced (LCY)")
                    else if Type = Type::"Fixed Asset" then AddToTable("No.", "Amt. Rcd. Not Invoiced (LCY)")
                        else
                        begin
                            if not GenPostingSetup.Get("Gen. Bus. Posting Group", "Gen. Prod. Posting Group")then GenPostingSetup.Init;
                            AddToTable(GenPostingSetup."Purch. Account", "Amt. Rcd. Not Invoiced (LCY)");
                        end;
                end;
            }
            dataitem(GLBuffer;"ForNAV Reconcile AP to GL Buf.")
            {
                DataItemTableView = sorting("Account No.");
                UseTemporary = true;

                column(ReportForNavId_1000000000;1000000000)
                {
                } // Autogenerated by ForNav - Do not delete
                column(ReportForNav_GLBuffer;ReportForNavWriteDataItem('GLBuffer', GLBuffer))
                {
                }
                trigger OnPreDataItem();
                begin
                    ReportForNav.OnPreDataItem('GLBuffer', GLBuffer);
                end;
            }
            trigger OnPreDataItem();
            begin
                ReportForNav.OnPreDataItem('Integer', Integer);
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
    procedure AddToTable(Acnt: Code[20];
    Amt: Decimal)var GLAccount: Record "G/L Account";
    UnknownTxt: label '******************', Comment='DO NOT TRANSLATE';
    begin
        if not GLBuffer.Get(Acnt)then begin
            GLBuffer.Init;
            GLBuffer."Account No.":=Acnt;
            if GLAccount.Get(Acnt)then GLBuffer."Account Name":=GLAccount.Name
            else
                GLBuffer."Account Name":=UnknownTxt;
            GLBuffer.Insert;
        end;
        if Amt > 0 then GLBuffer."Debit Amount"+=Amt
        else
            GLBuffer."Credit Amount"+=Amt;
        GLBuffer.Modify;
    end;
    local procedure GetFixedAssetGLAcc(Value: Code[20]): Code[20]var FADepBook: Record "FA Depreciation Book";
    DepBook: Record "Depreciation Book";
    FAPostingGroup: Record "FA Posting Group";
    begin
        FADepBook.Reset;
        FADepBook.SetRange("FA No.", Value);
        FADepBook.SetFilter("Depreciation Book Code", '<>%1', '');
        FADepBook.SetFilter("FA Posting Group", '<>%1', '');
        if FADepBook.FindSet then repeat DepBook.Get(FADepBook."Depreciation Book Code");
                if(("Purchase Line"."FA Posting Type" = "Purchase Line"."fa posting type"::"Acquisition Cost") and DepBook."G/L Integration - Acq. Cost") or (("Purchase Line"."FA Posting Type" = "Purchase Line"."fa posting type"::Maintenance) and DepBook."G/L Integration - Maintenance")then begin
                    FAPostingGroup.Get(FADepBook."FA Posting Group");
                    if "Purchase Line"."FA Posting Type" = "Purchase Line"."fa posting type"::"Acquisition Cost" then exit(FAPostingGroup."Acquisition Cost Account")
                    else
                        exit(FAPostingGroup."Maintenance Expense Account");
                    exit('');
                end;
            until FADepBook.Next = 0;
    end;
    local procedure LoadWatermark()var ForNAVSetup: Record "ForNAV Setup";
    OutStream: OutStream;
    begin
        ForNAVSetup.Get;
        ForNAVSetup.CalcFields(ForNAVSetup."List Report Watermark");
        if not ForNAVSetup."List Report Watermark".Hasvalue then exit;
        ReportForNav.LoadWatermarkImage(ForNAVSetup.GetListReportWatermark);
    end;
    trigger OnPreReport();
    begin
        ;
        ReportsForNavPre;
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
            jsonObject.Add('PurchaseLine$Get$Filters$Text', "Purchase Line".GetFilters());
            ReportForNavInit(jsonObject);
            ReportForNavInitialized:=true;
        end;
        case(dataItemId)of 'PurchaseLine': begin
            currLanguage:=GlobalLanguage;
            GlobalLanguage:=1033;
            jsonObject.Add('DataItem$PurchaseLine$CurrentKey$Text', "Purchase Line".CurrentKey);
            GlobalLanguage:=currLanguage;
        end;
        end;
        ReportForNav.AddDataItemValues(jsonObject, dataItemId, rec);
        jsonObject.WriteTo(values);
        exit(values);
    end;
// Reports ForNAV Autogenerated code - do not delete or modify -->
}
