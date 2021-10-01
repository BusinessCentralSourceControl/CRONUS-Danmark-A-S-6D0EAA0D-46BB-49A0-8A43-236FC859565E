Codeunit 6188472 "ForNAV Get Vat Amount Lines"
{
    // Copyright (c) 2017-2021 ForNAV ApS - All Rights Reserved
    // The intellectual work and technical concepts contained in this file are proprietary to ForNAV.
    // Unauthorized reverse engineering, distribution or copying of this file, parts hereof, or derived work, via any medium is strictly prohibited without written permission from ForNAV ApS.
    // This source code is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    trigger OnRun()begin
    end;
    procedure GetVatAmountLines(Rec: Variant;
    var VATAmountLine: Record "VAT Amount Line" temporary)var DocLineBuffer: Record "ForNAV Document Line Buffer" temporary;
    RecRefLib: Codeunit "ForNAV RecordRef Library";
    TestValidDociFace: Codeunit "ForNAV Test Valid Doc iFace";
    RecRef: RecordRef;
    LineRec: RecordRef;
    begin
        ThrowErrorIfNotTemp(VATAmountLine);
        RecRefLib.ConvertToRecRef(Rec, RecRef);
        TestValidDociFace.ThrowErrorIfNotValid(RecRef);
        FindLinesRecRef(DocLineBuffer, RecRef, LineRec);
        CreateVATAmountLine(DocLineBuffer, VATAmountLine);
    end;
    local procedure ThrowErrorIfNotTemp(var VATAmountLine: Record "VAT Amount Line")var CheckTemporary: Codeunit "ForNAV Check Temporary";
    begin
        CheckTemporary.IsTemporary(VATAmountLine, true);
    end;
    local procedure FindLinesRecRef(var DocLineBuffer: Record "ForNAV Document Line Buffer";
    var RecRef: RecordRef;
    var LineRec: RecordRef)var RecRefLib: Codeunit "ForNAV RecordRef Library";
    FldRef: FieldRef;
    begin
        LineRec.Open(RecRef.Number + 1);
        RecRefLib.FindAndFilterFieldNo(RecRef, LineRec, FldRef, 'No.');
        RecRefLib.FindAndFilterFieldNo(RecRef, LineRec, FldRef, 'Document Type');
        RecRefLib.FindAndFilterFieldNo(RecRef, LineRec, FldRef, 'Doc. No. Occurrence');
        RecRefLib.FindAndFilterFieldNo(RecRef, LineRec, FldRef, 'Version No.');
        if LineRec.FindSet then repeat DocLineBuffer.CreateForRecRef(LineRec);
            until LineRec.Next = 0;
    end;
    local procedure CreateVATAmountLine(var DocLineBuffer: Record "ForNAV Document Line Buffer";
    var VATAmountLine: Record "VAT Amount Line")begin
        if DocLineBuffer.FindSet then repeat VATAmountLine.Init;
                VATAmountLine."VAT Identifier":=DocLineBuffer."VAT Identifier";
                VATAmountLine."VAT Calculation Type":=DocLineBuffer."VAT Calculation Type";
                VATAmountLine."Tax Group Code":=DocLineBuffer."Tax Group Code";
                VATAmountLine."VAT %":=DocLineBuffer."VAT %";
                VATAmountLine."VAT Base":=DocLineBuffer.Amount;
                VATAmountLine."Amount Including VAT":=DocLineBuffer."Amount Including VAT";
                VATAmountLine."Line Amount":=DocLineBuffer."Line Amount";
                if DocLineBuffer."Allow Invoice Disc." then VATAmountLine."Inv. Disc. Base Amount":=DocLineBuffer."Line Amount";
                VATAmountLine."Invoice Discount Amount":=DocLineBuffer."Inv. Discount Amount";
                VATAmountLine."VAT Clause Code":=DocLineBuffer."VAT Clause Code";
                if(DocLineBuffer."VAT Clause Code" <> '') or (DocLineBuffer.Amount <> DocLineBuffer."Amount Including VAT")then VATAmountLine.InsertLine;
            until DocLineBuffer.Next = 0;
    end;
}
