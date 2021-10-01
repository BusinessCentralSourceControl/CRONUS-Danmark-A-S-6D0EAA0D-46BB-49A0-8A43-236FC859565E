table 6189100 "ForNAV Cloud Report Sessions"
{
    fields
    {
        field(1;"Session ID";Text[40])
        {
            DataClassification = SystemMetadata;
        }
        field(2;"Report ID";Integer)
        {
            DataClassification = SystemMetadata;
        }
        field(3;Created;DateTime)
        {
            DataClassification = SystemMetadata;
        }
        field(4;PreviewLayoutCode;Code[20])
        {
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(Key1;"Session ID")
        {
        }
    }
    fieldgroups
    {
    }
}
