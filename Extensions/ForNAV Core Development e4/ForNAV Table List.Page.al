Page 6188684 "ForNAV Table List"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = AllObjWithCaption;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ObjectCaption;Rec."Object Caption")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
