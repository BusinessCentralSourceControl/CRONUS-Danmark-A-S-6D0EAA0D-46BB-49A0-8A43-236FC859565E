Codeunit 6188476 "ForNAV Is Sales Tax"
{
    trigger OnRun()begin
    end;
    procedure CheckIsSalesTax(): Boolean var AllObjWithCaption: Record AllObjWithCaption;
    begin
        AllObjWithCaption.SetRange(AllObjWithCaption."Object Type", AllObjWithCaption."object type"::Table);
        AllObjWithCaption.SetRange(AllObjWithCaption."Object ID", 10000);
        exit(not AllObjWithCaption.IsEmpty);
    end;
}
