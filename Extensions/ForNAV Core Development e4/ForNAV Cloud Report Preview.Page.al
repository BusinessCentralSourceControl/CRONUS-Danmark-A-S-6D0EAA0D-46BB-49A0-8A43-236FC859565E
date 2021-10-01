page 6189100 "ForNAV Cloud Report Preview"
{
    SourceTable = "ForNAV Cloud Report Sessions";
    Caption = 'ForNAV Preview';
    DataCaptionExpression = 'ForNAV Preview Report ' + format(Rec."Report ID");
    Editable = false;

    layout
    {
        area(content)
        {
            label(HelpText)
            {
                ApplicationArea = All;
                Caption = 'This preview page can be closed.';
            }
        }
    }
    trigger OnAfterGetCurrRecord()var ReportLayoutSelection: Record "Report Layout Selection";
    CustomReportLayout: Record "Custom Report Layout";
    begin
        SelectLatestVersion();
        ReportLayoutSelection.Get(Rec."Report ID", CompanyName);
        ReportLayoutSelection.SetTempLayoutSelected(Rec.PreviewLayoutCode);
        if Codeunit.Run(6189103, Rec)then;
        ReportLayoutSelection.SetTempLayoutSelected('');
        if CustomReportLayout.Get(Rec.PreviewLayoutCode)then CustomReportLayout.Delete;
    end;
}
