Codeunit 6188683 "ForNAV Get Label Sheet"
{
    procedure GetLabels(var LabelSheetArgs: Record "ForNAV Label Sheet Args.";
    var LabelSheet: Record "ForNAV Label Sheet")var GetLabelFilters: Codeunit "ForNAV Get Label Filters";
    RecRef: RecordRef;
    begin
        TestRecRef(LabelSheetArgs);
        RecRef.Open(LabelSheetArgs."Table ID");
        GetLabelFilters.GetFiltersForRecRef(RecRef);
        MoveRecRefToLabel(LabelSheetArgs, LabelSheet, RecRef);
    end;
    local procedure MoveRecRefToLabel(var LabelSheetArgs: Record "ForNAV Label Sheet Args.";
    var LabelSheet: Record "ForNAV Label Sheet";
    var RecRef: RecordRef)var LabelRecRef: RecordRef;
    i: Integer;
    begin
        LabelRecRef.Open(Database::"ForNAV Label Sheet", true);
        if RecRef.FindSet then repeat for i:=1 to LabelSheetArgs."No. of Labels" do begin
                    CreateNewRowIfFirst(LabelRecRef, i = 1);
                    GetNoValueFromRecRef(i, RecRef, LabelRecRef);
                    if i < LabelSheetArgs."No. of Labels" then if RecRef.Next(1) = 0 then i:=LabelSheetArgs."No. of Labels";
                end;
                LabelRecRef.SetTable(LabelSheet);
                LabelSheet.Insert;
            until RecRef.Next = 0;
    end;
    local procedure TestRecRef(var LabelSheetArgs: Record "ForNAV Label Sheet Args.")var Fld: Record "Field";
    begin
        Fld.SetRange(Fld.TableNo, LabelSheetArgs."Table ID");
        Fld.SetRange(Fld.FieldName, 'No.');
        Fld.FindFirst;
    end;
    local procedure GetNoValueFromRecRef(LabelNo: Integer;
    var RecRef: RecordRef;
    var LabelRecRef: RecordRef)var Fld: Record "Field";
    SourceTableFld: Record "Field";
    SourceTableFldRef: FieldRef;
    LabelFldRef: FieldRef;
    begin
        LabelNo-=1;
        Fld.SetRange(TableNo, LabelRecRef.Number);
        Fld.SetRange("No.", (LabelNo * 100) + 10, (LabelNo * 100) + 99);
        if Fld.FindSet then repeat SourceTableFld.SetRange(TableNo, RecRef.Number);
                SourceTableFld.SetRange(FieldName, CopyStr(Fld.FieldName, 4, StrLen(Fld.FieldName)));
                if SourceTableFld.FindFirst then begin
                    SourceTableFldRef:=RecRef.Field(SourceTableFld."No.");
                    LabelFldRef:=LabelRecRef.Field(Fld."No.");
                    LabelFldRef.Value:=SourceTableFldRef.Value;
                    LabelRecRef.Modify;
                end;
            until Fld.Next = 0;
    end;
    local procedure CreateNewRowIfFirst(var LabelRecRef: RecordRef;
    First: Boolean)var FldRef: FieldRef;
    i: Integer;
    begin
        if not First then exit;
        FldRef:=LabelRecRef.Field(1);
        i:=FldRef.Value;
        i+=1;
        FldRef.Value:=i;
        LabelRecRef.Init;
        LabelRecRef.Insert;
    end;
}
