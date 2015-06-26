/****************************************************************************************
**  File:   GSEventTriggerTest.cls 
**  Desc:   Test Method for GSEventTriggerTest.cls.
**          Built for Apttus
**  Auth:   Rory Sherony
**  Date:   6.30.14
*****************************************************************************************
**  Change History
**  PR  Date        Author          Description 
**  --  --------    ------------    ------------------------------------
****************************************************************************************/
@isTest


private class GSEventTriggerTest {

    static testMethod void  GSEventTriggerTest() {
    
   

        Account A = new Account(Name = 'TestAccount');
        insert A;
        

        // Customer Status
        JBCXM__PickList__c plCustStat = new JBCXM__PickList__c(JBCXM__Active__c = true, JBCXM__Category__c = 'Customer Status', JBCXM__SystemName__c = 'ActiveCustomer', Name = 'Active');
        insert plCustStat;

        //Milestone type 1
        JBCXM__PickList__c MST1 = new JBCXM__PickList__c(JBCXM__Active__c = true, JBCXM__Category__c = 'Milestones', JBCXM__SystemName__c = 'MST1', Name = 'Active');
        insert MST1;

        //Milestone type 2
        JBCXM__PickList__c MST2 = new JBCXM__PickList__c(JBCXM__Active__c = true, JBCXM__Category__c = 'Milestones', JBCXM__SystemName__c = 'MST2', Name = 'Active');
        insert MST2;

        //Event type 1
        JBCXM__PickList__c EV1 = new JBCXM__PickList__c(JBCXM__Active__c = true, JBCXM__Category__c = 'SalesRep Name', JBCXM__SystemName__c = 'MST1Event', Name = 'Active');
        insert EV1;

        //Event type 2
        JBCXM__PickList__c EV2 = new JBCXM__PickList__c(JBCXM__Active__c = true, JBCXM__Category__c = 'SalesRep Name', JBCXM__SystemName__c = 'MST2Event', Name = 'Active');
        insert EV2;



        //CI Record
        JBCXM__CustomerInfo__c CI = new JBCXM__CustomerInfo__c(JBCXM__Account__c = A.Id, JBCXM__ASV__c = 0,JBCXM__MRR__c = 0, JBCXM__Status__c = plCustStat.Id);
        insert CI;

        
        //Complete Event to add Milestone
        JBCXM__CSEvent__c EVC = new JBCXM__CSEvent__c(JBCXM__Account__c = A.Id, JBCXM__CompletionDate__c = date.Today(), JBCXM__Date__c = date.Today(), JBCXM__Status__c = 'Complete', JBCXM__Type__c = EV1.id);
        

        //Complete Event to update Milestone
        JBCXM__CSEvent__c EVC2 = new JBCXM__CSEvent__c(JBCXM__Account__c = A.Id, JBCXM__CompletionDate__c = date.Today(), JBCXM__Date__c = date.Today(), JBCXM__Status__c = 'Complete', JBCXM__Type__c = EV1.id);
        insert EVC2;

        //Incomplete Event to remove Milestone
        JBCXM__CSEvent__c EVI = new JBCXM__CSEvent__c(JBCXM__Account__c = A.Id, JBCXM__CompletionDate__c = date.Today(), JBCXM__Date__c = date.Today(), JBCXM__Status__c = 'In Progress', JBCXM__Type__c = EV2.id);
        insert EVI;

        //Complete Milestone to be removed
        JBCXM__Milestone__c MS1= new JBCXM__Milestone__c(JBCXM__Account__c = A.Id, JBCXM__Date__c = date.Today().addDays(-10), JBCXM__Milestone__c = MST2.id, EventId__c = EVI.id);
        insert MS1;

        //Complete Milestone to be updated
        //JBCXM__Milestone__c MS2= new JBCXM__Milestone__c(JBCXM__Account__c = A.Id, JBCXM__Date__c = date.Today().addDays(-11), JBCXM__Milestone__c = MST1.id, EventId__c = EVC2.id);
        //insert MS2;
        
        
                
      
        
       
        
        Test.startTest();
        insert EVC;
        update EVC2;
        update EVI;
        Test.stopTest();
        
    }
}