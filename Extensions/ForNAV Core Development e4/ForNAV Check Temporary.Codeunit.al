Codeunit 6188479 "ForNAV Check Temporary"
{
    // We use this codeunit because ReportsForNAV is backwards compatible with NAV 2015. This version does not support ISTEMPORARY on record variables
    trigger OnRun()begin
    end;
    procedure IsTemporary(Rec: Variant;
    ThrowError: Boolean): Boolean var RecordRefLibrary: Codeunit "ForNAV RecordRef Library";
    RecRef: RecordRef;
    RecordShouldBeTempErr: label 'The Record Variable (%1) must be temporary when callng this API.', Comment='DO NOT TRANSLATE';
    begin
        RecordRefLibrary.ConvertToRecRef(Rec, RecRef);
        if RecRef.IsTemporary then exit(false);
        if ThrowError then Error(RecordShouldBeTempErr, RecRef.Name);
        exit(true);
    end;
}
