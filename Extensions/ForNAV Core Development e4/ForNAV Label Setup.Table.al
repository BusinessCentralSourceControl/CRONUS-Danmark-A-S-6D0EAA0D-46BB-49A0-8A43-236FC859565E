Table 6188481 "ForNAV Label Setup"
{
    Caption = 'ForNAV Label Setup';

    fields
    {
        field(1;"Primary Key";Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = SystemMetadata;
        }
        field(2;Orientation;Option)
        {
            Caption = 'Orientation';
            DataClassification = SystemMetadata;
            OptionMembers = Landscape, Portrait;
        }
        field(3;"Enable Preview";Boolean)
        {
            Caption = 'Enable Preview';
            DataClassification = SystemMetadata;
        }
        field(4;"Disable Warnings";Boolean)
        {
            Caption = 'Disable Warnings';
            DataClassification = SystemMetadata;
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
    procedure ReplaceReportSelection(HideDialog: Boolean)var DoYouWantToQst: label 'Do you want to replace the current reports with the ForNAV reports?';
    ReplaceReportSel: Codeunit "ForNAV Replace Report Sel.";
    begin
        if not HideDialog then if not Confirm(DoYouWantToQst, true)then exit;
        ReplaceReportSel.Run;
    end;
    procedure DesignTemplatePortrait()var Template: Report "ForNAV Label Portrait";
    Handled: Boolean;
    begin
        OnBeforeDesignTemplate(Template.ObjectId(false), Handled);
        if Handled then exit;
        Template.RunModal;
    end;
    procedure DesignTemplateLandscape()var Template: Report "ForNAV Label Landscape";
    Handled: Boolean;
    begin
        OnBeforeDesignTemplate(Template.ObjectId(false), Handled);
        if Handled then exit;
        Template.RunModal;
    end;
    procedure ShowOrDisableWarning(Value: Integer)var AskWarningQst: label 'Do you want to print %1 labels?';
    TheOptions: label 'Stop,Continue,Disable Warning';
    begin
        if Value < 10 then exit;
        case StrMenu(TheOptions, 1, StrSubstNo(AskWarningQst, Value))of 0, 1: Error('');
        2: exit;
        3: begin
            if not Get then Insert;
            "Disable Warnings":=true;
            Modify;
            Commit;
        end;
        end;
    end;
    [IntegrationEvent(false, false)]
    local procedure OnBeforeDesignTemplate(ReportID: Text;
    var Handled: Boolean)begin
    end;
}
