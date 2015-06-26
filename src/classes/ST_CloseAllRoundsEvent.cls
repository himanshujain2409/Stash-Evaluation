public class ST_CloseAllRoundsEvent {
    
    public static Contact createNewContact(Contact testContact)
    {
        testContact.pse__Is_Resource__c = true;
      	testContact.pse__Is_Resource_Active__c = true;
        testContact.LastName = 'User';
        testContact.FirstName = 'Test - ';
        testContact.LeadSource = 'Other';
        testContact.CurrencyIsoCode = 'USD';
            
        return testContact;
        
    }
  public List<Event> thisEvent;
  // Constructor
    public ST_CloseAllRoundsEvent(ApexPages.StandardController stdController) {
        Event tempEvent=(Event) stdController.getRecord();
        if (tempEvent!=null){
          try{
            thisEvent=[Select e.Id,e.WhoId,e.WhatId From Event e Where e.Id=: tempEvent.Id];
          } catch (Exception e){
        System.debug('*** Cannot create thisEvent');
          }
        }
    }
    // Method for Close All Rounds button on Event detail page
    public PageReference closeAllRoundsEventPage(){
      closeAllRoundsEvent(thisEvent);
       ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'All Rounds attached to this Contact have been closed'));
    return null;
//      return new PageReference('/' + thisEvent[0].Id);  
    }
  // Method for Close All Rounds on a list of Events
  public static void closeAllRoundsEvent(List<Event> events){
    List<Id> eventContactIds=new List<Id>();
    List<Contact> relatedContacts=new List<Contact>();
    // Create Set of all the Contact Ids named in the Events
    if (events!=null){
      for (Event e : events){
        eventContactIds.add(e.WhoId);
      }
    }
    // Add to the list of related Contacts all of the Contacts attached to Events
    if (eventContactIds!=null){
      // Create a List of the Contacts that are attached to Events
      try{
        relatedContacts=[Select c.Id From Contact c Where c.Id IN: eventContactIds];
      } catch (Exception e) {
        System.debug('*** Cannot create eventContacts');
      }
      // Close the rounds attached to any of the related contacts
      if (relatedContacts!=null){
        ST_CloseAllRoundsAccount.closeAllRoundsContact(relatedContacts);
      }
    }
  }

  // Test code for this class
  private static testMethod void testCloseAllRoundsEvent(){
    
    Account testAccount;
      Contact testContact;
      Event testEvent;
   
      testAccount = new Account();
      testAccount = (Account) ST_Utilities.Populate_sObject(testAccount);
      insert testAccount;
      testContact = new Contact();
      testContact  = createNewContact(testContact);
      //testContact = (Contact) ST_Utilities.Populate_sObject(testContact);
      testContact.AccountId = testAccount.Id;
      insert testContact;
      
      testEvent = new Event();
      testEvent = (Event)ST_Utilities.Populate_sObject(testEvent);
      testEvent.WhoId = testContact.Id;
      testEvent.DurationInMinutes=100;
      testEvent.ActivityDateTime = DateTime.Now().addDays(1);
      insert testEvent;
      
    // Start the test
    Test.startTest();
    // Go to the detail view of the Event
    Test.setCurrentPage(new PageReference('/' + testEvent.Id));
    // Click on the Close All Rounds button
    Test.setCurrentPage(Page.ST_CloseAllRoundsEvent);
    // Instantiate the controller (executes the Constructor code)
    ST_CloseAllRoundsEvent controller=new ST_CloseAllRoundsEvent(new ApexPages.StandardController(testEvent));
    // Instantiate the controller (executes the Constructor code)
//    ApexPages.StandardController stdController=new ApexPages.StandardController(testAccounts[0]));
    controller.closeAllRoundsEventPage();
    // End the test
    Test.stopTest();
  }
}