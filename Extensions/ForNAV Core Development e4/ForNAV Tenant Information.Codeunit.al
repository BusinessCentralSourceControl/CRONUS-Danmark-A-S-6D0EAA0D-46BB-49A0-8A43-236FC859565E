Codeunit 6188495 "ForNAV Tenant Information"
{
    TableNo = "ForNAV Tenant Information";

    trigger OnRun()var EnvInfo: Codeunit "Environment Information";
    TenantInfo: Codeunit "Tenant Information";
    AzureADTenant: Codeunit "Azure AD Tenant";
    AppModuleInfo: ModuleInfo;
    begin
        case Rec.TryGetFieldID of Rec.FieldNo(ID): Rec.ID:=TenantInfo.GetTenantId();
        Rec.FieldNo("Active Directory ID"): Rec."Active Directory ID":=AzureADTenant.GetAadTenantId;
        Rec.FieldNo(Name): Rec.Name:=TenantInfo.GetTenantDisplayName();
        Rec.FieldNo("Is Sandbox"): Rec."Is Sandbox":=EnvInfo.IsSandbox;
        Rec.FieldNo("Is Production"): Rec."Is Production":=EnvInfo.IsProduction;
        //     FieldNo("Platform Version"):
        //       "Platform Version" := GetPlatformVersion;
        Rec.FieldNo("Application Family"): Rec."Application Family":=EnvInfo.GetApplicationFamily();
        //     FieldNo("Application Version"):
        //       "Application Version" := GetApplicationVersion;
        Rec.FieldNo("Environment Name"): Rec."Environment Name":=EnvInfo.GetEnvironmentName();
        Rec.FieldNo("Domain Name"): Rec."Domain Name":=AzureADTenant.GetAadTenantDomainName;
        Rec.FieldNo("Report Pack Version"): if NavApp.GetCurrentModuleInfo(AppModuleInfo)then Rec."Report Pack Version":=Format(AppModuleInfo.AppVersion, 50);
        Rec.FieldNo("Business Central Version"): if NavApp.GetModuleInfo('63ca2fa4-4f03-4f2b-a480-172fef340d3f', AppModuleInfo)then Rec."Business Central Version":=Format(AppModuleInfo.AppVersion, 50);
        end;
    end;
}
