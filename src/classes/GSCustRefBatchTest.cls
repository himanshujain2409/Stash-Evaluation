/***************************************************************************************************************
**  File:   GSCustRefBatchTest.cls 
**  Desc:   Test method for Customer Reference Milestone Batch .
**          Built for Apttus
**  Auth:   Rory Sherony
**  Date:   5.26.14.14
****************************************************************************************************************
**  Change History
**  PR  Date        Author          Description 
**  --  --------    ------------    ------------------------------------
***************************************************************************************************************/

@isTest
global class GSCustRefBatchTest implements Schedulable{
    
    static testMethod void GSCustRefBatchTest()
    {

        
           JBCXM__PickList__c PL = new JBCXM__PickList__c(JBCXM__Active__c=true, JBCXM__Category__c='Customer Status', JBCXM__SystemName__c='ActiveCustomer', Name='Active');
            insert PL;
            
            JBCXM__PickList__c PL1 = new JBCXM__PickList__c(JBCXM__Active__c=true, JBCXM__Category__c='Alert Reason', JBCXM__SystemName__c='CustPart', Name='Reason');
            insert PL1;
            
            JBCXM__PickList__c PL2 = new JBCXM__PickList__c(JBCXM__Active__c=true, JBCXM__Category__c='Alert Status', JBCXM__SystemName__c='New Untouched', Name='Status');
            insert PL2;
            
            JBCXM__PickList__c PL3 = new JBCXM__PickList__c(JBCXM__Active__c=true, JBCXM__Category__c='Alert Type', JBCXM__SystemName__c='CustRef', Name='Type');
            insert PL3;
            
            JBCXM__PickList__c PL4 = new JBCXM__PickList__c(JBCXM__Active__c=true, JBCXM__Category__c='Alert Severity', JBCXM__SystemName__c='alertseverity3', Name='Severity');
            insert PL4;
            
            JBCXM__PickList__c MileS = new JBCXM__PickList__c(JBCXM__Active__c = true, JBCXM__Category__c = 'Milestone', JBCXM__SystemName__c = 'Reference', Name = 'Active');
            insert MileS;
                                    
            Account A = new Account(Name= 'Test Account');
            Insert A;
                                   
            Opportunity O = new Opportunity(AccountID=A.Id, Name = 'Test Oppty', StageName = 'Prove', CloseDate = Date.Today(), Training_Revenue__c = 4500);
            Insert O;
                          
                                                                          
            BL__BLLC_Requested_Reference__c BL = new BL__BLLC_Requested_Reference__c(BL__AccountID__c = A.id, BL__Status__c = 'Fulfilled', BL__ReferenceType__c= 'Test',BL__Opportunity__c = O.id);
            Insert BL;
                     
            BL__BLLC_Requested_Reference__c BL2 = new BL__BLLC_Requested_Reference__c(BL__AccountID__c = A.id, BL__Status__c = 'Fulfilled', BL__ReferenceType__c= 'Test',BL__Opportunity__c = O.id);
            Insert BL2;   
            
            JBCXM__Milestone__c MS = new JBCXM__Milestone__c (JBCXM__Account__c = A.id, BLID__c = BL2.id, JBCXM__Date__c = Date.Today());
            Insert MS;      
           
            JBCXM__CustomerInfo__c CI = new JBCXM__CustomerInfo__c (JBCXM__Account__c = A.id, JBCXM__ASV__c = 1200, JBCXM__MRR__c = 100, JBCXM__Status__c = PL.id);
            insert CI;
            
            System.Test.startTest();
    
            database.executebatch(new GSCustRefBatch(), 50);
    
            System.Test.stopTest();
       
        
    }

    // Test batch scheduling
    static testMethod void GSCustRefBatchSchedulableTest() 
    {
        GSCustRefBatchSchedulable m = new GSCustRefBatchSchedulable();
        string sch = '0 0 13 ? * SUN';
        system.schedule('Test Schedule', sch, m);
    }

    global void execute(SchedulableContext scMain) 
    {
        database.executebatch(new GSCustRefBatch(), 50);
    }
}