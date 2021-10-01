page 6189103 "ForNAV Document Archive"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "ForNAV Document Archive";
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    SourceTableView = sorting("Report Name", Created, Year, Month, "User ID");
    Caption = 'ForNAV Document Archive';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                ShowAsTree = true;
                IndentationColumn = Rec.indent;
                IndentationControls = name;
                TreeInitialState = ExpandAll;

                field(Name;name)
                {
                    Caption = 'Name';
                    ApplicationArea = All;
                }
                field(UserId;Rec."User ID")
                {
                    ApplicationArea = All;
                }
                field(DocumentType;Rec."Document Type")
                {
                    OptionCaption = ',PDF,Word,Html,Excel,Print,Preview';
                    ApplicationArea = All;
                }
                field(Copies;Rec.Copies)
                {
                    ApplicationArea = All;
                }
                field(Keywords;Rec.Keywords)
                {
                    ApplicationArea = All;
                }
                field(Downloaded;Rec.Downloaded)
                {
                    ApplicationArea = All;
                }
                field(Purged;Rec.Purged)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(View)
            {
                ApplicationArea = All;
                PromotedCategory = Process;
                Promoted = true;
                PromotedIsBig = true;
                Caption = 'View';
                Image = View;

                trigger OnAction()var is: InStream;
                clientFileName: Text;
                ReportWasPurged: Label 'The document has been deleted and cannot be downloaded.';
                fileType: Text;
                documentHistory: Record "ForNAV Document History";
                begin
                    if Rec.Indent = 3 then begin
                        if(Rec."Document Type" = Rec."Document Type"::preview) or (Rec."Document Type" = Rec."Document Type"::print)then fileType:='pdf'
                        else
                            fileType:=Format(Rec."Document Type");
                        clientFileName:=StrSubstNo('%1.%2', Rec."Report Name", fileType);
                        Rec.CalcFields(Document);
                        if not Rec.Document.HasValue then Error(ReportWasPurged);
                        Rec.Document.CreateInStream(is);
                        DownloadFromStream(is, '', '', '', clientFileName);
                        documentHistory.Create(Rec."Archive ID", documentHistory."Archive Action"::Viewed);
                    end;
                end;
            }
            action(Download)
            {
                ApplicationArea = All;
                PromotedCategory = Process;
                Promoted = true;
                PromotedIsBig = true;
                Image = Archive;
                Caption = 'Download';

                Trigger OnAction()var DocumentArchiveMgt: codeunit "ForNAV Document Archive Mgt.";
                DocArchive: Record "ForNAV Document Archive";
                documentHistory: Record "ForNAV Document History";
                begin
                    CurrPage.SetSelectionFilter(DocArchive);
                    if DocArchive.Count = 0 then DocArchive.SetRange(DocArchive."Archive ID", DocArchive."Archive ID");
                    DocumentArchiveMgt.ArchiveAction(DocArchive, DocumentHistory."Archive Action"::Downloaded);
                    CurrPage.Update();
                end;
            }
            action(Purge)
            {
                ApplicationArea = All;
                PromotedCategory = Process;
                Promoted = true;
                PromotedIsBig = true;
                Image = Delete;
                Caption = 'Purge Documents';

                Trigger OnAction()var documentArchive: codeunit "ForNAV Document Archive Mgt.";
                Selected: Record "ForNAV Document Archive";
                documentHistory: Record "ForNAV Document History";
                begin
                    CurrPage.SetSelectionFilter(Selected);
                    if Selected.Count() = 0 then Selected.SetRange(Selected."Archive ID", Selected."Archive ID");
                    documentArchive.ArchiveAction(Selected, documentHistory."Archive Action"::Purged);
                    CurrPage.Update();
                end;
            }
            action(History)
            {
                ApplicationArea = All;
                PromotedCategory = Process;
                Promoted = true;
                PromotedIsBig = true;
                Image = History;
                Caption = 'History';

                trigger OnAction()var documentHistory: Record "ForNAV Document History";
                begin
                    documentHistory.SetRange(documentHistory."Archive ID", Rec."Archive ID");
                    Page.RunModal(Page::"ForNAV Document History", documentHistory);
                end;
            }
        // action(DeleteAll)
        // {
        //     ApplicationArea = All;
        //     PromotedCategory = Process;
        //     Promoted = true;
        //     PromotedIsBig = true;
        //     Image = Delete;
        //     Caption = 'Delete';
        //     trigger OnAction()
        //     var
        //         documentHistory: Record "ForNAV Document History";
        //     begin
        //         documentHistory.DeleteAll();
        //         DeleteAll();
        //     end;
        // }
        }
    }
    var name: Text;
    trigger OnAfterGetRecord()begin
        case Rec.Indent of 0: name:=Rec."Report Name";
        1: name:=Format(Rec.Year);
        2: name:=Format(DMY2Date(1, Rec.Month, Rec.Year), 0, '<Month Text>');
        3: name:=Format(Rec.Created);
        end;
    end;
}
