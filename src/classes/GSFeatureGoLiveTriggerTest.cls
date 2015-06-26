/****************************************************************************************
**  File:   GSFeatureGoLiveTriggerTest.cls 
**  Desc:   Test method for GSFeatureGoLiveTriggerTest.cls 
**          Built for Apttus
**  Auth:   Rory Sherony
**  Date:   5.7.14
*****************************************************************************************
**  Change History
**  PR  Date        Author          Description 
**  --  --------    ------------    ------------------------------------
****************************************************************************************/

@isTest


private class  GSFeatureGoLiveTriggerTest {

    static testMethod void  GSFeatureGoLiveTriggerTest() {
    
   

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
        JBCXM__Features__c FT4 = new JBCXM__Features__c(JBCXM__Feature__c= 'CM', JBCXM__SystemName__c='GoLiveCM', JBCXM__Product__c='CM');
        insert FT4;
        JBCXM__Features__c FT5 = new JBCXM__Features__c(JBCXM__Feature__c= 'EC', JBCXM__SystemName__c='GoLiveEC', JBCXM__Product__c='EC');
        insert FT5;
        JBCXM__Features__c FT6 = new JBCXM__Features__c(JBCXM__Feature__c= 'DM', JBCXM__SystemName__c='GoLiveDM', JBCXM__Product__c='DM');
        insert FT6;
      
        //CustomerFeature
        JBCXM__CustomerFeatures__c CF = new JBCXM__CustomerFeatures__c(JBCXM__Account__c = A.id, JBCXM__Licensed__c = true, JBCXM__Features__c=FT.id);
        insert CF;
        JBCXM__CustomerFeatures__c CF2 = new JBCXM__CustomerFeatures__c(JBCXM__Account__c = A.id, JBCXM__Licensed__c = true, JBCXM__Features__c=FT2.id);
        insert CF2;
        JBCXM__CustomerFeatures__c CF3 = new JBCXM__CustomerFeatures__c(JBCXM__Account__c = A.id, JBCXM__Licensed__c = true, JBCXM__Features__c=FT3.id);
        insert CF3;
        JBCXM__CustomerFeatures__c CF4 = new JBCXM__CustomerFeatures__c(JBCXM__Account__c = A.id, JBCXM__Licensed__c = true, JBCXM__Features__c=FT4.id);
        insert CF4;
        JBCXM__CustomerFeatures__c CF5 = new JBCXM__CustomerFeatures__c(JBCXM__Account__c = A.id, JBCXM__Licensed__c = true, JBCXM__Features__c=FT5.id);
        insert CF5;
        JBCXM__CustomerFeatures__c CF6 = new JBCXM__CustomerFeatures__c(JBCXM__Account__c = A.id, JBCXM__Licensed__c = true, JBCXM__Features__c=FT6.id);
        insert CF6;
       
        
        Test.startTest();
        update CF;
        Test.stopTest();
        
    }
}