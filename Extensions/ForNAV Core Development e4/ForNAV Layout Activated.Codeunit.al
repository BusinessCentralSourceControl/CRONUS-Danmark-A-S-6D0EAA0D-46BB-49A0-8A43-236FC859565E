codeunit 6188702 "ForNAV Layout Activated" implements "ForNAV Layout"
{
    procedure OnDrillDown(Report: Record "ForNAV Reports"): Boolean begin
        Report.DesignReport;
    end;
    procedure GetStyle(): Text begin
        exit('strongaccent');
    end;
}
