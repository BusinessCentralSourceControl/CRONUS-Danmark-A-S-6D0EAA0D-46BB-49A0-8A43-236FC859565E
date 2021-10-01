Codeunit 6188774 "ForNAV Create Check Ledg. Ent."
{
    // Copyright (c) 2017-2021 ForNAV ApS - All Rights Reserved
    // The intellectual work and technical concepts contained in this file are proprietary to ForNAV.
    // Unauthorized reverse engineering, distribution or copying of this file, parts hereof, or derived work, via any medium is strictly prohibited without written permission from ForNAV ApS.
    // This source code is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    trigger OnRun()begin
    end;
    procedure CreateCheckLedgerEntry(Args: Record "ForNAV Check Arguments";
    Chck: Record "ForNAV Check";
    GenJnlLine: Record "Gen. Journal Line")var CheckLedgEntry: Record "Check Ledger Entry";
    CheckManagement: Codeunit CheckManagement;
    begin
        if not Args."Test Print" then begin
            CheckLedgEntry.Init;
            CheckLedgEntry."Bank Account No.":=Args."Bank Account No.";
            CheckLedgEntry."Posting Date":=GenJnlLine."Posting Date";
            CheckLedgEntry."Document Type":=GenJnlLine."Document Type";
            CheckLedgEntry."Document No.":=Args."Check No.";
            CheckLedgEntry.Description:=GenJnlLine.Description;
            CheckLedgEntry."Bank Payment Type":=GenJnlLine."Bank Payment Type";
            CheckLedgEntry."Bal. Account Type":=Chck."Balancing Type";
            CheckLedgEntry."Bal. Account No.":=Chck."Balancing No.";
            if Chck.Amount > 0 then begin
                CheckLedgEntry."Entry Status":=CheckLedgEntry."entry status"::Printed;
                CheckLedgEntry.Amount:=Chck.Amount;
            end
            else
            begin
                CheckLedgEntry."Entry Status":=CheckLedgEntry."entry status"::Voided;
                CheckLedgEntry.Amount:=0;
            end;
            CheckLedgEntry."Check Date":=GenJnlLine."Posting Date";
            CheckLedgEntry."Check No.":=Args."Check No.";
            CheckManagement.InsertCheck(CheckLedgEntry, GenJnlLine.RecordId);
        end
        else
        begin
            CheckLedgEntry.Init;
            CheckLedgEntry."Bank Account No.":=Args."Bank Account No.";
            CheckLedgEntry."Posting Date":=GenJnlLine."Posting Date";
            CheckLedgEntry."Document No.":=Args."Check No.";
            CheckLedgEntry.Description:='XXXXXX';
            CheckLedgEntry."Bank Payment Type":=GenJnlLine."bank payment type"::"Computer Check";
            CheckLedgEntry."Entry Status":=CheckLedgEntry."entry status"::"Test Print";
            CheckLedgEntry."Check Date":=GenJnlLine."Posting Date";
            CheckLedgEntry."Check No.":=Args."Check No.";
            CheckManagement.InsertCheck(CheckLedgEntry, GenJnlLine.RecordId);
        end;
    end;
}
