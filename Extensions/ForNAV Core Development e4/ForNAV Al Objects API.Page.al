page 6189114 "ForNAV Al Objects API"
{
    PageType = API;
    APIPublisher = 'ForNav';
    APIGroup = 'AppManagement';
    APIVersion = 'v1.0';
    EntityName = 'AlObject';
    EntitySetName = 'AlObjects';
    SourceTable = AllObj;
    SourceTableView = where("App Package ID"=filter('<>{00000000-0000-0000-0000-000000000000}'));
    DelayedInsert = true;
    Caption = 'ForNavAlObjectsApi';
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    ODataKeyFields = "Object Type", "Object ID";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Type;Rec."Object Type")
                {
                    ApplicationArea = All;
                    Caption = 'Type';
                }
                field(Id;Rec."Object ID")
                {
                    ApplicationArea = All;
                    Caption = 'Id';
                }
                field(Name;Rec."Object Name")
                {
                    ApplicationArea = All;
                    Caption = 'Name';
                }
                field(AppPackageId;Rec."App Package ID")
                {
                    ApplicationArea = All;
                    Caption = 'AppPackageId';
                }
                field(SourceTableId;SourceTableId)
                {
                    ApplicationArea = All;
                    Caption = 'SourceTableId';
                }
                field(PageType;PageType)
                {
                    ApplicationArea = All;
                    Caption = 'PageType';
                }
            }
        }
    }
    var SourceTableId: Integer;
    PageType: Text;
    trigger OnAfterGetRecord()var PageMetaData: Record "Page Metadata";
    begin
        if Rec."Object Type" = Rec."Object Type"::Page then begin
            PageMetaData.Get(Rec."Object ID");
            SourceTableId:=PageMetaData.SourceTable;
            PageType:=Format(PageMetaData.PageType);
        end
        else
        begin
            SourceTableId:=0;
            PageType:='';
        end;
    end;
}
