page 6189110 "ForNAV Extensions API"
{
    PageType = API;
    APIPublisher = 'ForNav';
    APIGroup = 'AppManagement';
    APIVersion = 'v1.0';
    EntityName = 'Extension';
    EntitySetName = 'Extensions';
    SourceTable = "Nav App Installed App";
    DelayedInsert = true;
    Caption = 'ForNavExtensionsApi';
    ODataKeyFields = "Package ID";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(AppPackageId;Rec."Package ID")
                {
                    Caption = 'AppPackageId';
                    ApplicationArea = All;
                }
                field(AppId;Rec."App ID")
                {
                    Caption = 'AppID';
                    ApplicationArea = All;
                }
                field(AppName;Rec.Name)
                {
                    Caption = 'Name';
                    ApplicationArea = All;
                }
                field(Publisher;Rec.Publisher)
                {
                    Caption = 'Publisher';
                    ApplicationArea = All;
                }
                field(Version;StrSubstNo('%1.%2.%3.%4', Rec."Version Major", Rec."Version Minor", Rec."Version Revision", Rec."Version Build"))
                {
                    Caption = 'Version';
                    ApplicationArea = All;
                }
            }
        }
    }
}
