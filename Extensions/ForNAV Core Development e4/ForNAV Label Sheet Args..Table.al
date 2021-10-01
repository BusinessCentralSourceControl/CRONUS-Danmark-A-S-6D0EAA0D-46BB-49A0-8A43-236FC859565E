Table 6188683 "ForNAV Label Sheet Args."
{
    fields
    {
        field(1;"Table ID";Integer)
        {
            DataClassification = SystemMetadata;
        }
        field(2;"No. of Labels";Integer)
        {
            DataClassification = SystemMetadata;
        }
        field(3;"Table Name";Text[50])
        {
            DataClassification = SystemMetadata;
            TableRelation = AllObjWithCaption."Object Caption" where("Object Type"=filter(Table));
        }
        field(4;"Filter";Integer)
        {
            FieldClass = FlowFilter;
        }
    }
    keys
    {
        key(Key1;"Table ID")
        {
        }
    }
    procedure ShowFilteredTableList()var AllObjWithCaption: Record AllObjWithCaption;
    AllObjWithCaptionBuffer: Record AllObjWithCaption temporary;
    Fld: Record "Field";
    begin
        Fld.SetRange(Type, Fld.Type::Code);
        Fld.SetRange(FieldName, 'No.');
        if Fld.FindSet then repeat if not HasEntryNo(Fld.TableNo)then begin
                    if AllObjWithCaption.Get(AllObjWithCaption."object type"::Table, Fld.TableNo)then begin
                        AllObjWithCaptionBuffer:=AllObjWithCaption;
                        if AllObjWithCaptionBuffer.Insert then;
                    end;
                end;
            until Fld.Next = 0;
        AllObjWithCaptionBuffer.FindFirst;
        if Page.RunModal(Page::"ForNAV Table List", AllObjWithCaptionBuffer) = Action::LookupOK then begin
            "Table ID":=AllObjWithCaptionBuffer."Object ID";
            "Table Name":=AllObjWithCaptionBuffer."Object Caption";
        end;
    end;
    local procedure HasEntryNo(Value: Integer): Boolean var Fld: Record "Field";
    begin
        Fld.SetRange(TableNo, Value);
        Fld.SetRange(FieldName, 'Entry No.');
        Fld.SetRange("No.", 1, 10);
        exit(not Fld.IsEmpty);
    end;
}
