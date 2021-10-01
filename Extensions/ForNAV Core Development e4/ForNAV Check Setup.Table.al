Table 6188781 "ForNAV Check Setup"
{
    Caption = 'ForNAV Check Setup', Comment='DO NOT TRANSLATE';

    fields
    {
        field(1;"Primary Key";Code[10])
        {
            Caption = 'Primary Key', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(2;"MICR Encoding";Option)
        {
            Caption = 'MICR Encoding', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
            OptionCaption = 'None,Check No. + Routing No. + Bank Account No.,Amount + Check No. + Routing No. + Bank Account No.,,,,,,,,,,Defined with Per-Tenant Extension', Comment='DO NOT TRANSLATE';
            OptionMembers = "None", "Check No. + Routing No. + Bank Account No.", "Amount + Check No. + Routing No. + Bank Account No.", , , , , , , , , , "Defined with Per-Tenant Extension";
        }
        field(10;"Layout";Option)
        {
            Caption = 'Layout', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
            OptionCaption = ' ,Check-Stub-Stub,Stub-Stub-Check,Stub-Check-Stub,3 Checks,Top Check with one Stub,Bottom Check with one Stub,,,Other', Comment='DO NOT TRANSLATE';
            OptionMembers = " ", "Check-Stub-Stub", "Stub-Stub-Check", "Stub-Check-Stub", "3 Checks", "Top Check with one Stub", "Bottom Check with one Stub", , , Other;

            trigger OnValidate()begin
                "No. of Lines (Stub)":=MaxLineNo;
            end;
        }
        field(11;"No. of Lines (Stub)";Integer)
        {
            Caption = 'No. of Lines (Stub)', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(20;Watermark;Blob)
        {
            Caption = 'Watermark', Comment='DO NOT TRANSLATE';
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(21;"Watermark File Name";Text[250])
        {
            Caption = 'Watermark File Name', Comment='DO NOT TRANSLATE';
            DataClassification = OrganizationIdentifiableInformation;
            Editable = false;
            InitValue = 'Click to import...';
        }
        field(30;Signature;Blob)
        {
            Caption = 'Signature', Comment='DO NOT TRANSLATE';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(31;"Signature File Name";Text[250])
        {
            Caption = 'Signature File Name', Comment='DO NOT TRANSLATE';
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
            InitValue = 'Click to import...';
        }
        field(32;"2nd Signature";Blob)
        {
            Caption = '2nd Signature', Comment='DO NOT TRANSLATE';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(33;"2nd Signature File Name";Text[250])
        {
            Caption = '2nd Signature File Name', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
            Editable = false;
            InitValue = 'Click to import...';
        }
    }
    keys
    {
        key(Key1;"Primary Key")
        {
        }
    }
    fieldgroups
    {
    }
    procedure InitSetup()begin
        if Get then exit;
        Init;
        Insert;
    end;
    local procedure MaxLineNo(): Integer begin
        case Layout of Layout::"3 Checks": exit(0);
        Layout::"Top Check with one Stub", Layout::"Bottom Check with one Stub": exit(20);
        else
            exit(9);
        end;
    end;
    procedure GetTypeBasedOnLayout(PartNo: Integer): Integer var Model: Record "ForNAV Check Model";
    NoImplementedErr: label 'This is not implemented, please contact your ForNAV partner.', Comment='DO NOT TRANSLATE';
    begin
        case Layout of Layout::"3 Checks": exit(Model.Type::Check);
        Layout::"Top Check with one Stub": case PartNo of 1: exit(Model.Type::Check);
            2: exit(Model.Type::Stub);
            3: exit(Model.Type::" ");
            end;
        Layout::"Bottom Check with one Stub": case PartNo of 1: exit(Model.Type::Stub);
            2: exit(Model.Type::Check);
            3: exit(Model.Type::" ");
            end;
        Layout::"Check-Stub-Stub": case PartNo of 1: exit(Model.Type::Check);
            2: exit(Model.Type::Stub);
            3: exit(Model.Type::Stub);
            end;
        Layout::Other: Error(NoImplementedErr);
        Layout::"Stub-Check-Stub": case PartNo of 1: exit(Model.Type::Stub);
            2: exit(Model.Type::Check);
            3: exit(Model.Type::Stub);
            end;
        Layout::"Stub-Stub-Check": case PartNo of 1: exit(Model.Type::Stub);
            2: exit(Model.Type::Stub);
            3: exit(Model.Type::Check);
            end;
        end;
    end;
    procedure ImportWatermarkFromClientFile(Which: Integer): Boolean var ReadCheckWatermarks: Codeunit "ForNAV Read Check Watermarks";
    begin
        exit(ReadCheckWatermarks.ReadFromFile(Rec, Which));
    end;
    procedure DesignTemplate()var Template: Report "ForNAV US Check";
    Handled: Boolean;
    begin
        OnBeforeDesignTemplate(Template.ObjectId(false), Handled);
        if Handled then exit;
        Template.RunModal;
    end;
    procedure DownloadWatermarks()begin
        Hyperlink('http://www.fornav.com/report-watermarks/');
    end;
    procedure SetDefault(Setup: Record "ForNAV Setup")var CheckSetup: Codeunit "ForNAV Check Setup";
    begin
        CheckSetup.SetCheckType(Setup, Rec);
    end;
    procedure GetCheckWatermark(): Text var TempBlob: Record "ForNAV Core Setup";
    begin
        CalcFields(Watermark);
        TempBlob.Blob:=Watermark;
        exit(TempBlob.ToBase64String);
    end;
    [IntegrationEvent(false, false)]
    local procedure OnBeforeDesignTemplate(ReportID: Text;
    var Handled: Boolean)begin
    end;
}
