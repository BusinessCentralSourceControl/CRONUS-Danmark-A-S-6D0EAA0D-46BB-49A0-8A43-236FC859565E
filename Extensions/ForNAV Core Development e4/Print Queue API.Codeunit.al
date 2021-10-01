codeunit 6188511 "Print Queue API"
{
    procedure JobCount(): Integer var r: Record "ForNAV Local Print Queue";
    begin
        exit(r.Count);
    end;
    procedure GetJob(serviceName: Text): Text;
    var rec: Record "ForNAV Local Print Queue";
    j: JsonObject;
    retv: Text;
    Base64Convert: Codeunit "Base64 Convert";
    base64: Text;
    inStr: InStream;
    begin
        // Create a loop that sleeps and waits for a signal from print queue table. 
        // rec.SetFilter("Cloud Printer Name", cloudPrinterFilter);
        rec.SetRange(Status, rec.Status::Ready);
        rec.LockTable(true);
        if rec.FindFirst()then begin
            j.Add('ID', rec.ID);
            j.Add('CloudPrinterName', rec."Cloud Printer Name");
            j.Add('ReportID', rec.ReportID);
            j.Add('DocumentName', rec."Document Name");
            j.Add('Owner', rec.Owner);
            j.Add('LocalPrinterName', rec."Local Printer");
            j.Add('Company', rec.Company);
            // Set status to spooling
            rec.Status:=rec.Status::Printing;
            rec."Service":=serviceName;
            rec.Modify(true);
            Commit(); // Update the table with spooling status and unlock the table while returning the document.
            // Add the document to the result
            rec.CalcFields(Document);
            rec.Document.CreateInStream(instr);
            base64:=Base64Convert.ToBase64(InStr);
            j.Add('Document', base64);
        end;
        j.WriteTo(retv);
        exit(retv);
    end;
    procedure SetStatus(id: Integer;
    status: Text;
    serviceName: Text)var rec: Record "ForNAV Local Print Queue";
    begin
        if rec.Get(id)then begin
            rec.Status:=Enum::"ForNAV Local Print Status".FromInteger("ForNAV Local Print Status".Ordinals.Get("ForNAV Local Print Status".Names.IndexOf(status)));
            rec.Service:=serviceName;
            rec.Modify(true);
        end;
    end;
    procedure DeleteJob(id: Integer)var rec: Record "ForNAV Local Print Queue";
    begin
        if rec.Get(id)then rec.Delete(true);
    end;
    procedure UpdatePrinters(serviceName: Text;
    json: Text)var ServicePrinter: Record "ForNAV Service Printer";
    jObj: JsonObject;
    t: JsonToken;
    a: JsonArray;
    k: Text;
    begin
        // Remove old entries for this service
        ServicePrinter.SetRange(Service, serviceName);
        ServicePrinter.DeleteAll(true);
        a.ReadFrom(json);
        foreach t in a do begin
            // jObj.SelectToken(k, t);
            ServicePrinter.Init();
            ServicePrinter.Service:=serviceName;
            ServicePrinter.LocalPrinter:=t.AsValue().AsText();
            ServicePrinter.Insert(true);
        end;
    end;
}
