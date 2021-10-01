Codeunit 6188561 "ForNAV RecordRef Library"
{
    procedure ConvertToRecRef(var Rec: Variant;
    RecRef: RecordRef)var WrongDataTypeErr: label 'Runtime Error: Wrong Datatype. Please contact your ForNAV reseller.', Comment='DO NOT TRANSLATE';
    begin
        case true of Rec.IsRecordRef: RecRef:=Rec;
        Rec.IsRecord: RecRef.GetTable(Rec);
        else
            Error(WrongDataTypeErr);
        end;
    end;
    procedure FindAndFilterFieldNo(var RecRef: RecordRef;
    var LineRec: RecordRef;
    var FldRef: FieldRef;
    Value: Text)var "Field": Record "Field";
    DocumentNoField: FieldRef;
    begin
        Field.SetRange(TableNo, RecRef.Number);
        Field.SetRange(FieldName, Value);
        if not Field.FindFirst then exit;
        DocumentNoField:=RecRef.Field(Field."No.");
        Field.Reset;
        Field.SetRange(TableNo, RecRef.Number + 1);
        Field.SetRange("No.", Field."No.");
        if not Field.FindFirst then exit;
        FldRef:=LineRec.Field(Field."No.");
        FldRef.SetRange(DocumentNoField.Value);
    end;
}
