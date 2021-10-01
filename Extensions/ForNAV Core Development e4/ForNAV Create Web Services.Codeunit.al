Codeunit 6188482 "ForNAV Create Web Services"
{
    trigger OnRun()begin
        CreateWebService;
    end;
    local procedure CreateWebService()var TempWebService: Record "ForNAV Web Service" temporary;
    RecRef: RecordRef;
    FldRef: FieldRef;
    begin
        CreateTempWebService(TempWebService);
        RecRef.Open(GetObjectID);
        TempWebService.FindSet;
        repeat FldRef:=RecRef.Field(TempWebService.FieldNo(TempWebService."Object Type"));
            FldRef.Value:=TempWebService."Object Type";
            FldRef:=RecRef.Field(TempWebService.FieldNo(TempWebService."Object ID"));
            FldRef.Value:=TempWebService."Object ID";
            FldRef:=RecRef.Field(TempWebService.FieldNo(TempWebService."Service Name"));
            FldRef.Value:=TempWebService."Service Name";
            FldRef.Validate;
            if not RecRef.Insert then exit;
            FldRef:=RecRef.Field(TempWebService.FieldNo(TempWebService.Published));
            FldRef.Validate(true);
            RecRef.Modify;
        until TempWebService.Next = 0;
    end;
    local procedure GetObjectID(): Integer var AllObjWithCaption: Record AllObjWithCaption;
    begin
        AllObjWithCaption.SetRange(AllObjWithCaption."Object Type", AllObjWithCaption."object type"::Table);
        AllObjWithCaption.SetRange(AllObjWithCaption."Object ID", 2000000168);
        if not AllObjWithCaption.IsEmpty then exit(2000000168);
        exit(2000000076);
    end;
    local procedure CreateTempWebService(var WebService: Record "ForNAV Web Service")begin
        WebService."Object Type":=WebService."object type"::Page;
        WebService."Object ID":=Page::"ForNAV Fields Webservice";
        WebService."Service Name":='FieldsEx';
        WebService.Insert;
        if not IsCloud then exit;
        WebService."Object Type":=WebService."object type"::Codeunit;
        WebService."Object ID":=ObjectIDForCloudWS;
        WebService."Service Name":='ForNavBc';
        WebService.Insert;
    end;
    local procedure IsCloud(): Boolean var AllObj: Record AllObj;
    begin
        AllObj.SetRange(AllObj."Object Type", AllObj."object type"::Codeunit);
        AllObj.SetRange(AllObj."Object ID", ObjectIDForCloudWS);
        exit(not AllObj.IsEmpty);
    end;
    local procedure ObjectIDForCloudWS(): Integer begin
        exit(6189102);
    end;
}
