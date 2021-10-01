pageextension 6188527 "ForNAV Item Card" extends "Item Card"
{
    actions
    {
        addlast(Reporting)
        {
            action(ForNAVLabels)
            {
                Caption = 'ForNAV Label';
                Image = PrintCover;
                ApplicationArea = All;

                trigger OnAction()var Item: Record Item;
                begin
                    Item:=Rec;
                    Item.SetRecFilter;
                    Report.Run(Report::"ForNAV Item - Label", true, false, Item);
                end;
            }
        }
    }
}
