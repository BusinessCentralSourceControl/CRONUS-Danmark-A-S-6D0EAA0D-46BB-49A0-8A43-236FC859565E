page 6189112 "ForNAV Fields API"
{
    PageType = API;
    APIPublisher = 'ForNav';
    APIGroup = 'AppManagement';
    APIVersion = 'v1.0';
    EntityName = 'Field';
    EntitySetName = 'Fields';
    SourceTable = "Field";
    DelayedInsert = true;
    Caption = 'ForNavFieldsApi';
    ODataKeyFields = TableNo, "No.";
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

                field(TableNo;Rec.TableNo)
                {
                    ApplicationArea = All;
                    Caption = 'TableNo';
                }
                field("No";Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'No';
                }
                field(TableName;Rec.TableName)
                {
                    ApplicationArea = All;
                    Caption = 'TableName';
                }
                field(FieldName;Rec.FieldName)
                {
                    ApplicationArea = All;
                    Caption = 'FieldName';
                }
                field(Type;Rec.Type)
                {
                    ApplicationArea = All;
                    Caption = 'Type';
                }
                field(Class;Rec.Class)
                {
                    ApplicationArea = All;
                    Caption = 'Class';
                }
                field(RelationTableNo;Rec.RelationTableNo)
                {
                    ApplicationArea = All;
                    Caption = 'RelationTableNo';
                }
                field(RelationFieldNo;Rec.RelationFieldNo)
                {
                    ApplicationArea = All;
                    Caption = 'RelationFieldNo';
                }
                field(OptionString;Rec.OptionString)
                {
                    ApplicationArea = All;
                    Caption = 'OptionString';
                }
            }
        }
    }
}
