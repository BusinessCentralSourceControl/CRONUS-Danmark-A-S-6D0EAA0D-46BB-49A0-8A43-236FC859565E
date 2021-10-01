page 6189121 "ForNAV TableRelation API"
{
    PageType = API;
    APIPublisher = 'ForNav';
    APIGroup = 'AppManagement';
    APIVersion = 'v1.0';
    EntityName = 'TableRelation';
    EntitySetName = 'TableRelations';
    SourceTable = "Table Relations Metadata";
    DelayedInsert = true;
    Caption = 'TableRelationsApi';
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(TableNo;Rec."Table ID")
                {
                    ApplicationArea = All;
                    Caption = 'TableNo';
                }
                field(FieldNo;Rec."Field No.")
                {
                    ApplicationArea = All;
                    Caption = 'FieldNo';
                }
                field(RelationNo;Rec."Relation No.")
                {
                    ApplicationArea = All;
                    Caption = 'RelationNo';
                }
                field(ConditionNo;Rec."Condition No.")
                {
                    ApplicationArea = All;
                    Caption = 'ConitionNo';
                }
                field(RelatedTableNo;Rec."Related Table ID")
                {
                    ApplicationArea = All;
                    Caption = 'RelatedTableNo';
                }
                field(RelatedFieldNo;Rec."Related Field No.")
                {
                    ApplicationArea = All;
                    Caption = 'RelatedFieldNo';
                }
                field(ConditionType;Rec."Condition Type")
                {
                    ApplicationArea = All;
                    Caption = 'ConditionType';
                }
                field(ConditionFieldNo;Rec."Condition Field No.")
                {
                    ApplicationArea = All;
                    Caption = 'ConditionFieldNo';
                }
                field(ConditionValue;Rec."Condition Value")
                {
                    ApplicationArea = All;
                    Caption = 'ConditionValue';
                }
            }
        }
    }
}
