Table 6188670 "ForNAV Label Args."
{
    fields
    {
        field(1;"Report ID";Integer)
        {
            DataClassification = SystemMetadata;
        }
        field(2;Orientation;Option)
        {
            DataClassification = SystemMetadata;
            OptionMembers = Undefined, Portrait, Landscape;
        }
        field(3;"One Label per Package";Boolean)
        {
            DataClassification = SystemMetadata;
        }
        field(4;"No. of Labels";Integer)
        {
            DataClassification = SystemMetadata;
        }
        field(5;"Open Designer";Boolean)
        {
            Caption = 'Design';
            DataClassification = SystemMetadata;
        }
        field(6;Merge;Boolean)
        {
            DataClassification = SystemMetadata;
        }
        field(7;"Direct Print";Boolean)
        {
            DataClassification = SystemMetadata;
        }
        field(8;"Printer Name";Text[250])
        {
            DataClassification = SystemMetadata;
        }
        field(9;Blob;Blob)
        {
            Caption = 'Blob', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
        field(10;"Print to Stream";Boolean)
        {
            Caption = 'Print to Stream', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(Key1;"Report ID")
        {
        }
    }
    var TempBlobWithState: Record "ForNAV Core Setup" temporary;
    procedure ClearMerge()begin
        TempBlobWithState.Reset;
        TempBlobWithState.DeleteAll;
    end;
    procedure CreateLabels(Data: Variant)var LabelSetup: Record "ForNAV Label Setup";
    Label: Record "ForNAV Label" temporary;
    RecRefLib: Codeunit "ForNAV RecordRef Library";
    RecRef: RecordRef;
    LineRec: RecordRef;
    n: Integer;
    begin
        if not LabelSetup.Get then LabelSetup."Enable Preview":=true;
        RecRefLib.ConvertToRecRef(Data, RecRef);
        if FindLinesRecRef(RecRef, LineRec)then begin
            if LineRec.FindSet then repeat Label."ForNAV Label No."+=1;
                    Label."ForNAV Page No.":=0;
                    for n:=1 to FindQtyField(LineRec)do CreateLabelPerLine(Label, RecRef, LineRec);
                until LineRec.Next = 0;
            LineRec.Close;
        end
        else
        begin
            Label."ForNAV Label No.":=1;
            Label."ForNAV Page No.":=0;
            for n:=1 to FindQtyField(RecRef)do CreateLabel(Label, RecRef);
        end;
        RunTheLabel(Data, Label, LabelSetup."Enable Preview");
    end;
    local procedure RunTheLabel(var Data: Variant;
    var Label: Record "ForNAV Label" temporary;
    DemoMode: Boolean)var TempBlob: Record "ForNAV Core Setup" temporary;
    LabelPortrait: Report "ForNAV Label Portrait";
    LabelLandscape: Report "ForNAV Label Landscape";
    LabelPriceTag: Report "ForNAV Label Price Tag";
    LabelMgt: Codeunit "ForNAV Label Mgt.";
    DirectPrint: Codeunit "ForNAV Direct Print";
    OutStr: OutStream;
    begin
        if TempBlobWithState.Blob.Hasvalue then begin
            TempBlob.Blob:=TempBlobWithState.Blob;
            TempBlob.Insert;
        end;
        if Merge then begin
            TempBlobWithState.DeleteAll;
            TempBlobWithState.Init;
            TempBlobWithState.Blob.CreateOutstream(OutStr);
        end;
        if "Print to Stream" then Blob.CreateOutstream(OutStr);
        LabelMgt.SetData(Label);
        LabelMgt.SetMergePDF(TempBlob);
        if IsForNAVLabel("Report ID")then begin
            if Merge or "Print to Stream" then Report.SaveAs("Report ID", '', Reportformat::Pdf, OutStr)
            else if "Direct Print" then DirectPrint.DirectPrint("Report ID", Label)
                else
                    Report.Run("Report ID", DemoMode, false, Label);
        end
        else
            ForNAVRunCustomLabelReport(Data, Label);
        if Merge then TempBlobWithState.Insert;
    end;
    local procedure FindLinesRecRef(var RecRef: RecordRef;
    var LineRec: RecordRef): Boolean var FldRef: FieldRef;
    UseDefaultLineFilters: Boolean;
    PrintOnHeader: Boolean;
    begin
        case RecRef.Number of Database::"Sales Header", Database::"Purchase Header": LineRec.Open(RecRef.Number + 1);
        Database::"Sales Invoice Header", Database::"Purch. Inv. Header": LineRec.Open(RecRef.Number + 1);
        Database::"Sales Shipment Header", Database::"Purch. Rcpt. Header": LineRec.Open(RecRef.Number + 1);
        Database::"Sales Cr.Memo Header", Database::"Purch. Cr. Memo Hdr.": LineRec.Open(RecRef.Number + 1);
        else
            ForNAVCreateLabelData(RecRef, LineRec, UseDefaultLineFilters, PrintOnHeader);
        end;
        if PrintOnHeader or (LineRec.Number = 0)then exit(false);
        if not UseDefaultLineFilters then begin
            if UseDocumentType(RecRef)then begin
                FldRef:=LineRec.Field(1);
                FldRef.SetRange(RecRef.Field(1).Value);
            end;
            FldRef:=LineRec.Field(3);
            FldRef.SetRange(RecRef.Field(3).Value);
        end;
        exit(true);
    end;
    local procedure CreateLabel(var Label: Record "ForNAV Label";
    var RecRef: RecordRef)var Fld: Record "Field";
    xLabel: Record "ForNAV Label";
    LabelRecRef: RecordRef;
    FldRef: FieldRef;
    begin
        xLabel:=Label;
        Label.Init;
        Label.SetFromCompany;
        LabelRecRef.Open(GetObjectID, true);
        Fld.SetRange(TableNo, GetObjectID);
        if Fld.FindSet then repeat FldRef:=LabelRecRef.Field(Fld."No.");
                case Fld.Type of Fld.Type::Text, Fld.Type::Code: FldRef.Value:=FindField(RecRef, FldRef.Name, '');
                Fld.Type::BigInteger, Fld.Type::Integer, Fld.Type::Decimal: FldRef.Value:=FindFieldDec(RecRef, FldRef.Name, 0);
                end;
            until Fld.Next = 0;
        LabelRecRef.SetTable(Label);
        Label."ForNAV Page No.":=xLabel."ForNAV Page No." + 1;
        Label."ForNAV Design":="Open Designer";
        Label."One Label per Package":=Rec."One Label per Package";
        GetBarCode(Label, RecRef, RecRef);
        GetLocation(Label, RecRef);
        Label.Insert;
    end;
    local procedure CreateLabelPerLine(var Label: Record "ForNAV Label";
    var RecRef: RecordRef;
    var LineRec: RecordRef)var Fld: Record "Field";
    LabelRecRef: RecordRef;
    FldRef: FieldRef;
    xLabel: Record "ForNAV Label";
    begin
        xLabel:=Label;
        Label.Init;
        Label.SetFromCompany;
        LabelRecRef.Open(GetObjectID, true);
        Fld.SetRange(TableNo, GetObjectID);
        if Fld.FindSet then repeat FldRef:=LabelRecRef.Field(Fld."No.");
                case Fld.Type of Fld.Type::Text, Fld.Type::Code: begin
                    FldRef.Value:=FindField(RecRef, FldRef.Name, '');
                    FldRef.Value:=FindField(LineRec, FldRef.Name, FldRef.Value);
                end;
                Fld.Type::Date: begin
                    FldRef.Value:=FindFieldDate(RecRef, FldRef.Name, 0D);
                    FldRef.Value:=FindFieldDate(LineRec, FldRef.Name, FldRef.Value);
                end;
                Fld.Type::BigInteger, Fld.Type::Integer, Fld.Type::Decimal: begin
                    FldRef.Value:=FindFieldDec(RecRef, FldRef.Name, 0);
                    FldRef.Value:=FindFieldDec(LineRec, FldRef.Name, FldRef.Value);
                end;
                end;
            until Fld.Next = 0;
        LabelRecRef.SetTable(Label);
        Label."ForNAV Label No.":=xLabel."ForNAV Label No.";
        Label."ForNAV Page No.":=xLabel."ForNAV Page No." + 1;
        Label."ForNAV Design":="Open Designer";
        Label."One Label per Package":=Rec."One Label per Package";
        GetBarCode(Label, RecRef, LineRec);
        GetArea(Label, RecRef, LineRec);
        GetLocation(Label, RecRef);
        Label.Insert;
    end;
    local procedure FindField(var RecRef: RecordRef;
    Which: Text;
    Value: Variant): Text var Fld: Record "Field";
    FldRef: FieldRef;
    begin
        Fld.SetRange(TableNo, RecRef.Number);
        Fld.SetRange(FieldName, Which);
        if not Fld.FindFirst then exit(Value);
        FldRef:=RecRef.Field(Fld."No.");
        exit(FldRef.Value);
    end;
    local procedure FindFieldDec(var RecRef: RecordRef;
    Which: Text;
    Value: Variant): Decimal var Fld: Record "Field";
    FldRef: FieldRef;
    begin
        Fld.SetRange(TableNo, RecRef.Number);
        Fld.SetRange(FieldName, Which);
        if not Fld.FindFirst then exit(Value);
        FldRef:=RecRef.Field(Fld."No.");
        exit(FldRef.Value);
    end;
    local procedure FindFieldDate(var RecRef: RecordRef;
    Which: Text;
    Value: Variant): Date var Fld: Record "Field";
    FldRef: FieldRef;
    begin
        Fld.SetRange(TableNo, RecRef.Number);
        Fld.SetRange(FieldName, Which);
        if not Fld.FindFirst then exit(Value);
        FldRef:=RecRef.Field(Fld."No.");
        exit(FldRef.Value);
    end;
    local procedure GetObjectID(): Integer var AllObj: Record AllObj;
    begin
        AllObj.SetRange("Object Type", AllObj."object type"::Table);
        AllObj.SetRange("Object Name", 'ForNAV Label');
        AllObj.FindFirst;
        exit(AllObj."Object ID");
    end;
    local procedure GetBarCode(var Label: Record "ForNAV Label";
    var RecRef: RecordRef;
    var LineRec: RecordRef)var Handled: Boolean;
    begin
        GetBarCodeEvent(Label, RecRef, LineRec, Handled);
        if Handled then exit;
        Label.Barcode:=Label."No.";
    end;
    [IntegrationEvent(false, false)]
    local procedure GetBarCodeEvent(var Label: Record "ForNAV Label";
    var RecRef: RecordRef;
    var LineRec: RecordRef;
    var Handled: Boolean)begin
    end;
    local procedure GetArea(var Label: Record "ForNAV Label";
    var RecRef: RecordRef;
    var LineRec: RecordRef)var Handled: Boolean;
    begin
        GetAreaEvent(Label, RecRef, LineRec, Handled);
        if Handled then exit;
        Label.Area:=Label."Ship-to Post Code";
    end;
    local procedure GetAreaEvent(var Label: Record "ForNAV Label";
    var RecRef: RecordRef;
    var LineRec: RecordRef;
    var Handled: Boolean)begin
    end;
    local procedure GetLocation(var Label: Record "ForNAV Label";
    var RecRef: RecordRef)var Location: Record Location;
    CompanyInformation: Record "Company Information";
    Fld: Record "Field";
    FldRef: FieldRef;
    begin
        CompanyInformation.Get;
        Label."From Name":=CompanyInformation.Name;
        Label."From Name 2":=CompanyInformation."Name 2";
        Label."From Address":=CompanyInformation.Address;
        Label."From Address 2":=CompanyInformation."Address 2";
        Label."From Post Code":=CompanyInformation."Post Code";
        Label."From City":=CompanyInformation.City;
        Label."From County":=CompanyInformation.County;
        Label."From Country/Region Code":=CompanyInformation."Country/Region Code";
        Fld.SetRange(TableNo, RecRef.Number);
        Fld.SetRange(FieldName, 'Location Code');
        if not Fld.FindFirst then exit;
        FldRef:=RecRef.Field(Fld."No.");
        if not Location.Get(FldRef.Value)then exit;
        Label."From Name":=Location.Name;
        Label."From Name 2":=Location."Name 2";
        Label."From Address":=Location.Address;
        Label."From Address 2":=Location."Address 2";
        Label."From Post Code":=Location."Post Code";
        Label."From City":=Location.City;
        Label."From County":=Location.County;
        Label."From Country/Region Code":=Location."Country/Region Code";
        Label."From Contact":=Location.Contact;
    end;
    local procedure UseDocumentType(var RecRef: RecordRef): Boolean begin
        exit(RecRef.Number in[Database::"Sales Header", Database::"Purchase Header"]);
    end;
    [IntegrationEvent(false, false)]
    local procedure ForNAVRunCustomLabelReport(var Data: Variant;
    var Label: Record "ForNAV Label" temporary)begin
    end;
    [IntegrationEvent(false, false)]
    local procedure ForNAVCreateLabelData(var RecRef: RecordRef;
    var LineRec: RecordRef;
    var UseDefaultLineFilters: Boolean;
    var PrintOnHeader: Boolean)begin
    end;
    local procedure FindQtyField(var RecRef: RecordRef): Integer var Fld: Record "Field";
    FldRef: FieldRef;
    Value: Decimal;
    begin
        if not "One Label per Package" then exit(1);
        Fld.SetRange(TableNo, RecRef.Number);
        Fld.SetRange(FieldName, 'Quantity');
        if Fld.IsEmpty then exit(1);
        Fld.FindFirst;
        FldRef:=RecRef.Field(Fld."No.");
        case Fld.Type of Fld.Type::Integer, Fld.Type::BigInteger: exit(FldRef.Value);
        Fld.Type::Decimal: begin
            Value:=FldRef.Value;
            exit(ROUND(Value, 1));
        end;
        else
            exit(1);
        end;
    end;
    procedure GetOrientationForRequestPage()var LabelSetup: Record "ForNAV Label Setup";
    begin
        if not LabelSetup.Get then exit;
        case LabelSetup.Orientation of LabelSetup.Orientation::Landscape: Orientation:=Orientation::Landscape;
        LabelSetup.Orientation::Portrait: Orientation:=Orientation::Portrait;
        end;
    end;
    local procedure IsForNAVLabel(Value: Integer)ReturnValue: Boolean var Handled: Boolean;
    begin
        SetIsForNAVLabel(Value, ReturnValue);
        if Handled then exit;
        exit(Value in[Report::"ForNAV Label Price Tag", Report::"ForNAV Label Landscape", Report::"ForNAV Label Portrait"]);
    end;
    [IntegrationEvent(true, false)]
    local procedure SetIsForNAVLabel(Value: Integer;
    var ReturnValue: Boolean)begin
    end;
}
