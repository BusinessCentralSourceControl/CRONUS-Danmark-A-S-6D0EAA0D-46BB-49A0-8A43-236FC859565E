Codeunit 6188471 "ForNAV Check Document Discount"
{
    // Copyright (c) 2017-2021 ForNAV ApS - All Rights Reserved
    // The intellectual work and technical concepts contained in this file are proprietary to ForNAV.
    // Unauthorized reverse engineering, distribution or copying of this file, parts hereof, or derived work, via any medium is strictly prohibited without written permission from ForNAV ApS.
    // This source code is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    trigger OnRun()begin
    end;
    procedure HasDiscount(Rec: Variant): Boolean var RecRefLib: Codeunit "ForNAV RecordRef Library";
    TestValidDociFace: Codeunit "ForNAV Test Valid Doc iFace";
    RecRef: RecordRef;
    begin
        RecRefLib.ConvertToRecRef(Rec, RecRef);
        TestValidDociFace.ThrowErrorIfNotValid(RecRef);
        exit(CheckLinesTableForDiscount(RecRef, FindDiscountFieldNoInLines(RecRef)));
    end;
    local procedure FindDiscountFieldNoInLines(RecRef: RecordRef): Integer var "Field": Record "Field";
    NoDiscountFieldErr: label 'The connected line table does not contain a valid field for Line Discount.', Comment='DO NOT TRANSLATE';
    begin
        Field.SetRange(TableNo, GetLineTable(RecRef.Number));
        Field.SetRange(FieldName, 'Line Discount %');
        if not Field.FindFirst then Error(NoDiscountFieldErr);
        exit(Field."No.");
    end;
    local procedure CheckLinesTableForDiscount(var RecRef: RecordRef;
    FieldNo: Integer): Boolean var RecRefLib: Codeunit "ForNAV RecordRef Library";
    LineRec: RecordRef;
    FldRef: FieldRef;
    begin
        LineRec.Open(RecRef.Number + 1);
        RecRefLib.FindAndFilterFieldNo(RecRef, LineRec, FldRef, 'No.');
        RecRefLib.FindAndFilterFieldNo(RecRef, LineRec, FldRef, 'Document Type');
        FldRef:=LineRec.Field(FieldNo);
        FldRef.SetFilter('<>0');
        exit(not LineRec.IsEmpty);
    end;
    local procedure GetLineTable(Value: Integer): Integer begin
        if Value = Database::"Service Header" then exit(Value + 2);
        exit(Value + 1);
    end;
}
