page 6189122 "ForNAV Page Controls API"
{
    PageType = API;
    APIPublisher = 'ForNav';
    APIGroup = 'AppManagement';
    APIVersion = 'v1.0';
    EntityName = 'PageControl';
    EntitySetName = 'PageControls';
    SourceTable = "All Control Fields";
    SourceTableView = where("Object Type"=const(Page));
    DelayedInsert = true;
    Caption = 'PageControlsAPI';
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

                field(Id;Rec."Object ID")
                {
                    ApplicationArea = All;
                    Caption = 'Id';
                }
                field(Name;Rec."Control Name")
                {
                    ApplicationArea = All;
                    Caption = 'Name';
                }
                field(Caption;Rec.Caption)
                {
                    ApplicationArea = All;
                    Caption = 'Caption';
                }
            }
        }
    }
}
