Codeunit 6188490 "ForNAV Notifications"
{
    // Copyright (c) 2017-2019 ForNAV ApS - All Rights Reserved
    // The intellectual work and technical concepts contained in this file are proprietary to ForNAV.
    // Unauthorized reverse engineering, distribution or copying of this file, parts hereof, or derived work, via any medium is strictly prohibited without written permission from ForNAV ApS.
    // This source code is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    trigger OnRun()begin
        ShowSetupNotification; // Test Framework...
    end;
    [EventSubscriber(Objecttype::Codeunit, 2000000005, 'GetPrinterName', '', true, true)]
    local procedure OnFindPrinter(ReportID: Integer;
    var PrinterName: Text[250])var ForNAVSetup: Record "ForNAV Setup";
    begin
        if not ForNAVSetup.ReadPermission then exit;
        ShowSetupNotification;
        ShowLabelNotification(ReportID);
    end;
    local procedure ShowSetupNotification()var MyNotifications: Record "My Notifications";
    ForNAVSetup: Record "ForNAV Setup";
    NotificationIDs: Codeunit "ForNAV Notification IDs";
    MyNotification: Notification;
    ForNAVNotSetup: label 'ForNAV is installed but not setup. Do you want to do this now?';
    Yes: label 'Yes';
    NoAndDontAskAgain: label 'No, and please don''t remind me again.';
    begin
        if ForNAVSetup.Get then exit;
        if not MyNotifications.IsEnabled(NotificationIDs.SetupForNAV)then exit;
        MyNotification.ID:=NotificationIDs.SetupForNAV;
        MyNotification.Message:=ForNAVNotSetup;
        MyNotification.AddAction(Yes, Codeunit::"ForNAV Notification Actions", 'SetupForNAV');
        MyNotification.AddAction(NoAndDontAskAgain, Codeunit::"ForNAV Notification Actions", 'DisableSetup');
        MyNotification.Send;
    end;
    local procedure ShowLabelNotification(ReportID: Integer)var MyNotifications: Record "My Notifications";
    ForNAVLabelSetup: Record "ForNAV Label Setup";
    NotificationIDs: Codeunit "ForNAV Notification IDs";
    MyNotification: Notification;
    ForNAVNotSetup: label 'ForNAV Label module is installed but not setup. Do you want to do this now?';
    Yes: label 'Yes';
    NoAndDontAskAgain: label 'No, and please don''t remind me again.';
    begin
        if ForNAVLabelSetup.Get then exit;
        if not MyNotifications.IsEnabled(NotificationIDs.SetupForNAVLabel)then exit;
        if not IsLabelReport(ReportID)then exit;
        MyNotification.ID:=NotificationIDs.SetupForNAVLabel;
        MyNotification.Message:=ForNAVNotSetup;
        MyNotification.AddAction(Yes, Codeunit::"ForNAV Notification Actions", 'SetupForNAVLabels');
        MyNotification.AddAction(NoAndDontAskAgain, Codeunit::"ForNAV Notification Actions", 'DisableSetup');
        MyNotification.Send;
    end;
    local procedure IsLabelReport(ReportID: Integer): Boolean var AllObj: Record AllObj;
    begin
        AllObj.Get(AllObj."object type"::Report, ReportID);
        exit(StrPos(UpperCase(AllObj."Object Name"), 'LABEL') <> 0);
    end;
}
