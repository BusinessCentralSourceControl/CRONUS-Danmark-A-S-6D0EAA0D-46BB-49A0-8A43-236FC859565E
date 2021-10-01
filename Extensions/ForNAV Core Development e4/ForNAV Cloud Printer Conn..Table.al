table 6188486 "ForNAV Cloud Printer Conn."
{
    Access = Internal;
    DataPerCompany = false;
    DataClassification = SystemMetadata;

    fields
    {
        field(1;"Cloud Printer";Text[50])
        {
            DataClassification = SystemMetadata;
        }
        field(2;Service;Text[50])
        {
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(PK;"Cloud Printer", Service)
        {
            Clustered = true;
        }
    }
}
