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
**      11.18.14    RSherony`       Modified for Cockpit Migration
****************************************************************************************/
@isTest


private class GSEventTriggerNewTest {

    static testMethod void  GSEventTriggerNewTest() {
    
   

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
        JBCXM__PickList__c EV1 = new JBCXM__PickList__c(JBCXM__Active__c = true, JBCXM__Category__c = 'Alert Reason', JBCXM__SystemName__c = 'MST1Event', Name = 'Active');
        insert EV1;

        //Event type 2
        JBCXM__PickList__c EV2 = new JBCXM__PickList__c(JBCXM__Active__c = true, JBCXM__Category__c = 'Alert Reason', JBCXM__SystemName__c = 'MST2Event', Name = 'Active');
        insert EV2;

        JBCXM__PickList__c ST1 = new JBCXM__PickList__c(JBCXM__Active__c = true, JBCXM__Category__c = 'Alert Status', JBCXM__SystemName__c = 'ClosedWon', Name = 'Active');
        insert ST1;

        JBCXM__PickList__c ST2 = new JBCXM__PickList__c(JBCXM__Active__c = true, JBCXM__Category__c = 'Alert Status', JBCXM__SystemName__c = 'InProgress', Name = 'Active');
        insert ST2;

        JBCXM__CTATypes__c CTT = new JBCXM__CTATypes__c(JBCXM__DisplayOrder__c = 1, JBCXM__Type__c = 'Event', Name = 'Event');
        insert CTT;



        //CI Record
        JBCXM__CustomerInfo__c CI = new JBCXM__CustomerInfo__c(JBCXM__Account__c = A.Id, JBCXM__ASV__c = 0,JBCXM__MRR__c = 0, JBCXM__Status__c = plCustStat.Id);
        insert CI;

        
        //Complete Event to add Milestone
        JBCXM__CTA__c EVC = new JBCXM__CTA__c(JBCXM__Account__c = A.Id, JBCXM__Reason__c = EV1.id,   JBCXM__ClosedDate__c = date.Today(), JBCXM__Type__c = CTT.id, JBCXM__DueDate__c = date.Today(), JBCXM__Stage__c = ST1.id);
        

        //Complete Event to update Milestone
        JBCXM__CTA__c EVC2 = new JBCXM__CTA__c(JBCXM__Account__c = A.Id, JBCXM__Reason__c = EV1.id, JBCXM__ClosedDate__c = date.Today(), JBCXM__Type__c = CTT.id, JBCXM__DueDate__c = date.Today(), JBCXM__Stage__c = ST2.id);
        insert EVC2;

        //Incomplete Event to remove Milestone
        JBCXM__CTA__c EVI = new JBCXM__CTA__c(JBCXM__Account__c = A.Id, JBCXM__Reason__c = EV2.id, JBCXM__ClosedDate__c = date.Today(), JBCXM__DueDate__c = date.Today(), JBCXM__Stage__c = ST1.id, JBCXM__Type__c = CTT.id);
        insert EVI;
        
        JBCXM__CTA__c EVC3 = new JBCXM__CTA__c(JBCXM__Account__c = A.Id, JBCXM__Reason__c = EV2.id, JBCXM__ClosedDate__c = date.Today(), JBCXM__Type__c = CTT.id, JBCXM__DueDate__c = date.Today(), JBCXM__Stage__c = ST1.id);
        insert EVC3;

        //Complete Milestone to be removed
        JBCXM__Milestone__c MS1= new JBCXM__Milestone__c(JBCXM__Account__c = A.Id, JBCXM__Date__c = date.Today().addDays(-10), JBCXM__Milestone__c = MST2.id, EventId__c = EVC3.id);
        insert MS1;

        //Complete Milestone to be updated
        JBCXM__Milestone__c MS2= new JBCXM__Milestone__c(JBCXM__Account__c = A.Id, JBCXM__Date__c = date.Today().addDays(-10), JBCXM__Milestone__c = MST1.id, EventId__c = EVC2.id);
        insert MS2;
        
        
                
      
        
       
        
        Test.startTest();
        insert EVC;
        EVC2.JBCXM__Stage__c = ST1.id;
        Update EVC2;
        EVI.JBCXM__Stage__c = ST2.id;
        Update EVI;
        delete MS1;
        Test.stopTest();
        
    }
}