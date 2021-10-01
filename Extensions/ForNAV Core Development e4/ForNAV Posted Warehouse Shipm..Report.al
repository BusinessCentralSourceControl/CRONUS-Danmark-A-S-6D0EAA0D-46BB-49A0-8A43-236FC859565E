Report 6188485 "ForNAV Posted Warehouse Shipm."
{
    Caption = 'Warehouse Shipment (Posted)';
    WordLayout = './Layouts/ForNAV Posted Warehouse Shipm..docx';
    DefaultLayout = Word;

    dataset
    {
        dataitem(Header;"Posted Whse. Shipment Header")
        {
            RequestFilterFields = "No.", "Location Code";

            column(ReportForNavId_1000000000;1000000000)
            {
            } // Autogenerated by ForNav - Do not delete
            column(ReportForNav_Header;ReportForNavWriteDataItem('Header', Header))
            {
            }
            dataitem(Line;"Posted Whse. Shipment Line")
            {
                DataItemLink = "No."=FIELD("No.");
#pragma warning disable AL0254 DataItemTableView = sorting("No.", "Bin Code");

#pragma warning restore AL0254 column(ReportForNavId_1000000001;1000000001)
                {
                } // Autogenerated by ForNav - Do not delete
                column(ReportForNav_Line;ReportForNavWriteDataItem('Line', Line))
                {
                }
                dataitem(BOMComponent;"BOM Component")
                {
                    DataItemLink = "Parent Item No."=FIELD("Item No.");
                    DataItemTableView = sorting("Parent Item No.", "Line No.");

                    column(ReportForNavId_1000000002;1000000002)
                    {
                    } // Autogenerated by ForNav - Do not delete
                    column(ReportForNav_BOMComponent;ReportForNavWriteDataItem('BOMComponent', BOMComponent))
                    {
                    }
                    trigger OnPreDataItem();
                    begin
                        ReportForNav.OnPreDataItem('BOMComponent', BOMComponent);
                    end;
                }
                dataitem(CommentLine;"Sales Comment Line")
                {
                    DataItemLink = "No."=FIELD("Source No."), "Document Line No."=FIELD("Source Line No.");
                    DataItemTableView = sorting("Document Type", "No.", "Document Line No.", "Line No.")where("Document Type"=const(Order));

                    column(ReportForNavId_1000000003;1000000003)
                    {
                    } // Autogenerated by ForNav - Do not delete
                    column(ReportForNav_CommentLine;ReportForNavWriteDataItem('CommentLine', CommentLine))
                    {
                    }
                    trigger OnPreDataItem();
                    begin
                        ReportForNav.OnPreDataItem('CommentLine', CommentLine);
                    end;
                }
                trigger OnPreDataItem();
                begin
                    ReportForNav.OnPreDataItem('Line', Line);
                end;
            }
            trigger OnPreDataItem();
            begin
                ReportForNav.OnPreDataItem('Header', Header);
            end;
            trigger OnAfterGetRecord();
            begin
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
            ReportForNavInit(jsonObject);
            ReportForNavInitialized:=true;
        end;
        case(dataItemId)of 'Header': begin
            currLanguage:=GlobalLanguage;
            GlobalLanguage:=1033;
            jsonObject.Add('DataItem$Header$CurrentKey$Text', Header.CurrentKey);
            GlobalLanguage:=currLanguage;
        end;
        end;
        ReportForNav.AddDataItemValues(jsonObject, dataItemId, rec);
        jsonObject.WriteTo(values);
        exit(values);
    end;
// Reports ForNAV Autogenerated code - do not delete or modify -->
}
