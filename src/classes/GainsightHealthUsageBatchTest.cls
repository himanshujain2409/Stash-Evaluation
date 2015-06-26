/***************************************************************************************************************
**  File:   GainsightHealthUsageBatchTest.cls 
**  Desc:   Test method for GainsightHealthUsageBatch .
**          Built for Apttus
**  Auth:   Rory Sherony
**  Date:   3.22.14            DEPRECATED
****************************************************************************************************************
**  Change History
**  PR  Date        Author          Description 
**  --  --------    ------------    -------DEPRECATED-----------------
***************************************************************************************************************/

@isTest
global class GainsightHealthUsageBatchTest implements Schedulable{
    
    static testMethod void GainsightHealthUsageBatchTest()
    {

        
           JBCXM__PickList__c PL = new JBCXM__PickList__c(JBCXM__Active__c=true, JBCXM__Category__c='Customer Status', JBCXM__SystemName__c='ActiveCustomer', Name='Active');
            insert PL;
    
            System.debug('PL: ' + PL);
            
                           
            Account A = new Account(Name= 'Test Account');
            Insert A;
            
            System.debug('A: ' + A);
            
            Account A2 = new Account(Name= 'Test Account2');
            Insert A2;
            
            System.debug('A2: ' + A2);
            
            JBCXM__ScorecardConfig__c SC = new JBCXM__ScorecardConfig__c(JBCXM__CustomerRollup__c='WEIGHT',JBCXM__HistoryTrackingFrequency__c=24,JBCXM__OverrideCustomer__c=false,JBCXM__ScorecardEnabled__c=true,Name='SCORECARD CONFIGURATION');
            insert SC;
            
            JBCXM__ScoringScheme__c SS = new JBCXM__ScoringScheme__c(JBCXM__CustomerScheme__c=true,JBCXM__From__c=0,JBCXM__IsActive__c=true,JBCXM__SystemDefined__c=true,JBCXM__To__c=100,JBCXM__Type__c='Score',Name='Numeric: 0 to 100');
            insert SS;
            
            JBCXM__ScoringSchemeDefinition__c SSD = new JBCXM__ScoringSchemeDefinition__c(JBCXM__Color__c='#4a841e',JBCXM__Display__c= '#4a841e',JBCXM__From__c=0,JBCXM__IsActive__c=true,JBCXM__SchemeId__c=SS.Id,JBCXM__Score__c=0,JBCXM__To__c=100,Name='#4a841e');
            insert SSD; 
            
            JBCXM__ScoringSchemeDefinition__c SSD2 = new JBCXM__ScoringSchemeDefinition__c(JBCXM__Color__c='#d5bf50',JBCXM__Display__c= '#d5bf50',JBCXM__From__c=0,JBCXM__IsActive__c=true,JBCXM__SchemeId__c=SS.Id,JBCXM__Score__c=0,JBCXM__To__c=100,Name='#d5bf50');
            insert SSD2; 
            
            JBCXM__CustomerInfo__c CI = new JBCXM__CustomerInfo__c(JBCXM__Account__c=A.Id, JBCXM__Status__c = PL.Id, JBCXM__ASV__c = 1000, JBCXM__CurScoreId__c = SSD.id );
            Insert CI;
            
            System.debug('CI: ' + CI); 
            
            JBCXM__CustomerInfo__c CI2 = new JBCXM__CustomerInfo__c(JBCXM__Account__c=A2.Id, JBCXM__Status__c = PL.Id, JBCXM__ASV__c = 1000, JBCXM__CurScoreId__c = SSD2.id );
            Insert CI2;
            
            System.debug('CI2: ' + CI2); 
                                        
            Case CS = new Case(AccountId = A.id, Status = 'New');
            Insert CS;
            
            System.debug('CS: ' + CS);
            
            JBCXM__UsageData__c UD = new JBCXM__UsageData__c(Name='ACCOUNTLEVEL',  JBCXM__WeekLabel__c = Date.Today().toStartOfWeek().addDays(-7) , JBCXM__Account__c = A.Id,JBCXM__Date__c = Date.Today().toStartOfWeek().addDays(-7));
            Insert UD;
            
            System.debug('UD: ' + UD);
            
            JBCXM__ApplicationSettings__c appSetObj = new JBCXM__ApplicationSettings__c(JBCXM__AdoptionAggregationType__c = 'USERLEVEL', JBCXM__AdoptionGranularity__c ='WEEKLY', JBCXM__AdoptionAggregationColumns__c = '[]', JBCXM__AdoptionMeasureColMap__c = '{}');
            insert appSetObj;
        
            Test.startTest();
    
            database.executebatch(new GainsightHealthUsageBatch(), 50);
    
            Test.stopTest();
       
        
    }

    // Test batch scheduling
    static testMethod void GainsightHealthUsageBatchSchedulableTest() 
    {
        GainsightHealthUsageBatchSchedulable m = new GainsightHealthUsageBatchSchedulable();
        string sch = '0 0 13 ? * SUN';
        system.schedule('Test Schedule', sch, m);
    }

    global void execute(SchedulableContext scMain) 
    {
        database.executebatch(new GainsightHealthUsageBatch(), 50);
    }
}