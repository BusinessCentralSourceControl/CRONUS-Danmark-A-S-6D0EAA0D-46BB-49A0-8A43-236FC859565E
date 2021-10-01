Codeunit 6188475 "ForNAV Get Sales Tax Details"
{
    // Copyright (c) 2017-2021 ForNAV ApS - All Rights Reserved
    // The intellectual work and technical concepts contained in this file are proprietary to ForNAV.
    // Unauthorized reverse engineering, distribution or copying of this file, parts hereof, or derived work, via any medium is strictly prohibited without written permission from ForNAV ApS.
    // This source code is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    trigger OnRun()begin
    end;
    procedure GetSalesTax(Rec: Variant;
    var SalesTaxBuffer: Record "ForNAV Sales Tax Buffer" temporary)var DocLineBuffer: Record "ForNAV Document Line Buffer" temporary;
    RecRefLib: Codeunit "ForNAV RecordRef Library";
    TestValidDociFace: Codeunit "ForNAV Test Valid Doc iFace";
    RecRef: RecordRef;
    LineRec: RecordRef;
    begin
        ThrowErrorIfNotTemp(SalesTaxBuffer);
        RecRefLib.ConvertToRecRef(Rec, RecRef);
        TestValidDociFace.ThrowErrorIfNotValid(RecRef);
        FindLinesRecRef(DocLineBuffer, RecRef, LineRec);
        CreateSalesTaxDetails(DocLineBuffer, SalesTaxBuffer);
    end;
    local procedure ThrowErrorIfNotTemp(var SalesTaxBuffer: Record "ForNAV Sales Tax Buffer")var CheckTemporary: Codeunit "ForNAV Check Temporary";
    begin
        CheckTemporary.IsTemporary(SalesTaxBuffer, true);
    end;
    local procedure FindLinesRecRef(var DocLineBuffer: Record "ForNAV Document Line Buffer";
    var RecRef: RecordRef;
    var LineRec: RecordRef)var RecRefLib: Codeunit "ForNAV RecordRef Library";
    FldRef: FieldRef;
    begin
        LineRec.Open(RecRef.Number + 1);
        RecRefLib.FindAndFilterFieldNo(RecRef, LineRec, FldRef, 'No.');
        RecRefLib.FindAndFilterFieldNo(RecRef, LineRec, FldRef, 'Document Type');
        if LineRec.FindSet then repeat DocLineBuffer.CreateForRecRef(LineRec);
            until LineRec.Next = 0;
    end;
    local procedure CreateSalesTaxDetails(var DocLineBuffer: Record "ForNAV Document Line Buffer";
    var SalesTaxBuffer: Record "ForNAV Sales Tax Buffer")begin
        SalesTaxBuffer.Init;
        SalesTaxBuffer.Insert;
        if DocLineBuffer.FindSet then repeat if DocLineBuffer."VAT %" = 0 then SalesTaxBuffer."Exempt Amount":=SalesTaxBuffer."Exempt Amount" + DocLineBuffer.Amount
                else
                    SalesTaxBuffer."Taxable Amount":=SalesTaxBuffer."Taxable Amount" + DocLineBuffer.Amount;
                SalesTaxBuffer.Modify;
            until DocLineBuffer.Next = 0;
    end;
}
