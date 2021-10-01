Codeunit 6188771 "ForNAV Test Void Check"
{
    // Copyright (c) 2017-2021 ForNAV ApS - All Rights Reserved
    // The intellectual work and technical concepts contained in this file are proprietary to ForNAV.
    // Unauthorized reverse engineering, distribution or copying of this file, parts hereof, or derived work, via any medium is strictly prohibited without written permission from ForNAV ApS.
    // This source code is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    trigger OnRun()begin
    end;
    procedure TestVoidCheck(var GenJnlLn: Record "Gen. Journal Line";
    var Args: Record "ForNAV Check Arguments";
    Preview: Boolean): Boolean var Text000Err: label 'Preview is not allowed.', Comment='DO NOT TRANSLATE';
    Text001Err: label 'Last Check No. must be filled in.', Comment='DO NOT TRANSLATE';
    Text002Err: label 'Filters on %1 and %2 are not allowed.', Comment='DO NOT TRANSLATE';
    USText004Err: label 'Last Check No. must include at least one digit, so that it can be incremented.', Comment='DO NOT TRANSLATE';
    begin
        if Preview then exit(false);
        if Args."Check No." = '' then Error(Text001Err);
        if IncStr(Args."Check No.") = '' then Error(USText004Err);
        if Args."Test Print" then exit(false);
        if not Args."Reprint Checks" then exit(false);
        if(GenJnlLn.GetFilter(GenJnlLn."Line No.") <> '') or (GenJnlLn.GetFilter(GenJnlLn."Document No.") <> '')then Error(Text002Err, GenJnlLn.FieldCaption(GenJnlLn."Line No."), GenJnlLn.FieldCaption(GenJnlLn."Document No."));
        GenJnlLn.SetRange(GenJnlLn."Bank Payment Type", GenJnlLn."bank payment type"::"Computer Check");
        GenJnlLn.SetRange(GenJnlLn."Check Printed", true);
        exit(true);
    end;
}
