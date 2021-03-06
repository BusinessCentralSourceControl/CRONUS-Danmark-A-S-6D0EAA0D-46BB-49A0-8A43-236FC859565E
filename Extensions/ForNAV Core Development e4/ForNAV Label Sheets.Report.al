Report 6188684 "ForNAV Label Sheets"
{
    Caption = 'Label Sheets';
    UsageCategory = ReportsAndAnalysis;
    WordLayout = './Layouts/ForNAV Label Sheets.docx';
    DefaultLayout = Word;

    dataset
    {
        dataitem(Args;"ForNAV Label Sheet Args.")
        {
            DataItemTableView = sorting("Table ID");
            UseTemporary = true;

            column(ReportForNavId_1;1)
            {
            } // Autogenerated by ForNav - Do not delete
            column(ReportForNav_Args;ReportForNavWriteDataItem('Args', Args))
            {
            }
            dataitem(LabelSheet;"ForNAV Label Sheet")
            {
                DataItemTableView = sorting("Row No.");
                UseTemporary = true;

                column(ReportForNavId_2;2)
                {
                } // Autogenerated by ForNav - Do not delete
                column(ReportForNav_LabelSheet;ReportForNavWriteDataItem('LabelSheet', LabelSheet))
                {
                }
                trigger OnPreDataItem();
                begin
                    ReportForNav.OnPreDataItem('LabelSheet', LabelSheet);
                end;
            }
            trigger OnPreDataItem();
            begin
                Insert;
                LabelSheet.FindFirst;
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

                    field(TableName;Args."Table Name")
                    {
                        ApplicationArea = All;
                        Caption = 'Table Name';
                        Editable = false;
                        TableRelation = AllObjWithCaption."Object Caption" where("Object Type"=filter(Table));

                        trigger OnAssistEdit()begin
                            Args.ShowFilteredTableList;
                        end;
                        trigger OnLookup(var Text: Text): Boolean begin
                            Args.ShowFilteredTableList;
                        end;
                    }
                    field(NoOfLabels;Args."No. of Labels")
                    {
                        ApplicationArea = All;
                        Caption = 'No. of Labels';
                        MaxValue = 9;
                        MinValue = 1;
                    }
                    field(TableID;Args."Table ID")
                    {
                        ApplicationArea = All;
                        Visible = false;
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
            SetInitValues;
        end;
    }
    trigger OnInitReport()begin
        ;
        ReportsForNavInit;
    end;
    trigger OnPostReport()begin
    end;
    trigger OnPreReport()var GetLabelSheet: Codeunit "ForNAV Get Label Sheet";
    begin
        if not ReportForNavOpenDesigner then GetLabelSheet.GetLabels(Args, LabelSheet);
        ;
        ;
        ReportsForNavPre;
    end;
    local procedure SetInitValues()var AllObjWithCaption: Record AllObjWithCaption;
    begin
        if Args."No. of Labels" = 0 then Args."No. of Labels":=2;
        if Args."Table ID" = 0 then begin
            Args."Table ID":=27;
            AllObjWithCaption.SetRange("Object ID", Args."Table ID");
            AllObjWithCaption.SetRange("Object Type", AllObjWithCaption."object type"::Table);
            AllObjWithCaption.FindFirst;
            Args."Table Name":=AllObjWithCaption."Object Caption";
        end;
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
