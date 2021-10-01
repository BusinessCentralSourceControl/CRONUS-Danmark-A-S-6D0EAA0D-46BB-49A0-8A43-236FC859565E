page 6188510 "ForNAV Local Printers"
{
    PageType = List;
    Caption = 'ForNAV Local Printers';
    SourceTable = "ForNAV Local Printer";
    AdditionalSearchTerms = 'Specify printers for Direct Printing.';
    DelayedInsert = true;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(CloudPrinterName;Rec."Cloud Printer Name")
                {
                    NotBlank = true;
                    ApplicationArea = All;
                }
                field(LocalPrinterName;Rec."Local Printer Name")
                {
                    ApplicationArea = All;
                }
                field(Description;Rec.Description)
                {
                    ApplicationArea = All;
                }
#if LocalPrintService field(IsPrintService;Rec.IsPrintService)
                {
                    ApplicationArea = All;
                }
#endif field(Paperkind;Rec.Paperkind)
                {
                    ApplicationArea = All;
                    OptionCaption = 'Custom,Letter,Letter Small,Tabloid,Ledger,Legal,Statement,Executive,A3,A4,A4 Small,A5,B4 (JIS),B5 (JIS),Folio,Quarto,10×14,11×17,Note,Envelope #9,Envelope #10,Envelope #11,Envelope #12,Envelope #14,C size sheet,D size sheet,E size sheet,Envelope DL,Envelope C5,Envelope C3,Envelope C4,Envelope C6,Envelope C65,Envelope B4,Envelope B5,Envelope B6,Envelope,Envelope Monarch,6 3/4 Envelope,US Std Fanfold,German Std Fanfold,German Legal Fanfold,B4 (ISO),Japanese Postcard,9×11,10×11,15×11,Envelope Invite,,,Letter Extra,Legal Extra,Tabloid Extra,A4 Extra,Letter Transverse,A4 Transverse,Letter Extra Transverse,Super A,Super B,Letter Plus,A4 Plus,A5 Transverse,B5 (JIS) Transverse,A3 Extra,A5 Extra,B5 (ISO) Extra,A2,A3 Transverse,A3 Extra Transverse,Japanese Double Postcard,A6,Japanese Envelope Kaku #2,Japanese Envelope Kaku #3,Japanese Envelope Chou #3,Japanese Envelope Chou #4,Letter Rotated,A3 Rotated,A4 Rotated,A5 Rotated,B4 (JIS) Rotated,B5 (JIS) Rotated,Japanese Postcard Rotated,Double Japan Postcard Rotated,A6 Rotated,Japan Envelope Kaku #2 Rotated,Japan Envelope Kaku #3 Rotated,Japan Envelope Chou #3 Rotated,Japan Envelope Chou #4 Rotated,B6 (JIS),B6 (JIS) Rotated,12×11,Japan Envelope You #4,Japan Envelope You #4 Rotated,PRC 16K,PRC 32K,PRC 32K(Big),PRC Envelope #1,PRC Envelope #2,PRC Envelope #3,PRC Envelope #4,PRC Envelope #5,PRC Envelope #6,PRC Envelope #7,PRC Envelope #8,PRC Envelope #9,PRC Envelope #10,PRC 16K Rotated,PRC 32K Rotated,PRC 32K(Big) Rotated,PRC Envelope #1 Rotated,PRC Envelope #2 Rotated,PRC Envelope #3 Rotated,PRC Envelope #4 Rotated,PRC Envelope #5 Rotated,PRC Envelope #6 Rotated,PRC Envelope #7 Rotated,PRC Envelope #8 Rotated,PRC Envelope #9 Rotated,PRC Envelope #10 Rotated,Default';
                }
                field(Unit;Rec.Unit)
                {
                    ApplicationArea = All;
                    OptionCaption = 'Hundredths of an inch,Thousandths of an inch,Inches,Centimeters,Millimeters,Picas,Points';
                }
                field(Width;Rec.Width)
                {
                    ApplicationArea = All;
                }
                field(Height;Rec.Height)
                {
                    ApplicationArea = All;
                }
                field(Color;Rec.Color)
                {
                    ApplicationArea = All;
                }
                field(Landscape;Rec.Landscape)
                {
                    ApplicationArea = All;
                    OptionCaption = 'Default,Portrait,Landscape';
                }
                field(Duplex;Rec.Duplex)
                {
                    ApplicationArea = All;
                    OptionCaption = 'Default,Simplex,Vertical,Horizontal';
                }
                field(Copies;Rec.Copies)
                {
                    ApplicationArea = All;
                }
                field(PaperSourceKind;Rec."Paper Source Kind")
                {
                    ApplicationArea = All;
                    OptionCaption = 'Custom,Upper Bin,Lower Bin,Middle Bin,Manual Feed,Envelope,Manual Feed Envelope,Automatic Feed,Tractor Feed,Small Format Paper,Large Format Paper,Large Capacity Bin,,,Cassette,Default';
                }
                field(CustomPaperSourceName;Rec."Custom Paper Source Name")
                {
                    ApplicationArea = All;
                }
                field(ScaleMode;Rec."Scale Mode")
                {
                    ApplicationArea = All;
                    OptionCaption = 'Fit,ActualSize,CustomScale';
                }
                field(Scale;Rec.Scale)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(processing)
        {
            action(DownLoadLocalPrinter)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Caption = 'Download Local Printer';
                Image = ExportFile;

                trigger OnAction()begin
                    Hyperlink('https://www.fornav.com/dispatch/?product=reports&action=directprint');
                end;
            }
            action(TestLocalPrinter)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Caption = 'Test Local Printer';
                Image = TestReport;

                trigger OnAction()var recRef: RecordRef;
                begin
                    Rec.SetRange(SystemId, Rec.SystemId);
                    recRef.GetTable(Rec);
                    Report.Print(Report::"ForNAV Local Printer Test", '', Rec."Cloud Printer Name", recRef);
                    Rec.SetRange(SystemId);
                end;
            }
            action(PrinterSelections)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Report;
                Caption = 'Printer Selections';
                Image = SelectReport;
                RunObject = Page "Printer Selections";
            }
        }
    }
}
