/****************************************************************************************
**  File:   GSRenewalAlertBatch.cls 
**  Desc:   Daily batch to create Alerts for upcoming Renewals.
**          Built for Apttus
**  Auth:   Rory Sherony
**  Date:   6.18.14          DEPRECATED
*****************************************************************************************
**  Change History
**  PR  Date        Author          Description 
**  --  --------    ------------    ---DEPRECATED-----------------
****************************************************************************************/


global class GSRenewalAlertBatch implements Database.Batchable<sObject>, Database.Stateful
{
   
            
    global void execute(SchedulableContext SC) 
    {
        database.executebatch(new GSRenewalAlertBatch(),1);
    }
      
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        string Query = 'SELECT Id, JBCXM__Account__c, JBCXM__ASV__c, JBCXM__NextRenewalDate__c, JBCXM__Account__r.AccountStatusGS__c, JBCXM__MRR__c, JBCXM__Account__r.Name, JBCXM__Status__c FROM JBCXM__CustomerInfo__c  WHERE JBCXM__Account__c != null';
        return Database.getQueryLocator(Query);
    }
    
    global void execute(Database.BatchableContext BC, List<JBCXM__CustomerInfo__c> scope)
    {
       /**
        try 
        {

//Check for Custom Setting
if(GainsightAutomation__c.getValues('GainsightAutomation') != null)
{

GainsightAutomation__c GA = GainsightAutomation__c.getValues('GainsightAutomation');

//Check for Active via Custom Setting
if(GA.Renewal_Alerts__c = true)
{
                
            List<JBCXM__Alert__c> AlertsToInsert = new list<JBCXM__Alert__c>();
            

           for(JBCXM__CustomerInfo__c CI: scope)  
           {
               Integer DaysBetween = CI.JBCXM__NextRenewalDate__c.daysBetween(date.Today());
               
             if(DaysBetween == -30)
              {

                  //add an alert in Gainsight for 30 days to Renewal
                  
                                    
                  JBCXM__Alert__c A = new JBCXM__Alert__c();
                  
                A.JBCXM__Account__c    = CI.JBCXM__Account__c;
                A.Name                 = 'Upcoming Renewal';  
                A.JBCXM__ASV__c        = ((CI.JBCXM__ASV__c) != null ? CI.JBCXM__ASV__c : 0);
                A.JBCXM__Comment__c    = CI.JBCXM__Account__r.Name+'\'s Renewal is due in 30 Days. Their current health score is '+CI.JBCXM__Account__r.AccountStatusGS__c + '.';
                A.JBCXM__Date__c       = Date.today();
                A.JBCXM__MRR__c        = ((CI.JBCXM__MRR__c) != null ? CI.JBCXM__MRR__c : 0);
                A.JBCXM__Severity__c   = GainsightDAL.GetAlertSeverityBySystemName('alertseverity2').Id;
                A.JBCXM__Status__c     = GainsightDAL.GetAlertStatusBySystemName('New Untouched').Id;
                A.JBCXM__Type__c       = GainsightDAL.GetAlertTypeBySystemName('RenewalAlert').Id;
                A.JBCXM__Reason__c     = GainsightDAL.GetAlertReasonBySystemName('Renewal30').Id ;
                
    
                AlertsToInsert.add (A);
              }

             if(DaysBetween == -45)
              {

                  //add an alert in Gainsight for 45 days to Renewal
                  
                                    
                  JBCXM__Alert__c A = new JBCXM__Alert__c();
                  
                A.JBCXM__Account__c    = CI.JBCXM__Account__c;
                A.Name                 = 'Upcoming Renewal';  
                A.JBCXM__ASV__c        = ((CI.JBCXM__ASV__c) != null ? CI.JBCXM__ASV__c : 0);
                A.JBCXM__Comment__c    = CI.JBCXM__Account__r.Name+'\'s Renewal is due in 45 Days.  Their current health score is '+CI.JBCXM__Account__r.AccountStatusGS__c + '.';
                A.JBCXM__Date__c       = Date.today();
                A.JBCXM__MRR__c        = ((CI.JBCXM__MRR__c) != null ? CI.JBCXM__MRR__c : 0);
                A.JBCXM__Severity__c   = GainsightDAL.GetAlertSeverityBySystemName('alertseverity3').Id;
                A.JBCXM__Status__c     = GainsightDAL.GetAlertStatusBySystemName('New Untouched').Id;
                A.JBCXM__Type__c       = GainsightDAL.GetAlertTypeBySystemName('RenewalAlert').Id;
                A.JBCXM__Reason__c     = GainsightDAL.GetAlertReasonBySystemName('Renewal45').Id ;
                
    
                AlertsToInsert.add (A);
              }
           
             if(DaysBetween == -60)
              {

                  //add an alert in Gainsight for 60 days to Renewal
                  
                                    
                  JBCXM__Alert__c A = new JBCXM__Alert__c();
                  
                A.JBCXM__Account__c    = CI.JBCXM__Account__c;
                A.Name                 = 'Upcoming Renewal';  
                A.JBCXM__ASV__c        = ((CI.JBCXM__ASV__c) != null ? CI.JBCXM__ASV__c : 0);
                A.JBCXM__Comment__c    = CI.JBCXM__Account__r.Name+'\'s Renewal is due in 60 Days.  Their current health score is '+CI.JBCXM__Account__r.AccountStatusGS__c + '.';
                A.JBCXM__Date__c       = Date.today();
                A.JBCXM__MRR__c        = ((CI.JBCXM__MRR__c) != null ? CI.JBCXM__MRR__c : 0);
                A.JBCXM__Severity__c   = GainsightDAL.GetAlertSeverityBySystemName('alertseverity3').Id;
                A.JBCXM__Status__c     = GainsightDAL.GetAlertStatusBySystemName('New Untouched').Id;
                A.JBCXM__Type__c       = GainsightDAL.GetAlertTypeBySystemName('RenewalAlert').Id;
                A.JBCXM__Reason__c     = GainsightDAL.GetAlertReasonBySystemName('Renewal60').Id ;
                
    
                AlertsToInsert.add (A);
              }
              
                
             if(DaysBetween == -90)
              {

                  //add an alert in Gainsight for 90 days to Renewal
                  
                                    
                  JBCXM__Alert__c A = new JBCXM__Alert__c();
                  
                A.JBCXM__Account__c    = CI.JBCXM__Account__c;
                A.Name                 = 'Upcoming Renewal';  
                A.JBCXM__ASV__c        = ((CI.JBCXM__ASV__c) != null ? CI.JBCXM__ASV__c : 0);
                A.JBCXM__Comment__c    = CI.JBCXM__Account__r.Name+'\'s Renewal is due in 90 Days. Their current health score is '+CI.JBCXM__Account__r.AccountStatusGS__c + '.';
                A.JBCXM__Date__c       = Date.today();
                A.JBCXM__MRR__c        = ((CI.JBCXM__MRR__c) != null ? CI.JBCXM__MRR__c : 0);
                A.JBCXM__Severity__c   = GainsightDAL.GetAlertSeverityBySystemName('alertseverity3').Id;
                A.JBCXM__Status__c     = GainsightDAL.GetAlertStatusBySystemName('New Untouched').Id;
                A.JBCXM__Type__c       = GainsightDAL.GetAlertTypeBySystemName('RenewalAlert').Id;
                A.JBCXM__Reason__c     = GainsightDAL.GetAlertReasonBySystemName('Renewal90').Id ;
                
    
                AlertsToInsert.add (A);
              }



           }   

                  
                  
           if(AlertsToInsert.size() > 0) insert AlertsToInsert;

           

}
}
        } 

catch(System.CalloutException e) 

        {                          

    JBCXM__Log__c errorLog = New JBCXM__Log__c(JBCXM__ExceptionDescription__c   = 'Received a '+e.getTypeName()+' at line No. '+e.getLineNumber()+' while running the Batch to insert Alerts due to upcoming Renewals.',

                                                   JBCXM__LogDateTime__c            = datetime.now(),

                                                   JBCXM__SourceData__c             = e.getMessage(),

                                                   JBCXM__SourceObject__c           = 'JBCXM__CustomerInfo__c',

                                                   JBCXM__Type__c                   = 'GSRenewalAlertBatch');

        insert errorLog;

        system.Debug(errorLog.JBCXM__ExceptionDescription__c);

        system.Debug(errorLog.JBCXM__SourceData__c);

        }
**/
 }

global void finish(Database.BatchableContext BC)
{}
}