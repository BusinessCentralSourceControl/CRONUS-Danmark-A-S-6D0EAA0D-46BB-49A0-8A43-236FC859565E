page 6189184 "ForNAV File Storage"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "ForNAV File Storage";
    Caption = 'File Storage';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Code;Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Type;Rec.Type)
                {
                    ApplicationArea = All;
                }
                field(FileName;Rec.Filename)
                {
                    ApplicationArea = All;
                    Editable = false;

                    trigger OnDrillDown()var //                        TempBlob: Codeunit "Temp Blob";
                    //                        is: InStream;
                    //                        os: OutStream;
                    begin
                        //                        Rec.CalcFields(Watermark);
                        //                        if Rec."File Name" <> 'Click to import...' then begin
                        //                            TempBlob.FromRecord(Rec, Rec.FieldNo(Watermark));
                        //                            TempBlob.CreateOutStream(os);
                        //                            TempBlob.CreateInStream(is);
                        //                            DownloadFromStream(is, '', '', '', rec."File Name");
                        //                        end else
                        Rec.ImportFromFile;
                        Rec.Modify;
                    end;
                }
                field(Description;Rec.Description)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
