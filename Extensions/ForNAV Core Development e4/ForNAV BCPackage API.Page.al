page 6189117 "ForNAV BCPackage API"
{
    PageType = API;
    APIPublisher = 'ForNav';
    APIGroup = 'AppManagement';
    APIVersion = 'v1.0';
    EntityName = 'BcPackage';
    EntitySetName = 'BcPackages';
    SourceTable = Integer;
    SourceTableTemporary = true;
    DelayedInsert = true;
    Caption = 'BcPackageApi';
    ODataKeyFields = Number;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;

                // field(Number; Number)
                // {
                //     ApplicationArea = All;
                //     Caption = 'Number';
                // }
                field(ReportNo;Rec.Number)
                {
                    ApplicationArea = All;
                    Caption = 'ReportNo';
                }
                field(PackageType;PackageType)
                {
                    ApplicationArea = All;
                    Caption = 'PackageType';
                }
                field(PackageVersion;PackageVersion)
                {
                    ApplicationArea = All;
                    Caption = 'PackageVersion';
                }
                field(ServiceUrl;ServiceUrl)
                {
                    ApplicationArea = All;
                    Caption = 'ServiceUrl';
                }
                field(SessionId;SessionId)
                {
                    ApplicationArea = All;
                    Caption = 'SessionId';
                }
                field(PreviewLayoutCode;PreviewLayoutCode)
                {
                    ApplicationArea = All;
                    Caption = 'PreviewLayoutCode';
                }
                field(Code;Code)
                {
                    ApplicationArea = All;
                    Caption = 'Code';
                }
                field(CompanyName;CompanyName)
                {
                    ApplicationArea = All;
                    Caption = 'CompanyName';
                }
                field(PreviewUrl;PreviewUrl)
                {
                    ApplicationArea = All;
                    Caption = 'PreviewUrl';
                }
                field(WebServiceUrl;WebServiceUrl)
                {
                    ApplicationArea = All;
                    Caption = 'WebServiceUrl';
                }
                field(DataContract;DataContract)
                {
                    ApplicationArea = All;
                    Caption = 'DataContract';
                }
                field(ServerName;ServerName)
                {
                    ApplicationArea = All;
                    Caption = 'ServerName';
                }
                field(DatabaseName;DatabaseName)
                {
                    ApplicationArea = All;
                    Caption = 'DatabaseName';
                }
                field(FinsqlPath;FinsqlPath)
                {
                    ApplicationArea = All;
                    Caption = 'FinsqlPath';
                }
                field(Base64Layout;Base64Layout)
                {
                    ApplicationArea = All;
                    Caption = 'Base64Layout';
                }
            }
        }
    }
    var PackageType: Option Word, Rdlc, DefaultSettings, New; // public enum PackageTypeEnum { Word,Rdlc, DefaultSettings,New }; public PackageTypeEnum PackageType;
    PackageVersion: Integer; // public int PackageVersion { get;set; }
    ServiceUrl: Text; // public string ServiceUrl { get; set; }
    SessionId: Text; // public string SessionId { get; set; }
    PreviewLayoutCode: Text; // public string PreviewLayoutCode { get; set; }
    Code: Code[20]; // public string Code { get; set; }
    ReportNo: Integer; // public int ReportNo { get; set; } 
    CompanyName: Text; // public string CompanyName { get; set; }
    PreviewUrl: Text; // public string PreviewUrl { get; set; }
    WebServiceUrl: Text; // public string WebServiceUrl { get; set; }
    DataContract: Text; // public string DataContract { get; set; }
    ServerName: Text; // public string ServerName { get; set; }
    DatabaseName: Text; // public string DatabaseName { get; set; }
    FinsqlPath: Text; // public string FinsqlPath { get; set; }
    Base64Layout: Text;
    portIndex: Integer;
    paramIndex: Integer;
    trigger OnAfterGetRecord()var session: Record "ForNAV Cloud Report Sessions";
    reportManagement: Codeunit "ForNAV Report Management";
    cloudWebService: Codeunit "ForNAV Cloud Web Service";
    customReportLayout: Record "Custom Report Layout";
    tempBlob: Record "ForNAV Core Setup";
    begin
        PackageVersion:=3;
        if Rec.Number <= 0 then begin
            PackageType:=-Rec.Number;
            ReportNo:=0;
        end
        else
        begin
            PackageType:=PackageType::Word;
            ReportNo:=Rec.Number;
        end;
        if PackageType <> PackageType::DefaultSettings then reportManagement.CreateSession(ReportNo, session);
        if PackageType = PackageType::Word then begin
            CustomReportLayout.Init();
            CustomReportLayout.SetRange("Last Modified", CreateDateTime(0D, 0T), CreateDateTime(CalcDate('<-2D>'), 0T));
            CustomReportLayout.SetFilter(Description, 'ForNAV BC preview *');
            CustomReportLayout.DeleteAll();
            // Create empty preview layout
            // CustomReportLayout.Init;
            // CustomReportLayout.Code := session.PreviewLayoutCode;
            // CustomReportLayout."Report ID" := ReportNo;
            // CustomReportLayout."Company Name" := CompanyName;
            // CustomReportLayout.Type := CustomReportLayout.Type::RDLC;
            // CustomReportLayout.Description := 'ForNAV BC preview (report ' + Format(ReportNo) + ')';
            // CustomReportLayout."Last Modified by User" := UserId;
            // CustomReportLayout."Last Modified" := CreateDateTime(Today, Time);
            // CustomReportLayout.Insert;
            Commit;
        end;
        ServiceUrl:=GetUrl(CLIENTTYPE::Api, CompanyName, OBJECTTYPE::Page, 6189112);
        SessionId:=session."Session ID";
        PreviewLayoutCode:=session.PreviewLayoutCode;
        reportManagement.GetWordLayout(reportNo, tempBlob, Code);
        base64Layout:=tempBlob.ToBase64String();
        CompanyName:=Database.CompanyName;
        PreviewUrl:=GetUrl(CLIENTTYPE::Web, CompanyName, OBJECTTYPE::Page, 6189100, session);
        WebServiceUrl:=GetUrl(CLIENTTYPE::SOAP, CompanyName, OBJECTTYPE::Codeunit, 6189102);
        if WebServiceUrl = '' then begin
            reportManagement.CreateWebService;
            WebServiceUrl:=GetUrl(CLIENTTYPE::SOAP, CompanyName, OBJECTTYPE::Codeunit, 6189102);
        end;
    end;
    trigger OnFindRecord(Which: Text): Boolean begin
        if Evaluate(Rec.Number, Rec.GetFilter(Number))then exit(true)
        else
            exit(false);
    end;
}
