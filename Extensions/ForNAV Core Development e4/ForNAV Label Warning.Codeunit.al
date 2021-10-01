Codeunit 6188497 "ForNAV Label Warning"
{
    trigger OnRun()begin
    end;
    procedure ShowLabelWarning(Cnt: Integer)var LabelSetup: Record "ForNAV Label Setup";
    begin
        if LabelSetup.Get then if LabelSetup."Disable Warnings" then exit;
        LabelSetup.ShowOrDisableWarning(Cnt);
    end;
}
