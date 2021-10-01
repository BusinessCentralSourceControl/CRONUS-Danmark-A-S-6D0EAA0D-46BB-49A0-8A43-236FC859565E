Codeunit 6188671 "ForNAV Label Mgt."
{
    SingleInstance = true;

    var Label: Record "ForNAV Label" temporary;
    Blob: Record "ForNAV Core Setup" temporary;
    procedure SetData(var Rec: Record "ForNAV Label")begin
        if not Rec.IsTemporary then Error('Wrong function call...');
        Label.Copy(Rec, true);
    end;
    procedure GetData(var Rec: Record "ForNAV Label")begin
        if not Rec.IsTemporary then Error('Wrong function call...');
        Rec.Copy(Label, true);
    end;
    procedure SetMergePDF(var Rec: Record "ForNAV Core Setup")begin
        if not Rec.IsTemporary then Error('Wrong function call...');
        Blob.Copy(Rec, true);
    end;
    procedure GetMergePDF(var Rec: Record "ForNAV Core Setup")begin
        if not Rec.IsTemporary then Error('Wrong function call...');
        Rec.Copy(Blob, true);
    end;
}
