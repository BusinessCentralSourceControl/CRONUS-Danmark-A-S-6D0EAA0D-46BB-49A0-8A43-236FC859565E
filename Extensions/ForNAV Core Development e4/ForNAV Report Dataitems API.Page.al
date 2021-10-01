page 6189113 "ForNAV Report Dataitems API"
{
    PageType = API;
    APIPublisher = 'ForNav';
    APIGroup = 'AppManagement';
    APIVersion = 'v1.0';
    EntityName = 'ReportDataitem';
    EntitySetName = 'ReportDataitems';
    SourceTable = "Report Data Items";
    DelayedInsert = true;
    Caption = 'ForNavReportDataitemsApi';
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ReportId;Rec."Report ID")
                {
                    ApplicationArea = All;
                    Caption = 'ReportId';
                }
                field(DataItemId;Rec."Data Item ID")
                {
                    ApplicationArea = All;
                    Caption = 'DataItemID';
                }
                field(Name;Rec.Name)
                {
                    ApplicationArea = All;
                    Caption = 'Name';
                }
                field(RequestFilterFields;Rec."Request Filter Fields")
                {
                    ApplicationArea = All;
                    Caption = 'RequestFilterFields';
                }
                field(RelatedTableId;Rec."Related Table ID")
                {
                    ApplicationArea = All;
                    Caption = 'RelatedTableID';
                }
                field(IndentationLevel;Rec."Indentation Level")
                {
                    ApplicationArea = All;
                    Caption = 'IndentationLevel';
                }
                field(SortingFields;Rec."Sorting Fields")
                {
                    ApplicationArea = All;
                    Caption = 'SortingFields';
                }
                field(DataItemTableView;Rec."Data Item Table View")
                {
                    ApplicationArea = All;
                    Caption = 'DataItemTableView';
                }
            }
        }
    }
}
