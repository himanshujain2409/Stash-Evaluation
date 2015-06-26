/******************************

** File:    GainsightCaseSurveyBatchTest.cls

** Desc:    Test Method for GainsightAutomatedCaseSurvey

** Auth:    Rory Sherony

** Date:    4.30.14

**************************

** Change History

**************************

** PR   Date        Author   Description

** --   --------    -------  ------------------------------------

** 

*******************************/
@isTest
global class GainsightCaseSurveyBatchTest implements Schedulable{
    
    static testMethod void GainsightCaseSurveyBatchTest()
    {

        // ------------------------------ BEGIN SETUP ------------------------------ //
     /*   Account A = new Account(Name= 'Test Account');
        Insert A;
        
        Contact C = new Contact(AccountId=A.Id, FirstName='Ron', LastName='Swanson', Email='RSwanson@myhero.com');
        Insert C;
        
        Contact CT = new Contact(AccountId=A.Id, FirstName='Ronald', LastName='Reagan', Email='Reagan@notarepublican.com');
        Insert CT;
                
        CaseSurvey__c ACS = new CaseSurvey__c(Name= 'CaseSurvey' , Case_Category_exclusion__c = '',  Active__c=true, DateRange__c = 30);
        Insert ACS;
        
               
        Case CS = new Case(AccountId=A.Id, Contact__c = CT.Id, ContactId = C.Id, Case_Category__c = 'other', Status = 'Closed Confirmed');
        Insert CS;
                                  
        JBCXM__PickList__c PL = new JBCXM__PickList__c(JBCXM__Active__c=true, JBCXM__Category__c='Customer Status', JBCXM__SystemName__c='ActiveCustomer', Name='Active');
        insert PL;
        
        JBCXM__PickList__c PL2 = new JBCXM__PickList__c(JBCXM__Active__c=true, JBCXM__Category__c='Customer Stage', JBCXM__SystemName__c='stage1', Name='New Business');
        insert PL2;
        
        JBCXM__PickList__c PL3 = new JBCXM__PickList__c(JBCXM__Active__c = true, JBCXM__Category__c = 'Order Type', JBCXM__SystemName__c = 'New Business', Name = 'New Business');
        insert PL3;
          
        JBCXM__CustomerInfo__c CI = new JBCXM__CustomerInfo__c(JBCXM__Account__c=A.Id, JBCXM__ASV__c = 0,JBCXM__MRR__c = 0, JBCXM__Stage__c = PL2.Id, JBCXM__Status__c = PL.Id );
        Insert CI;
        
         */     
         Account acc = new Account(Name = 'Test Account12345');
        acc.BillingCountry = 'United States';        
        insert acc;
        
        Contact cnt = new Contact(); 
        cnt.LastName = 'Test Contact12345';
        cnt.AccountId = acc.Id;
        insert cnt;
        Case Testcase = new Case();
        Testcase.Status = 'New';
        Testcase.Origin = 'Phone';
        Testcase.Contact = cnt;
        Testcase.Account = acc;
        Testcase.Subject = 'Test Case';
        Testcase.Description = 'Test Case';
        insert Testcase;
        
         CaseSurvey__c ACS = new CaseSurvey__c(Name= 'CaseSurvey' , Case_Category_exclusion__c = '',  Active__c=true, DateRange__c = 30);
        Insert ACS;
         CaseSurvey__c ACS1 = new CaseSurvey__c(Name= 'CaseSurvey1' , Case_Category_exclusion__c = '',  Active__c=true, DateRange__c = 28);
        Insert ACS1;
         CaseSurvey__c ACS2 = new CaseSurvey__c(Name= 'CaseSurvey2' , Case_Category_exclusion__c = '',  Active__c=true, DateRange__c = 29);
        Insert ACS2;
        JBCXM__PickList__c PL = new JBCXM__PickList__c(JBCXM__Active__c=true, JBCXM__Category__c='Customer Status', JBCXM__SystemName__c='ActiveCustomer', Name='Active');
            insert PL;
            
            //Alert Type
            JBCXM__PickList__c PLA = new JBCXM__PickList__c(JBCXM__Active__c=true, JBCXM__Category__c='Alert Status', JBCXM__SystemName__c='New Untouched', Name='Active');
            insert PLA;

            //Alert Severity 3
            JBCXM__PickList__c PLAS3 = new JBCXM__PickList__c(JBCXM__Active__c=true, JBCXM__Category__c='Alert Severity', JBCXM__SystemName__c='alertseverity3', Name='Active');
            insert PLAS3;

            //Alert Severity 2
            JBCXM__PickList__c PLAS2 = new JBCXM__PickList__c(JBCXM__Active__c=true, JBCXM__Category__c='Alert Severity', JBCXM__SystemName__c='alertseverity2', Name='Active');
            insert PLAS2;
            
            //Alert Reason 30
            JBCXM__PickList__c PLAR30 = new JBCXM__PickList__c(JBCXM__Active__c=true, JBCXM__Category__c='Alert Reason', JBCXM__SystemName__c='Renewal30', Name='Active');
            insert PLAR30;

            //Alert Reason 45
            JBCXM__PickList__c PLAR45 = new JBCXM__PickList__c(JBCXM__Active__c=true, JBCXM__Category__c='Alert Reason', JBCXM__SystemName__c='Renewal45', Name='Active');
            insert PLAR45;

            //Alert Reason 60
            JBCXM__PickList__c PLAR60 = new JBCXM__PickList__c(JBCXM__Active__c=true, JBCXM__Category__c='Alert Reason', JBCXM__SystemName__c='Renewal60', Name='Active');
            insert PLAR60;

            //Alert Reason 90
            JBCXM__PickList__c PLAR90 = new JBCXM__PickList__c(JBCXM__Active__c=true, JBCXM__Category__c='Alert Reason', JBCXM__SystemName__c='Renewal90', Name='Active');
            insert PLAR90;

            //Alert Type
            JBCXM__PickList__c PLAT = new JBCXM__PickList__c(JBCXM__Active__c=true, JBCXM__Category__c='Alert Type', JBCXM__SystemName__c='RenewalAlert', Name='Active');
            insert PLAT;



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
             
            Contact C = new Contact(LastName = 'name', AccountId= a.Id, CurrencyIsoCode = 'USD'); 
            insert C;                 
            Account A2 = new Account(Name= 'Test Account2');
            Insert A2;
            
            Account A3 = new Account(Name= 'Test Account3');
            Insert A3;
            
            Account A4 = new Account(Name= 'Test Account4');
            Insert A4;

            JBCXM__CustomerInfo__c CI = new JBCXM__CustomerInfo__c (JBCXM__Account__c = A.id, JBCXM__ASV__c = 1200, JBCXM__MRR__c = 100, JBCXM__Status__c = PL.id, YesterdayHealthScore__c = 'Red', JBCXM__NextRenewalDate__c = Date.today().addDays(90), JBCXM__CurScoreId__c = SSD.id );
            insert CI;
                                   
            JBCXM__CustomerInfo__c CI2 = new JBCXM__CustomerInfo__c (JBCXM__Account__c = A2.id, JBCXM__ASV__c = 1200, JBCXM__MRR__c = 100, JBCXM__Status__c = PL.id, YesterdayHealthScore__c = 'Green', JBCXM__NextRenewalDate__c = Date.today().addDays(60), JBCXM__CurScoreId__c = SSD2.id );
            insert CI2;
                       
            JBCXM__CustomerInfo__c CI3 = new JBCXM__CustomerInfo__c (JBCXM__Account__c = A3.id, JBCXM__ASV__c = 1200, JBCXM__MRR__c = 100, JBCXM__Status__c = PL.id, YesterdayHealthScore__c = 'Yellow', JBCXM__NextRenewalDate__c = Date.today().addDays(45), JBCXM__CurScoreId__c = SSD3.id );
            insert CI3;
                                  
            JBCXM__CustomerInfo__c CI4 = new JBCXM__CustomerInfo__c (JBCXM__Account__c = A3.id, JBCXM__ASV__c = 1200, JBCXM__MRR__c = 100, JBCXM__Status__c = PL.id, YesterdayHealthScore__c = 'Yellow', JBCXM__NextRenewalDate__c = Date.today().addDays(30), JBCXM__CurScoreId__c = SSD3.id );
            insert CI4;             
              
             JBCXM__SurveyParticipant__c SPT = New JBCXM__SurveyParticipant__c (JBCXM__Contact__c=C.id,   JBCXM__ContextMessage__c=Testcase.id, JBCXM__Account__c=a.id);
        
			insert SPT;
            

        
        
        
                

        // ------------------------------- END SETUP ------------------------------- //


        Test.startTest();
        date myDate = date.newInstance(2015,04, 17);
		GainsightAutomatedCaseSurvey gain=new GainsightAutomatedCaseSurvey(myDate);
        GainsightAutomatedCaseSurvey gain1=new GainsightAutomatedCaseSurvey();
        SchedulableContext SCC ;
        gain.execute(SCC);
        Database.BatchableContext BC ;
        gain1.start(BC);
        List<Case> scope =new List<Case>();
        
        
        scope.add(Testcase);
        gain1.execute(BC, scope);
        database.executebatch(new GainsightAutomatedCaseSurvey(), 50);
        gain1.finish(BC);

        Test.stopTest();
        
        
        
    }

    // Test batch scheduling
    static testMethod void GainsightCaseSurveyBatchSchedulableTest() 
    {
        GainsightCaseSurveyBatchSchedulable m = new GainsightCaseSurveyBatchSchedulable();
        string sch = '0 0 13 ? * SUN';
        system.schedule('Test Schedule', sch, m);
    }

    global void execute(SchedulableContext scMain) 
    {
        database.executebatch(new GainsightAutomatedCaseSurvey(), 50);
    }
}