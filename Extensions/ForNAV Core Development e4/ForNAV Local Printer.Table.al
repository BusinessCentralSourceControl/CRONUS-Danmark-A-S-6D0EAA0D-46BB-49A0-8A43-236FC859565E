table 6188510 "ForNAV Local Printer"
{
    DataClassification = ToBeClassified;
    Caption = 'ForNAV Local Printer';

    fields
    {
        field(1;"Cloud Printer Name";Text[250])
        {
            Caption = 'Cloud Printer Name';
            DataClassification = SystemMetadata;
            NotBlank = true;
        }
        field(2;"Local Printer Name";Text[250])
        {
            Caption = 'Local Printer Name';
            DataClassification = SystemMetadata;
            InitValue = 'DEFAULT';
            NotBlank = true;
        }
        field(3;Description;Text[250])
        {
            Caption = 'Description';
            DataClassification = SystemMetadata;
        }
        field(4;Paperkind;Option)
        {
            Caption = 'Paperkind';
            DataClassification = SystemMetadata;
            OptionMembers = Custom, Letter, LetterSmall, Tabloid, Ledger, Legal, Statement, Executive, A3, A4, A4Small, A5, B4, B5, Folio, Quarto, Standard10x14, Standard11x17, Note, Number9Envelope, Number10Envelope, Number11Envelope, Number12Envelope, Number14Envelope, CSheet, DSheet, ESheet, DLEnvelope, C5Envelope, C3Envelope, C4Envelope, C6Envelope, C65Envelope, B4Envelope, B5Envelope, B6Envelope, ItalyEnvelope, MonarchEnvelope, PersonalEnvelope, USStandardFanfold, GermanStandardFanfold, GermanLegalFanfold, IsoB4, JapanesePostcard, Standard9x11, Standard10x11, Standard15x11, InviteEnvelope, , , LetterExtra, LegalExtra, TabloidExtra, A4Extra, LetterTransverse, A4Transverse, LetterExtraTransverse, APlus, BPlus, LetterPlus, A4Plus, A5Transverse, B5Transverse, A3Extra, A5Extra, B5Extra, A2, A3Transverse, A3ExtraTransverse, JapaneseDoublePostcard, A6, JapaneseEnvelopeKakuNumber2, JapaneseEnvelopeKakuNumber3, JapaneseEnvelopeChouNumber3, JapaneseEnvelopeChouNumber4, LetterRotated, A3Rotated, A4Rotated, A5Rotated, B4JisRotated, B5JisRotated, JapanesePostcardRotated, JapaneseDoublePostcardRotated, A6Rotated, JapaneseEnvelopeKakuNumber2Rotated, JapaneseEnvelopeKakuNumber3Rotated, JapaneseEnvelopeChouNumber3Rotated, JapaneseEnvelopeChouNumber4Rotated, B6Jis, B6JisRotated, Standard12x11, JapaneseEnvelopeYouNumber4, JapaneseEnvelopeYouNumber4Rotated, Prc16K, Prc32K, Prc32KBig, PrcEnvelopeNumber1, PrcEnvelopeNumber2, PrcEnvelopeNumber3, PrcEnvelopeNumber4, PrcEnvelopeNumber5, PrcEnvelopeNumber6, PrcEnvelopeNumber7, PrcEnvelopeNumber8, PrcEnvelopeNumber9, PrcEnvelopeNumber10, Prc16KRotated, Prc32KRotated, Prc32KBigRotated, PrcEnvelopeNumber1Rotated, PrcEnvelopeNumber2Rotated, PrcEnvelopeNumber3Rotated, PrcEnvelopeNumber4Rotated, PrcEnvelopeNumber5Rotated, PrcEnvelopeNumber6Rotated, PrcEnvelopeNumber7Rotated, PrcEnvelopeNumber8Rotated, PrcEnvelopeNumber9Rotated, PrcEnvelopeNumber10Rotated, Default;
            InitValue = Default;
        }
        field(5;Landscape;Option)
        {
            Caption = 'Landscape';
            DataClassification = SystemMetadata;
            OptionMembers = Default, Portrait, Landscape;
        }
        field(6;Color;Boolean)
        {
            Caption = 'Color';
            InitValue = true;
            DataClassification = SystemMetadata;
        }
        field(7;Duplex;Option)
        {
            Caption = 'Duplex';
            DataClassification = SystemMetadata;
            OptionMembers = Default, Simplex, Vertical, Horizontal;
        }
        field(8;Copies;Integer)
        {
            Caption = 'Copies';
            DataClassification = SystemMetadata;
            InitValue = 1;
            MinValue = 1;
        }
        field(9;"Paper Source Kind";Option)
        {
            Caption = 'Paper Source Kind';
            DataClassification = SystemMetadata;
            OptionMembers = Custom, Upper, Lower, Middle, Manual, Envelope, ManualFeed, AutomaticFeed, TractorFeed, SmallFormat, LargeFormat, LargeCapacity, , , Cassette, FormSource;
            InitValue = FormSource;

            trigger OnValidate()begin
                if "Paper Source Kind" <> "Paper Source Kind"::Custom then "Custom Paper Source Name":='';
            end;
        }
        field(10;"Custom Paper Source Name";Text[30])
        {
            Caption = 'Custom Paper Source Name';
            DataClassification = SystemMetadata;

            trigger OnValidate()begin
                if "Custom Paper Source Name" <> '' then "Paper Source Kind":="Paper Source Kind"::Custom;
            end;
        }
#if LocalPrintService field(11;IsPrintService;Boolean)
        {
            Caption = 'Is Print Service';
            DataClassification = SystemMetadata;
        }
#endif field(20;Unit;Option)
        {
            Caption = 'Unit';
            DataClassification = SystemMetadata;
            OptionMembers = HI, TI, "IN", CM, MM, PC, PT;
        }
        field(21;Width;Integer)
        {
            Caption = 'Width';
            DataClassification = SystemMetadata;
            MinValue = 0;
        }
        field(22;Height;Integer)
        {
            Caption = 'Height';
            DataClassification = SystemMetadata;
            MinValue = 0;
        }
        field(23;"Scale Mode";Option)
        {
            Caption = 'Scale Mode';
            DataClassification = SystemMetadata;
            OptionMembers = Fit, ActualSize, CustomScale;
            InitValue = ActualSize;
        }
        field(24;Scale;Integer)
        {
            Caption = 'Scale';
            DataClassification = SystemMetadata;
            InitValue = 100;
            MinValue = 1;
            MaxValue = 100;
        }
    }
    keys
    {
        key(PK;"Cloud Printer Name")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()begin
        SetValues;
    end;
    trigger OnRename()begin
        if xRec."Cloud Printer Name" = 'Default' then Error('The default printer cannot be renamed.');
    end;
    trigger OnModify()begin
        if(xRec."Cloud Printer Name" = 'Default') and (Rec."Local Printer Name" <> 'DEFAULT')then Error('The local printer must be DEFAULT for the Default printer.');
        SetValues;
    end;
    trigger OnDelete()begin
        if "Cloud Printer Name" = 'Default' then Error('The default printer cannot be deleted.');
    end;
    procedure SetValues()begin
        if Paperkind <> Paperkind::Custom then begin
            Width:=0;
            Height:=0;
        end;
        if "Scale Mode" <> "Scale Mode"::CustomScale then Scale:=100;
    end;
    procedure PrinterPayLoad(): JsonObject var payload: JsonObject;
    paperTray: JsonObject;
    paperTrays: JsonArray;
    begin
        payload.Add('version', 1);
        if(Duplex <> Duplex::Default) and (Duplex <> Duplex::Simplex)then payload.Add('duplex', true);
        if Description <> '' then payload.Add('description', Description);
        if Color then payload.Add('color', Color);
        if Copies <> 1 then payload.Add('defaultcopies', Copies);
        if "Paper Source Kind" = "Paper Source Kind"::Custom then paperTray.Add('papersourcekind', 257)
        else
            paperTray.Add('papersourcekind', "Paper Source Kind");
        if Paperkind = Paperkind::Default then paperTray.Add('paperkind', 9) // A4
        else
            paperTray.Add('paperkind', paperkind);
        if Paperkind = Paperkind::Custom then begin
            paperTray.Add('units', Unit);
            paperTray.Add('width', Width);
            paperTray.Add('height', Height);
        end;
        if Landscape = LandScape::Landscape then paperTray.Add('landscape', true);
        paperTrays.Add(paperTray);
        payload.Add('papertrays', paperTrays);
        exit(payload);
    end;
    procedure PrinterSetting(): JsonObject var printerSettings: JsonObject;
    begin
        printerSettings.Add('Version', 1);
        printerSettings.Add('Description', Description);
        printerSettings.Add('Color', Color);
        printerSettings.Add('Copies', Copies);
        printerSettings.Add('PaperSourceKind', Format("Paper Source Kind"));
        printerSettings.Add('CustomPaperSourceName', "Custom Paper Source Name");
        if PaperKind = PaperKind::Default then begin
            PaperKind:=PaperKind::Custom;
            Width:=0;
            Height:=0;
        end;
        printerSettings.Add('PaperKind', Format(Paperkind));
        printerSettings.Add('Unit', Format(Unit));
        printerSettings.Add('Width', Width);
        printerSettings.Add('Height', Height);
        printerSettings.Add('Landscape', Format(Landscape));
        printerSettings.Add('Duplex', Format(Duplex));
        printerSettings.Add('ScaleMode', Format("Scale Mode"));
        printerSettings.Add('Scale', Scale);
        exit(printerSettings);
    end;
    procedure GetLocalPrinter(CloudPrinterName: Text[250];
    var LocalPrinterName: Text;
    var PrinterSettings: Text;
    var IsPrintService: Boolean): Boolean begin
        if Get(CloudPrinterName)then begin
            LocalPrinterName:="Local Printer Name";
            PrinterSetting().WriteTo(PrinterSettings);
#if LocalPrintService IsPrintService:=Rec.IsPrintService;
#endif exit(true);
        end;
        LocalPrinterName:='';
        PrinterSettings:='';
        exit(false);
    end;
}
