Codeunit 6188551 "ForNAV Test Valid Doc iFace"
{
    // Copyright (c) 2017-2021 ForNAV ApS - All Rights Reserved
    // The intellectual work and technical concepts contained in this file are proprietary to ForNAV.
    // Unauthorized reverse engineering, distribution or copying of this file, parts hereof, or derived work, via any medium is strictly prohibited without written permission from ForNAV ApS.
    // This source code is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    trigger OnRun()begin
    end;
    procedure ThrowErrorIfNotValid(var RecRef: RecordRef)var NotValidTableErr: label 'This table (%1) is not supported for this function.', Comment='DO NOT TRANSLATE';
    IsHandled: Boolean;
    begin
        OnBeforeCheckValid(RecRef, IsHandled);
        if IsHandled then exit;
        if not CheckValid(RecRef)then Error(NotValidTableErr, RecRef.Caption);
    end;
    procedure CheckValid(var RecRef: RecordRef): Boolean begin
        case RecRef.Number of Database::"Sales Header", Database::"Sales Shipment Header", Database::"Sales Invoice Header", Database::"Sales Cr.Memo Header", Database::"Purchase Header", Database::"Purch. Rcpt. Header", Database::"Purch. Inv. Header", Database::"Purch. Cr. Memo Hdr.", Database::"Reminder Header", Database::"Issued Reminder Header", Database::"Finance Charge Memo Header", Database::"Issued Fin. Charge Memo Header", Database::"Service Header", Database::"Service Invoice Header", Database::"Service Shipment Header", Database::"Service Cr.Memo Header", Database::"Sales Header Archive": exit(true);
        end;
        exit(false);
    end;
    [IntegrationEvent(false, false)]
    local procedure OnBeforeCheckValid(var RecRef: RecordRef;
    var IsHandled: Boolean)begin
    end;
}
