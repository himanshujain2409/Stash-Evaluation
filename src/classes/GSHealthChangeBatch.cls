/****************************************************************************************
**  File:   GSHealthChangeBatch.cls
**  Desc:   Daily Batch update HealthChangeDate__c when customer health is changed
**  Auth:   Rory Sherony
**  Date:   6.10.14
*****************************************************************************************
**  Change History
**  PR  Date        Author          Description 
**  --  --------    ------------    ------------------------------------
****************************************************************************************/
global class GSHealthChangeBatch implements Database.Batchable<sObject>, Database.Stateful
{
                
    global void execute(SchedulableContext SC) 
    {
        database.executebatch(new GSHealthChangeBatch(),1);
    }
      
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        string Query = 'SELECT Id, Health_Change_Date__c, YesterdayHealthScore__c, JBCXM__CurScoreId__c, JBCXM__CurScoreId__r.JBCXM__Color__c, JBCXM__Account__c, JBCXM__Account__r.AccountStatusGS__c FROM JBCXM__CustomerInfo__c ';
        return Database.getQueryLocator(Query);
    }
    
    global void execute(Database.BatchableContext BC, List<JBCXM__CustomerInfo__c> scope)
    {
       
        try 
        {
            
            List<JBCXM__CustomerInfo__c> CItoUpdate = new List<JBCXM__CustomerInfo__c>();

             
    
            
            for(JBCXM__CustomerInfo__c CI : scope)

            {
                if( CI.JBCXM__Account__r.AccountStatusGS__c != CI.YesterdayHealthScore__c )
                {
                    if(CI.JBCXM__CurScoreId__r.JBCXM__Color__c == '#76ad27')
                    {
                        CI.YesterdayHealthScore__c = 'Green';
                        CI.Health_Change_Date__c = Date.today().addDays(-1);
                    }

                    else if (CI.JBCXM__CurScoreId__r.JBCXM__Color__c == '#eba638')
                    {
                        CI.YesterdayHealthScore__c = 'Yellow';
                        CI.Health_Change_Date__c = Date.today().addDays(-1);

                    }

                    else if (CI.JBCXM__CurScoreId__r.JBCXM__Color__c == '#c53536')
                    {
                        CI.YesterdayHealthScore__c = 'Red';
                        CI.Health_Change_Date__c = Date.today().addDays(-1);
                    }

                
                CItoUpdate.add(CI);
                }
                
            }

                if(CItoUpdate.size()> 0) update CItoUpdate;
                

        } 

catch(System.CalloutException e) 

        {                          

    JBCXM__Log__c errorLog = New JBCXM__Log__c(JBCXM__ExceptionDescription__c   = 'Received a '+e.getTypeName()+' at line No. '+e.getLineNumber()+' while running the Batch to iupdate Health_Change_Date__c',

                                                   JBCXM__LogDateTime__c            = datetime.now(),

                                                   JBCXM__SourceData__c             = e.getMessage(),

                                                   JBCXM__SourceObject__c           = 'JBCXM__CustomerInfo__c',

                                                   JBCXM__Type__c                   = 'GSHealthChangeBatch');

        insert errorLog;

        system.Debug(errorLog.JBCXM__ExceptionDescription__c);

        system.Debug(errorLog.JBCXM__SourceData__c);

        }

 }

global void finish(Database.BatchableContext BC)
{}
}