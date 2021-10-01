table 6189181 "ForNAV File Storage"
{
    DataClassification = SystemMetadata;
    Caption = 'ForNAV File Storage';

    fields
    {
        field(1;"Code";Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Code';
        }
        field(2;"Type";Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Type';
        }
        field(3;"Data";Blob)
        {
            Compressed = true;
            DataClassification = SystemMetadata;
        }
        field(4;"Filename";Text[250])
        {
            InitValue = 'Click to import...';
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'File Name';
        }
        field(5;Description;Text[250])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Description';
        }
    }
    keys
    {
        key(Key1;Code, Type)
        {
        }
    }
    procedure ImportFromFile()var TempBlob: Record "ForNAV Core Setup" temporary;
    UploadFilename: Text;
    InStream: InStream;
    OutStream: OutStream;
    SelectFile: Label 'Select a file';
    //        AzureStorageMgt: Codeunit "ForNAV Azure Storage Mgt.";
    begin
        UploadIntoStream(SelectFile, '', 'All files (*.*)|*.*', UploadFilename, InStream);
        if UploadFilename <> '' then begin
            Data.CreateOutstream(OutStream);
            //            if not AzureStorageMgt.PutBlob(Database::"ForNAV File Storage", 3, Code + '$' + Type, UploadFilename, inStream) then
            CopyStream(OutStream, InStream);
            Filename:=UploadFilename;
        end;
    end;
}
