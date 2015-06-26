/***************************************************************************************************************
**  File:   GainsightHealthUsageBatch.cls 
**  Desc:   Run this batch weekly to add customer health and case metrics to Usage Data for historical trending.
**          Built for Apttus
**  Auth:   Rory Sherony
**  Date:   3.22.14        DEPRECATED
****************************************************************************************************************
**  Change History
**  PR  Date        Author          Description 
**  --  --------    ------------    ------------------------------------
        4.29.13     Rory Sherony    Modified to track current health as three seperate Usage Data fields for Green Yellow, and Red.
                                    Added ACV and ACV at Risk Metrics.

        10.14.14    Rory Sherony    Included Open_Cases__c metric in SOQL query of JBCXM__UsageData__c
        
                                    DEPRECATED
                                    
***************************************************************************************************************/

global class GainsightHealthUsageBatch implements Database.Batchable<sObject>, Database.Stateful
{
    private Date StartDate = Date.Today().addDays(-1).toStartOfWeek();
    private Date EndDate = Date.Today().addDays(-1);
            
    global void execute(SchedulableContext SC) 
    {
        database.executebatch(new GainsightHealthUsageBatch(),1);
    }
      
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        string Query = 'SELECT JBCXM__Account__c,JBCXM__ASV__c,JBCXM__MRR__c, JBCXM__CurScoreId__c FROM JBCXM__CustomerInfo__c WHERE JBCXM__Account__c != null';
        return Database.getQueryLocator(Query);
    }
    
    global void execute(Database.BatchableContext BC, List<JBCXM__CustomerInfo__c> scope)
    {
   
 }

global void finish(Database.BatchableContext BC)
{}
}