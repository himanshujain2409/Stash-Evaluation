/*
* Unit test for ACPCaseRuleSupportLevelTimeSLA class
* @author Copyright (c) 2012 Apttus.
* @author dberriel@altimetrik.com
*/ 
@isTest
private class ACPCaseRuleSupportLevelTimeSLATest {

    /* Test method to send email with cases that are marked as “critical” or customer support level is “premium”*/
    static testMethod void sendCasesMail() {
    	//Objective: code coverage to can send email.
    	Account a = ACPTestUtils.createAccount('TestAccount', 'Premium');
    	insert a;
		Contact contactTest = ACPTestUtils.createContact('TestContact', a.Id); 
        contactTest.pse__Is_Resource__c = true;
        contactTest.firstName='ACPCaseViewsControllerTest';
            contactTest.lastName='ACPCaseViewsControllerTest';
            contactTest.email = 'rbhatt@apttus.com';
		insert contactTest;
    	
    	List<Case> cases = new List<Case>();
    	
    	for(Integer i = 0; i < 10; i++){
    		Case caseTst = ACPTestUtils.createCase();
    		caseTst.ContactId = contactTest.Id;
    		caseTst.AccountId = contactTest.AccountId;
            cases.add(caseTst);
    	}
    	
    	insert cases;
    	
       test.startTest();
       ACPCaseRuleSupportLevelTimeSLA.CaseRuleSupportLevelTimeSLA();
       Test.stopTest();
    }
}