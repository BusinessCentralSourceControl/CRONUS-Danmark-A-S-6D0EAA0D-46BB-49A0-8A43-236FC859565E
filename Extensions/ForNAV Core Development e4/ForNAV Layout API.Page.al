page 6189111 "ForNAV Layout API"
{
    PageType = API;
    APIPublisher = 'ForNav';
    APIGroup = 'AppManagement';
    APIVersion = 'v1.0';
    EntityName = 'Layout';
    EntitySetName = 'Layouts';
    SourceTable = "Custom Report Layout";
    DelayedInsert = true;
    Caption = 'ForNavLayoutApi';
    ODataKeyFields = "Report ID";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    SourceTableView = sorting("Report ID", "Company Name", Type)where(Type=Const(Word));

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(ReportId;Rec."Report ID")
                {
                    Caption = 'ReportId';
                    ApplicationArea = All;
                }
                field(ReportName;Rec."Report Name")
                {
                    Caption = 'ReportName';
                    ApplicationArea = All;
                }
                field(Description;Rec.Description)
                {
                    Caption = 'Description';
                    ApplicationArea = All;
                }
                field(CompanyName;Rec."Company Name")
                {
                    Caption = 'CompanyName';
                    ApplicationArea = All;
                }
                field(Code;Rec.Code)
                {
                    Caption = 'Code';
                    ApplicationArea = All;
                }
                field(Base64Layout;Base64Layout)
                {
                    Caption = 'BaseLayout';
                    ApplicationArea = All;
                }
            }
        }
    }
    var Base64Layout: Text;
    trigger OnAfterGetRecord()var iStream: InStream;
    forNAVReportManagement: Codeunit "ForNAV Report Management";
    begin
        Rec.CalcFields(Layout);
        if Rec.Layout.HasValue then begin
            Rec.Layout.CreateInStream(iStream);
            Base64Layout:=forNAVReportManagement.ToBase64String(iStream);
        end
        else
            Base64Layout:='';
    end;
}
