codeunit 6189001 "ForNAV Install App"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()begin
    end;
    procedure UpdateUserAccess()begin
    end;
    trigger OnInstallAppPerDatabase()begin
    end;
    local procedure AddUserAccess(AssignToUser: Guid;
    PermissionSet: Code[20]);
    var begin
    end;
}
