codeunit 6188501 "ForNAV Direct Print"
{
    procedure DirectPrint(ReportId: Integer;
    Rec: Variant)var PrinterSelection: Record "Printer Selection";
    RecRefLib: Codeunit "ForNAV RecordRef Library";
    RecRef: RecordRef;
    begin
        RecRefLib.ConvertToRecRef(Rec, RecRef);
        Report.Print(ReportId, '', '', RecRef);
    end;
//     [EventSubscriber(ObjectType::Codeunit, Codeunit::"ReportManagement", 'OnAfterGetPrinterName', '', true, true)]
//     local procedure "ReportManagement_OnAfterGetPrinterName"
// (
//     ReportID: Integer;
//     var PrinterName: Text[250];
//     PrinterSelection: Record "Printer Selection"
// )
//     begin
//         //   Message('Ping?');
//     end;
}
