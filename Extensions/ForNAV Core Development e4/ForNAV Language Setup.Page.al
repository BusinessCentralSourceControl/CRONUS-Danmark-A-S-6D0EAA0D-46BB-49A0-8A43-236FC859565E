page 6189180 "ForNAV Language Setup"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "ForNAV Language Setup";
    DelayedInsert = true;
    Caption = 'ForNAV Language';
    AdditionalSearchTerms = 'ForNAV Thesaurus';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Language Code";Rec."Language Code")
                {
                    ApplicationArea = All;
                }
                field("Report ID";Rec."Report ID")
                {
                    ApplicationArea = All;
                    Visible = ShowObjectDetails;
                }
                field("Report Name";Rec."Report Name")
                {
                    ApplicationArea = All;
                    Visible = ShowObjectDetails;
                }
                field("Table No.";Rec."Table No.")
                {
                    ApplicationArea = All;
                    Visible = ShowObjectDetails;
                }
                field("Table Name";Rec."Table Name")
                {
                    ApplicationArea = All;
                    Visible = ShowObjectDetails;
                }
                field("Field No.";Rec."Field No.")
                {
                    ApplicationArea = All;
                    Visible = ShowObjectDetails;
                }
                field("Field Name";Rec."Field Name")
                {
                    ApplicationArea = All;
                    Visible = ShowObjectDetails;
                }
                field(Caption;Rec."Translate From")
                {
                    ApplicationArea = All;
                    Editable = NOT ShowObjectDetails;

                    trigger OnValidate()begin
                        If ShowObjectDetails then TestObjectFields;
                    end;
                }
                field(Translation;Rec."Translate To")
                {
                    ApplicationArea = All;

                    trigger OnValidate()begin
                        If ShowObjectDetails then TestObjectFields;
                    end;
                }
            }
        }
        area(FactBoxes)
        {
            part(Translations;"ForNAV Language Details")
            {
                ApplicationArea = All;
                Caption = 'Translations';
                UpdatePropagation = SubPart;
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Captions)
            {
                Caption = 'Captions';
                Image = Translate;
                Visible = ShowObjectDetails;
                ApplicationArea = All;
                PromotedCategory = Process;
                Promoted = true;
                PromotedOnly = true;

                trigger OnAction();
                begin
                    ShowObjectDetails:=not ShowObjectDetails;
                    SetObjectFilter;
                end;
            }
            action(Objects)
            {
                Caption = 'Objects';
                Image = Database;
                Visible = not ShowObjectDetails;
                ApplicationArea = All;
                PromotedCategory = Process;
                Promoted = true;
                PromotedOnly = true;

                trigger OnAction();
                begin
                    ShowObjectDetails:=not ShowObjectDetails;
                    SetObjectFilter;
                end;
            }
            action(Export)
            {
                Caption = 'Export';
                Image = Export;
                ApplicationArea = All;
                PromotedCategory = Process;
                Promoted = true;
                PromotedOnly = true;

                trigger OnAction();
                begin
                    Rec.ExportToCSV;
                end;
            }
            action(Import)
            {
                Caption = 'Import';
                Image = Import;
                ApplicationArea = All;
                PromotedCategory = Process;
                Promoted = true;
                PromotedOnly = true;

                trigger OnAction();
                begin
                    Rec.ImportFromCSV();
                end;
            }
            action(Run)
            {
                ApplicationArea = All;
                Caption = 'Run';
                Image = ExecuteBatch;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()begin
                    Report.Run(Rec."Report ID");
                end;
            }
        }
    }
    trigger OnOpenPage()begin
        SetObjectFilter;
    end;
    trigger OnAfterGetCurrRecord()begin
        if CurrPage.Translations.Page.GetSelectedLanguage = '' then Rec.SetRange("Language Code")
        else
            Rec.SetRange("Language Code", CurrPage.Translations.Page.GetSelectedLanguage);
    end;
    local procedure TestObjectFields()begin
        if Rec."Report ID" + Rec."Table No." + Rec."Field No." = 0 then Error('Please put in either a Report ID, Table No. or Field No.');
    end;
    local procedure SetObjectFilter()begin
        if ShowObjectDetails then Rec.SetRange("Is Object Translation", true)
        else
            Rec.SetRange("Is Object Translation", false);
    end;
    var ShowObjectDetails: Boolean;
    OptionValue: Text;
}
