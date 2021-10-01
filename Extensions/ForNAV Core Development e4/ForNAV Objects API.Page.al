page 6189115 "ForNAV Objects API"
{
    PageType = API;
    APIPublisher = 'ForNav';
    APIGroup = 'AppManagement';
    APIVersion = 'v1.0';
    EntityName = 'TxtOrAlObject';
    EntitySetName = 'TxtOrAlObjects';
    SourceTable = AllObj;
    DelayedInsert = true;
    Caption = 'ForNavTxtOrAlObjectsApi';
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

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
