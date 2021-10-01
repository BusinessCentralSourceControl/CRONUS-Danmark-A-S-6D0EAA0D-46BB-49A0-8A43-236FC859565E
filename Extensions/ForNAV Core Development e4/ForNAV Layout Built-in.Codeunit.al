codeunit 6188700 "ForNAV Layout Built-in" implements "ForNAV Layout"
{
    procedure OnDrillDown(Report: Record "ForNAV Reports"): Boolean begin
        Report.DesignReport;
    end;
    procedure GetStyle(): Text begin
        exit('');
    end;
}
