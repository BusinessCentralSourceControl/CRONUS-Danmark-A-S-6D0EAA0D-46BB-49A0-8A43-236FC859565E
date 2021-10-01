page 6189120 "ForNAV Version API"
{
    PageType = API;
    APIPublisher = 'ForNav';
    APIGroup = 'AppManagement';
    APIVersion = 'v1.0';
    EntityName = 'BC183';
    EntitySetName = 'BC183s';
    SourceTable = Integer;
    SourceTableTemporary = true;
    DelayedInsert = true;
    Caption = 'BcApi';
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

                field(Number;Rec.Number)
                {
                    ApplicationArea = All;
                    Caption = 'Number';
                }
            }
        }
    }
}
