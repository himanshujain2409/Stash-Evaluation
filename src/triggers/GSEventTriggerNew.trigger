/****************************************************************************************
**  File:   GSEventTrigger.cls 
**  Desc:   Trigger to Create Milestones from closed CTA Events.
**          Built for Apttus
**  Auth:   Rory Sherony
**  Date:   6.23.14
*****************************************************************************************
**  Change History
**  PR  Date        Author          Description 
**  --  --------    ------------    ------------------------------------
**      11.17.14    RSherony        Modified trigger to work with CTA Events
****************************************************************************************/

trigger GSEventTriggerNew on JBCXM__CTA__c (after update, after insert) {

    try
    { 

      //Set of Milestone SystemNames
      Map<String, JBCXM__Picklist__c> MilestoneMapBySysName = new Map<String, JBCXM__Picklist__c>();
      Map<String, JBCXM__Milestone__c> ExistingMilestones = new Map<String, JBCXM__Milestone__c>();
      List<JBCXM__Milestone__c> MilestoneToUpsert = new List<JBCXM__Milestone__c>();
      List<JBCXM__Milestone__c> MilestonesToDelete = new List<JBCXM__Milestone__c>();
      Map<String, String> SystemNameMap = new Map<String, String>(); 
      Map<String,String> EventTypebyID = new Map<String,String>();
      Map<String,String> CTATypebyID = new Map<String,String>();
      Map<String,String> StatusMap = new Map<String,String>();
      //Make sure the event SystemName has a corresponding Milestone
     
      for(JBCXM__CTATypes__c CT : [SELECT Id, JBCXM__Type__c FROM JBCXM__CTATypes__c WHERE Name = 'Event' ])
      {
        CTATypebyID.put(CT.Id,CT.JBCXM__Type__c);
        system.debug('CTA Type Map: ' + CT.JBCXM__Type__c);
      }


      for(JBCXM__Picklist__c PL : [SELECT Id, JBCXM__Category__c, JBCXM__SystemName__c FROM JBCXM__Picklist__c WHERE JBCXM__Category__c IN ('Milestones', 'Alert Reason', 'Alert Status')])
      {
        if(PL.JBCXM__Category__c == 'Milestones')
        {
            MilestoneMapBySysName.put(PL.JBCXM__SystemName__c+'Event',PL);
            System.debug('Milestone Type: ' + PL.JBCXM__SystemName__c+'Event');
        }

        if(PL.JBCXM__Category__c == 'Alert Status')
        {
          StatusMap.put(PL.id, PL.JBCXM__SystemName__c);
          system.debug('Status Map: ' + StatusMap);
        }

        if(PL.JBCXM__Category__c == 'Alert Reason')
        {
          EventTypebyID.put(PL.id, PL.JBCXM__SystemName__c);
          system.debug('Reason Map: ' + EventTypebyID);
        }



        
      }      

      for(JBCXM__Milestone__c MS : [SELECT Id, JBCXM__Account__c, EventId__c, JBCXM__Date__c FROM JBCXM__Milestone__c WHERE EventID__c IN :Trigger.newMap.keySet()])
      {
        ExistingMilestones.put(MS.EventId__c,MS);
        
      }

      for(JBCXM__CTA__c EVT: Trigger.new)
      {
          system.debug(EVT);
          
          if(StatusMap.get(EVT.JBCXM__Stage__c) == 'ClosedWon')
          {
            System.debug('Complete!');
            System.debug('Event Type Exists: ' + EventTypebyID.containsKey(EVT.JBCXM__Type__c));
            
            if(CTATypebyID.containsKey(EVT.JBCXM__Type__c))
            {
                System.debug(MilestoneMapBySysName.containsKey(EventTypebyID.get(EVT.JBCXM__Type__c)));
                System.debug(EventTypebyID.get(EVT.JBCXM__Type__c));
                System.debug(EVT.JBCXM__ClosedDate__c);
                
                if(EventTypebyID.containsKey(EVT.JBCXM__Reason__c))
                {
                  if(MilestoneMapBySysName.containsKey(EventTypebyID.get(EVT.JBCXM__Reason__c)) && EVT.JBCXM__ClosedDate__c != null)
                  {
                    JBCXM__Milestone__c MS = new JBCXM__Milestone__c();
      
                    if(ExistingMilestones.containsKey(EVT.Id))
                    {
                      MS = ExistingMilestones.get(EVT.Id);
                    }
                    else
                    {
                      MS.JBCXM__Account__c = EVT.JBCXM__Account__c;
                    }
      
                    MS.EventId__c = EVT.id;
                    MS.JBCXM__Date__c = EVT.JBCXM__ClosedDate__c;
                    MS.JBCXM__Milestone__c = MilestoneMapBySysName.get(EventTypebyID.get(EVT.JBCXM__Reason__c)).id;
                    MS.JBCXM__Comment__c = EVT.JBCXM__Comments__c;
                    
                    system.debug(MS);
      
                    MilestoneToUpsert.add(MS);
                    
                    system.debug(MilestoneToUpsert);
                    system.debug(EVT);
                  }
                }
              }
          }
          else
          {
            if(ExistingMilestones.containsKey(EVT.Id))
            {
              MilestonesToDelete.add(ExistingMilestones.get(EVT.Id));
            }
          }
      }

      if(MilestoneToUpsert.size() > 0) upsert MilestoneToUpsert;
      if(MilestonesToDelete.size() > 0) delete MilestonesToDelete;

  }
    catch (Exception e) {
        JBCXM__Log__c errorLog = New JBCXM__Log__c(JBCXM__ExceptionDescription__c   = 'Received a '+e.getTypeName()+' at line No. '+e.getLineNumber()+' while running the Trigger to create Milestones from completed Events',
                                                   JBCXM__LogDateTime__c            = datetime.now(),
                                                   JBCXM__SourceData__c             = e.getMessage(),
                                                   JBCXM__SourceObject__c           = 'JBCXM__CSEvent__c',
                                                   JBCXM__Type__c                   = 'JBCXM__CSEvent__c Trigger');
        insert errorLog;
        system.Debug(errorLog.JBCXM__ExceptionDescription__c);
        system.Debug(errorLog.JBCXM__SourceData__c);
  }
}