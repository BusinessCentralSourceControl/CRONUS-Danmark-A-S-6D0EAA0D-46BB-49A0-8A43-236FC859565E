Codeunit 6188486 "ForNAV Assisted Setup"
{
    local procedure Add(var GuidedExperience: Codeunit "Guided Experience";
    ExtensionID: Guid;
    PageID: Integer;
    AssistantName: Text;
    GroupName: Enum "Assisted Setup Group";
    VideoLink: Text[250];
    VideoCategory: Enum "Video Category";
    HelpLink: Text[250];
    Description: Text[1024])begin
        GuidedExperience.InsertAssistedSetup(AssistantName, AssistantName, Description, 3, ObjectType::Page, PageID, GroupName, VideoLink, VideoCategory, HelpLink);
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Guided Experience", 'OnRegisterAssistedSetup', '', false, false)]
    local procedure AssistedSetup()var AssistedSetup: Codeunit "Guided Experience";
    ForNAVSetup: Record "ForNAV Setup";
    AssistedSetupGroup: Enum "Assisted Setup Group";
    VideoCategory: Enum "Video Category";
    // ForNAV Setup Wizard
    "How to manage...": Label 'How to manage report selection, add logo and watermarks, and more';
    // ForNAV Setup
    "Modify Invoice": Label 'Modify Invoice';
    "Create and modify invoices...": Label 'Create and modify invoices, and ensure that they exactly fit your specific business needs and branding.';
    // ForNAV Local Printers
    "Direct Local Print": Label 'Direct Local Print';
    "Define local printers...": Label 'Define local printers and print ForNAV reports to them directly, without the PDF Print dialog.';
    // ForNAV Language Setup
    "Specific Terminology": Label 'Specific Terminology';
    "Change and translate texts...": Label 'Change and translate texts in your ForNAV reports without changing the layout itself.';
    // ForNAV Setup
    "Add Barcodes to Reports": Label 'Add Barcodes to Reports';
    "See how easily...": Label 'See how easily you can add barcodes/QR codes to your ForNAV reports';
    begin
        Add(AssistedSetup, GetAppId(), PAGE::"ForNAV Setup Wizard", ForNAVSetup.TableCaption, AssistedSetupGroup::Extensions, 'https://www.youtube.com/embed/PX0qntKpe-s?list=PLtpjnuA-F0c_XQ-y7kGZKAWCXeop7F7Wa', VideoCategory::Uncategorized, 'https://www.fornav.com/documents/Getting%20Started%20with%20ForNAV%20Customizable%20Report%20Pack%20Feb%202019%20Final.pdf', "How to manage...");
        Add(AssistedSetup, GetAppId(), PAGE::"ForNAV Reports", "Modify Invoice", AssistedSetupGroup::FirstInvoice, '', VideoCategory::Uncategorized, 'https://fornav.github.io/ForNav.Guide/#/ForNAVForBCSaaS/EditYourFirstReport', "Create and modify invoices...");
        Add(AssistedSetup, GetAppId(), PAGE::"ForNAV Local Printers", "Direct Local Print", AssistedSetupGroup::DoMoreWithBC, 'https://www.youtube.com/embed/jPMTr3fmXK8?list=PLtpjnuA-F0c_XQ-y7kGZKAWCXeop7F7Wa', VideoCategory::Uncategorized, 'https://www.fornav.com/knowledge-base/define-local-printers-for-direct-print/', "Define local printers...");
        Add(AssistedSetup, GetAppId(), PAGE::"ForNAV Language Setup", "Specific Terminology", AssistedSetupGroup::DoMoreWithBC, 'https://www.youtube.com/embed/12t7j3rZqNo?list=PLtpjnuA-F0c_XQ-y7kGZKAWCXeop7F7Wa', VideoCategory::Uncategorized, 'https://fornav.github.io/ForNav.Guide/#/ForNAVForBCSaaS/Language', "Change and translate texts...");
        Add(AssistedSetup, GetAppId(), PAGE::"ForNAV Setup", "Add Barcodes to Reports", AssistedSetupGroup::DoMoreWithBC, '', VideoCategory::Uncategorized, '', "See how easily...");
    end;
    local procedure Insert(var Sender: Codeunit "Guided Experience";
    Name: Text[50];
    Description: Text[250];
    Keywords: Text[250];
    RunPage: Integer;
    ExtensionId: Guid;
    Category: Enum "Manual Setup Category")begin
        Sender.InsertManualSetup(Name, Name, Description, 3, ObjectType::Page, RunPage, Category, Keywords);
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Guided Experience", 'OnRegisterManualSetup', '', false, false)]
    local procedure ManualSetup(var Sender: Codeunit "Guided Experience")var // ForNAV Setup
    "How to manage report selection...": Label 'How to manage report selection, add logo and watermarks, and more';
    "Setup Keywords": Label 'Watermark, Invoice, Label, Barcode, Font, Designer, RDLC, Excel, PDF, Layout, Document Customize';
    // Direct Local Print
    "Define local printers...": Label 'Define local printers and print ForNAV reports to them directly, without the PDF Print dialog.';
    "Direct Local Print Keywords": Label 'Direct Print, Local Print';
    // Specific Terminology
    "Change and translate texts...": Label 'Change and translate texts in your ForNAV reports without changing the layout itself.';
    "Specific Terminology Keywords": Label 'Terminology, Language, Translation';
    // ForNAV Check Setup
    "Check printing with MICR...": Label 'Check printing with MICR font for North America';
    "Check Setup Keywords": Label 'Reporting, Check, MICR Font';
    //ForNAV Archive Setup
    "Setup archiving...": Label 'Setup archiving for your ForNAV report output';
    "Archive Setup Keywords": Label 'Archive';
    begin
        Insert(Sender, 'ForNAV Setup', "How to manage report selection...", "Setup Keywords", PAGE::"ForNAV Setup", GetAppId(), "Manual Setup Category"::General);
        Insert(Sender, 'Direct Local Print', "Define local printers...", "Direct Local Print Keywords", PAGE::"ForNAV Local Printers", GetAppId(), "Manual Setup Category"::General);
        Insert(Sender, 'Specific Terminology', "Change and translate texts...", "Specific Terminology Keywords", PAGE::"ForNAV Language Setup", GetAppId(), "Manual Setup Category"::General);
        Insert(Sender, 'ForNAV Check Setup', "Check printing with MICR...", "Check Setup Keywords", PAGE::"ForNAV Check Setup", GetAppId(), "Manual Setup Category"::General);
        Insert(Sender, 'ForNAV Archive Setup', "Setup archiving...", "Archive Setup Keywords", PAGE::"ForNAV Document Archive Setup", GetAppId(), "Manual Setup Category"::General);
    end;
    local procedure GetAppId(): Guid var Info: ModuleInfo;
    begin
        NavApp.GetCurrentModuleInfo(Info);
        exit(Info.Id());
    end;
}
