Codeunit 6188498 "ForNAV Order License"
{
    trigger OnRun()begin
    end;
    procedure SendEmail()var EmailItem: Record "Email Item" temporary;
    TenantInformation: Record "ForNAV Tenant Information" temporary;
    LicenseSku: Record "ForNAV License SKU" temporary;
    BodyText: Text;
    begin
        BodyText+='Tenant Information : ' + CRLF;
        TenantInformation.GetInfo;
        BodyText+=TenantInformation.FieldCaption(ID) + ' - ' + TenantInformation.ID + CRLF;
        BodyText+=TenantInformation.FieldCaption("Active Directory ID") + ' - ' + TenantInformation."Active Directory ID" + CRLF;
        BodyText+=TenantInformation.FieldCaption(Name) + ' - ' + TenantInformation.Name + CRLF;
        BodyText+=TenantInformation.FieldCaption("Is Sandbox") + ' - ' + Format(TenantInformation."Is Sandbox") + CRLF;
        BodyText+=TenantInformation.FieldCaption("Is Production") + ' - ' + Format(TenantInformation."Is Production") + CRLF;
        BodyText+=TenantInformation.FieldCaption("Platform Version") + ' - ' + TenantInformation."Platform Version" + CRLF;
        BodyText+=TenantInformation.FieldCaption("Application Family") + ' - ' + TenantInformation."Application Family" + CRLF;
        BodyText+=TenantInformation.FieldCaption("Application Version") + ' - ' + TenantInformation."Application Version" + CRLF;
        BodyText+=TenantInformation.FieldCaption("Environment Name") + ' - ' + TenantInformation."Environment Name" + CRLF;
        BodyText+=TenantInformation.FieldCaption("Domain Name") + ' - ' + TenantInformation."Domain Name" + CRLF;
        BodyText+='SKU Information : ' + CRLF;
        InitLicenseData(LicenseSku);
        if LicenseSku.FindSet then repeat BodyText+=LicenseSku.SKU + ' : ' + Format(LicenseSku.Units);
            until LicenseSku.Next = 0;
        EmailItem."Send to":='license@fornav.com';
        EmailItem.Subject:='License Order ' + COMPANYNAME;
        EmailItem."Plaintext Formatted":=true;
        EmailItem.SetBodyText(BodyText);
        EmailItem.Send(false, "Email Scenario"::Default);
    end;
    local procedure InitLicenseData(var LicenseSku: Record "ForNAV License SKU")begin
        LicenseSku.AddDataFromQuery();
    end;
    local procedure CRLF()ReturnValue: Text begin
        ReturnValue[1]:=10;
        ReturnValue[2]:=13;
    //ReturnValue += '<br>'
    end;
}
