/****************************************************************************************
**  File:   GSHealthChangeBatchTest.cls
**  Desc:   Test Method for GSHealthChangeBatch.cls
**  Auth:   Rory Sherony
**  Date:   6.10.14
*****************************************************************************************
**  Change History
**  PR  Date        Author          Description 
**  --  --------    ------------    ------------------------------------
****************************************************************************************/


@isTest
global class GSHealthChangeBatchTest implements Schedulable{
    
    static testMethod void GSCustRefBatchTest()
    {

        
           JBCXM__PickList__c PL = new JBCXM__PickList__c(JBCXM__Active__c=true, JBCXM__Category__c='Customer Status', JBCXM__SystemName__c='ActiveCustomer', Name='Active');
            insert PL;
            
            
            JBCXM__ScorecardConfig__c SC = new JBCXM__ScorecardConfig__c(JBCXM__CustomerRollup__c='WEIGHT',JBCXM__HistoryTrackingFrequency__c=24,JBCXM__OverrideCustomer__c=false,JBCXM__ScorecardEnabled__c=true,Name='SCORECARD CONFIGURATION');
            insert SC;
            
            JBCXM__ScoringScheme__c SS = new JBCXM__ScoringScheme__c(JBCXM__CustomerScheme__c=true,JBCXM__From__c=0,JBCXM__IsActive__c=true,JBCXM__SystemDefined__c=true,JBCXM__To__c=100,JBCXM__Type__c='Score',Name='Numeric: 0 to 100');
            insert SS;
            
            JBCXM__ScoringSchemeDefinition__c SSD = new JBCXM__ScoringSchemeDefinition__c(JBCXM__Color__c='#eba638',JBCXM__Display__c= '#eba638',JBCXM__From__c=0,JBCXM__IsActive__c=true,JBCXM__SchemeId__c=SS.Id,JBCXM__Score__c=0,JBCXM__To__c=100,Name='#eba638');
            insert SSD; 
            
            JBCXM__ScoringSchemeDefinition__c SSD2 = new JBCXM__ScoringSchemeDefinition__c(JBCXM__Color__c='#76ad27',JBCXM__Display__c= '#76ad27',JBCXM__From__c=0,JBCXM__IsActive__c=true,JBCXM__SchemeId__c=SS.Id,JBCXM__Score__c=0,JBCXM__To__c=100,Name='#76ad27');
            insert SSD2; 
            
            JBCXM__ScoringSchemeDefinition__c SSD3 = new JBCXM__ScoringSchemeDefinition__c(JBCXM__Color__c='#c53536',JBCXM__Display__c= '#c53536',JBCXM__From__c=0,JBCXM__IsActive__c=true,JBCXM__SchemeId__c=SS.Id,JBCXM__Score__c=0,JBCXM__To__c=100,Name='#c53536');
            insert SSD3; 
            
            
            
            Account A = new Account(Name= 'Test Account');
            Insert A;
                                    
            Account A2 = new Account(Name= 'Test Account2');
            Insert A2;
            
            Account A3 = new Account(Name= 'Test Account3');
            Insert A3;
            
            JBCXM__CustomerInfo__c CI = new JBCXM__CustomerInfo__c (JBCXM__Account__c = A.id, JBCXM__ASV__c = 1200, JBCXM__MRR__c = 100, JBCXM__Status__c = PL.id, YesterdayHealthScore__c = 'Red', Health_Change_Date__c = Date.today().addDays(-20), JBCXM__CurScoreId__c = SSD.id );
            insert CI;
                                   
            JBCXM__CustomerInfo__c CI2 = new JBCXM__CustomerInfo__c (JBCXM__Account__c = A2.id, JBCXM__ASV__c = 1200, JBCXM__MRR__c = 100, JBCXM__Status__c = PL.id, YesterdayHealthScore__c = 'Green', Health_Change_Date__c = Date.today().addDays(-20), JBCXM__CurScoreId__c = SSD2.id );
            insert CI2;
                       
            JBCXM__CustomerInfo__c CI3 = new JBCXM__CustomerInfo__c (JBCXM__Account__c = A3.id, JBCXM__ASV__c = 1200, JBCXM__MRR__c = 100, JBCXM__Status__c = PL.id, YesterdayHealthScore__c = 'Yellow', Health_Change_Date__c = Date.today().addDays(-20), JBCXM__CurScoreId__c = SSD3.id );
            insert CI3;
                                  
                          
              
           
            
            
            Test.startTest();
    
            database.executebatch(new GSHealthChangeBatch(), 50);
    
            Test.stopTest();
       
        
    }

    // Test batch scheduling
    static testMethod void GSHealthChangeBatchSchedulableTest() 
    {
        GSHealthChangeBatchSchedulable m = new GSHealthChangeBatchSchedulable();
        string sch = '0 0 13 ? * SUN';
        system.schedule('Test Schedule', sch, m);
    }

    global void execute(SchedulableContext scMain) 
    {
        database.executebatch(new GSHealthChangeBatch(), 50);
    }
}