/******************************
** File:    GSHealthCheckEventBatchTest.cls
** Desc:    Test Method for GSHealthCheckEventBatch
** Auth:    Rory Sherony
** Date:    7.20.14    DEPRECATED
**************************

** Change History

**************************

** PR   Date        Author   Description

** --   --------    -------  ------------------------------------
                    DEPRECATED
** 

*******************************/
@isTest
global class GSHealthCheckEventBatchhTest implements Schedulable{
    
    static testMethod void GSHealthCheckEventBatchTest()
    {

        // ------------------------------ BEGIN SETUP ------------------------------ //
                
        Account A = new Account(Name= 'Test Account' );
        Insert A;
                
                                   
        JBCXM__PickList__c PL = new JBCXM__PickList__c(JBCXM__Active__c=true, JBCXM__Category__c='Customer Status', JBCXM__SystemName__c='ActiveCustomer', Name='Active');
        insert PL;
        
        JBCXM__PickList__c PL2 = new JBCXM__PickList__c(JBCXM__Active__c=true, JBCXM__Category__c='Customer Stage', JBCXM__SystemName__c='stage1', Name='New Business');
        insert PL2;
        
        JBCXM__PickList__c PL3 = new JBCXM__PickList__c(JBCXM__Active__c = true, JBCXM__Category__c = 'Milestone', JBCXM__SystemName__c = 'GoLiveCPQ', Name = 'Go Live CPQ');
        insert PL3;
        
        JBCXM__PickList__c PL30 = new JBCXM__PickList__c(JBCXM__Active__c = true, JBCXM__Category__c = 'SalesRep Name', JBCXM__SystemName__c = '30HayHCEvent', Name = '30Day Health Check');
        insert PL30;
        
        JBCXM__PickList__c PL60 = new JBCXM__PickList__c(JBCXM__Active__c = true, JBCXM__Category__c = 'SalesRep Name', JBCXM__SystemName__c = '60HayHCEvent', Name = '60Day Health Check');
        insert PL60;
                
        JBCXM__PickList__c PL90 = new JBCXM__PickList__c(JBCXM__Active__c = true, JBCXM__Category__c = 'SalesRep Name', JBCXM__SystemName__c = '90HayHCEvent', Name = '90Day Health Check');
        insert PL90;
          
        JBCXM__CustomerInfo__c CI = new JBCXM__CustomerInfo__c(JBCXM__Account__c=A.Id, JBCXM__ASV__c = 0,JBCXM__MRR__c = 0, JBCXM__Stage__c = PL2.Id, JBCXM__Status__c = PL.Id );
        Insert CI;
        
         JBCXM__Milestone__c TH30 = new JBCXM__Milestone__c(JBCXM__Account__c=A.Id, JBCXM__Date__c=Datetime.now().addDays(-15), JBCXM__Milestone__c = PL3.id);
         JBCXM__Milestone__c TH60 = new JBCXM__Milestone__c(JBCXM__Account__c=A.Id, JBCXM__Date__c=Datetime.now().addDays(-45), JBCXM__Milestone__c = PL3.id);
         JBCXM__Milestone__c TH90 = new JBCXM__Milestone__c(JBCXM__Account__c=A.Id, JBCXM__Date__c=Datetime.now().addDays(-75), JBCXM__Milestone__c = PL3.id);
        Insert TH30;
        Insert TH60;
        Insert TH90;
        
        
        
        
                

        // ------------------------------- END SETUP ------------------------------- //


        Test.startTest();

        database.executebatch(new GSHealthCheckEventBatch(), 50);

        Test.stopTest();
        
        
        
    }

    // Test batch scheduling
    static testMethod void GSHealthCheckEventSchedulableTest() 
    {
        GSHealthCheckEventSchedulable m = new GSHealthCheckEventSchedulable();
        string sch = '0 0 13 ? * SUN';
       // String sch = '0 50 15 * * *';
        system.schedule('Test Schedule', sch, m);
    }

    global void execute(SchedulableContext scMain) 
    {
        database.executebatch(new GSHealthCheckEventBatch(), 50);
    }
}