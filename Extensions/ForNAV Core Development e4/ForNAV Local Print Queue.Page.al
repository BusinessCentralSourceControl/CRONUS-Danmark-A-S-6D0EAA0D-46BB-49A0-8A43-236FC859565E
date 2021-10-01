page 6189102 "ForNAV Local Print Queue"
{
    PageType = List;
    Caption = 'ForNAV Print Queue';
    SourceTable = "ForNAV Local Print Queue";
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    Editable = true;
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Document Name";Rec."Document")
                {
                    ApplicationArea = All;
                }
                field(Status;Rec.Status)
                {
                    ApplicationArea = All;
                }
                field(Size;Rec.Size)
                {
                    ApplicationArea = All;
                }
                field(Submitted;Rec.SystemCreatedAt)
                {
                    ApplicationArea = All;
                }
                field("Job ID";Rec.ID)
                {
                    ApplicationArea = All;
                }
                field(Owner;Rec.Owner)
                {
                    ApplicationArea = All;
                }
                field("Cloud Printer Name";Rec."Cloud Printer Name")
                {
                    ApplicationArea = All;
                }
                field(LocalPrinterName;Rec."Local Printer")
                {
                    ApplicationArea = All;
                }
                field("Service Name";Rec."Service")
                {
                    ApplicationArea = All;
                }
                field(Message;Rec.Message)
                {
                    ApplicationArea = All;
                }
                field(Company;Rec.Company)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Restart)
            {
                ApplicationArea = All;
                PromotedCategory = Process;
                Promoted = true;
                PromotedIsBig = true;
                Caption = 'Restart';
                Image = View;

                trigger OnAction()begin
                    CurrPage.Update(true);
                    Rec.Restart();
                end;
            }
            action(Test)
            {
                ApplicationArea = All;
                PromotedCategory = Process;
                Promoted = true;
                PromotedIsBig = true;
                Caption = 'Test';
                Image = View;

                trigger OnAction()var json: Text;
                serviceName: Text;
                api: Codeunit "Print Queue API";
                begin
                    serviceName:='mypc';
                    json:='["Snagit 2018","OneNote for Windows 10","Print To Word","PDF Writer - bioPDF","Network PDF Printer - 7PDF","Microsoft XPS Document Writer","Microsoft Print to PDF","LBP622C/623C","Infix PDF","Google Cloud Printer","Gecko Hybrid Mail","Fax","Canon LBP-2000 PCL","Bullzip PDF Printer","7-PDF Printer","320","220","120","\\\\192.168.50.132\\Canon LBP-2000 PCL"]';
                    api.UpdatePrinters(serviceName, json);
                    CurrPage.Update(true);
                    Rec.Restart();
                end;
            }
        }
    }
    trigger OnAfterGetRecord()begin
        Rec.CalcFields("Report Name");
    end;
}
