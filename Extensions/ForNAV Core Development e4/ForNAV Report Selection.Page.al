Page 6188479 "ForNAV Report Selection"
{
    Caption = 'Report Selections';
    ApplicationArea = All;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "ForNAV Report Selection";
    SourceTableTemporary = true;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(GetUsage;Rec.GetUsage)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(ReportID;Rec."Report ID")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(ReportCaption;Rec."Report Caption")
                {
                    ApplicationArea = All;
                }
                field(Source;Rec.Source)
                {
                    ApplicationArea = All;
                }
                field(CurrentReportID;Rec."Current Report ID")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(OriginalReportID;Rec."Original Report ID")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(ForNAVReportID;Rec."ForNAV Report ID")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            part(ReportSelections;"ForNAV Report Selection Short.")
            {
                ApplicationArea = All;
                Caption = 'Report Selections';
            }
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
            action(ReplaceReports)
            {
                ApplicationArea = All;
                Caption = 'Replace Report Selections';
                Image = SwitchCompanies;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()begin
                    Rec.ReplaceReportsWithForNAV;
                    SetData;
                end;
            }
            action("Restore Original")
            {
                ApplicationArea = All;
                Image = Restore;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()begin
                    Rec.RestoreOriginal;
                    Rec.Modify;
                end;
            }
            action("Use ForNAV")
            {
                ApplicationArea = All;
                Image = Add;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()begin
                    Rec.UseForNAV;
                    Rec.Modify;
                end;
            }
            action("Restore All")
            {
                ApplicationArea = All;
                Image = UndoCategory;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()var RestoreReportSelect: Codeunit "ForNAV Restore Report Select.";
                begin
                    RestoreReportSelect.Run;
                    SetData;
                end;
            }
            action(ResetToMSDefault)
            {
                ApplicationArea = All;
                Caption = 'Reset to Microsoft Default';
                Image = AddToHome;

                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                trigger OnAction()begin
                    Rec.ResetToMicrosoftDefault;
                    SetData;
                end;
            }
        }
    }
    trigger OnOpenPage()begin
        SetData;
    end;
    local procedure SetData()var ReportSelectionHist: Record "ForNAV Report Selection Hist.";
    ReportSelections: Record "Report Selections";
    RepSelBuffer: Record "ForNAV Report Selection Hist." temporary;
    AllObj: Record AllObj;
    RecRef: RecordRef;
    FldRef: FieldRef;
    begin
        Rec.DeleteAll;
        Rec.GetDefaults(RepSelBuffer);
        Rec.ModifyAll(Source, Rec.Source::ForNAV);
        if RepSelBuffer.FindSet then repeat if RepSelBuffer.Origin = 77 then begin
                    ReportSelections.SetRange(Usage, RepSelBuffer.Usage);
                    if ReportSelections.FindFirst then begin
                        Rec.Init;
                        Rec.TransferFields(ReportSelections);
                        Rec."Current Report ID":=Rec."Report ID";
                        Rec."ForNAV Report ID":=RepSelBuffer."Report ID";
                        ReportSelectionHist.SetRange(Usage, RepSelBuffer.Usage);
                        if ReportSelectionHist.FindFirst then Rec."Original Report ID":=ReportSelectionHist."Report ID";
                        Rec.Origin:=77;
                        Rec.Insert(true);
                    end;
                end
                else
                begin
                    AllObj.SetRange("Object Type", AllObj."object type"::Table);
                    AllObj.SetRange("Object ID", 7355);
                    if AllObj.FindSet then begin
                        RecRef.Open(7355);
                        FldRef:=RecRef.Field(1);
                        FldRef.SetRange(RepSelBuffer.Usage);
                        if RecRef.FindFirst then begin
                            Rec.Init;
                            Rec.Usage:=FldRef.Value;
                            Rec."Usage (Warehouse)":=FldRef.Value;
                            FldRef:=RecRef.Field(2);
                            Rec.Sequence:=FldRef.Value;
                            FldRef:=RecRef.Field(3);
                            Rec."Report ID":=FldRef.Value;
                            Rec."Current Report ID":=Rec."Report ID";
                            Rec."ForNAV Report ID":=RepSelBuffer."Report ID";
                            ReportSelectionHist.SetRange(Usage, RepSelBuffer.Usage);
                            if ReportSelectionHist.FindFirst then Rec."Original Report ID":=ReportSelectionHist."Report ID";
                            Rec.Origin:=7355;
                            Rec.Insert(true);
                        end;
                        RecRef.Close;
                    end;
                end;
            until RepSelBuffer.Next = 0;
        Rec.FindFirst;
    end;
}
