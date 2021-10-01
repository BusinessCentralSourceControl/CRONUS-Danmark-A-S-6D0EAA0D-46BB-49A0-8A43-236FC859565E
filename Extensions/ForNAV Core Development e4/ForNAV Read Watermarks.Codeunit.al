Codeunit 6188477 "ForNAV Read Watermarks"
{
    // Copyright (c) 2017-2021 ForNAV ApS - All Rights Reserved
    // The intellectual work and technical concepts contained in this file are proprietary to ForNAV.
    // Unauthorized reverse engineering, distribution or copying of this file, parts hereof, or derived work, via any medium is strictly prohibited without written permission from ForNAV ApS.
    // This source code is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    trigger OnRun()begin
    end;
    procedure ReadFromFile(var ForNAVSetup: Record "ForNAV Setup";
    Which: Integer): Boolean var TempBlob: Record "ForNAV Core Setup" temporary;
    FileName: Text;
    InStream: InStream;
    OutStream: OutStream;
    SelectFile: Label 'Select a file';
    begin
        UploadIntoStream(SelectFile, '', 'PDF files (*.pdf)|*.pdf|All files (*.*)|*.*', FileName, InStream);
        if FileName <> '' then begin
            TempBlob.Blob.CreateOutstream(OutStream);
            CopyStream(OutStream, InStream);
            case Which of ForNAVSetup.FieldNo(ForNAVSetup.Logo): begin
                ForNAVSetup.Logo:=TempBlob.Blob;
                ForNAVSetup."Logo File Name":=GetFileNameFromFile(FileName);
            end;
            ForNAVSetup.FieldNo(ForNAVSetup."Document Watermark"): begin
                ForNAVSetup."Document Watermark":=TempBlob.Blob;
                ForNAVSetup."Document Watermark File Name":=GetFileNameFromFile(FileName);
            end;
            ForNAVSetup.FieldNo(ForNAVSetup."List Report Watermark"): begin
                ForNAVSetup."List Report Watermark":=TempBlob.Blob;
                ForNAVSetup."List Report Watermark File N.":=GetFileNameFromFile(FileName);
            end;
            ForNAVSetup.FieldNo(ForNAVSetup."List Report Watermark (Lands.)"): begin
                ForNAVSetup."List Report Watermark (Lands.)":=TempBlob.Blob;
                ForNAVSetup."List Report W. File N. Lands.":=GetFileNameFromFile(FileName);
            end;
            end;
            exit(true);
        end;
        exit(false);
    end;
    local procedure GetFileNameFromFile(Value: Text): Text var LastPos: Integer;
    i: Integer;
    begin
        while i < StrLen(Value)do begin
            i:=i + 1;
            if Value[i] = '\' then LastPos:=i;
        end;
        exit(CopyStr(Value, LastPos + 1));
    end;
}
