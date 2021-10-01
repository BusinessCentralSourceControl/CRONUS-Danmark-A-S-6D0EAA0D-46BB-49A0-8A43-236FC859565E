Table 6188479 "ForNAV Report Selection"
{
    fields
    {
        field(1;Usage;Option)
        {
            Caption = 'Usage', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
            OptionCaption = 'S.Quote,S.Order,S.Invoice,S.Cr.Memo,S.Test,P.Quote,P.Order,P.Invoice,P.Cr.Memo,P.Receipt,P.Ret.Shpt.,P.Test,B.Stmt,B.Recon.Test,B.Check,Reminder,Fin.Charge,Rem.Test,F.C.Test,Prod. Order,S.Blanket,P.Blanket,M1,M2,M3,M4,Inv1,Inv2,Inv3,SM.Quote,SM.Order,SM.Invoice,SM.Credit Memo,SM.Contract Quote,SM.Contract,SM.Test,S.Return,P.Return,S.Shipment,S.Ret.Rcpt.,S.Work Order,Invt. Period Test,SM.Shipment,S.Test Prepmt.,P.Test Prepmt.,S.Arch. Quote,S.Arch. Order,P.Arch. Quote,P.Arch. Order,S. Arch. Return Order,P. Arch. Return Order,Asm. Order,P.Assembly Order,S.Order Pick Instruction,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,C.Statement,V.Remittance,JQ,S.Invoice Draft,Pro Forma S. Invoice,S. Arch. Blanket Order,P. Arch. Blanket Order', Comment='DO NOT TRANSLATE';
            OptionMembers = "S.Quote", "S.Order", "S.Invoice", "S.Cr.Memo", "S.Test", "P.Quote", "P.Order", "P.Invoice", "P.Cr.Memo", "P.Receipt", "P.Ret.Shpt.", "P.Test", "B.Stmt", "B.Recon.Test", "B.Check", Reminder, "Fin.Charge", "Rem.Test", "F.C.Test", "Prod. Order", "S.Blanket", "P.Blanket", M1, M2, M3, M4, Inv1, Inv2, Inv3, "SM.Quote", "SM.Order", "SM.Invoice", "SM.Credit Memo", "SM.Contract Quote", "SM.Contract", "SM.Test", "S.Return", "P.Return", "S.Shipment", "S.Ret.Rcpt.", "S.Work Order", "Invt. Period Test", "SM.Shipment", "S.Test Prepmt.", "P.Test Prepmt.", "S.Arch. Quote", "S.Arch. Order", "P.Arch. Quote", "P.Arch. Order", "S. Arch. Return Order", "P. Arch. Return Order", "Asm. Order", "P.Assembly Order", "S.Order Pick Instruction", , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , "C.Statement", "V.Remittance", JQ, "S.Invoice Draft", "Pro Forma S. Invoice", "S. Arch. Blanket Order", "P. Arch. Blanket Order";
        }
        field(2;Sequence;Code[10])
        {
            Caption = 'Sequence', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
            Numeric = true;
        }
        field(3;"Report ID";Integer)
        {
            Caption = 'Report ID';
            DataClassification = SystemMetadata;
            TableRelation = AllObjWithCaption."Object ID" where("Object Type"=const(Report));
        }
        field(4;"Report Caption";Text[250])
        {
            CalcFormula = lookup(AllObjWithCaption."Object Caption" where("Object Type"=const(Report), "Object ID"=field("Report ID")));
            Caption = 'Report Caption';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6188471;Type;Option)
        {
            Caption = 'Type', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
            OptionCaption = 'Original,,,,Default,,,,Current';
            OptionMembers = Original, , , , Default, , , , Current;
        }
        field(6188472;Source;Option)
        {
            Caption = 'Source', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
            OptionCaption = ' ,Microsoft,ForNAV,Custom,Other';
            OptionMembers = " ", Microsoft, ForNAV, Custom, Other;
        }
        field(6188473;"Current Report ID";Integer)
        {
            Caption = 'Current Report ID', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(6188474;"Original Report ID";Integer)
        {
            Caption = 'Original Report ID', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(6188475;"ForNAV Report ID";Integer)
        {
            Caption = 'ForNAV Report ID', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(6188476;Origin;Integer)
        {
            Caption = '', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(6188477;"Usage (Warehouse)";Option)
        {
            Caption = 'Usage', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
            OptionCaption = 'Put-away,Pick,Movement,Invt. Put-away,Invt. Pick,Invt. Movement,Receipt,Shipment,Posted Receipt,Posted Shipment', Comment='DO NOT TRANSLATE';
            OptionMembers = "Put-away", Pick, Movement, "Invt. Put-away", "Invt. Pick", "Invt. Movement", Receipt, Shipment, "Posted Receipt", "Posted Shipment";
        }
    }
    keys
    {
        key(Key1;Usage, Type, Origin)
        {
        }
    }
    fieldgroups
    {
    }
    trigger OnInsert()begin
        SetSource;
    end;
    procedure RestoreHistory()begin
    end;
    procedure ReplaceReport()begin
    end;
    procedure GetDefaults(var ReportSelectionHist: Record "ForNAV Report Selection Hist.")var ReplaceReportSel: Codeunit "ForNAV Replace Report Sel.";
    begin
        ReplaceReportSel.GetDefaults(ReportSelectionHist);
    end;
    local procedure SetSource()begin
        case "Report ID" of 1 .. 49999, 99000000 .. 99000999: Source:=Source::Microsoft;
        50000 .. 99999: Source:=Source::Custom;
        6188471 .. 6189470: Source:=Source::ForNAV;
        else
            Source:=Source::Other;
        end;
    end;
    procedure RestoreOriginal()begin
        CreateReportSelections("Original Report ID");
    end;
    procedure UseForNAV()begin
        CreateReportSelections("ForNAV Report ID");
    end;
    local procedure CreateReportSelections(ReportID: Integer)var ReportSelections: Record "Report Selections";
    begin
        ReportSelections.SetRange(Usage, Usage);
        ReportSelections.DeleteAll;
        ReportSelections.Usage:="Report Selection Usage".FromInteger(Usage);
        ReportSelections.Sequence:='1';
        ReportSelections."Report ID":=ReportID;
        ReportSelections.Insert;
        "Report ID":=ReportID;
        "Current Report ID":=ReportID;
        SetSource;
    end;
    procedure GetUsage(): Text begin
        if Origin = Database::"Report Selections" then exit(Format(Usage));
        exit(Format("Usage (Warehouse)"));
    end;
    procedure ReplaceReportsWithForNAV()var Setup: Record "ForNAV Setup";
    begin
        Setup.ReplaceReportSelection(false);
    end;
    procedure ResetToMicrosoftDefault()var ForNAVReportSelectionHist: Record "ForNAV Report Selection Hist.";
    ReportSelections: Record "Report Selections";
    ReportSelectionWarehouse: Record "Report Selection Warehouse";
    ReportSelectionMgt: Codeunit "Report Selection Mgt.";
    begin
        ForNAVReportSelectionHist.DeleteAll;
        ReportSelections.DeleteAll;
        ReportSelectionWarehouse.DeleteAll;
        ReportSelectionMgt.InitReportSelectionSales;
        ReportSelectionMgt.InitReportSelectionPurch;
        ReportSelectionMgt.InitReportSelectionBank;
        ReportSelectionMgt.InitReportSelectionCust;
        ReportSelectionMgt.InitReportSelectionInvt;
        ReportSelectionMgt.InitReportSelectionProd;
        ReportSelectionMgt.InitReportSelectionServ;
        ReportSelectionMgt.InitReportSelectionWhse;
    end;
}
