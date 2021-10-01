table 6188477 "ForNAV Service Printer"
{
    Access = Internal;
    DataPerCompany = false;
    DataClassification = SystemMetadata;

    fields
    {
        field(1;Service;Text[50])
        {
            DataClassification = SystemMetadata;
            Caption = 'Service';
        }
        field(2;LocalPrinter;Text[50])
        {
            DataClassification = SystemMetadata;
            Caption = 'Local Printer';
        }
    }
    keys
    {
        key(PK;Service, LocalPrinter)
        {
            Clustered = true;
        }
    }
}
