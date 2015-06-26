@isTest
public with sharing class ST_OppNew_Test
{
  // Test code for this class
   private static testMethod void testOppNew(){
      CreateTestData();
      
      // Start the test
      Test.startTest();
      // Go to the detail view of the Event
      Test.setCurrentPage(new PageReference('/' + testEvent.Id));
      // Click on the Create Opportunity button (takes you to the ST_OppNew page)
      Test.setCurrentPage(Page.ST_OppNew);
      // Instantiate the controller (executes the Constructor code)
      ST_OppNew controller=new ST_OppNew(new ApexPages.StandardController(testEvent));
      // Run all of the methods related to the Close Entire Account selection
      controller.cancelOpp();
      controller.getItems();
      controller.getCloseEntireAccount();
      controller.setCloseEntireAccount('y');
      // Click on the Create Opportunity button
      controller.createOpp();
      // End the test
      Test.stopTest();
   }
   private static testMethod void testLinkMIEvent(){
      CreateTestData();
      // Clone the testOpp
      Opportunity testOppClone=testOpp.clone(false, true);
      // Modify the testOppClone to reference the Event Id
      testOppClone.MI_Event_Id__c=testEvent.Id;
      testOppClone.AccountId=testContact.AccountId;
      testOppClone.Close_Entire_Account__c='y';
      Map<String, Schema.SObjectField> fieldMap = Opportunity.getSObjectType().getDescribe().fields.getMap();
      for(Schema.SObjectField field : fieldMap.values())
      {
         if(field.getDescribe().getName()=='Additional_Rep_Percentage__c')
            testOppClone.put('Additional_Rep_Percentage__c', 0.3);
      }
      // Start the test
      Test.startTest();
      // Insert testOppClone (should run the trigger)
      insert testOppClone;
      // End the test
      Test.stopTest();
   }
   
   private static testMethod void testUtil()
   {
     ST_Utilities.getCreatableFieldsSOQL('Account', ' Id<>null ');
   }

   private static Account testAccount;
   private static Contact testContact;
   private static Opportunity testOpp;
   private static Event testEvent;
   
   private static void CreateTestData()
   {
    testAccount = new Account();
    testAccount = (Account) ST_Utilities.Populate_sObject(testAccount);
    insert testAccount;
    testContact = new Contact();
    testContact = (Contact) ST_Utilities.Populate_sObject(testContact);
    testContact.AccountId = testAccount.Id;
    insert testContact;
    testOpp = new Opportunity();
    testOpp = (Opportunity)ST_Utilities.Populate_sObject((sObject)testOpp);
    testOpp.AccountId = testAccount.Id;
    insert testOpp;
    testEvent = new Event();
    testEvent = (Event)ST_Utilities.Populate_sObject(testEvent);
    testEvent.WhoId = testContact.Id;
    testEvent.WhatId = testOpp.Id;
    testEvent.DurationInMinutes=100;
    testEvent.ActivityDateTime = DateTime.Now().addDays(1);
    insert testEvent;
   }
}