Codeunit 6188484 "ForNAV Check Design Allowed"
{
    trigger OnRun()begin
    end;
    procedure DesignIsAllowed(): Boolean var CompanyInformation: Record "Company Information";
    begin
        exit(CompanyInformation.WritePermission);
    end;
}
