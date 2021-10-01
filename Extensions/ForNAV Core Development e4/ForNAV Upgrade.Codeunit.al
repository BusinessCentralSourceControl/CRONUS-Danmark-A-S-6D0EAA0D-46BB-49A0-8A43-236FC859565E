codeunit 6188496 "ForNAV Upgrade"
{
    Subtype = Upgrade;

    trigger OnCheckPreconditionsPerCompany()begin
    // Code to make sure company is OK to upgrade.
    end;
    trigger OnUpgradePerCompany()begin
        CreateDefaultPrinter;
    end;
    trigger OnValidateUpgradePerCompany()begin
    // Code to make sure that upgrade was successful for each company
    end;
    local procedure CreateDefaultPrinter()var Setup: Record "ForNAV Setup";
    begin
        if not Setup.Get then exit;
        Setup.CreateDefaultPrinter;
        if(Setup."Service Endpoint" <> '') or (Setup."Endpoint Settings" <> '')then begin
            Setup."Service Endpoint":='';
            Setup."Endpoint Settings":='';
            Setup.Modify();
        end;
    end;
}
