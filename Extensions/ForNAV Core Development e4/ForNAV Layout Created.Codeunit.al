codeunit 6188701 "ForNAV Layout Created" implements "ForNAV Layout"
{
    procedure OnDrillDown(Report: Record "ForNAV Reports"): Boolean begin
        Report.ShowForNAVLayouts;
        exit(true);
    end;
    procedure GetStyle(): Text begin
        exit('ambiguous');
    end;
}
