@isTest


private class GainsightCaseSurveyTriggerTest {

    static testMethod void GainsightCaseSurveyTriggerTest() {
    
   

        Account a = ACPTestUtils.createAccount('TestAccount', 'Premium');
        insert a;
        Contact C = ACPTestUtils.createContact('TestContact', a.Id); 
        insert C;

        // Customer Status
        JBCXM__PickList__c plCustStat = new JBCXM__PickList__c(JBCXM__Active__c = true, JBCXM__Category__c = 'Customer Status', JBCXM__SystemName__c = 'ActiveCustomer', Name = 'Active');
        insert plCustStat;

        //CI Record
        JBCXM__CustomerInfo__c CI = new JBCXM__CustomerInfo__c(JBCXM__Account__c = A.Id, JBCXM__ASV__c = 0,JBCXM__MRR__c = 0, JBCXM__Status__c = plCustStat.Id);
        insert CI;
        
        // Alert Type
        JBCXM__PickList__c plAlertType = new JBCXM__PickList__c(JBCXM__Active__c = true, JBCXM__Category__c = 'Alert Type', JBCXM__SystemName__c = 'CustomerConcern', Name = 'Active');
        insert plAlertType;

        // Alert Severity
        JBCXM__PickList__c plAlertSeverity = new JBCXM__PickList__c(JBCXM__Active__c = true, JBCXM__Category__c = 'Alert Severity', JBCXM__SystemName__c = 'alertseverity1', Name = 'Active');
        insert plAlertSeverity;
        
        // Alert Reason
        JBCXM__PickList__c plAlertReason = new JBCXM__PickList__c(JBCXM__Active__c = true, JBCXM__Category__c = 'Alert Reason', JBCXM__SystemName__c = 'OpenCase', Name = 'Active');
        insert plAlertReason;

        // Alert Status
        JBCXM__PickList__c plAlertStatus = new JBCXM__PickList__c(JBCXM__Active__c = true, JBCXM__Category__c = 'Alert Status', JBCXM__SystemName__c = 'Open', Name = 'Active');
        insert plAlertStatus;

       
        Case case1 = new Case(AccountId = A.Id, Severity__c = '1- Urgent- Users Cannot Function', Reason = 'Training/Best Practices Request', Origin = 'Other');
        insert case1;
        
        
        JBCXM__SurveyParticipant__c SPT = New JBCXM__SurveyParticipant__c (JBCXM__Contact__c=C.id,   JBCXM__ContextMessage__c=case1.id, JBCXM__Account__c=a.id);
        
        
        
        Test.startTest();
        insert SPT;
        Test.stopTest();
        
    }
}