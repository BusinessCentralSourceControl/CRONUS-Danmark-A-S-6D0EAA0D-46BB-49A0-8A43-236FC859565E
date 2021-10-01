Page 6188477 "ForNAV Fields Webservice"
{
    Caption = 'FieldsEx', Comment='DO NOT TRANSLATE';
    Editable = false;
    PageType = List;
    SourceTable = "Field";

    layout
    {
        area(content)
        {
            repeater(RepeaterControl)
            {
                field(TableNo;Rec.TableNo)
                {
                    ApplicationArea = All;
                }
                field(No;Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(TableName;Rec.TableName)
                {
                    ApplicationArea = All;
                }
                field(FieldName;Rec.FieldName)
                {
                    ApplicationArea = All;
                }
                field(Type;Rec.Type)
                {
                    ApplicationArea = All;
                }
                field(Class;Rec.Class)
                {
                    ApplicationArea = All;
                }
                field(RelationTableNo;Rec.RelationTableNo)
                {
                    ApplicationArea = All;
                }
                field(RelationFieldNo;Rec.RelationFieldNo)
                {
                    ApplicationArea = All;
                }
                field(OptionString;Rec.OptionString)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
    }
}
