Report 6188661 "ForNAV Sales Shipment Label"
{
    Caption = 'Sales Shipment Label';
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Args;"ForNAV Label Args.")
        {
            DataItemTableView = sorting("Report ID");
            UseTemporary = true;

            column(ReportForNavId_2;2)
            {
            }
        }
        dataitem(Label;"Sales Shipment Header")
        {
            RequestFilterFields = "No.", "Shipment Date";

            column(ReportForNavId_1;1)
            {
            }
            trigger OnPreDataItem()begin
                ShowLabelWarning;
            end;
            trigger OnAfterGetRecord()begin
                PrintLabel;
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

                    field(Orientation;Args.Orientation)
                    {
                        ApplicationArea = All;
                        Caption = 'Orientation';

                        trigger OnValidate()begin
                            Args.Validate(Orientation, Args.Orientation);
                        end;
                    }
                    field(OneLabelPerPackage;Args."One Label per Package")
                    {
                        ApplicationArea = All;
                        Caption = 'One Label per Package';
                    }
                    field(DirectPrint;Args."Direct Print")
                    {
                        ApplicationArea = All;
                        Caption = 'Direct Print';
                    }
                    field(ForNavOpenDesigner;Args."Open Designer")
                    {
                        ApplicationArea = All;
                        Caption = 'Design';
                    }
                }
            }
        }
        trigger OnOpenPage()begin
            Args.GetOrientationForRequestPage;
        end;
    }
    trigger OnInitReport()begin
        Codeunit.Run(Codeunit::"ForNAV First Time Setup");
        Commit;
    end;
    procedure SetArgs(var ArgsSet: Record "ForNAV Label Args.")begin
        if not ArgsSet.IsTemporary then Error('Coding error, contact system admin.');
        Args.Copy(ArgsSet, true);
    end;
    procedure GetArgs(var ArgsGet: Record "ForNAV Label Args.")begin
        Args.FindFirst;
        if not ArgsGet.IsTemporary then Error('Coding error, contact system admin.');
        ArgsGet.Copy(Args, true);
    end;
    local procedure PrintLabel()var CreateLabel: Codeunit "ForNAV Label Mgt.";
    begin
        case Args.Orientation of Args.Orientation::Landscape: Args."Report ID":=Report::"ForNAV Label Landscape";
        Args.Orientation::Portrait: Args."Report ID":=Report::"ForNAV Label Portrait";
        end;
        Args.CreateLabels(Label);
        if Args."Print to Stream" then Args.Insert;
    end;
    local procedure ShowLabelWarning()var LabelWarning: Codeunit "ForNAV Label Warning";
    begin
        LabelWarning.ShowLabelWarning(Label.Count);
    end;
}
