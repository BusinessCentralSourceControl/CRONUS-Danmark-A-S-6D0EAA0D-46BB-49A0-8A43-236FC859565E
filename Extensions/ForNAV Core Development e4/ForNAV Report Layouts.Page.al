page 6188483 "ForNAV Report Layouts"
{
    Caption = 'ForNAV Report Layouts';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "ForNAV Report Layout";
    SourceTableTemporary = true;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(List)
            {
                field("Report ID";Rec."Report ID")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Name;Rec.Name)
                {
                    ApplicationArea = All;
                }
                field("Custom Report Layout Code";Rec."Custom Report Layout Code")
                {
                    ApplicationArea = All;
                }
                field(Description;Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Last Modified";Rec."Last Modified")
                {
                    ApplicationArea = All;
                }
                field("Last Modified By User";Rec."Last Modified By User")
                {
                    ApplicationArea = All;
                }
                field(Activated;Rec.Activated)
                {
                    ApplicationArea = All;

                    trigger OnValidate()begin
                        Rec.ModifyAll(Activated, false);
                        Rec.ActivateLayout;
                    end;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Design)
            {
                ApplicationArea = All;
                Caption = 'Design';
                Image = Design;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()var ReportMgt: Codeunit "ForNAV Report Management";
                RepLaySel: Record "Report Layout Selection";
                begin
                    RepLaySel.SetTempLayoutSelected(Rec."Custom Report Layout Code");
                    ReportMgt.LaunchDesigner(Rec."Report ID", true);
                    RepLaySel.SetTempLayoutSelected('');
                end;
            }
            action(Copy)
            {
                ApplicationArea = All;
                Caption = 'Copy';
                Image = Copy;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()var ReportLayoutMgt: Codeunit "ForNAV Report Layout Mgt.";
                begin
                    Rec.CopyLayout;
                    Rec.DeleteAll;
                    ReportLayoutMgt.CreateBuffer(Rec);
                    CurrPage.Update(false);
                end;
            }
            action(Export)
            {
                ApplicationArea = All;
                Caption = 'Export';
                Image = Export;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()begin
                    Rec.ExportLayout;
                end;
            }
            action(Delete)
            {
                ApplicationArea = All;
                Caption = 'Delete';
                Image = Delete;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()var CustRepLayout: Record "Custom Report Layout";
                RepLaySel: Record "Report Layout Selection";
                begin
                    CustRepLayout.Get(Rec."Custom Report Layout Code");
                    CustRepLayout.Delete;
                    RepLaySel.SetRange("Custom Report Layout Code", Rec."Custom Report Layout Code");
                    RepLaySel.DeleteAll;
                    Rec.Delete;
                end;
            }
            action(CopyToOtherReport)
            {
                ApplicationArea = All;
                Caption = 'Copy to other Report';
                Image = CopyBudget;

                trigger OnAction()var ReportLayoutMgt: Codeunit "ForNAV Report Layout Mgt.";
                begin
                    Rec.CopyLayoutToOtherReport();
                    Rec.DeleteAll;
                    ReportLayoutMgt.CreateBuffer(Rec);
                    CurrPage.Update(false);
                end;
            }
        }
    }
    trigger OnOpenPage()var ReportLayoutMgt: Codeunit "ForNAV Report Layout Mgt.";
    begin
        ReportLayoutMgt.CreateBuffer(Rec);
    end;
    trigger OnDeleteRecord(): Boolean var CustRepLayout: Record "Custom Report Layout";
    begin
        CustRepLayout.Get(Rec."Custom Report Layout Code");
        CustRepLayout.Delete(true);
    end;
}
