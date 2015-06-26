/*
* Controller for ApttusCustomerPortalFAQSection page
* @author Copyright (c) 2012 Apttus.
* @author dberriel@altimetrik.com
*/

public with sharing class ACPFAQController {
	
	public List<ACP_FAQ__c> faqs{get; set;}
	
	public ACPFAQController(){
		faqs = [SELECT Visible_On_Customer_Portal__c, Question__c, 
				Name, Id, Category__c, Answer__c 
				FROM ACP_FAQ__c
				ORDER BY Category__c desc, Name asc];
	}
	
	/*Test method to the class*/
	
	static testmethod void testFAQVisibleOnPortal(){
		ACP_FAQ__c faq = new ACP_FAQ__c();
		faq.Question__c = 'Test question?';
		faq.Answer__c = 'Test Answer';
		test.startTest();
		insert faq;
		ACPFAQController fController = new ACPFAQController();
		List<ACP_FAQ__c> testList = fController.faqs;
		System.assert(testList.get(0).Visible_On_Customer_Portal__c==true);
		test.stopTest();
		
	}
	
	static testmethod void testFAQNotVisibleOnPortal(){
		ACP_FAQ__c faq = new ACP_FAQ__c();
		faq.Question__c = 'Test question?';
		faq.Answer__c = 'Test Answer';
		faq.Visible_On_Customer_Portal__c = false;
		test.startTest();
		insert faq;
		ACPFAQController fController = new ACPFAQController();
		List<ACP_FAQ__c> testList = fController.faqs;
		System.assert(testList.get(0).Visible_On_Customer_Portal__c==false);
		test.stopTest();
		
	}
}