Page 6188482 "ForNAV Report Selection Short."
{
    ApplicationArea = All;
    Caption = 'Report Selection';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "ForNAV Report Selection Short.";
    SourceTableTemporary = true;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Description;Rec.Description)
                {
                    ApplicationArea = All;

                    trigger OnAssistEdit()begin
                        Page.Run(Rec."Page No.");
                    end;
                }
            }
        }
    }
    actions
    {
        area(processing)
        {
            action(Run)
            {
                ApplicationArea = All;
                Caption = 'Run';
                Image = ExecuteBatch;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()begin
                    Page.Run(Rec."Page No.");
                end;
            }
        }
    }
    trigger OnOpenPage()begin
        GetShortcuts;
    end;
    local procedure GetShortcuts()var AllObjWithCaption: Record AllObjWithCaption;
    begin
        AllObjWithCaption.SetRange("Object Type", AllObjWithCaption."object type"::Page);
        AllObjWithCaption.SetFilter("Object Name", 'Report Selection - *');
        if AllObjWithCaption.FindSet then repeat Rec."Page No.":=AllObjWithCaption."Object ID";
                Rec.Description:=AllObjWithCaption."Object Caption";
                Rec.Insert;
            until AllObjWithCaption.Next = 0;
    end;
}
