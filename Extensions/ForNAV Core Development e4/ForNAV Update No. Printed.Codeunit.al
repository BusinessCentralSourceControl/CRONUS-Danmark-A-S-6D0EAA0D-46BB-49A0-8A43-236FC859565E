Codeunit 6188474 "ForNAV Update No. Printed"
{
    Permissions = TableData "Sales Header"=rm,
        TableData "Purchase Header"=rm,
        TableData "Sales Shipment Header"=rm,
        TableData "Sales Invoice Header"=rm,
        TableData "Sales Cr.Memo Header"=rm,
        TableData "Purch. Rcpt. Header"=rm,
        TableData "Purch. Inv. Header"=rm,
        TableData "Purch. Cr. Memo Hdr."=rm,
        TableData "Issued Reminder Header"=rm,
        TableData "Issued Fin. Charge Memo Header"=rm,
        TableData "Service Invoice Header"=rm,
        TableData "Service Header"=rm,
        TableData "Service Cr.Memo Header"=rm,
        TableData "Service Contract Header"=rm,
        TableData "Return Shipment Header"=rm,
        tabledata "Return Receipt Header"=rm;

    procedure UpdateNoPrinted(Rec: Variant;
    Preview: Boolean)var RecRefLib: Codeunit "ForNAV RecordRef Library";
    RecRef: RecordRef;
    Handled: Boolean;
    begin
        if Preview then exit;
        OnBeforeUpdateNoPrinted(Rec, Handled);
        if Handled then exit;
        RecRefLib.ConvertToRecRef(Rec, RecRef);
        FindAndUpdateField(RecRef);
    end;
    local procedure FindAndUpdateField(var RecRef: RecordRef)var "Field": Record "Field";
    FldRef: FieldRef;
    NoPrinted: Integer;
    NotAValidTableErr: label 'This table is not valid to be used with the Update No. Printed Function. Please contact your system administrator or ForNAV support.', Comment='DO NOT TRANSLATE';
    begin
        Field.SetRange(TableNo, RecRef.Number);
        Field.SetRange(FieldName, 'No. Printed');
        if not Field.FindFirst then Error(NotAValidTableErr);
        FldRef:=RecRef.Field(Field."No.");
        NoPrinted:=FldRef.Value;
        NoPrinted+=1;
        FldRef.Value:=NoPrinted;
        RecRef.Modify;
        Commit;
    end;
    [IntegrationEvent(false, false)]
    procedure OnBeforeUpdateNoPrinted(Rec: Variant;
    var Handled: Boolean)begin
    end;
}
