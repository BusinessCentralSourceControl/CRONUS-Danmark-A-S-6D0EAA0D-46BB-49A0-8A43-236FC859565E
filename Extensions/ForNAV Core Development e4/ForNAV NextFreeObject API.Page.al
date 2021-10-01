page 6189118 "ForNAV NextFreeObject API"
{
    PageType = API;
    APIPublisher = 'ForNav';
    APIGroup = 'AppManagement';
    APIVersion = 'v1.0';
    EntityName = 'NextFreeObject';
    EntitySetName = 'NextFreeObjects';
    SourceTable = Integer;
    SourceTableTemporary = true;
    DelayedInsert = true;
    Caption = 'NextFreeObjectApi';
    ODataKeyFields = Number;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;

                field(ObjectType;Rec.Number)
                {
                    ApplicationArea = All;
                    Caption = 'ObjectType';
                }
                field(NextFreeNumber;NextFreeNumber)
                {
                    ApplicationArea = All;
                    Caption = 'NextFreeNumber';
                }
            }
        }
    }
    var NextFreeNumber: Integer;
    //        ObjectType: Option TableData,Table,,Report,,Codeunit,XMLport,MenuSuite,Page,Query,System,FieldNumber,,,"PageExtension";
    trigger OnAfterGetRecord()var AllObj: Record AllObj;
    begin
        //TableData, Table, , Report=3, , Codeunit, XMLport, MenuSuite, Page, Query, System, FieldNumber,PageExtension = 14
        AllObj.SetRange(AllObj."Object Type", Rec.Number);
        NextFreeNumber:=56789;
        AllObj.SetRange(AllObj."Object ID", NextFreeNumber, 99999);
        if AllObj.FindFirst then begin
            while NextFreeNumber = AllObj."Object ID" do begin
                NextFreeNumber+=1;
                if AllObj.next <> 1 then exit;
            end;
        end;
    end;
    trigger OnFindRecord(Which: Text): Boolean begin
        if Evaluate(Rec.Number, Rec.GetFilter(Number))then exit(true)
        else
            exit(false);
    end;
}
