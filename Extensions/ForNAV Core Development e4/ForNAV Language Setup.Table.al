table 6189180 "ForNAV Language Setup"
{
    DataClassification = SystemMetadata;
    Caption = 'ForNAV Language';

    fields
    {
        field(1;"Language Code";Code[10])
        {
            DataClassification = SystemMetadata;
            NotBlank = true;
            TableRelation = Language;
            ValidateTableRelation = false;

            trigger OnValidate()var Lang: Record Language;
            begin
                Lang.Get("Language Code");
                "Windows Language ID":=Lang."Windows Language ID";
            end;
        }
        field(2;"Report ID";Integer)
        {
            DataClassification = SystemMetadata;
            TableRelation = "ForNAV Report Object";
            ValidateTableRelation = false;

            trigger OnValidate()var AllObj: Record AllObj;
            begin
                if "Translate From" <> '' then exit;
                AllObj.Get(AllObj."Object Type"::Report, "Report ID");
                "Translate From":=AllObj."Object Name";
                CalcFields("Report Name");
                SetIsObjectTranslation;
            end;
        }
        field(3;"Report Name";Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(AllObj."Object Name" where("Object Type"=const(Report), "Object ID"=field("Report ID")));
            Editable = false;
        }
        field(5;"Table No.";Integer)
        {
            DataClassification = SystemMetadata;
            TableRelation = AllObjWithCaption."Object ID" where("Object Type"=const(Table));

            trigger OnValidate()begin
                CalcFields("Table Name");
                "Translate From":="Table Name";
                "Field No.":=0;
                "Field Name":='';
                SetIsObjectTranslation;
            end;
        }
        field(6;"Table Name";Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(AllObj."Object Name" where("Object Type"=const(Table), "Object ID"=field("Table No.")));
            Editable = false;
        }
        field(8;"Field No.";Integer)
        {
            DataClassification = SystemMetadata;
            TableRelation = "ForNAV Field"."No." where("Table No."=field("Table No."));
            ValidateTableRelation = false;

            trigger OnValidate()var Fld: Record Field;
            begin
                Fld.Get("Table No.", "Field No.");
                "Translate From":=Fld.FieldName;
                CalcFields("Field Name");
                SetIsObjectTranslation;
            end;
        }
        field(9;"Field Name";Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Field.FieldName where(TableNo=field("Table No."), "No."=field("Field No.")));
            Editable = false;
        }
        field(12;"Translate From";Text[100])
        {
            Caption = 'Translate From';
            DataClassification = SystemMetadata;
            NotBlank = true;
        }
        field(15;"Translate To";Text[250])
        {
            Caption = 'Translate To';
            DataClassification = SystemMetadata;
        }
        field(18;"Windows Language ID";Integer)
        {
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(20;"Is Object Translation";Boolean)
        {
            Caption = 'Is Object Translation', Comment='DO NOT TRANSLATE';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(99;Blob;Blob)
        {
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(PK;"Language Code", "Report ID", "Table No.", "Field No.", "Translate From")
        {
            Clustered = true;
        }
    }
    procedure ExportToCSV()var Translation: Record "ForNAV Language Setup";
    CSVBuffer: Record "CSV Buffer" temporary;
    TempBlob: Codeunit "Temp Blob";
    InStr: InStream;
    TranslationFileName: Text;
    begin
        if Translation.IsEmpty then exit;
        CSVBuffer."Line No."+=1;
        CSVBuffer.InsertEntry(CSVBuffer."Line No.", 1, Translation.FieldCaption("Language Code"));
        CSVBuffer.InsertEntry(CSVBuffer."Line No.", 2, Translation.FieldCaption("Report ID"));
        CSVBuffer.InsertEntry(CSVBuffer."Line No.", 3, Translation.FieldCaption("Table No."));
        CSVBuffer.InsertEntry(CSVBuffer."Line No.", 4, Translation.FieldCaption("Field No."));
        CSVBuffer.InsertEntry(CSVBuffer."Line No.", 5, Translation.FieldCaption("Translate From"));
        CSVBuffer.InsertEntry(CSVBuffer."Line No.", 6, Translation.FieldCaption("Translate To"));
        Translation.FindSet;
        repeat CSVBuffer."Line No."+=1;
            CSVBuffer.InsertEntry(CSVBuffer."Line No.", 1, Translation."Language Code");
            CSVBuffer.InsertEntry(CSVBuffer."Line No.", 2, Format(Translation."Report ID"));
            CSVBuffer.InsertEntry(CSVBuffer."Line No.", 3, Format(Translation."Table No."));
            CSVBuffer.InsertEntry(CSVBuffer."Line No.", 4, Format(Translation."Field No."));
            CSVBuffer.InsertEntry(CSVBuffer."Line No.", 5, Translation."Translate From");
            CSVBuffer.InsertEntry(CSVBuffer."Line No.", 6, Translation."Translate To");
        until Translation.Next = 0;
        CSVBuffer.SaveDataToBlob(TempBlob, ';');
        TempBlob.CreateInStream(InStr);
        TranslationFileName:='ForNAVTranslations.csv';
        DownloadFromStream(InStr, '', '', '', TranslationFileName);
    end;
    procedure ImportFromCSV()var InStr: InStream;
    TranslationFileName: Text;
    begin
        UploadIntoStream('', '', '', TranslationFileName, InStr);
        ImportFromCSV(InStr);
    end;
    procedure ImportFromCSV(InStr: InStream)var CSVBuffer: Record "CSV Buffer" temporary;
    RecRef: RecordRef;
    FldRef: array[6]of FieldRef;
    Variant: Variant;
    NoOfLines: Integer;
    i: Integer;
    no: Integer;
    TranslationExist: Label 'The translation %1 already exist. Overwrite?';
    begin
        RecRef.Open(Database::"ForNAV Language Setup");
        FldRef[1]:=RecRef.Field(FieldNo("Language Code"));
        FldRef[2]:=RecRef.Field(FieldNo("Report ID"));
        FldRef[3]:=RecRef.Field(FieldNo("Table No."));
        FldRef[4]:=RecRef.Field(FieldNo("Field No."));
        FldRef[5]:=RecRef.Field(FieldNo("Translate From"));
        FldRef[6]:=RecRef.Field(FieldNo("Translate To"));
        CSVBuffer.LoadDataFromStream(InStr, ';');
        CSVBuffer.SetRange("Line No.", 2, 999999999);
        if CSVBuffer.GetNumberOfColumns <> 6 then Error('The CSV file should contain exactly 6 columns');
        NoOfLines:=CSVBuffer.GetNumberOfLines;
        CSVBuffer."Line No.":=1;
        repeat CSVBuffer."Line No."+=1;
            RecRef.Field(FieldNo("Is Object Translation")).Value:=false;
            for i:=1 to 6 do begin
                Variant:=CSVBuffer.GetValueOfLineAt(i);
                case FldRef[i].Number of FieldNo("Report ID"), FieldNo("Table No."), FieldNo("Field No."): begin
                    no:=Variant;
                    if no <> 0 then FldRef[i].Validate(Variant)
                    else
                        FldRef[i].Value:=0;
                end
                else
                    FldRef[i].Validate(Variant);
                end;
            end;
            if not RecRef.Insert then if not Confirm(TranslationExist, true, RecRef.CurrentKey)then Error('')
                else
                    RecRef.Modify;
        until CSVBuffer."Line No." = NoOfLines;
    end;
    procedure GetDefaultTranslations()var CSVBuffer: Record "CSV Buffer" temporary;
    Client: HttpClient;
    ResponseMessage: HttpResponseMessage;
    ResponseText: InStream;
    ErrorResponse: Text;
    NoOfColumns: Integer;
    Column: Integer;
    NoOfRows: Integer;
    Row: Integer;
    begin
        if not Client.Get(GetTranslationURL, ResponseMessage)then Error('The call to the web service failed.');
        ResponseMessage.Content.ReadAs(ResponseText);
        if not ResponseMessage.IsSuccessStatusCode then begin
            ResponseMessage.Content.ReadAs(ErrorResponse);
            error('The web service returned an error message:\' + 'Status code: %1' + 'Description: %2', ResponseMessage.HttpStatusCode, ErrorResponse);
        end;
        CSVBuffer.LoadDataFromStream(ResponseText, ';');
        "Report ID":=0;
        "Table No.":=0;
        "Field No.":=0;
        NoOfColumns:=CSVBuffer.GetNumberOfColumns;
        NoOfRows:=CSVBuffer.GetNumberOfLines;
        Column:=2;
        repeat validate("Language Code", CSVBuffer.GetValue(1, Column));
            for Row:=2 to NoOfRows do begin
                "Translate From":=CopyStr(CSVBuffer.GetValue(Row, 1), 1, MaxStrLen("Translate From"));
                "Translate To":=CopyStr(CSVBuffer.GetValue(Row, Column), 1, MaxStrLen("Translate To"));
                if Insert then;
            end;
            Column+=1;
        until Column = NoOfColumns;
    end;
    local procedure SetIsObjectTranslation()begin
        "Is Object Translation":="Report ID" + "Table No." + "Field No." <> 0;
    end;
    procedure GetTranslationURL()TranslationURL: Text var Handled: Boolean;
    begin
        OnBeforeGetTranslationURL(TranslationURL, Handled);
        if Handled and (TranslationURL <> '')then exit(TranslationURL);
        exit('https://vgblobstoragepublic.blob.core.windows.net/anveo/Translations 20190827.csv');
    end;
    procedure CheckForDuplicates()var l: Record "ForNAV Language Setup";
    c: Integer;
    lblDuplicateLcids: Label 'An entry with the Windows Language ID %1 already exists';
    begin
        l.SetRange(l."Windows Language ID", "Windows Language ID");
        l.SetRange(l."Report ID", "Report ID");
        l.SetRange(l."Table No.", "Table No.");
        l.SetRange(l."Field No.", "Field No.");
        if("Table No." = 0) and ("Field No." = 0) and ("Report ID" = 0)then l.SetRange(l."Translate From", "Translate From");
        c:=l.Count();
        if(c > 0)then Error(lblDuplicateLcids, "Windows Language ID")end;
    trigger OnInsert()begin
        CheckForDuplicates();
    end;
    trigger OnRename()begin
        CheckForDuplicates();
    end;
    [IntegrationEvent(false, false)]
    procedure OnBeforeGetTranslationURL(var TranslationURL: Text;
    var Handled: Boolean)begin
    end;
}
