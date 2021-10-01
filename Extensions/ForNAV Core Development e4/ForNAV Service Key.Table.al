table 6188485 "ForNAV Service Key"
{
    Access = Internal;
    DataPerCompany = false;
    DataClassification = SystemMetadata;

    fields
    {
        field(1;"Service Key";Text[50])
        {
            DataClassification = SystemMetadata;
        }
        field(2;Description;Text[150])
        {
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(PK;"Service Key")
        {
            Clustered = true;
        }
    }
}
