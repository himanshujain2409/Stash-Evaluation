/****************************************************************************************
**  File:   GSEventTrigger.cls 
**  Desc:   Trigger to Create Milestones from closed Events.
**          Built for Apttus
**  Auth:   Rory Sherony
**  Date:   6.23.14                DEPRECATED
*****************************************************************************************
**  Change History
**  PR  Date        Author          Description 
**  --  --------    ------------    ----------DEPRECATED------------------
****************************************************************************************/

trigger GSEventTrigger on JBCXM__CSEvent__c (after update, after insert) {
/**
    try
    { 
//Check for Custom Setting
if(GainsightAutomation__c.getValues('GainsightAutomation') != null)
{

GainsightAutomation__c GA = GainsightAutomation__c.getValues('GainsightAutomation');

//Check for Active via Custom Setting
if(GA.Event_to_Milestones__c = true)
{
      //Set of Milestone SystemNames
      Map<String, JBCXM__Picklist__c> MilestoneMapBySysName = new Map<String, JBCXM__Picklist__c>();
      Map<String, JBCXM__Milestone__c> ExistingMilestones = new Map<String, JBCXM__Milestone__c>();
      List<JBCXM__Milestone__c> MilestoneToUpsert = new List<JBCXM__Milestone__c>();
      List<JBCXM__Milestone__c> MilestonesToDelete = new List<JBCXM__Milestone__c>();
      Map<String, String> SystemNameMap = new Map<String, String>(); 
      Map<String,String> EventTypebyID = new Map<String,String>();
      //Make sure the event SystemName has a corresponding Milestone
     
      for(JBCXM__Picklist__c PL : [SELECT Id, JBCXM__Category__c, JBCXM__SystemName__c FROM JBCXM__Picklist__c WHERE JBCXM__Category__c IN ('Milestones','SalesRep Name')])
      {
        if(PL.JBCXM__Category__c == 'Milestones')
        {
            MilestoneMapBySysName.put(PL.JBCXM__SystemName__c+'Event',PL);
            System.debug('Milestone Type: ' + PL.JBCXM__SystemName__c+'Event');
        }
        else if(PL.JBCXM__Category__c == 'SalesRep Name')
        {
            EventTypebyID.put(PL.Id,PL.JBCXM__SystemName__c);
            System.debug('Event Type: ' + PL.JBCXM__SystemName__c);
        }
        
      }      

      for(JBCXM__Milestone__c MS : [SELECT Id, JBCXM__Account__c, EventId__c, JBCXM__Date__c FROM JBCXM__Milestone__c WHERE EventID__c IN :Trigger.newMap.keySet()])
      {
        ExistingMilestones.put(MS.EventId__c,MS);
        
      }

      for(JBCXM__CSEvent__c EVT: Trigger.new)
      {
          system.debug(EVT);
          
          if(EVT.JBCXM__Status__c == 'Complete')
          {
            System.debug('Complete!');
            System.debug('Event Type Exists: ' + EventTypebyID.containsKey(EVT.JBCXM__Type__c));
            
            if(EventTypebyID.containsKey(EVT.JBCXM__Type__c))
            {
                System.debug(MilestoneMapBySysName.containsKey(EventTypebyID.get(EVT.JBCXM__Type__c)));
                System.debug(EventTypebyID.get(EVT.JBCXM__Type__c));
                System.debug(EVT.JBCXM__CompletionDate__c);
            
                if(MilestoneMapBySysName.containsKey(EventTypebyID.get(EVT.JBCXM__Type__c)) && EVT.JBCXM__CompletionDate__c != null)
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
                  MS.JBCXM__Date__c = EVT.JBCXM__CompletionDate__c;
                  MS.JBCXM__Milestone__c = MilestoneMapBySysName.get(EventTypebyID.get(EVT.JBCXM__Type__c)).id;
                  MS.JBCXM__Comment__c = EVT.Name;
                  
                  system.debug(MS);
    
                  MilestoneToUpsert.add(MS);
                  
                  system.debug(MilestoneToUpsert);
                  system.debug(EVT);
                }
              }
          }
          else if(EVT.JBCXM__Status__c != 'Complete')
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
}
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
  **/
}