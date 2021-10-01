table 6189105 "ForNAV Document History"
{
    DataClassification = SystemMetadata;
    Caption = 'ForNAV Document Archive History';

    fields
    {
        field(1;"Entry ID";Integer)
        {
            DataClassification = SystemMetadata;
            AutoIncrement = true;
        }
        field(2;"Archive ID";Integer)
        {
            DataClassification = SystemMetadata;
            Caption = 'Archive ID';
        }
        field(3;"Archive Timestamp";DateTime)
        {
            DataClassification = EndUserIdentifiableInformation;
            Caption = 'Timestamp';
        }
        field(4;"User ID";Code[50])
        {
            DataClassification = EndUserIdentifiableInformation;
            Caption = 'User ID';
        }
        field(5;"Archive Action";enum "ForNAV Document History Type")
        {
            DataClassification = EndUserIdentifiableInformation;
            Caption = 'Archive Action';
        // OptionMembers = Created,Viewed,Downloaded,Purged;
        // OptionCaption = 'Created,Viewed,Downloaded,Purged';
        }
    }
    keys
    {
        key(PK;"Entry ID")
        {
            Clustered = true;
        }
        key(SK;"Archive ID", "Archive Timestamp", "User ID")
        {
        }
    }
    procedure Create(ArchiveId: Integer;
    What: enum "ForNAV Document History Type")begin
        Rec."Entry ID":=0;
        Rec."Archive ID":=ArchiveId;
        Rec."Archive Action":=What;
        Rec."Archive Timestamp":=CurrentDateTime;
        Rec."User ID":=Database.UserId;
        Rec.Insert();
    end;
    procedure StatusValue(action: Option Created, Viewed, Downloaded, Purged;
    var userId: Text;
    var dateTime: DateTime): Boolean begin
        Rec.SetRange(Rec."Archive Action", action);
        if Rec.FindLast()then begin
            dateTime:=Rec."Archive Timestamp";
            userId:=Rec."User ID";
            exit(true)end
        else
        begin
            Clear(dateTime);
            userId:='';
            exit(false);
        end;
    end;
}
