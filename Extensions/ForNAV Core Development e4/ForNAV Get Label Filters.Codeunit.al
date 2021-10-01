Codeunit 6188684 "ForNAV Get Label Filters"
{
    trigger OnRun()begin
    end;
    procedure GetFiltersForRecRef(var RecRef: RecordRef)var MyFilterPageBuilder: FilterPageBuilder;
    begin
        MyFilterPageBuilder.AddTable(RecRef.Caption, RecRef.Number);
        AddFirstThreeFields(MyFilterPageBuilder, RecRef);
        MyFilterPageBuilder.RunModal;
        RecRef.SetView(MyFilterPageBuilder.GetView(RecRef.Caption));
    end;
    local procedure AddFirstThreeFields(var MyFilterPageBuilder: FilterPageBuilder;
    var RecRef: RecordRef)var Fld: Record "Field";
    i: Integer;
    begin
        Fld.SetRange(TableNo, RecRef.Number);
        if Fld.FindSet then repeat i+=1;
                MyFilterPageBuilder.AddFieldNo(RecRef.Caption, Fld."No.");
            until(Fld.Next = 0) or (i = 3);
    end;
}
