Codeunit 6188775 "ForNAV Create Check Model"
{
    // Copyright (c) 2017-2021 ForNAV ApS - All Rights Reserved
    // The intellectual work and technical concepts contained in this file are proprietary to ForNAV.
    // Unauthorized reverse engineering, distribution or copying of this file, parts hereof, or derived work, via any medium is strictly prohibited without written permission from ForNAV ApS.
    // This source code is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    trigger OnRun()begin
    end;
    procedure CreateFromGenJnlLn(var Args: Record "ForNAV Check Arguments";
    var GenJnlLn: Record "Gen. Journal Line";
    var Model: Record "ForNAV Check Model"): Boolean var Check: Record "ForNAV Check" temporary;
    Stub: Record "ForNAV Stub" temporary;
    begin
        if not ValidLine(Args, GenJnlLn, Model)then exit(false);
        Clear(Model);
        Check.CreateFromGenJnlLn(Args, GenJnlLn);
        Check.GetStub(Args, Stub, GenJnlLn);
        Check.UpdateJournal(Args, GenJnlLn);
        Check.CreateCheckLedgerEntry(Args, GenJnlLn);
        CreateModel(Check, Stub, Model);
        Args.IncreaseCheckNoIfMultiplePages(Model."No. of Pages");
        exit(true);
    end;
    procedure CreateModel(var Check: Record "ForNAV Check";
    var Stub: Record "ForNAV Stub";
    var Model: Record "ForNAV Check Model")var NextLineNo: Integer;
    begin
        Model.DeleteAll;
        ForEachStubCreateModel(Check, Stub, Model, NextLineNo);
        CreateEmptyLinesInStub(Model, NextLineNo, Stub.Count);
        SetDataInModel(Model);
    end;
    local procedure ForEachStubCreateModel(var Check: Record "ForNAV Check";
    var Stub: Record "ForNAV Stub";
    var Model: Record "ForNAV Check Model";
    var NextLineNo: Integer)var CheckSetup: Record "ForNAV Check Setup";
    RunningTotal: Decimal;
    begin
        CheckSetup.Get;
        Stub.FindSet;
        repeat CreateModelFromStub(Stub, Model, NextLineNo, RunningTotal);
            UpdateModelWithCheck(Check, Model);
        until(Stub.Next = 0) or (CheckSetup.Layout = CheckSetup.Layout::"3 Checks");
    end;
    local procedure CreateModelFromStub(var Stub: Record "ForNAV Stub";
    var Model: Record "ForNAV Check Model";
    var NextLineNo: Integer;
    var RunningTotal: Decimal)begin
        RunningTotal+=Stub.Amount;
        Model.Init;
        Model."Entry No.":=Stub."Entry No.";
        Model."Entry Type":=Stub."Entry Type";
        Model."Document Date":=Stub."Document Date";
        Model."Document No.":=Stub."Document No.";
        Model."External Document No.":=Stub."External Document No.";
        Model.Amount:=Stub.Amount + Stub."Discount Amount";
        Model."Running Total":=RunningTotal;
        Model."Discount Amount":=Stub."Discount Amount";
        Model."Net Amount":=Stub.Amount;
        Model."Document Type":=Stub."Document Type";
        Model."Job No.":=Stub."Job No.";
        Model."Currency Code":=Stub."Currency Code";
        Model.SetNoOfPages(Stub.Count);
        Model.SetPageAndLineNo(NextLineNo);
        Model.Insert;
    end;
    local procedure UpdateModelWithCheck(var Check: Record "ForNAV Check";
    var Model: Record "ForNAV Check Model")begin
        Model."Posting Date":=Check."Posting Date";
        Model.Test:=Check.Test;
        Model."Check No.":=Check."Check No.";
        Model."Check No Stub":=Check."Check No.";
        Model."Amount Paid":=Check.Amount;
        Model."Amount Written in Text":=Check."Amount as Text (LCY)";
        Model."Amount in Numbers":=Check."Amount Filled as Text";
        Model."Pay-to Vendor No.":=Check."Pay-to Vendor No.";
        Model."Pay-to Name":=Check."Pay-to Name";
        Model."Pay-to Name 2":=Check."Pay-to Name 2";
        Model."Pay-to Address":=Check."Pay-to Address";
        Model."Pay-to Address 2":=Check."Pay-to Address 2";
        Model."Pay-to Post Code":=Check."Pay-to Post Code";
        Model."Pay-to City":=Check."Pay-to City";
        Model."Pay-to County":=Check."Pay-to County";
        Model."Pay-to Country/Region Code":=Check."Pay-to Country/Region Code";
        Model."Bank Name":=Check."Bank Name";
        Model."Bank Account No.":=Check."Bank Account No. (Text)";
        Model."Bank Routing No.":=Check."Bank Routing No.";
        Model.Modify;
        Model.Duplicate;
    end;
    local procedure SetDataInModel(var Model: Record "ForNAV Check Model")begin
        Model.Reset;
        Model.FindSet;
        repeat Model.SetType;
            Model.SetIsVoid;
            Model.SetAddress;
            Model.SetIsNewPage;
            Model.SetContinuedOnNextPage;
            Model.SetMICRLine;
            Model.SetPayToAddress;
            Model.VoidCheckFields;
            Model.Modify;
        until Model.Next = 0;
    end;
    local procedure CreateEmptyLinesInStub(var Model: Record "ForNAV Check Model";
    var NextLineNo: Integer;
    StubCount: Integer)var CheckSetup: Record "ForNAV Check Setup";
    begin
        CheckSetup.Get;
        if NextLineNo >= CheckSetup."No. of Lines (Stub)" then exit;
        while NextLineNo < CheckSetup."No. of Lines (Stub)" do begin
            Model.Init;
            Model."Part No.":=1;
            NextLineNo+=1;
            Model."Line No.":=NextLineNo;
            Model.SetNoOfPages(StubCount);
            Model.Insert;
            Model.Duplicate;
        end;
    end;
    local procedure ValidLine(var Args: Record "ForNAV Check Arguments";
    var GenJnlLn: Record "Gen. Journal Line";
    var Model: Record "ForNAV Check Model"): Boolean begin
        if not Args."One Check Per Vendor" then exit(true);
        if not Model.FindFirst then exit(true);
        exit(GenJnlLn."Account No." <> Model."Pay-to Vendor No.");
    end;
}
