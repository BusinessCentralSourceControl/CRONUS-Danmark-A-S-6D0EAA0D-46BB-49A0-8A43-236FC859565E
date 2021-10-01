Page 6188496 "ForNAV License SKU"
{
    PageType = ListPart;
    SourceTable = "ForNAV License SKU";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(SKU;Rec.SKU)
                {
                    ApplicationArea = All;
                }
                field(Units;Rec.Units)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    trigger OnInit()begin
        Rec.AddDataFromQuery;
    end;
}
