/****************************************************************************************
**  File:   GainsightCaseAlertTrigger.cls 
**  Desc:   Trigger to create Alerts for Cases where type is "Users cannot function" or "Major functionality impairment".
**          Built for Apttus
**  Auth:   Rory Sherony
**  Date:   3.5.14                    DEPRECATED
*****************************************************************************************
**  Change History
**  PR  Date        Author          Description 
**  --  --------    ------------    -----------DEPRECATED------------------------
****************************************************************************************/

trigger GainsightCaseAlertTrigger on Case (after update, after insert) {
/**
    try
  
  {
        //Check for Custom Setting
            if(GainsightAutomation__c.getValues('GainsightAutomation') != null)
            {
                
                GainsightAutomation__c GA = GainsightAutomation__c.getValues('GainsightAutomation');

                //Check for Active via Custom Setting
                if(GA.CaseAlerts__c = true)
                {
    Set<id> AccountIDSet = new Set<id>();
    Map<string, JBCXM__Alert__c> AlertMap = new Map<string, JBCXM__Alert__c>();
    List<Case> CaseList = Trigger.New;
    Set<Id> CaseIds = (Trigger.isDelete) ? Trigger.oldMap.keySet() : Trigger.newMap.keySet();
    List<JBCXM__Alert__c> AlertsToInsert = new list<JBCXM__Alert__c>();

    
    for(case c : CaseList)
    {
      AccountIDSet.add(c.AccountId);
    } 

    map<string, JBCXM__CustomerInfo__c> CustInfoMap = new map<string, JBCXM__CustomerInfo__c>();

    for (JBCXM__CustomerInfo__c CI : [SELECT Id,JBCXM__ASV__c,JBCXM__MRR__c,JBCXM__Account__c FROM JBCXM__CustomerInfo__c WHERE JBCXM__Account__c in :AccountIDSet ])
    {
      CustInfoMap.put(CI.JBCXM__Account__c, CI);

    }

    for (JBCXM__Alert__c A : [SELECT Id,JBCXM__Account__c,JBCXM__Comment__c,JBCXM__Date__c,JBCXM__MRR__c,JBCXM__Severity__c,JBCXM__Status__c,JBCXM__Type__c,JBCXM__Reason__c,JBCXM__AssociatedObjectRecordID__c FROM JBCXM__Alert__c WHERE JBCXM__AssociatedObjectRecordID__c in :CaseIds ])
    {
      AlertMap.put(A.JBCXM__AssociatedObjectRecordID__c, A);

    }
   
    for(case c : CaseList)
    {
      
        if(c.accountid != null && c.Severity__c == '1- Urgent- Users Cannot Function' || c.accountid != null && c.Severity__c == '2- Major Functionality Impairment' )
        {
          if(CustInfoMap.containskey (c.AccountId))
          {  

            JBCXM__CustomerInfo__c CI = CustInfoMap.get(c.AccountId);

            JBCXM__Alert__c alert     = new JBCXM__Alert__c();

            if(AlertMap.containsKey(c.Id))
            {
                alert = AlertMap.get(c.Id);
            }
            else
            {
                alert.JBCXM__Account__c    = c.AccountId;
            }

            alert.Name              = 'A Severe Case has been logged';  
                
            alert.JBCXM__ASV__c        = ((CI.JBCXM__ASV__c) != null ? CI.JBCXM__ASV__c : 0);
            alert.JBCXM__Comment__c    = 'A Severe Case has been logged and needs to be reviewed.<br><br><a target="_blank" href="' + URL.getSalesforceBaseUrl().toExternalForm().replace('-api','') + '/' + C.Id + '">Case ' + C.CaseNumber + '</a>';
            alert.JBCXM__Date__c      = Date.today();
            alert.JBCXM__MRR__c        = ((CI.JBCXM__MRR__c) != null ? CI.JBCXM__MRR__c : 0);
            alert.JBCXM__Severity__c  = GainsightDAL.GetAlertSeverityBySystemName('alertseverity1').Id;
            alert.JBCXM__Status__c      = GainsightDAL.GetAlertStatusBySystemName('Open').Id;
            alert.JBCXM__Type__c      = GainsightDAL.GetAlertTypeBySystemName('CustomerConcern').Id;
            alert.JBCXM__Reason__c     = (GainsightDAL.GetAlertReasonBySystemName('OpenCase') != null) ? GainsightDAL.GetAlertReasonBySystemName('OpenCase').Id : '';
            alert.JBCXM__AssociatedObjectRecordID__c = C.Id;

            AlertsToInsert.add (alert);
        
          }
        
      } 
    
    }

    if(AlertsToInsert.size() > 0) insert AlertsToInsert;
    
}
}
  }
    catch (Exception e) {
        JBCXM__Log__c errorLog = New JBCXM__Log__c(JBCXM__ExceptionDescription__c   = 'Received a '+e.getTypeName()+' at line No. '+e.getLineNumber()+' while running the Trigger to create alerts from Severe Cases',
                                                   JBCXM__LogDateTime__c            = datetime.now(),
                                                   JBCXM__SourceData__c             = e.getMessage(),
                                                   JBCXM__SourceObject__c           = 'Case',
                                                   JBCXM__Type__c                   = 'GainsightCaseAlertTrigger Trigger');
        insert errorLog;
        system.Debug(errorLog.JBCXM__ExceptionDescription__c);
        system.Debug(errorLog.JBCXM__SourceData__c);
  }**/
}