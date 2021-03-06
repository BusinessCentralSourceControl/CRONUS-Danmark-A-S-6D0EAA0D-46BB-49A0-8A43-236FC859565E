Report 6188996 "ForNAV Reminder Template"
{
    Caption = 'Reminder Template';
    WordLayout = './Layouts/ForNAV Reminder Template.docx';
    DefaultLayout = Word;

    dataset
    {
        dataitem(Header;"Issued Reminder Header")
        {
            MaxIteration = 1;
            RequestFilterFields = "No.", "Customer No.";

            column(ReportForNavId_1000000000;1000000000)
            {
            } // Autogenerated by ForNav - Do not delete
            column(ReportForNav_Header;ReportForNavWriteDataItem('Header', Header))
            {
            }
            column(SingleVATPct;VATAmountLine.ForNavSingleVATPct())
            {
            IncludeCaption = false;
            }
            dataitem(Line;"Issued Reminder Line")
            {
                DataItemLink = "Reminder No."=FIELD("No.");
                DataItemTableView = sorting("Reminder No.", "Line No.");

                column(ReportForNavId_1000000001;1000000001)
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
            dataitem(VATAmountLine;"VAT Amount Line")
            {
                UseTemporary = true;
                DataItemTableView = sorting("VAT Identifier", "VAT Calculation Type", "Tax Group Code", "Use Tax", Positive);

                column(ReportForNavId_1000000002;1000000002)
                {
                } // Autogenerated by ForNav - Do not delete
                column(ReportForNav_VATAmountLine;ReportForNavWriteDataItem('VATAmountLine', VATAmountLine))
                {
                }
                trigger OnPreDataItem();
                begin
                    ReportForNav.OnPreDataItem('VATAmountLine', VATAmountLine);
                end;
                trigger OnAfterGetRecord();
                begin
                    if not PrintVATAmountLines then CurrReport.Break;
                end;
            }
            trigger OnPreDataItem();
            begin
                ReportForNav.OnPreDataItem('Header', Header);
            end;
            trigger OnAfterGetRecord();
            begin
                ChangeLanguage("Language Code");
                GetVatAmountLines;
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
    end;
    trigger OnPostReport()begin
    end;
    trigger OnPreReport()begin
        LoadWatermark;
        ;
        ReportsForNavPre;
    end;
    local procedure ChangeLanguage(LanguageCode: Code[10])var ForNAVSetup: Record "ForNAV Setup";
    begin
        ForNAVSetup.Get;
        if ForNAVSetup."Inherit Language Code" then CurrReport.Language(ReportForNav.GetLanguageID(LanguageCode));
    end;
    local procedure GetVatAmountLines()var ForNAVGetVatAmountLines: Codeunit "ForNAV Get Vat Amount Lines";
    begin
        VATAmountLine.DeleteAll;
        ForNAVGetVatAmountLines.GetVatAmountLines(Header, VATAmountLine);
    end;
    local procedure PrintVATAmountLines(): Boolean var ForNAVSetup: Record "ForNAV Setup";
    begin
        ForNAVSetup.Get;
        case ForNAVSetup."VAT Report Type" of ForNAVSetup."vat report type"::Always: exit(true);
        ForNAVSetup."vat report type"::"Multiple Lines": exit(VATAmountLine.Count > 1);
        ForNAVSetup."vat report type"::Never: exit(false);
        end;
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
            ReportForNavInit(jsonObject);
            ReportForNavInitialized:=true;
        end;
        case(dataItemId)of 'Header': begin
            jsonObject.Add('CurrReport$Language$Integer', CurrReport.Language);
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
