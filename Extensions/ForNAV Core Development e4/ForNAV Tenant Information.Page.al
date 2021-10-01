Page 6188495 "ForNAV Tenant Information"
{
    PageType = CardPart;
    SourceTable = "ForNAV Tenant Information";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            field(ID;Rec.ID)
            {
                ApplicationArea = All;
            }
            field(ActiveDirectoryID;Rec."Active Directory ID")
            {
                ApplicationArea = All;
            }
            field(Name;Rec.Name)
            {
                ApplicationArea = All;
            }
            field(IsSandbox;Rec."Is Sandbox")
            {
                ApplicationArea = All;
            }
            field(IsProduction;Rec."Is Production")
            {
                ApplicationArea = All;
            }
            // field(PlatformVersion; Rec."Platform Version")
            // {
            //     ApplicationArea = All;
            // }
            // field(ApplicationFamily; Rec."Application Family")
            // {
            //     ApplicationArea = All;
            // }
            // field(ApplicationVersion; Rec."Application Version")
            // {
            //     ApplicationArea = All;
            // }
            field(EnvironmentName;Rec."Environment Name")
            {
                ApplicationArea = All;
            }
            field(DomainName;Rec."Domain Name")
            {
                ApplicationArea = All;
            }
            field(ReportPackVersion;Rec."Report Pack Version")
            {
                ApplicationArea = All;
            }
            field(BusinessCentralVersion;Rec."Business Central Version")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
    }
    trigger OnOpenPage()begin
        Rec.GetInfo;
    end;
}
