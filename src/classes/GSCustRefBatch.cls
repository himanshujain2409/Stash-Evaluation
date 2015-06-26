/****************************************************************************************
**  File:   GSCustRefBatch.cls 
**  Desc:   Daily batch to create Milestones for completed customer references.
**          Built for Apttus
**  Auth:   Rory Sherony
**  Date:   5.20.14
*****************************************************************************************
**  Change History
**  PR  Date        Author          Description 
**  --  --------    ------------    ------------------------------------
****************************************************************************************/


global class GSCustRefBatch implements Database.Batchable<sObject>, Database.Stateful
{
   
            
    global void execute(SchedulableContext SC) 
    {
        database.executebatch(new GSCustRefBatch(),1);
    }
      
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        string Query = 'SELECT Id, BL__AccountID__c, Name, BL__Status__c, BL__Opportunity__c, BL__ReferenceType__c, BL__Opportunity__r.Account.Name, BL__BL_Created_On__c FROM BL__BLLC_Requested_Reference__c WHERE BL__Status__c = \'Fulfilled\' ';
        return Database.getQueryLocator(Query);
    }
    
    global void execute(Database.BatchableContext BC, List<BL__BLLC_Requested_Reference__c> scope)
    {
       
        try 
        {
            Set<Id> AcctIdSet = new Set<Id>();
            Set<Id> BLIDset= new Set<Id>(); 
            Set<Id> OldMSset= new Set<Id>(); 
            List<JBCXM__Milestone__c> MilestonesToInsert = new List<JBCXM__Milestone__c>();
            Map<String, JBCXM__Milestone__c> MSMap = new Map<String, JBCXM__Milestone__c>();
            Map<String, BL__BLLC_Requested_Reference__c> BLMap = new Map<String, BL__BLLC_Requested_Reference__c>();
            Set<Id> CustInfoSet = new Set<Id>();
            Map<string, JBCXM__CustomerInfo__c> CustInfoMap = new Map<string, JBCXM__CustomerInfo__c>();
            List<JBCXM__Alert__c> AlertsToInsert = new list<JBCXM__Alert__c>();

           for(BL__BLLC_Requested_Reference__c BL: scope)  
           {
            BLIDset.add(BL.Id);
            BLMap.put(BL.Id,BL);
            AcctIdSet.add(BL.BL__AccountID__c);
           }   

           for(JBCXM__CustomerInfo__c CI : [SELECT Id, JBCXM__Account__c, JBCXM__ASV__c, JBCXM__MRR__c FROM JBCXM__CustomerInfo__c WHERE JBCXM__Account__c IN :AcctIdSet])
           {
            CustInfoSet.add(CI.JBCXM__Account__c);
            CustInfoMap.put(CI.JBCXM__Account__c, CI);

           } 
            
           for(JBCXM__Milestone__c MS : [SELECT Id, BLID__c FROM JBCXM__Milestone__c WHERE BLID__c IN :BLIDset])
           {
            OldMSset.add(MS.BLID__c);         
           } 

           for(BL__BLLC_Requested_Reference__c BL: scope)  
           {
            if(!OldMSset.contains(BL.Id))
            {
              if(AcctIdSet.contains(BL.BL__AccountID__c))
                {
                   
                    
                  JBCXM__Milestone__c MSN = new JBCXM__Milestone__c();
    
                  MSN.JBCXM__Account__c = BL.BL__AccountID__c;
                  MSN.JBCXM__Date__c = BL.BL__BL_Created_On__c;
                  MSN.JBCXM__Opportunity__c = BL.BL__Opportunity__c;
                  MSN.JBCXM__Milestone__c = GainsightDAL.GetMilestoneAttributeBySystemName('Reference').Id;
                  MSN.BLID__c = BL.Id;
                  MSN.JBCXM__Comment__c = BL.Name+ ' fulfilled a ' +BL.BL__ReferenceType__c+ ' for an opportunity at ' +BL.BL__Opportunity__r.Account.Name ;
    
                  MilestonesToInsert.add(MSN);
                  
                  //add an alert in Gainsight
                  
                  JBCXM__CustomerInfo__c CI = CustInfoMap.get(BL.BL__AccountId__c);
                  
                  JBCXM__Alert__c alert     = new JBCXM__Alert__c();
                  
                alert.JBCXM__Account__c    = BL.BL__AccountId__c;
                alert.Name                 = 'Fulfilled Customer Reference';  
                alert.JBCXM__ASV__c        = ((CI.JBCXM__ASV__c) != null ? CI.JBCXM__ASV__c : 0);
                alert.JBCXM__Comment__c    = 'A Customer Reference has been fulfilled by '+ BL.Name+ '.';
                alert.JBCXM__Date__c       = Date.today();
                alert.JBCXM__MRR__c        = ((CI.JBCXM__MRR__c) != null ? CI.JBCXM__MRR__c : 0);
                alert.JBCXM__Severity__c   = GainsightDAL.GetAlertSeverityBySystemName('alertseverity3').Id;
                alert.JBCXM__Status__c     = GainsightDAL.GetAlertStatusBySystemName('New Untouched').Id;
                alert.JBCXM__Type__c       = GainsightDAL.GetAlertTypeBySystemName('CustRef').Id;
                alert.JBCXM__Reason__c     = GainsightDAL.GetAlertReasonBySystemName('CustPart').Id ;
                alert.JBCXM__AssociatedObjectRecordID__c = BL.Id;
    
                AlertsToInsert.add (alert);

                }
            }
           }

           if(MilestonesToInsert.size()>0) insert MilestonesToInsert;
           if(AlertsToInsert.size() > 0) insert AlertsToInsert;


        } 

catch(System.CalloutException e) 

        {                          

    JBCXM__Log__c errorLog = New JBCXM__Log__c(JBCXM__ExceptionDescription__c   = 'Received a '+e.getTypeName()+' at line No. '+e.getLineNumber()+' while running the Batch to insert Milestones from Boulder Logic customer References',

                                                   JBCXM__LogDateTime__c            = datetime.now(),

                                                   JBCXM__SourceData__c             = e.getMessage(),

                                                   JBCXM__SourceObject__c           = 'BL__BLLC_Requested_Reference__c',

                                                   JBCXM__Type__c                   = 'GSCustRefBatch');

        insert errorLog;

        system.Debug(errorLog.JBCXM__ExceptionDescription__c);

        system.Debug(errorLog.JBCXM__SourceData__c);

        }

 }

global void finish(Database.BatchableContext BC)
{}
}