page 6189181 "ForNAV Language Details"
{
    PageType = ListPart;
    SourceTable = Language;
    SourceTableTemporary = true;
    Editable = false;
    Caption = 'ForNAV Language Details';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Code;Rec.Code)
                {
                    ApplicationArea = All;
                    Caption = 'Language Code';
                }
                field(Name;Rec.Name)
                {
                    ApplicationArea = All;
                    Caption = 'Language';
                }
                field(NoOfTranslations;GetNoOfTranslations)
                {
                    ApplicationArea = All;
                    Caption = 'Quantity';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Filter)
            {
                Caption = 'Filter';
                ApplicationArea = All;

                trigger OnAction()begin
                    FilterCode:=Rec.Code;
                    CurrPage.Update;
                end;
            }
            action(Reset)
            {
                Caption = 'Reset';
                ApplicationArea = All;

                trigger OnAction()begin
                    FilterCode:='';
                    CurrPage.Update;
                end;
            }
        }
    }
    trigger OnOpenPage()var Lang: Record Language;
    Translation: Record "ForNAV Language Setup";
    begin
        if Translation.FindSet then repeat if not Rec.Get(Translation."Language Code")then begin
                    Rec.Code:=Translation."Language Code";
                    Lang.Get(Rec.Code);
                    Rec.Name:=Lang.Name;
                    Rec.Insert;
                end;
            until Translation.Next = 0;
    end;
    procedure GetSelectedLanguage(): Code[20]begin
        exit(FilterCode);
    end;
    local procedure GetNoOfTranslations(): Integer var Translation: Record "ForNAV Language Setup";
    begin
        Translation.SetRange("Language Code", Rec.Code);
        exit(Translation.Count);
    end;
    var FilterCode: Code[20];
}
