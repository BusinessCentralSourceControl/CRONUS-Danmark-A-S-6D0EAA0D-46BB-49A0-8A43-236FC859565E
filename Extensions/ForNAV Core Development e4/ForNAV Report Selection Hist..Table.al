Table 6188478 "ForNAV Report Selection Hist."
{
    Caption = 'Report Selection History', Comment='DO NOT TRANSLATE';

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
            Caption = 'Report ID', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
            TableRelation = AllObjWithCaption."Object ID" where("Object Type"=const(Report));
        }
        field(7;"Custom Report Layout Code";Code[20])
        {
            Caption = 'Custom Report Layout Code', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
            Editable = false;
            TableRelation = "Custom Report Layout".Code where(Code=field("Custom Report Layout Code"));
        }
        field(19;"Use for Email Attachment";Boolean)
        {
            Caption = 'Use for Email Attachment', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
            InitValue = true;
        }
        field(20;"Use for Email Body";Boolean)
        {
            Caption = 'Use for Email Body', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(21;"Email Body Layout Code";Code[20])
        {
            Caption = 'Email Body Layout Code', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
            TableRelation = if("Email Body Layout Type"=const("Custom Report Layout"))"Custom Report Layout".Code where(Code=field("Email Body Layout Code"), "Report ID"=field("Report ID"))
            else if("Email Body Layout Type"=const("HTML Layout"))"O365 HTML Template".Code;
        }
        field(25;"Email Body Layout Type";Option)
        {
            Caption = 'Email Body Layout Type', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
            OptionCaption = 'Custom Report Layout,HTML Layout', Comment='DO NOT TRANSLATE';
            OptionMembers = "Custom Report Layout", "HTML Layout";
        }
        field(6188471;Origin;Integer)
        {
            Caption = 'Origin', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(6188472;"Usage (Warehouse)";Option)
        {
            Caption = 'Usage', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
            OptionCaption = 'Put-away,Pick,Movement,Invt. Put-away,Invt. Pick,Invt. Movement,Receipt,Shipment,Posted Receipt,Posted Shipment', Comment='DO NOT TRANSLATE';
            OptionMembers = "Put-away", Pick, Movement, "Invt. Put-away", "Invt. Pick", "Invt. Movement", Receipt, Shipment, "Posted Receipt", "Posted Shipment";
        }
    }
    keys
    {
        key(Key1;Usage, Sequence, Origin)
        {
        }
    }
    procedure Restore()begin
        case Origin of Database::"Report Selections": CreateReportSelections("Report ID");
        Database::"Report Selection Warehouse": CreateReportSelectionsWarehouse("Report ID");
        end;
    end;
    local procedure CreateReportSelections(ReportID: Integer)var ReportSelections: Record "Report Selections";
    begin
        ReportSelections.SetRange(Usage, Usage);
        ReportSelections.DeleteAll;
        ReportSelections.Usage:="Report Selection Usage".FromInteger(Usage);
        ReportSelections.Sequence:=Sequence;
        ReportSelections."Report ID":=ReportID;
        ReportSelections.Insert;
    end;
    local procedure CreateReportSelectionsWarehouse(ReportID: Integer)var ReportSelectionWarehouse: Record "Report Selection Warehouse";
    begin
        ReportSelectionWarehouse.SetRange(Usage, "Usage (Warehouse)");
        ReportSelectionWarehouse.DeleteAll;
        ReportSelectionWarehouse.Usage:="Report Selection Warehouse Usage".FromInteger("Usage (Warehouse)");
        ReportSelectionWarehouse.Sequence:=Sequence;
        ReportSelectionWarehouse."Report ID":=ReportID;
        ReportSelectionWarehouse.Insert;
    end;
}
