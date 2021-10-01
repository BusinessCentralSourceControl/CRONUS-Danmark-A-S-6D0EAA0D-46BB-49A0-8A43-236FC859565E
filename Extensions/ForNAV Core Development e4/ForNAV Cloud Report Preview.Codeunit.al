codeunit 6189103 "ForNAV Cloud Report Preview"
{
    TableNo = "ForNAV Cloud Report Sessions";

    trigger OnRun()begin
        REPORT.RunModal(Rec."Report ID");
    end;
}
