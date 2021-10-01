Page 6188472 "ForNAV Legal Cond. Translation"
{
    ApplicationArea = All;
    Caption = 'ForNAV Legal Cond. Translation';
    PageType = List;
    SourceTable = "ForNAV Legal Cond. Translation";
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
                field(LegalConditions;Rec."Legal Conditions")
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
