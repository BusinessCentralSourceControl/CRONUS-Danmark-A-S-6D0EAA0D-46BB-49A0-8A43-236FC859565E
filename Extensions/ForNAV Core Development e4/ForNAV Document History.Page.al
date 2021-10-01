page 6189105 "ForNAV Document History"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "ForNAV Document History";
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    SourceTableView = sorting("Archive ID", "Archive Timestamp", "User ID")order(ascending);
    Caption = 'ForNAV Document Archive History';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(DateTime;Rec."Archive Timestamp")
                {
                    ApplicationArea = All;
                }
                field(UserId;Rec."User ID")
                {
                    ApplicationArea = All;
                }
                field(Status;Rec."Archive Action")
                {
                    Caption = 'Actions';
                    ApplicationArea = All;
                }
            }
        }
    }
    trigger OnOpenPage()var archive: Record "ForNAV Document Archive";
    begin
        Rec.FindFirst();
        archive.SetRange(archive."Archive ID", Rec."Archive ID");
        archive.FindFirst();
        CurrPage.Caption:=CurrPage.Caption + ' - ' + archive."Report Name";
    end;
}
