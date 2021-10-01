Page 6188475 "ForNAV Reports"
{
    ApplicationArea = All;
    Caption = 'ForNAV Reports';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "ForNAV Reports";
    SourceTableTemporary = true;
    UsageCategory = Lists;
    PromotedActionCategories = 'New,Process,Report,Layout,Page';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                ShowAsTree = true;
                IndentationColumn = Rec.Indent;
                IndentationControls = Name;
                TreeInitialState = ExpandAll;

                field(Name;Rec.Name)
                {
                    ApplicationArea = All;
                    Style = Strong;
                    StyleExpr = Rec.Indent = 1;
                }
                field("Current Report Layout";Rec.Description)
                {
                    ApplicationArea = All;
                    StyleExpr = LayoutStyle;

                    trigger OnDrillDown()var //                        ForNAVLayout: Interface "ForNAV Layout";
                    begin
                        //                        ForNAVLayout := Rec.Layout;
                        // Rec.DesignReport();
                        // ForNAVLayout.OnDrillDown(Rec) then
                        //     Rec.GetCurrentReportLayout;
                        // Rec.Modify;
                        // CurrPage.Update;
                        Rec.DrillDownDescription();
                        CurrPage.Update;
                    end;
                }
                field(Archived;Rec.Archived)
                {
                    ApplicationArea = All;
                    Style = Subordinate;
                    StyleExpr = NOT Rec."Archive Enabled";

                    trigger OnDrillDown()begin
                        EnableOrShowArchive();
                    end;
                }
                field(Printer;Rec.Printer)
                {
                    ApplicationArea = All;

                    trigger OnDrillDown()begin
                        Page.RunModal(Page::"Printer Selections");
                    end;
                }
                field(ID;Rec.ID)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
        }
    }
    actions
    {
        area(Navigation)
        {
            action(CustomLayouts)
            {
                ApplicationArea = All;
                Caption = 'Custom Layouts';
                Image = SelectReport;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()var ReportLayout: Record "ForNAV Report Layout" temporary;
                begin
                    if Rec.ID <> 0 then begin
                        ReportLayout.SetRange("Report ID", Rec.ID);
                        Page.RunModal(Page::"ForNAV Report Layouts", ReportLayout);
                        RefreshPage;
                    end;
                end;
            }
            action(ExportLayouts)
            {
                ApplicationArea = All;
                Caption = 'Export Layouts';
                Image = ImportExport;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = page "ForNAV Report Layouts";
            }
            action(ImportLayouts)
            {
                ApplicationArea = All;
                Caption = 'Import Layouts';
                Image = ImportExport;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()begin
                    CodeUnit.Run(Codeunit::"ForNAV Report Layout Import");
                    RefreshPage;
                end;
            }
            action(UseBuiltInLayout)
            {
                ApplicationArea = All;
                Caption = 'Use Built-in Layout';
                Image = Undo;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Category4;

                trigger OnAction()begin
                    Rec.DeactivateLayout;
                    RefreshPage;
                end;
            }
            action(PrinterSelections)
            {
                ApplicationArea = All;
                Caption = 'Printer Selections';
                Image = Print;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Category4;

                trigger OnAction()begin
                    Page.RunModal(Page::"Printer Selections");
                    CurrPage.Update(false);
                end;
            }
        }
        area(processing)
        {
            action(Refresh)
            {
                ApplicationArea = All;
                Caption = 'Refresh';
                Image = Refresh;
                Promoted = true;
                ShortcutKey = F5;
                PromotedCategory = Category5;
                PromotedIsBig = true;

                trigger OnAction()begin
                    RefreshPage;
                end;
            }
        }
        area(Reporting)
        {
            action(Run)
            {
                ApplicationArea = All;
                Caption = 'Run';
                Image = ExecuteBatch;
                ShortcutKey = 'F9';
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;

                trigger OnAction()var Archive: Codeunit "ForNAV Document Archive Mgt.";
                begin
                    if Rec.ID = 0 then exit;
                    Report.Run(Rec.ID);
                    if archive.GetArchiveSetup(Rec.ID, Rec.Archived)then Rec.Modify();
                end;
            }
            action(LocalPrint)
            {
                ApplicationArea = All;
                Caption = 'Local Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;

                trigger OnAction()var printer: Text;
                archive: Codeunit "ForNAV Document Archive Mgt.";
                begin
                    if Rec.ID = 0 then exit;
                    printer:=GetPrinterSelected();
                    if printer = '' then printer:='Default';
                    Report.Print(Rec.ID, '', printer);
                    if archive.GetArchiveSetup(Rec.ID, Rec.Archived)then Rec.Modify();
                end;
            }
            // action(PrintToExcel)
            // {
            //     ApplicationArea = All;
            //     Caption = 'Print to Excel';
            //     Image = Excel;
            //     Promoted = true;
            //     PromotedCategory = Report;
            //     PromotedIsBig = true;
            //     trigger OnAction()
            //     var
            //         TempBlob: Record "ForNAV Core Setup";
            //         RecRef: RecordRef;
            //         FileName: Text;
            //         OutStr: OutStream;
            //         InStr: InStream;
            //     begin
            //         if ID = 0 then
            //             exit;
            //         TempBlob.Blob.CreateOutstream(OutStr);
            //         TempBlob.Blob.CreateInStream(InStr);
            //         Report.SaveAs(ID, '', Reportformat::Excel, OutStr, RecRef);
            //         FileName := Format(ID) + '.xlsx';
            //         DownloadFromStream(InStr, '', '', '', fileName);
            //     end;
            // }
            action(Design)
            {
                ApplicationArea = All;
                Caption = 'Design';
                Image = Design;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;

                trigger OnAction()begin
                    if Rec.ID = 0 then exit;
                    Rec.DesignReport;
                end;
            }
            action(New)
            {
                ApplicationArea = All;
                Caption = 'New';
                Image = NewOrder;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;

                trigger OnAction()var ReportMgt: Codeunit "ForNAV Report Management";
                begin
                    ReportMgt.DownloadDesignNewReportPackage();
                end;
            }
            action(Archive)
            {
                ApplicationArea = All;
                Caption = 'Archive';
                Image = Archive;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;

                trigger OnAction()begin
                    EnableOrShowArchive();
                end;
            }
        }
    }
    trigger OnOpenPage()begin
        GetReports;
    end;
    procedure GetPrinterSelected(): Text var printerSelection: Record "Printer Selection";
    Printer: Text;
    begin
        if Rec.ID = 0 then Printer:=''
        else if printerSelection.Get(UserId, Rec.ID)then Printer:=printerSelection."Printer Name"
            else if printerSelection.Get('', Rec.ID)then Printer:=printerSelection."Printer Name"
                else if printerSelection.Get(UserId, 0)then Printer:=printerSelection."Printer Name"
                    else if printerSelection.Get('', 0)then Printer:=printerSelection."Printer Name"
                        else
                            Printer:='';
        exit(Printer);
    end;
    // trigger OnAfterGetRecord()
    // var
    //     ForNAVLayout: Interface "ForNAV Layout";
    // begin
    //     ForNAVLayout := Rec.Layout;
    //     LayoutStyle := ForNAVLayout.GetStyle;
    //     Rec.Printer := GetPrinterSelected();
    // end;
    trigger OnAfterGetRecord()begin
        case Rec.Layout of Rec.Layout::Created: LayoutStyle:='ambiguous';
        Rec.Layout::Activated: LayoutStyle:='strongaccent';
        rec.Layout::"Defined Externally": LayoutStyle:='attention';
        else
            LayoutStyle:='';
        end;
        Rec.Printer:=GetPrinterSelected();
    end;
    local procedure GetReports()var GetForNAVReports: Codeunit "ForNAV Get ForNAV Reports";
    xRec: Record "ForNAV Reports";
    printerSelection: Record "Printer Selection";
    begin
        GetForNAVReports.GetForNAVReports(Rec);
        Rec.ModifyAll(Indent, 2);
        Rec.SetRange(Indent, 2);
        Rec.SetFilter(ID, '<>0');
        if Rec.FindSet then repeat xRec:=Rec;
                if not Rec.get(Rec.Category, 0)then begin
                    Rec.Init;
                    Rec.ID:=0;
                    Rec.Indent:=1;
                    Rec.Name:=Format(Rec.Category);
                    if printerSelection.Get(UserId, Rec.ID)then Rec.Printer:=printerSelection."Printer Name"
                    else if printerSelection.Get('', Rec.ID)then Rec.Printer:=printerSelection."Printer Name"
                        else if printerSelection.Get(UserId, 0)then Rec.Printer:=printerSelection."Printer Name"
                            else if printerSelection.Get('', 0)then Rec.Printer:=printerSelection."Printer Name"
                                else
                                    Rec.Printer:='';
                    Rec.Insert;
                end;
                Rec:=xRec;
            until Rec.Next = 0;
        Rec.SetRange(Indent);
        Rec.SetRange(ID);
        if Rec.FindFirst then;
    end;
    local procedure RefreshPage()var xID: Integer;
    xCat: Integer;
    begin
        xID:=Rec.ID;
        xCat:=Rec.Category.AsInteger();
        Rec.FindSet;
        repeat Rec.GetCurrentReportLayout;
            if Rec.Description <> xRec.Description then Rec.Modify;
        until Rec.Next = 0;
        Rec.Get(xCat, xID);
    end;
    local procedure EnableOrShowArchive()var archive: Record "ForNAV Document Archive";
    ArchiveSetup: Codeunit "ForNAV Document Archive Mgt.";
    enableArchiving: Label 'Archiving is not turned on for this report - do you want to turn it on?';
    begin
        if(Rec.ID <> 0)then begin
            if archiveSetup.GetArchiveSetup(Rec.ID)then begin
                archive.SetRange("Report ID", Rec.ID);
                Page.RunModal(Page::"ForNAV Document Archive", archive);
            end
            else
            begin
                if(Confirm(enableArchiving, true))then archiveSetup.SetArchiveSetup(Rec.ID, true);
            end;
        end;
    end;
    var LayoutStyle: Text;
}
