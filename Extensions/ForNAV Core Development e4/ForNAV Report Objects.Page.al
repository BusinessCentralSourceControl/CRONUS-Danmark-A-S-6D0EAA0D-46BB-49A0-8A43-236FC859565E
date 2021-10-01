page 6189183 "ForNAV Report Objects"
{
    PageType = List;
    SourceTable = "ForNAV Report Object";
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(ID;Rec.ID)
                {
                    ApplicationArea = All;
                }
                field(Name;Rec.Name)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    trigger OnOpenPage()var ReportMgt: Codeunit "ForNAV Check Is ForNAV Report";
    begin
        if Rec.IsEmpty then ReportMgt.GetAllForNAVReports(Rec);
        if not Rec.FindFirst then Error('No ForNAV Reports Found');
    end;
    procedure SetData(var Value: Record "ForNAV Report Object")begin
        Rec.Copy(Value, true);
    end;
}
