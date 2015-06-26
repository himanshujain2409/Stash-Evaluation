@isTest


private class GSMilestoneTriggerTest {

    static testMethod void  GSMilestoneTriggerTest() {
    
   

        Account A = new Account(Name = 'TestAccount');
        insert A;
        

        // Customer Status
        JBCXM__PickList__c plCustStat = new JBCXM__PickList__c(JBCXM__Active__c = true, JBCXM__Category__c = 'Customer Status', JBCXM__SystemName__c = 'ActiveCustomer', Name = 'Active');
        insert plCustStat;

        //CI Record
        JBCXM__CustomerInfo__c CI = new JBCXM__CustomerInfo__c(JBCXM__Account__c = A.Id, JBCXM__ASV__c = 0,JBCXM__MRR__c = 0, JBCXM__Status__c = plCustStat.Id);
        insert CI;
        
        // Milestone Type
        JBCXM__PickList__c plMSType = new JBCXM__PickList__c(JBCXM__Active__c = true, JBCXM__Category__c = 'Milestones', JBCXM__SystemName__c = 'GoLiveCPQ', Name = 'CPQ');
        insert plMSType;
        
                
      
        //Feature
        JBCXM__Features__c FT = new JBCXM__Features__c(JBCXM__Feature__c= 'CPQ', JBCXM__SystemName__c='GoLiveCPQ', JBCXM__Product__c='CPQ');
        insert FT;
        JBCXM__Features__c FT2 = new JBCXM__Features__c(JBCXM__Feature__c= 'AWA', JBCXM__SystemName__c='GoLiveAWA', JBCXM__Product__c='AWA');
        insert FT2;
        JBCXM__Features__c FT3 = new JBCXM__Features__c(JBCXM__Feature__c= 'XA', JBCXM__SystemName__c='GoLiveXA', JBCXM__Product__c='XA');
        insert FT3;
      
        //CustomerFeature
        JBCXM__CustomerFeatures__c CF = new JBCXM__CustomerFeatures__c(JBCXM__Account__c = A.id, JBCXM__Licensed__c = true, JBCXM__Features__c=FT.id);
        insert CF;
        
        JBCXM__CustomerFeatures__c CF2 = new JBCXM__CustomerFeatures__c(JBCXM__Account__c = A.id, JBCXM__Licensed__c = true, JBCXM__Features__c=FT2.id);
        insert CF2;
        
        JBCXM__CustomerFeatures__c CF3 = new JBCXM__CustomerFeatures__c(JBCXM__Account__c = A.id, JBCXM__Licensed__c = true, JBCXM__Features__c=FT3.id);
        insert CF3;
        
        JBCXM__Milestone__c MS = new JBCXM__Milestone__c(JBCXM__Account__c = A.id, JBCXM__Date__c = Datetime.now(), JBCXM__Milestone__c = plMSType.id);
       
        
        Test.startTest();
        insert MS;
        Test.stopTest();
        
    }
}