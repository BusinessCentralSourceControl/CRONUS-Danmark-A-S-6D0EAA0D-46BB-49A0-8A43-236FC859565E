Codeunit 6189400 "ForNAV - Test Library"
{
    procedure RestoreToCRONUS()var ReportSelections: Record "Report Selections";
    CompanyInitialize: Codeunit "Company-Initialize";
    begin
        ReportSelections.SetRange(ReportSelections.Usage, ReportSelections.Usage::"S.Invoice");
        ReportSelections.SetRange(ReportSelections."Report ID", 6188471, 6189470);
        if ReportSelections.IsEmpty then exit;
        ReportSelections.DeleteAll;
        CompanyInitialize.Run;
    end;
    procedure GetJournalTemplate(): Code[20]var GenJnlTemplate: Record "Gen. Journal Template";
    begin
        GenJnlTemplate.SetRange(Type, GenJnlTemplate.Type::Payments);
        GenJnlTemplate.FindFirst;
        exit(GenJnlTemplate.Name);
    end;
    procedure GetJournalBatch(): Code[10]var GenJnlBatch: Record "Gen. Journal Batch";
    begin
        GenJnlBatch.SetRange("Journal Template Name", GetJournalTemplate);
        GenJnlBatch.FindFirst;
        exit(GenJnlBatch.Name);
    end;
    procedure FindValidBank(): Code[20]var BankAccount: Record "Bank Account";
    begin
        BankAccount.FindFirst();
        exit(BankAccount."No.");
    end;
    procedure SetAppSettings()var NAVAppSetting: Record "NAV App Setting";
    Info: ModuleInfo;
    begin
        NavApp.GetCurrentModuleInfo(Info);
        if not NAVAppSetting.Get(Info.Id)then begin
            NAVAppSetting."App ID":=Info.Id;
            NAVAppSetting.Insert;
        end;
        if NAVAppSetting."Allow HttpClient Requests" then exit;
        NAVAppSetting."Allow HttpClient Requests":=true;
        NAVAppSetting.Modify;
    end;
}
