page 6189119 "ForNAV Url API"
{
    PageType = API;
    APIPublisher = 'ForNav';
    APIGroup = 'AppManagement';
    APIVersion = 'v1.0';
    EntityName = 'Url';
    EntitySetName = 'Urls';
    SourceTable = Integer;
    SourceTableTemporary = true;
    DelayedInsert = true;
    Caption = 'UrlApi';
    //    ODataKeyFields = Number;
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

                field(WebServiceUrl;WebServiceUrl)
                {
                    ApplicationArea = All;
                    Caption = 'WebServiceUrl';
                }
                field(PreviewUrl;PreviewUrl)
                {
                    ApplicationArea = All;
                    Caption = 'WebServiceUrl';
                }
            }
        }
    }
    var WebServiceUrl: Text;
    PreviewUrl: Text;
    trigger OnAfterGetRecord()begin
        WebServiceUrl:=GetUrl(CLIENTTYPE::SOAP, CompanyName, OBJECTTYPE::Codeunit, 6189102);
        PreviewUrl:=GetUrl(CLIENTTYPE::Web, CompanyName, OBJECTTYPE::Page, 6189100);
    end;
    trigger OnFindRecord(Which: Text): Boolean begin
        exit(true)end;
}
