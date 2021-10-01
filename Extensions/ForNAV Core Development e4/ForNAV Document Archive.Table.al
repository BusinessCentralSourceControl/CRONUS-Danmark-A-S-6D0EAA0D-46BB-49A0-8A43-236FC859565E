table 6189103 "ForNAV Document Archive"
{
    DataClassification = SystemMetadata;
    Caption = 'ForNAV Document Archive';

    fields
    {
        field(1;"Archive ID";Integer)
        {
            DataClassification = SystemMetadata;
            AutoIncrement = true;
        }
        field(2;"Report ID";Integer)
        {
            DataClassification = SystemMetadata;
            Caption = 'Report ID';
        }
        field(3;Created;DateTime)
        {
            DataClassification = EndUserIdentifiableInformation;
            Caption = 'Created';
        }
        field(4;"User ID";Code[50])
        {
            DataClassification = EndUserIdentifiableInformation;
            Caption = 'User ID';
        }
        field(5;"Document Type";Option)
        {
            DataClassification = SystemMetadata;
            OptionMembers = , pdf, docx, html, xlsx, print, preview;
            Caption = 'Document Type';
        }
        field(6;Document;Blob)
        {
            DataClassification = CustomerContent;
            Compressed = true;
            Caption = 'Document';
        }
        field(7;Downloaded;Boolean)
        {
            DataClassification = EndUserIdentifiableInformation;
            Caption = 'Downloaded';
        }
        field(8;Purged;Boolean)
        {
            DataClassification = EndUserIdentifiableInformation;
            Caption = 'Purged';
        }
        field(9;Keywords;Text[2000])
        {
            DataClassification = CustomerContent;
            Caption = 'Keywords';
        }
        field(10;"Report Name";Code[30])
        {
            DataClassification = SystemMetadata;
            Caption = 'Report Name';
        }
        field(11;Indent;Integer)
        {
            DataClassification = SystemMetadata;
            Caption = 'Document';
        }
        field(12;Month;Integer)
        {
            DataClassification = CustomerContent;
        }
        field(13;Year;Integer)
        {
            DataClassification = CustomerContent;
        }
        field(14;Copies;Integer)
        {
            DataClassification = CustomerContent;
            BlankZero = true;
        }
    }
    keys
    {
        key(PK;"Archive ID")
        {
            Clustered = true;
        }
        key(SK;"Report Name", Created, Year, Month, "User ID")
        {
        }
    }
}
