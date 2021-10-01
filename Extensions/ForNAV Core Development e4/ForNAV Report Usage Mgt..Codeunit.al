Codeunit 6188494 "ForNAV Report Usage Mgt."
{
    SingleInstance = true;

    procedure AddToBuffer(ReportID: Integer)begin
        ReportUsageStatisticsBuffer."Entry No.":=1;
        if ReportUsageStatisticsBuffer.FindLast then ReportUsageStatisticsBuffer."Entry No."+=1;
        ReportUsageStatisticsBuffer.Init;
        ReportUsageStatisticsBuffer."Report ID":=ReportID;
        ReportUsageStatisticsBuffer."User ID":=UserId;
        ReportUsageStatisticsBuffer."Date Time Printed":=CurrentDatetime;
        ReportUsageStatisticsBuffer.Insert;
    end;
    [EventSubscriber(Objecttype::Codeunit, 2000000003, 'OnCompanyClose', '', false, false)]
    procedure SaveBufferToDatabase()var ReportUsageStatistics: Record "ForNAV Report Usage Statistics";
    begin
        if ReportUsageStatisticsBuffer.IsEmpty then exit;
        if not ReportUsageStatistics.WritePermission then exit;
        ReportUsageStatisticsBuffer.FindSet;
        repeat ReportUsageStatistics:=ReportUsageStatisticsBuffer;
            ReportUsageStatistics."Entry No.":=0;
            ReportUsageStatistics.Insert;
        until ReportUsageStatisticsBuffer.Next = 0;
    end;
    var ReportUsageStatisticsBuffer: Record "ForNAV Report Usage Statistics" temporary;
}
