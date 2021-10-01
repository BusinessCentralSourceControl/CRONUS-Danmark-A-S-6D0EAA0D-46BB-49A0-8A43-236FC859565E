Page 6188481 "ForNAV Label Setup"
{
    // Copyright (c) 2017-2021 ForNAV ApS - All Rights Reserved
    // The intellectual work and technical concepts contained in this file are proprietary to ForNAV.
    // Unauthorized reverse engineering, distribution or copying of this file, parts hereof, or derived work, via any medium is strictly prohibited without written permission from ForNAV ApS.
    // This source code is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    ApplicationArea = All;
    Caption = 'ForNAV Label Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "ForNAV Label Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field(Orientation;Rec.Orientation)
                {
                    ApplicationArea = All;
                }
                field(EnablePreview;Rec."Enable Preview")
                {
                    ApplicationArea = All;
                }
                field(DisableWarnings;Rec."Disable Warnings")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            systempart(MyNotes;MyNotes)
            {
                ApplicationArea = All;
            }
            systempart(RecordLinks;Links)
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        area(processing)
        {
            group(Template)
            {
                Caption = 'Template';

                action(DesignTemplatePortrait)
                {
                    ApplicationArea = All;
                    Caption = 'Design Label Template (Portrait)';
                    Image = UnitOfMeasure;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()begin
                        Rec.DesignTemplatePortrait;
                    end;
                }
                action(DesignTemplateLandscape)
                {
                    ApplicationArea = All;
                    Caption = 'Design Label Template (Landscape)';
                    Image = VATPostingSetup;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()begin
                        Rec.DesignTemplateLandscape;
                    end;
                }
            }
        }
    }
    trigger OnOpenPage()begin
        Rec.InitSetup;
    end;
}
