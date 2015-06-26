/****************************************************************************************
**  File:   GainsightCaseAlertTrigger.cls 
**  Desc:   Trigger to populate Survey Participant records with Case information.
**          Built for Apttus
**  Auth:   Rory Sherony
**  Date:   4.29.14
*****************************************************************************************
**  Change History
**  PR  Date        Author          Description 
**  --  --------    ------------    ------------------------------------
****************************************************************************************/

trigger GainsightCaseSurveyTrigger on JBCXM__SurveyParticipant__c (before insert) {

    try
    {
      Map<String,Case> CaseMap = new Map<String,Case>();
      Set<String> CaseIdSet = new Set<String>();

      for(JBCXM__SurveyParticipant__c SP : Trigger.new)
      {
        CaseIdSet.add(SP.JBCXM__ContextMessage__c);
      } 

      for (Case C : [SELECT Id, Contact__r.Name FROM Case WHERE Id IN :CaseIdSet])
      {
        CaseMap.put(C.Id,C);
      }

      for(JBCXM__SurveyParticipant__c SP : Trigger.new)
      {
         if(CaseMap.containsKey(String.ValueOf(SP.JBCXM__ContextMessage__c)))
        {
          Case C = CaseMap.get(String.ValueOf(SP.JBCXM__ContextMessage__c));
          SP.Survey_Case__c = C.id;
          SP.CaseAgent__c = C.Contact__r.Name;
        }
      }

      

  }
    catch (Exception e) {
        JBCXM__Log__c errorLog = New JBCXM__Log__c(JBCXM__ExceptionDescription__c   = 'Received a '+e.getTypeName()+' at line No. '+e.getLineNumber()+' while running the Trigger to update Survey Participants from the auto Case Survey',
                                                   JBCXM__LogDateTime__c            = datetime.now(),
                                                   JBCXM__SourceData__c             = e.getMessage(),
                                                   JBCXM__SourceObject__c           = 'JBCXM__SurveyParticipant__c',
                                                   JBCXM__Type__c                   = 'JBCXM__SurveyParticipant__c Trigger');
        insert errorLog;
        system.Debug(errorLog.JBCXM__ExceptionDescription__c);
        system.Debug(errorLog.JBCXM__SourceData__c);
  }
}