/****************************************************************************************
**  File:   GSFeatureGoLiveTrigger.cls 
**  Desc:   Trigger to update features in Gainsight and on the Account.
**          Built for Apttus
**  Auth:   Rory Sherony
**  Date:   5.7.14
*****************************************************************************************
**  Change History
**  PR  Date        Author          Description 
**  --  --------    ------------    ------------------------------------
****************************************************************************************/

trigger GSFeatureGoLiveTrigger on JBCXM__CustomerFeatures__c (before insert, after update) {

    try
    {
      Map<String,String> FeatureMap = new Map<String,String>();
      Map<String, Map<String,Boolean>> CustFeatureAcctMap = new Map<String, Map<String,Boolean>>();
      List<Account> AccountToUpdate = new List<Account>();

      //Query Features
      for(JBCXM__Features__c FT: [SELECT Id, JBCXM__SystemName__c FROM JBCXM__Features__c ])
      {
        FeatureMap.put(FT.id, FT.JBCXM__SystemName__c);
      }

     for( JBCXM__CustomerFeatures__c CF : Trigger.new)
     {
      //New Customer Feature Map
      Map<String,Boolean> TempMap = new Map<String,Boolean>();

      //Check if Account already has Customer Feature Map
      if(CustFeatureAcctMap.containsKey(CF.JBCXM__Account__c))
      {
        TempMap = CustFeatureAcctMap.get(CF.JBCXM__Account__c);
      }

      //If Feature exists
      if(FeatureMap.containsKey(CF.JBCXM__Features__c))
      {
        //Add Customer Feature to Customer Feature Map
        TempMap.put(FeatureMap.get(CF.JBCXM__Features__c), CF.JBCXM__Licensed__c);
      }

      //Add Feature Map for Account
      CustFeatureAcctMap.put(CF.JBCXM__Account__c,TempMap);
     }
      

     for(Account A : [SELECT Id, PurchasedCPQ__c,PurchasedCM__c,PurchasedAWA__c,PurchasedXA__c,PurchasedEC__c,PurchasedDM__c,PurchasedRevenue__c,PurchasedRenewal__c FROM Account WHERE id IN :CustFeatureAcctMap.keyset()])
      {
        //Check if Account already has Customer Feature Map
        if(CustFeatureAcctMap.containsKey(A.id))
        {
          Map<String,Boolean> TempMap = CustFeatureAcctMap.get(A.id);

          if(TempMap.containsKey('GoLiveCPQ'))
          {
            A.PurchasedCPQ__c = TempMap.get('GoLiveCPQ');
          }

          if(TempMap.containsKey('GoLiveCM'))
          {
            A.PurchasedCM__c = TempMap.get('GoLiveCM');
          }

          if(TempMap.containsKey('GoLiveAWA'))
          {
            A.PurchasedAWA__c = TempMap.get('GoLiveAWA');
          }

          if(TempMap.containsKey('GoLiveXA'))
          {
            A.PurchasedXA__c = TempMap.get('GoLiveXA');
          }

          if(TempMap.containsKey('GoLiveEC'))
          {
            A.PurchasedEC__c = TempMap.get('GoLiveEC');
          }
          
          if(TempMap.containsKey('GoLiveSRM'))
          {
            A.PurchasedSRM__c = TempMap.get('GoLiveSRM');
          }

          if(TempMap.containsKey('GoLiveDM'))
          {
            A.PurchasedDM__c = TempMap.get('GoLiveDM');
          }

          if(TempMap.containsKey('GoLiveRevenue'))
          {
            A.PurchasedRevenue__c = TempMap.get('GoLiveRevenue');
          }

          if(TempMap.containsKey('GoLiveRenewal'))
          {
            A.PurchasedRenewal__c = TempMap.get('GoLiveRenewal');
          }
          
          AccountToUpdate.add(A);

        }
      }

      if(AccountToUpdate.size() > 0)
      {
        update AccountToUpdate;
      }

    }
    catch (Exception e) {
        JBCXM__Log__c errorLog = New JBCXM__Log__c(JBCXM__ExceptionDescription__c   = 'Received a '+e.getTypeName()+' at line No. '+e.getLineNumber()+' while running the Trigger to populate Accounts from Features',
                                                   JBCXM__LogDateTime__c            = datetime.now(),
                                                   JBCXM__SourceData__c             = e.getMessage(),
                                                   JBCXM__SourceObject__c           = 'JBCXM__Features__c',
                                                   JBCXM__Type__c                   = 'JBCXM__Features__c Trigger');
        insert errorLog;
        system.Debug(errorLog.JBCXM__ExceptionDescription__c);
        system.Debug(errorLog.JBCXM__SourceData__c);
  }
}