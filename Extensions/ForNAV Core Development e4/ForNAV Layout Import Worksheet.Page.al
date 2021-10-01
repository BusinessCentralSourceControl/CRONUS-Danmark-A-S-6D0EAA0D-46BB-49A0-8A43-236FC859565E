page 6188484 "ForNAV Layout Import Worksheet"
{
    PageType = NavigatePage;
    SourceTable = "ForNAV Layout Import Worksheet";
    SourceTableTemporary = true;
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            group(ImportWorksheet)
            {
                Caption = 'ForNAV';
                InstructionalText = 'Welcome to the ForNAV Import Worksheet.';
            }
            repeater(List)
            {
                field("Report ID";Rec."Report ID")
                {
                    ApplicationArea = All;
                }
                field("Report Name";Rec."Report Name")
                {
                    ApplicationArea = All;
                }
                field(Description;Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Custom Layout Code";Rec."Custom Layout Code")
                {
                    ApplicationArea = All;
                }
                field("Import Action";Rec."Import Action")
                {
                    ApplicationArea = All;
                }
                field("Report Exists";Rec."Report Exists")
                {
                    ApplicationArea = All;
                }
                field("Existing Report Name";Rec."Existing Report Name")
                {
                    ApplicationArea = All;
                }
            }
            group(Explanation)
            {
                Caption = 'Actions';
                InstructionalText = 'Choose Import to move to the next step...';
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ReplaceAll)
            {
                ApplicationArea = All;
                Image = Replan;
                Caption = 'Replace All';
                Promoted = true;
                InFooterBar = true;

                trigger OnAction()var ImportWorkSheeet: Record "ForNAV Layout Import Worksheet";
                begin
                    // Rec.ModifyAll("Import Action", Rec."Import Action"::Replace); // Old code
                    if ImportWorkSheeet.FindSet()then begin
                        repeat ImportWorkSheeet.SetDefaultAction();
                            ImportWorkSheeet.Modify();
                        //     if ImportWorkSheeet."Report Exists" then begin
                        //         ImportWorkSheeet."Import Action" := ImportWorkSheeet."Import Action"::Replace;
                        //         ImportWorkSheeet.Modify();
                        //     end;
                        until ImportWorkSheeet.Next() <> 1;
                    end;
                end;
            }
            action(SkipAll)
            {
                ApplicationArea = All;
                Image = SplitChecks;
                Caption = 'Skip All';
                Promoted = true;
                InFooterBar = true;

                trigger OnAction()begin
                    Rec.ModifyAll("Import Action", Rec."Import Action"::Skip);
                end;
            }
            action(Import)
            {
                ApplicationArea = All;
                Image = Import;
                Caption = 'Import';
                Promoted = true;
                InFooterBar = true;

                trigger OnAction()var ExecuteImport: Codeunit "ForNAV Report Layout Import";
                begin
                    ExecuteImport.ExecuteWorksheet(Rec);
                    CurrPage.Close;
                end;
            }
        }
    }
}
