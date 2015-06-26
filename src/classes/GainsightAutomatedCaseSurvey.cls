/****************************************************************************************
**  File:   Gainsight Automated Case Survey.cls
**  Desc:   Daily Batch to survey closed Case Contacts
**  Auth:   Rob Begley
**  Date:   4.24.14
*****************************************************************************************
**  Change History
**  PR  Date        Author          Description 
**  --  --------    ------------    ------------------------------------
****************************************************************************************/

global class GainsightAutomatedCaseSurvey implements Database.Batchable<sObject>, Database.Stateful
{
    private final DateTime TodayDateTime;

    public GainsightAutomatedCaseSurvey(Date pDate)
    {
        TodayDateTime = DateTime.newInstanceGMT(pDate.addDays(-1),Time.newInstance(12, 0, 0, 0));
    }

    public GainsightAutomatedCaseSurvey()
    {
        TodayDateTime = DateTime.newInstanceGMT(Date.today().addDays(-1),Time.newInstance(12, 0, 0, 0));
    }

    global void execute(SchedulableContext SC) 
    {
        database.executebatch(new GainsightAutomatedCaseSurvey(),1);
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        string Query = 'SELECT Id,AccountId,Case_Category__c,ContactId FROM Case WHERE  ClosedDate >= ' + TodayDateTime.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
        System.debug(Query);
        return Database.getQueryLocator(Query);
    }

    global void execute(Database.BatchableContext BC, List<Case> scope)
    {
        try 
        {
            //Check for Custom Setting
            if(CaseSurvey__c.getValues('CaseSurvey') != null)
            {
                System.debug('Step 1');
                CaseSurvey__c CS = CaseSurvey__c.getValues('CaseSurvey');

                //See if Survey is Active via Custom Setting
                if(CS.Active__c && CS.DateRange__c >= 0)
                {
                    System.debug('Step 2');
                    List<String> SplitList = CS.Case_Category_exclusion__c != null ? CS.Case_Category_exclusion__c.split('~') : new List<String>();
                    Set<String> ExcludedCategories = new Set<String>();
                    ExcludedCategories.addAll(SplitList);
                    Set<String> AccountIds = new Set<String>();
                    Set<String> ContactIds = new Set<String>();
                    Set<String> CustomerInfoAccounts = new Set<String>();
                    Set<String> AlreadySurveyed = new Set<String>();
                    List<JBCXM.LaunchSurveyObject> SurveyList = new List<JBCXM.LaunchSurveyObject>();


                    for(Case C : scope)
                    {
                        System.debug('Step 3');
                        AccountIds.add(C.AccountId);
                        ContactIds.add(C.ContactId);
                    }
                    
                    for(JBCXM__CustomerInfo__c CI : [SELECT Id,JBCXM__Account__c FROM JBCXM__CustomerInfo__c WHERE JBCXM__Account__c IN :AccountIds])
                    {
                        System.debug('Step 4');
                        CustomerInfoAccounts.add(CI.JBCXM__Account__c);
                    }

                    for(JBCXM__SurveyParticipant__c SP : [SELECT JBCXM__Contact__c FROM JBCXM__SurveyParticipant__c WHERE JBCXM__Contact__c IN :ContactIds AND JBCXM__EmailSentDate__c >= :TodayDateTime.addDays(1).addDays(Integer.valueOf(CS.DateRange__c) * -1)])
                    {
                        System.debug('Step 5');
                        AlreadySurveyed.add(SP.JBCXM__Contact__c);
                    }

                    for(Case C : scope)
                    {
                        //Make sure Case Category is valid and Account is a Customer in Gainsight
                        if(!ExcludedCategories.contains(C.Case_Category__c) && CustomerInfoAccounts.contains(C.AccountId))
                        {
                            System.debug('Step 6');
                            if(!AlreadySurveyed.contains(C.ContactId))
                            {
                                System.debug('Step 7');
                                JBCXM.LaunchSurveyObject LS = new JBCXM.LaunchSurveyObject();

                                LS.relatedId = C.Id;

                                LS.ContactObj = new Contact();
                                LS.ContactObj.id = C.ContactId;
                        

                                LS.AccountObj = new Account();
                                LS.AccountObj.id = C.AccountId;
                              

                                LS.contextMessage = C.Id;
                               

                                SurveyList.add(LS);
                            }
                        }
                    }

                    if(SurveyList.size() > 0 )
                    {
                        System.debug('Step 8');
                        String status = JBCXM.LaunchSurveyEmailController.launchSurveyInternal('CaseSat', SurveyList);
                    }
                }
            }
        }
        catch (Exception e) {
            JBCXM__Log__c errorLog = New JBCXM__Log__c(JBCXM__ExceptionDescription__c   = 'Received a ' + e.getTypeName() + ' at line No. ' + e.getLineNumber() + ' while running the Batch to send Case Closure Survey.',
                                                       JBCXM__LogDateTime__c            = datetime.now(),
                                                       JBCXM__SourceData__c             = e.getMessage(),
                                                       JBCXM__SourceObject__c           = 'JBCXM__CustomerInfo__c',
                                                       JBCXM__Type__c                   = 'GainsightAutomatedCaseSurvey');
            insert errorLog;
            system.Debug(errorLog.JBCXM__ExceptionDescription__c);
        }
    }
    
    global void finish(Database.BatchableContext BC)
    {
        
    }
    
}