table 6189102 "ForNAV Local Print Queue"
{
    Access = Internal;
    DataPerCompany = false;

    fields
    {
        field(1;ID;Integer)
        {
            DataClassification = SystemMetadata;
            AutoIncrement = true;
        }
        field(2;"Cloud Printer Name";Text[250])
        {
            Caption = 'Cloud Printer Name';
            DataClassification = SystemMetadata;
            NotBlank = true;
        }
        field(4;ReportID;Integer)
        {
            Caption = 'Report ID';
            DataClassification = SystemMetadata;
        }
        field(5;"Report Name";Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(AllObj."Object Name" where("Object Type"=const(Report), "Object ID"=field(ReportID)));
            Caption = 'Report Name';
            Editable = false;
        }
        field(6;"Local Printer";Text[250])
        {
            Caption = 'Local Printer';
            DataClassification = SystemMetadata;
        }
        field(7;Status;Enum "ForNAV Local Print Status")
        {
            DataClassification = SystemMetadata;
        // OptionMembers = Ready,Printing;
        // OptionCaption = 'Ready,Printing';
        }
        field(9;"Service";Text[250])
        {
            DataClassification = SystemMetadata;
        }
        field(10;Document;BLOB)
        {
            DataClassification = EndUserIdentifiableInformation;
        }
        field(11;"Message";Text[1000])
        {
            DataClassification = SystemMetadata;
        }
        field(12;"Size";BigInteger)
        {
            DataClassification = SystemMetadata;
        }
        field(13;"Owner";Text[250])
        {
            DataClassification = SystemMetadata;
        }
        field(14;"Document Name";Text[250])
        {
            Caption = 'Document';
            DataClassification = SystemMetadata;
        }
        field(16;"Company";Text[250])
        {
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(PK;ID)
        {
        }
    }
    trigger OnModify()begin
        if((rec.Status = rec.Status::Ready) and (xRec.Status <> xRec.Status::Ready))then begin
            // Status changed to ready
            Clear(Rec.Service);
            Clear(Rec.Message);
        end;
    end;
    procedure Create(ReportID: Integer;
    var "Cloud Printer Name": Text;
    var "Local Printer Name": Text;
    DocumentStream: InStream)var OutStr: OutStream;
    begin
        Rec.Init();
        Rec.ReportID:=ReportID;
        Rec."Cloud Printer Name":="Cloud Printer Name";
        Rec."Local Printer":="Local Printer Name";
        Rec.Document.CreateOutStream(OutStr);
        CopyStream(OutStr, DocumentStream);
        Rec.Size:=Rec.Document.Length;
        Rec.Owner:=UserId();
        Rec.CalcFields(Rec."Report Name");
        Rec."Document Name":=Rec."Report Name";
        Rec.Company:=CompanyName();
        Rec.Insert(true);
    end;
    // procedure Get(ID: Integer; var LocalPrinterName: Text; var PrinterSettings: Text; var Base64Pdf: Text)
    // var
    //     ReportForNav: Codeunit "ForNAV Report Management";
    //     Base64Convert: Codeunit "Base64 Convert";
    //     InStr: InStream;
    //     IsPrintService: Boolean;
    // begin
    //     Rec.Get(ID);
    //     ReportForNav.GetLocalPrinter(Rec."Cloud Printer Name", LocalPrinterName, PrinterSettings, IsPrintService);
    //     Rec.Document.CreateInStream(InStr);
    //     Base64Pdf := Base64Convert.ToBase64(InStr);
    // end;
    procedure Restart()var r: Record "ForNAV Local Print Queue";
    begin
        SelectLatestVersion();
        if not r.Get(rec.ID)then begin
            Message('The job is no longer available.');
            exit;
        end;
        r.Message:='';
        r.Status:=Rec.Status::Ready;
        r.Service:='';
        r.Modify(true);
    end;
}
