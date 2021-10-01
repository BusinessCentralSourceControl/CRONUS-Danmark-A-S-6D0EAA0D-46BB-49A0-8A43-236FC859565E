Page 6188473 "ForNAV Paym. Note Translation"
{
    ApplicationArea = All;
    Caption = 'ForNAV Payment Note Translations';
    PageType = List;
    SourceTable = "ForNAV Paym. Note Translation";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(LanguageCode;Rec."Language Code")
                {
                    ApplicationArea = All;
                }
                field("Payment Note";Rec."Payment Note")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
    }
}
