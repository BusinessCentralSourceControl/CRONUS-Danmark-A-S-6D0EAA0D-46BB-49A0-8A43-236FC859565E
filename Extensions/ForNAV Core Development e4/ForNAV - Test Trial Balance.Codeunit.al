Codeunit 6189431 "ForNAV - Test Trial Balance"
{
    Subtype = Test;

    [Test]
    //    [HandlerFunctions('StrMenuHandler')]
    procedure TestTrialBalance()var GLAccount: Record "G/L Account";
    SendResultToAzure: Codeunit "ForNAV - Test Azure Interface";
    RecRef: RecordRef;
    begin
        // [Given]
        Initialize;
        // [When]
        GLAccount.SetRange("Date Filter", Dmy2date(1, 1, 2020), Dmy2date(31, 12, 2020));
        RecRef.Open(Database::"G/L Account");
        RecRef.SetView(GLAccount.GetView);
        SendResultToAzure.SimpleSaveReport(Report::"ForNAV Trial Balance", 'Financial/TrialBalance', RecRef);
    // [Then]
    end;
    [Test]
    procedure TestTrialBalanceFCY()var Args: Record "ForNAV Trial Balance Args.";
    GLAccount: Record "G/L Account";
    TempBlob: Record "ForNAV Core Setup";
    TrialBalance: Report "ForNAV Trial Balance";
    SendResultToAzure: Codeunit "ForNAV - Test Azure Interface";
    RecRef: RecordRef;
    OutStr: OutStream;
    InStr: InStream;
    begin
        // [Given]
        Initialize;
        // [When]
        GLAccount.SetRange("Date Filter", Dmy2date(1, 1, 2020), Dmy2date(31, 12, 2020));
        RecRef.Open(Database::"G/L Account");
        RecRef.SetView(GLAccount.GetView);
        Args."Net Change Actual":=true;
        Args."Net Change Actual Last Year":=true;
        Args."Variance in Changes":=true;
        Args."% Variance in Changes":=true;
        Args."All Amounts in LCY":=true;
        TrialBalance.SetArgs(Args);
        TempBlob.Blob.CreateOutstream(OutStr);
        TempBlob.Blob.CreateInStream(InStr);
        TrialBalance.SaveAs('', Reportformat::Pdf, OutStr, RecRef);
        SendResultToAzure.SendFileToAzureBlobContainer(InStr, 'Financial/TrialBalanceFCY.pdf');
        Clear(TrialBalance);
        TrialBalance.SaveAs('', Reportformat::Html, OutStr, RecRef);
        SendResultToAzure.SendFileToAzureBlobContainer(InStr, 'Financial/TrialBalanceFCY.html');
        Clear(TrialBalance);
        TrialBalance.SaveAs('', Reportformat::Word, OutStr, RecRef);
        SendResultToAzure.SendFileToAzureBlobContainer(InStr, 'Financial/TrialBalanceFCY.docx');
        Clear(TrialBalance);
        TrialBalance.SaveAs('', Reportformat::Xml, OutStr, RecRef);
        SendResultToAzure.SendFileToAzureBlobContainer(InStr, 'Financial/TrialBalanceFCY.xml');
    // [Then]
    end;
    [Test]
    procedure TestTrialBalanceBudget()var Args: Record "ForNAV Trial Balance Args.";
    GLAccount: Record "G/L Account";
    TempBlob: Record "ForNAV Core Setup";
    TrialBalance: Report "ForNAV Trial Balance";
    SendResultToAzure: Codeunit "ForNAV - Test Azure Interface";
    RecRef: RecordRef;
    OutStr: OutStream;
    InStr: InStream;
    begin
        // [Given]
        Initialize;
        // [When]
        GLAccount.SetRange("Date Filter", Dmy2date(1, 1, 2020), Dmy2date(31, 12, 2020));
        RecRef.Open(Database::"G/L Account");
        RecRef.SetView(GLAccount.GetView);
        Args."Net Change Actual":=true;
        Args."Net Change Actual Last Year":=true;
        Args."Variance in Changes":=true;
        Args."% Variance in Changes":=true;
        Args."All Amounts in LCY":=true;
        Args."Balance at Date Actual":=true;
        Args."Balance at Date Act. Last Year":=true;
        Args."Variance in Balances":=true;
        Args."% Variance in Balances":=true;
        TrialBalance.SetArgs(Args);
        TempBlob.Blob.CreateOutstream(OutStr);
        TempBlob.Blob.CreateInStream(InStr);
        TrialBalance.SaveAs('', Reportformat::Pdf, OutStr, RecRef);
        SendResultToAzure.SendFileToAzureBlobContainer(InStr, 'Financial/TrialBalanceBudget.pdf');
        Clear(TrialBalance);
        TrialBalance.SaveAs('', Reportformat::Html, OutStr, RecRef);
        SendResultToAzure.SendFileToAzureBlobContainer(InStr, 'Financial/TrialBalanceBudget.html');
        Clear(TrialBalance);
        TrialBalance.SaveAs('', Reportformat::Word, OutStr, RecRef);
        SendResultToAzure.SendFileToAzureBlobContainer(InStr, 'Financial/TrialBalanceBudget.docx');
        Clear(TrialBalance);
        TrialBalance.SaveAs('', Reportformat::Xml, OutStr, RecRef);
        SendResultToAzure.SendFileToAzureBlobContainer(InStr, 'Financial/TrialBalanceBudget.xml');
    // [Then]
    end;
    local procedure Initialize()var InitializeTest: Codeunit "ForNAV - Test Initialize Test";
    begin
        if IsInitialized then exit;
        InitializeTest.BaseSetup;
        IsInitialized:=true;
    end;
    var IsInitialized: Boolean;
// [StrMenuHandler]
// procedure StrMenuHandler(Options: Text[1024]; var Choice: Integer; Instruction: Text[1024])
// begin
//     Choice := 1;
// end;
}
