Page 6188781 "ForNAV Check Setup"
{
    // Copyright (c) 2017-2021 ForNAV ApS - All Rights Reserved
    // The intellectual work and technical concepts contained in this file are proprietary to ForNAV.
    // Unauthorized reverse engineering, distribution or copying of this file, parts hereof, or derived work, via any medium is strictly prohibited without written permission from ForNAV ApS.
    // This source code is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    ApplicationArea = All;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "ForNAV Check Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(MICREncoding;Rec."MICR Encoding")
                {
                    ApplicationArea = All;
                }
                field("Layout";Rec.Layout)
                {
                    ApplicationArea = All;
                }
                field(NoofLinesStub;Rec."No. of Lines (Stub)")
                {
                    ApplicationArea = All;
                }
            }
            group(Visuals)
            {
                field(WatermarkFileName;Rec."Watermark File Name")
                {
                    ApplicationArea = All;
                    Caption = 'Watermark';

                    trigger OnDrillDown()var TempBlob: Codeunit "Temp Blob";
                    //                        is: InStream;
                    //                        os: OutStream;
                    begin
                        //                        Rec.CalcFields(Watermark);
                        //                        if Rec."Watermark File Name" <> 'Click to import...' then begin
                        //                            TempBlob.FromRecord(Rec, Rec.FieldNo(Watermark));
                        //                            TempBlob.CreateOutStream(os);
                        //                            TempBlob.CreateInStream(is);
                        //                            DownloadFromStream(is, '', '', '', Rec."Watermark File Name");
                        //                        end else
                        Rec.ImportWatermarkFromClientFile(Rec.FieldNo(Watermark));
                        Rec.Modify;
                    end;
                }
                field(SignatureFileName;Rec."Signature File Name")
                {
                    ApplicationArea = All;

                    trigger OnDrillDown()var TempBlob: Codeunit "Temp Blob";
                    //                        ClientFileName: Text;
                    //                        is: InStream;
                    //                        os: OutStream;
                    begin
                        //                        Rec.CalcFields(Signature);
                        //                        if Rec."Signature File Name" <> 'Click to import...' then begin
                        //                            TempBlob.FromRecord(Rec, Rec.FieldNo(Signature));
                        //                            TempBlob.CreateOutStream(os);
                        //                            TempBlob.CreateInStream(is);
                        //                            ClientFileName := 'Signature.pdf';
                        //                            DownloadFromStream(is, '', '', '', ClientFileName);
                        //                        end else
                        Rec.ImportWatermarkFromClientFile(Rec.FieldNo(Signature));
                        Rec.Modify;
                    end;
                }
                field("2ndSignatureFileName";Rec."2nd Signature File Name")
                {
                    ApplicationArea = All;

                    trigger OnDrillDown()var TempBlob: Codeunit "Temp Blob";
                    //                        ClientFileName: Text;
                    //                        is: InStream;
                    //                        os: OutStream;
                    begin
                        //                        Rec.CalcFields(Signature);
                        //                        if Rec."2nd Signature File Name" <> 'Click to import...' then begin
                        //                            TempBlob.FromRecord(Rec, Rec.FieldNo("2nd Signature"));
                        //                            TempBlob.CreateOutStream(os);
                        //                            TempBlob.CreateInStream(is);
                        //                            ClientFileName := '2ndSignature.pdf';
                        //                            DownloadFromStream(is, '', '', '', ClientFileName);
                        //                        end else
                        Rec.ImportWatermarkFromClientFile(Rec.FieldNo("2nd Signature"));
                        Rec.Modify;
                    end;
                }
            }
        }
        area(factboxes)
        {
            systempart(MyNotes;MyNotes)
            {
                ApplicationArea = All;
            }
            systempart(RecordLinks;Links)
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        area(processing)
        {
            group(Watermark)
            {
                Caption = 'Watermark';

                action(DownloadWatermark)
                {
                    ApplicationArea = All;
                    Caption = 'Download Watermarks';
                    Image = Link;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()begin
                        Rec.DownloadWatermarks;
                    end;
                }
            }
            group("Delete Visuals")
            {
                Caption = 'Delete Visuals';

                action(DeleteWatermark)
                {
                    ApplicationArea = All;
                    Caption = 'Watermark';
                    Image = Delete;

                    trigger OnAction()var AreYouSureQst: label 'Are you sure you want to clear %1?';
                    begin
                        if not Confirm(AreYouSureQst, false, Rec.FieldCaption(Watermark))then exit;
                        Rec."Watermark File Name":='Click to import...';
                        Clear(Rec.Watermark);
                        Rec.Modify;
                    end;
                }
                action(DeleteSignature)
                {
                    ApplicationArea = All;
                    Caption = 'Signature', Comment='DO NOT TRANSLATE';
                    Image = Delete;

                    trigger OnAction()var AreYouSureQst: label 'Are you sure you want to clear %1?';
                    begin
                        if not Confirm(AreYouSureQst, false, Rec.FieldCaption(Signature))then exit;
                        Rec."Signature File Name":='Click to import...';
                        Clear(Rec.Signature);
                        Rec.Modify;
                    end;
                }
                action(Delete2ndSignature)
                {
                    ApplicationArea = All;
                    Caption = '2nd Signature', Comment='DO NOT TRANSLATE';
                    Image = Delete;

                    trigger OnAction()var AreYouSureQst: label 'Are you sure you want to clear %1?';
                    begin
                        if not Confirm(AreYouSureQst, false, Rec.FieldCaption("2nd Signature"))then exit;
                        Rec."2nd Signature File Name":='Click to import...';
                        Clear(Rec."2nd Signature");
                        Rec.Modify;
                    end;
                }
            }
            group(Template)
            {
                Caption = 'Template';

                action(DesignTemplate)
                {
                    ApplicationArea = All;
                    Caption = 'Design';
                    Image = VATPostingSetup;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()begin
                        Rec.DesignTemplate;
                    end;
                }
            }
        }
    }
    trigger OnOpenPage()begin
        Rec.InitSetup;
    end;
}
