/****************************************************************************************
**  File:   GSHealthCheckEventBatch.cls 
**  Desc:   Daily batch to create Health Check Events.
**          Built for Apttus
**  Auth:   Rory Sherony
**  Date:   7.20.14        DEPRECATED
*****************************************************************************************
**  Change History
**  PR  Date        Author          Description 
**  --  --------    ------------    ------------------------------------
****************************************************************************************/


global class GSHealthCheckEventBatch implements Database.Batchable<sObject>, Database.Stateful
{
   
            
    global void execute(SchedulableContext SC) 
    {
        database.executebatch(new GSHealthCheckEventBatch(),1);
    }
      
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
          string Query = 'SELECT JBCXM__Account__c, JBCXM__Date__c, JBCXM__Opportunity__c, JBCXM__Account__r.CSM__c ,JBCXM__Account__r.JBCXM__CustomerInfo__r.JBCXM__Status__r.JBCXM__SystemName__c, JBCXM__Account__r.Name ,JBCXM__Account__r.JBCXM__CustomerInfo__r.JBCXM__Stage__r.JBCXM__SystemName__c FROM JBCXM__Milestone__c WHERE JBCXM__Milestone__r.JBCXM__SystemName__c LIKE \'GoLive%\'';
        return Database.getQueryLocator(Query);
    }
    
    global void execute(Database.BatchableContext BC, List<JBCXM__Milestone__c> scope)
    {
       /**
        try 
        {
        
    
//Check for Custom Setting
if(GainsightAutomation__c.getValues('GainsightAutomation') != null)
{

GainsightAutomation__c GA = GainsightAutomation__c.getValues('GainsightAutomation');

//Check for Active via Custom Setting
if(GA.HealthCheckEvent__c = true)
{
           
            List<JBCXM__CSEvent__c> EventsToInsert = new List<JBCXM__CSEvent__c>();
            Map<String, String> EventPicklistMap = new Map<String, String>();

           for(JBCXM__Picklist__c PL : [SELECT Id, JBCXM__SystemName__c FROM JBCXM__PickList__c WHERE JBCXM__Category__c = 'SalesRep Name']) 
           {
            EventPicklistMap.put(PL.JBCXM__SystemName__c, PL.Id);
            system.debug(EventPicklistMap);
           }

           for(JBCXM__Milestone__c TH: scope)  
           {
              
               Integer DaysBetween = TH.JBCXM__Date__c.date().daysBetween(date.Today());
               system.debug(DaysBetween);
             if(DaysBetween == 15)
              {

                  //add an EVENT in Gainsight for 30 days after Renewal
                  
                                    
                  JBCXM__CSEvent__c EV = new JBCXM__CSEvent__c();
                  
                EV.JBCXM__Account__c    = TH.JBCXM__Account__c;
                EV.JBCXM__Assigned__c   = TH.JBCXM__Account__r.CSM__c;
                EV.Name                 = '30 Day Health Check';  
                EV.JBCXM__Date__c       = Date.today().addDays(+15);
                EV.JBCXM__Status__c     = 'Open';
                EV.JBCXM__Type__c       = EventPicklistMap.get('30DayHCEvent');
                EV.JBCXM__IsRecurrence__c = false;
                EV.JBCXM__IsChild__c      = false;
                EV.JBCXM__Description__c = TH.JBCXM__Account__r.Name+'\'s Health Check. ';
                EV.JBCXM__Priority__c   = 'Medium';
    
                EventsToInsert.add (EV);
                system.debug('30');
              }

           
              if(DaysBetween == 45)
              {

                  //add an EVENT in Gainsight for 60 days after Renewal
                  
                                    
                  JBCXM__CSEvent__c EV = new JBCXM__CSEvent__c();
                  
                EV.JBCXM__Account__c    = TH.JBCXM__Account__c;
                EV.JBCXM__Assigned__c   = TH.JBCXM__Account__r.CSM__c;
                EV.Name                 = '60 Day Health Check';  
                EV.JBCXM__Date__c       = Date.today().addDays(+15);
                EV.JBCXM__Status__c     = 'Open';
                EV.JBCXM__Type__c       = EventPicklistMap.get('60DayHCEvent');
                EV.JBCXM__IsRecurrence__c = false;
                EV.JBCXM__IsChild__c      = false;
                EV.JBCXM__Description__c = TH.JBCXM__Account__r.Name+'\'s Health Check. ';
                EV.JBCXM__Priority__c   = 'Medium';
    
                EventsToInsert.add (EV);
                system.debug('60');
              }
              
                
             if(DaysBetween == 75)
              {

                  //add an alert in Gainsight for 90 days After Renewal
                  
                                    
                                    
                  JBCXM__CSEvent__c EV = new JBCXM__CSEvent__c();
                  
                EV.JBCXM__Account__c    = TH.JBCXM__Account__c;
                EV.JBCXM__Assigned__c   = TH.JBCXM__Account__r.CSM__c;
                EV.Name                 = '90 Day Health Check';  
                EV.JBCXM__Date__c       = Date.today().addDays(+15);
                EV.JBCXM__Status__c     = 'Open';
                EV.JBCXM__Type__c       = EventPicklistMap.get('90DayHCEvent');
                EV.JBCXM__IsRecurrence__c = false;
                EV.JBCXM__IsChild__c      = false;
                EV.JBCXM__Description__c = TH.JBCXM__Account__r.Name+'\'s Health Check. ';
                EV.JBCXM__Priority__c   = 'Medium';
    
                EventsToInsert.add (EV);
                system.debug('90');
              }

           
              

             
           }   

                  
                  
           if(EventsToInsert.size() > 0) insert EventsToInsert;

           system.debug('EventsToInsert');

}
}
        } 

catch(System.CalloutException e) 

        {                          

    JBCXM__Log__c errorLog = New JBCXM__Log__c(JBCXM__ExceptionDescription__c   = 'Received a '+e.getTypeName()+' at line No. '+e.getLineNumber()+' while running the Batch to insert Health CHeck Events.',

                                                   JBCXM__LogDateTime__c            = datetime.now(),

                                                   JBCXM__SourceData__c             = e.getMessage(),

                                                   JBCXM__SourceObject__c           = 'JBCXM__TransHeader__c',

                                                   JBCXM__Type__c                   = 'GSHealthCheckEventBatch');

        insert errorLog;

        system.Debug(errorLog.JBCXM__ExceptionDescription__c);

        system.Debug(errorLog.JBCXM__SourceData__c);

        }
**/
 }

global void finish(Database.BatchableContext BC)
{}
}