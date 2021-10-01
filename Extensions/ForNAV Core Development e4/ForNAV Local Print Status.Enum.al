enum 6189102 "ForNAV Local Print Status"
{
    Access = Internal;
    Extensible = false;

    value(0;"Ready")
    {
    Caption = 'Ready';
    }
    value(1;"Printing")
    {
    Caption = 'Printing';
    }
    value(2;"Spooling")
    {
    Caption = 'Spooling';
    }
    value(3;"Error")
    {
    Caption = 'Error';
    }
    value(4;"Paused")
    {
    Caption = 'Paused';
    }
}
