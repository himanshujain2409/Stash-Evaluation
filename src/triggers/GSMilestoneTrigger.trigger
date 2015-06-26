/****************************************************************************************
**  File:   GSMilestoneTrigger.cls 
**  Desc:   Trigger to update features in Gainsight and on the Account.
**          Built for Apttus
**  Auth:   Rory Sherony
**  Date:   5.7.14
*****************************************************************************************
**  Change History
**  PR  Date        Author          Description 
**  --  --------    ------------    ------------------------------------
****************************************************************************************/

trigger GSMilestoneTrigger on JBCXM__Milestone__c (before insert) {

    try
    {
      Map<String,JBCXM__CustomerFeatures__c> CustomerFeatureMap = new Map<String,JBCXM__CustomerFeatures__c>();
      Set<String> AcctIDset = new Set<String>();
      Set<String> UpdatedAccountSet = new Set<String>();
      Set<String> MilestoneTypeSet = new Set<String>();
      Map<String,String> FeatureMap = new Map<String,String>();
      List<JBCXM__CustomerFeatures__c> CFToUpsert = new List<JBCXM__CustomerFeatures__c>();
      List<Account> AccountsToUpdate = new List<Account>();
      Map<String, Account> AccountMap = new Map<String, Account>();
      Map<String,String> GoLivePicklistMap = new Map<String,String>();

      for (JBCXM__Picklist__c PL : [SELECT Id,JBCXM__SystemName__c FROM JBCXM__Picklist__c WHERE JBCXM__Category__c = 'Milestones' AND JBCXM__SystemName__c LIKE 'GoLive%'])
      {
        GoLivePicklistMap.put(PL.id,PL.JBCXM__SystemName__c);
      }

      for(JBCXM__Milestone__c MS : Trigger.new)
      {
        if(GoLivePicklistMap.containsKey(MS.JBCXM__Milestone__c))
        {
          AcctIDset.add(MS.JBCXM__Account__c);
          MilestoneTypeSet.add(GoLivePicklistMap.get(MS.JBCXM__Milestone__c));
        }
      }

      //Query Accounts store in map (key is Id, value = Account)
      for(Account A : [SELECT Id, GS_CPQLDate__c,GS_CMLDate__c,GS_AWALDate__c,GS_SRMLDate__c,GS_XALDate__c FROM Account WHERE Id IN :AcctIDset])
      {
        AccountMap.put(A.Id, A);
      }

      //Map of Features (Products)
      for(JBCXM__Features__c F : [SELECT Id,JBCXM__SystemName__c FROM JBCXM__Features__c WHERE JBCXM__SystemName__c IN :MilestoneTypeSet])
      {
        FeatureMap.put(F.JBCXM__SystemName__c,F.Id);
      }

      //Map of Customer Features to Update
      for (JBCXM__CustomerFeatures__c CF : [SELECT Id, JBCXM__Account__c, JBCXM__Enabled__c, JBCXM__Licensed__c, JBCXM__Features__c, JBCXM__Features__r.JBCXM__SystemName__c FROM JBCXM__CustomerFeatures__c WHERE JBCXM__Account__c IN :AcctIDset])
      {
        CustomerFeatureMap.put(CF.JBCXM__Account__c + '~' + CF.JBCXM__Features__r.JBCXM__SystemName__c,CF);
      }

      for(JBCXM__Milestone__c MS : Trigger.new)
      {
        if(GoLivePicklistMap.containsKey(MS.JBCXM__Milestone__c) && FeatureMap.containsKey(GoLivePicklistMap.get(MS.JBCXM__Milestone__c)))
        {
          JBCXM__CustomerFeatures__c CF = new JBCXM__CustomerFeatures__c();

          if(CustomerFeatureMap.containsKey(MS.JBCXM__Account__c + '~' + GoLivePicklistMap.get(MS.JBCXM__Milestone__c)))
          {
            CF = CustomerFeatureMap.get(MS.JBCXM__Account__c + '~' + GoLivePicklistMap.get(MS.JBCXM__Milestone__c));
          }
          else
          {
            CF.JBCXM__Account__c = MS.JBCXM__Account__c;
          }

          CF.JBCXM__Comment__C = 'Go Live Date - ' + MS.JBCXM__Date__c.DateGMT().format();
          CF.JBCXM__Enabled__c = true;
          CF.JBCXM__Licensed__c = true;
          CF.JBCXM__Features__c = FeatureMap.get(GoLivePicklistMap.get(MS.JBCXM__Milestone__c));

          //if AccountMap contains Milestone Account Id, grab it and update the fields and put in back in map , make another set of accoutn ids that are updated
          if(AccountMap.containsKey(MS.JBCXM__Account__c))
          {
            Account A = AccountMap.get(MS.JBCXM__Account__c);
            
            
            
            if(GoLivePicklistMap.get(MS.JBCXM__Milestone__c) == 'GoLiveCPQ')
            {
              A.GS_CPQLDate__c = MS.JBCXM__Date__c.dateGMT();
            }
            else if(GoLivePicklistMap.get(MS.JBCXM__Milestone__c) == 'GoLiveCM') 
            {
              A.GS_CMLDate__c =  MS.JBCXM__Date__c.dateGMT();
            }
            else if(GoLivePicklistMap.get(MS.JBCXM__Milestone__c) == 'GoLiveAWA') 
            {
              A.GS_AWALDate__c =  MS.JBCXM__Date__c.dateGMT();
            }
            else if(GoLivePicklistMap.get(MS.JBCXM__Milestone__c) == 'GoLiveSRM') 
            {
              A.GS_SRMLDate__c =  MS.JBCXM__Date__c.dateGMT();
            }
            else if(GoLivePicklistMap.get(MS.JBCXM__Milestone__c) == 'GoLiveXA') 
            {
              A.GS_XALDate__c =  MS.JBCXM__Date__c.dateGMT();
            }
            else if(GoLivePicklistMap.get(MS.JBCXM__Milestone__c) == 'GoLiveDM') 
            {
              A.GS_DMLDate__c =  MS.JBCXM__Date__c.dateGMT();
            }
            else if(GoLivePicklistMap.get(MS.JBCXM__Milestone__c) == 'GoLiveEC') 
            {
              A.GS_ECLDate__c =  MS.JBCXM__Date__c.dateGMT();
            }
            else if(GoLivePicklistMap.get(MS.JBCXM__Milestone__c) == 'GoLiveRenewal') 
            {
              A.GS_RenewalLDate__c =  MS.JBCXM__Date__c.dateGMT();
            }
            else if(GoLivePicklistMap.get(MS.JBCXM__Milestone__c) == 'GoLiveRevenue') 
            {
              A.GS_RevenueLDate__c =  MS.JBCXM__Date__c.dateGMT();
            }

            AccountMap.put(A.Id,A);
            UpdatedAccountSet.add(A.Id);
          }

          CFToUpsert.add(CF);
        }
      }
      
      for(String S: UpdatedAccountSet)
      {
        if(AccountMap.containsKey(S))
        {
          AccountsToUpdate.add(AccountMap.get(S));
        }
        
      }

      if(AccountsToUpdate.size() > 0) update AccountsToUpdate;
      if(CFToUpsert.size() > 0) upsert CFToUpsert;


      

  }
    catch (Exception e) {
        JBCXM__Log__c errorLog = New JBCXM__Log__c(JBCXM__ExceptionDescription__c   = 'Received a '+e.getTypeName()+' at line No. '+e.getLineNumber()+' while running the Trigger to populate Features from Milestones',
                                                   JBCXM__LogDateTime__c            = datetime.now(),
                                                   JBCXM__SourceData__c             = e.getMessage(),
                                                   JBCXM__SourceObject__c           = 'JBCXM__Milestone__c',
                                                   JBCXM__Type__c                   = 'JBCXM__Milestone__c Trigger');
        insert errorLog;
        system.Debug(errorLog.JBCXM__ExceptionDescription__c);
        system.Debug(errorLog.JBCXM__SourceData__c);
  }
}