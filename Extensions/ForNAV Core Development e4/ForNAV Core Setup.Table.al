table 6189101 "ForNAV Core Setup"
{
    fields
    {
        field(1;"Primary Key";Code[1])
        {
            DataClassification = SystemMetadata;
        }
        field(2;"Service Endpoint ID";Text[250])
        {
            DataClassification = SystemMetadata;
        }
        field(3;"Endpoint Settings";Text[250])
        {
            DataClassification = SystemMetadata;
        }
        field(99;Blob;Blob)
        {
            DataClassification = SystemMetadata;
            Caption = 'Blob';
        }
    }
    keys
    {
        key(PK;"Primary Key")
        {
            Clustered = true;
        }
    }
    procedure ToBase64String(): Text var base64convert: Codeunit "Base64 Convert";
    is: InStream;
    //        TempBlob: Record TempBlob;
    begin
        Blob.CreateInStream(is);
        exit(base64convert.ToBase64(is));
    //     TempBlob.Blob := Blob;
    //     exit(TempBlob.ToBase64String);
    end;
    procedure FromBase64String(Base64String: Text)var base64convert: Codeunit "Base64 Convert";
    os: OutStream;
    //       TempBlob: Record TempBlob;
    begin
        Blob.CreateOutStream(os);
        base64convert.FromBase64(Base64String, os);
    // TempBlob.FromBase64String(Base64String);
    // Blob := TempBlob.Blob;
    end;
    procedure GetZipContents(Value: Text;
    var InStr: InStream): Boolean var OutStr: OutStream;
    DataCompression: Codeunit "Data Compression";
    ZipEntryList: List of[Text];
    ZipEntryLength: Integer;
    begin
        DataCompression.OpenZipArchive(InStr, false);
        Rec.Blob.CreateOutStream(OutStr);
        DataCompression.GetEntryList(ZipEntryList);
        if not ZipEntryList.Contains(Value)then exit(false);
        DataCompression.ExtractEntry(Value, OutStr, ZipEntryLength);
        exit(true);
    end;
}
