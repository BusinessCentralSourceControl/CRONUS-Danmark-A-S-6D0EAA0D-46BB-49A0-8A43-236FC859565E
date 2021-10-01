Codeunit 6188777 "ForNAV Read Check Watermarks"
{
    // Copyright (c) 2017-2021 ForNAV ApS - All Rights Reserved
    // The intellectual work and technical concepts contained in this file are proprietary to ForNAV.
    // Unauthorized reverse engineering, distribution or copying of this file, parts hereof, or derived work, via any medium is strictly prohibited without written permission from ForNAV ApS.
    // This source code is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    trigger OnRun()begin
    end;
    procedure ReadFromFile(var ForNAVCheckSetup: Record "ForNAV Check Setup";
    Which: Integer): Boolean var TempBlob: Record "ForNAV Core Setup" temporary;
    InStream: InStream;
    OutStream: OutStream;
    FileName: Text;
    SelectFile: Label 'Select a file';
    begin
        UploadIntoStream(SelectFile, '', 'PDF files (*.pdf)|*.pdf|All files (*.*)|*.*', FileName, InStream);
        TempBlob.Blob.CreateOutstream(OutStream);
        CopyStream(OutStream, InStream);
        if FileName <> '' then begin
            case Which of ForNAVCheckSetup.FieldNo(ForNAVCheckSetup.Watermark): begin
                ForNAVCheckSetup.Watermark:=TempBlob.Blob;
                ForNAVCheckSetup."Watermark File Name":=GetFileNameFromFile(FileName);
            end;
            ForNAVCheckSetup.FieldNo(ForNAVCheckSetup.Signature): begin
                ForNAVCheckSetup.Signature:=TempBlob.Blob;
                ForNAVCheckSetup."Signature File Name":=GetFileNameFromFile(FileName);
            end;
            ForNAVCheckSetup.FieldNo(ForNAVCheckSetup."2nd Signature"): begin
                ForNAVCheckSetup."2nd Signature":=TempBlob.Blob;
                ForNAVCheckSetup."2nd Signature File Name":=GetFileNameFromFile(FileName);
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
