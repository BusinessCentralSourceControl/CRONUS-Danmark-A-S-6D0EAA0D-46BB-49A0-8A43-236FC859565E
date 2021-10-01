interface "ForNAV Layout"
{
    procedure OnDrillDown(Report: Record "ForNAV Reports"): Boolean;
    procedure GetStyle(): Text;
}
