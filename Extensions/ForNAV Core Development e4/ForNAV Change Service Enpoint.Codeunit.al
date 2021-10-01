codeunit 6188499 "ForNAV Change Service Enpoint"
{
    [EventSubscriber(ObjectType::Table, Database::"ForNAV Setup", 'OnAfterValidateEvent', 'Service Endpoint', false, false)]
    local procedure ChangeServiceEndpoint(CurrFieldNo: Integer;
    var Rec: Record "ForNAV Setup";
    var xRec: Record "ForNAV Setup");
    var CoreSetup: Record "ForNAV Core Setup";
    begin
        if not CoreSetup.get then begin
            CoreSetup.Init;
            CoreSetup.Insert;
        end;
        CoreSetup."Service Endpoint ID":=Rec."Service Endpoint";
        CoreSetup.Modify;
    end;
    [EventSubscriber(ObjectType::Table, Database::"ForNAV Setup", 'OnAfterValidateEvent', 'Endpoint Settings', false, false)]
    local procedure ChangeEndpointSettings(CurrFieldNo: Integer;
    var Rec: Record "ForNAV Setup";
    var xRec: Record "ForNAV Setup");
    var CoreSetup: Record "ForNAV Core Setup";
    begin
        if not CoreSetup.get then begin
            CoreSetup.Init;
            CoreSetup.Insert;
        end;
        CoreSetup."Endpoint Settings":=Rec."Endpoint Settings";
        CoreSetup.Modify;
    end;
}
