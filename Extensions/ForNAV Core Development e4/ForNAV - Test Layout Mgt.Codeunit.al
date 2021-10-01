codeunit 6189455 "ForNAV - Test Layout Mgt"
{
    Subtype = Test;

    [Test]
    procedure TestHasCustomReportLayout()begin
    end;
    [Test]
    procedure TestExportLayout()var ReportLayout: Record "ForNAV Report Layout" temporary;
    TestLib: Codeunit "ForNAV - Test Library";
    ReportLayoutMgt: Codeunit "ForNAV Report Layout Mgt.";
    TempBlob: Codeunit "Temp Blob";
    AzureInt: Codeunit "ForNAV - Test Azure Interface";
    begin
        // [Given]
        TestLib.SetAppSettings;
        ReportLayoutMgt.CloneDefaultLayout(6188471);
        ReportLayoutMgt.CloneDefaultLayout(6188472);
        // [When]
        ReportLayoutMgt.CreateBuffer(ReportLayout);
        ReportLayout.ExportLayout(TempBlob);
        // [Then]
        AzureInt.SendFileToAzureBlobContainer(TempBlob, 'Layout.7z');
    end;
    [Test]
    procedure TestImportLayout()begin
    end;
}
