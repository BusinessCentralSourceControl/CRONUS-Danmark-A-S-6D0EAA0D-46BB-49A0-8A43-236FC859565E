Codeunit 6189440 "ForNAV - Test Sales Reminders"
{
    Subtype = Test;

    [Test]
    // [HandlerFunctions('StrMenuHandler')]
    procedure TestStatement()var SendResultToAzure: Codeunit "ForNAV - Test Azure Interface";
    begin
        // [Given]
        Initialize;
        // [When]
        SendResultToAzure.SimpleSaveReport(Report::"ForNAV Statement", 'Reminders/Statement');
    // [Then]
    end;
    [Test]
    [HandlerFunctions('GenerateRemindersRequestPageHandler,IssueRemindersRequestPageHandler')]
    procedure TestReminders()var Cust: Record Customer;
    RemTerms: Record "Reminder Terms";
    SendResultToAzure: Codeunit "ForNAV - Test Azure Interface";
    CreateReminders: Report "Create Reminders";
    begin
        // [Given]
        Initialize;
        RemTerms.FindFirst;
        Cust.ModifyAll("Reminder Terms Code", RemTerms.Code, false);
        Commit;
        CreateReminders.Run;
        // [When]
        SendResultToAzure.SimpleSaveReport(Report::"ForNAV Reminder Test", 'Reminders/ReminderTest');
        Report.Run(Report::"Issue Reminders");
        SendResultToAzure.SimpleSaveReport(Report::"ForNAV Reminder", 'Reminders/Reminder');
    // [Then]
    end;
    [Test]
    [HandlerFunctions('GenerateFCMRequestPageHandler,IssueFCMRequestPageHandler')]
    procedure TestFinanceChargeMemo()var Cust: Record Customer;
    FinTerms: Record "Finance Charge Terms";
    SendResultToAzure: Codeunit "ForNAV - Test Azure Interface";
    CreateFinanceChargeMemos: Report "Create Finance Charge Memos";
    begin
        // [Given]
        Initialize;
        FinTerms.FindFirst;
        Cust.ModifyAll("Fin. Charge Terms Code", FinTerms.Code, false);
        Commit;
        CreateFinanceChargeMemos.Run;
        // [When]
        SendResultToAzure.SimpleSaveReport(Report::"ForNAV Finance Charge Memo T.", 'Reminders/FinanceChargeMemoTest');
        Report.Run(Report::"Issue Finance Charge Memos");
        SendResultToAzure.SimpleSaveReport(Report::"ForNAV Finance Charge Memo", 'Reminders/FinanceChargeMemo');
    // [Then]
    end;
    local procedure Initialize()var InitializeTest: Codeunit "ForNAV - Test Initialize Test";
    begin
        if IsInitialized then exit;
        InitializeTest.BaseSetup;
        Commit;
        IsInitialized:=true;
    end;
    [RequestPageHandler]
    procedure GenerateRemindersRequestPageHandler(var CreateReminders: TestRequestPage "Create Reminders")begin
        CreateReminders."ReminderHeaderReq.""Posting Date""".SETVALUE:=Today + 700; //* Against moving Cronus data
        CreateReminders.DocumentDate.SETVALUE:=Today + 700;
        CreateReminders.OK.INVOKE;
    end;
    [RequestPageHandler]
    procedure GenerateFCMRequestPageHandler(var CreateFinanceChargeMemos: TestRequestPage "Create Finance Charge Memos")begin
        CreateFinanceChargeMemos."FinChrgMemoHeaderReq.""Posting Date""".SETVALUE:=Today + 1000; //* Against moving Cronus data
        CreateFinanceChargeMemos.DocumentDate.SETVALUE:=Today + 1000;
        CreateFinanceChargeMemos.OK.INVOKE;
    end;
    [RequestPageHandler]
    procedure IssueRemindersRequestPageHandler(var IssueReminders: TestRequestPage "Issue Reminders")begin
        IssueReminders.OK.INVOKE;
    end;
    [RequestPageHandler]
    procedure IssueFCMRequestPageHandler(var IssueFinanceChargeMemos: TestRequestPage "Issue Finance Charge Memos")begin
        IssueFinanceChargeMemos.OK.INVOKE;
    end;
    [StrMenuHandler]
    procedure StrMenuHandler(Options: Text[1024];
    var Choice: Integer;
    Instruction: Text[1024])begin
        Choice:=1;
    end;
    var IsInitialized: Boolean;
}
