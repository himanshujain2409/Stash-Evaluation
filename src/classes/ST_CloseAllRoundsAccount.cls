public class ST_CloseAllRoundsAccount {
  public List<Account> thisAccount;
  // Constructor
    public ST_CloseAllRoundsAccount(ApexPages.StandardController stdController) {
        Account tempAccount=(Account) stdController.getRecord();
        if (tempAccount!=null){
          try{
            thisAccount=[Select a.Id From Account a Where a.Id=: tempAccount.Id];
          } catch (Exception e){
        System.debug('*** Cannot create thisAccount');
          }
        }
    }
    // Method for the Close All Rounds button on the Account detail page
    public PageReference closeAllRoundsAccountPage(){
      closeAllRoundsAccount(thisAccount);
       ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'All Rounds attached to this Account have been closed'));
       return null;
//      return new PageReference('/' + thisAccount[0].Id);  
    }
    // Method for Close All Rounds on a list of Accounts
  public static void closeAllRoundsAccount(List<Account> accounts){
    // Get the list of Contacts attached to this Account
    if (accounts!=null){
      try{
        List<Contact> relatedContacts=[Select c.Id From Contact c Where c.Account.Id IN: accounts];
        closeAllRoundsContact(relatedContacts);
      } catch (Exception e){
        System.debug('*** Cannot create relatedContacts');
      }
    }
  }
  // Method for Close All Rounds attached to a list of Contacts
  public static void closeAllRoundsContact(List<Contact> contacts){
    if (contacts!=null){
      // Get the list of Rounds attached to these Contacts
      try{
        List<FRLS_Round__c> relatedRounds=[Select r.Id,r.Name,r.Task__c,r.Contact__c From FRLS_Round__c r Where r.Contact__c IN: contacts Order By r.CreatedDate Desc];
        closeAllRounds(relatedRounds);
      } catch (Exception e){
        System.debug('*** Cannot create relatedRounds');
      }
    }
  }
  // Method to Close a List of Rounds
  public static void closeAllRounds(List<FRLS_Round__c> rounds){
    Boolean miSkipped=False;
    FRLS_Round__c tempRound=new FRLS_Round__c();
    List<FRLS_Round__c> addRounds=new List<FRLS_Round__c>();
    if (rounds!=null){
      List<FRLS_Round__c> roundsToUpdate=new List<FRLS_Round__c>();
      for (FRLS_Round__c r : rounds){
        if (r.Name=='Open Round'){
          if (miSkipped==False && r.Task__c=='MI'){
            // Create a new non-MI closed round
            tempRound=new FRLS_Round__c();
            tempRound.Name='Closed Round';
            tempRound.Contact__c=r.Contact__c;
            tempRound.Task__c='Do Not Call';
            addRounds.add(tempRound);
            // Close the MI round, but don't change the task field
            r.Name='Closed Round';
            roundsToUpdate.add(r);
            // Set the flag
            miSkipped=True;
          } else {
            // Close the round and change the task field to Do Not Call
            r.Name='Closed Round';
            r.Task__c='Do Not Call';
            roundsToUpdate.add(r);
          }
        }
      }
      Try{
        if (roundsToUpdate.isEmpty()==false){
          // Update all rounds except the first MI
          update roundsToUpdate;
        }
        if (addRounds.isEmpty()==False){
          // If an MI was skipped, insert a new Closed Round
          insert addRounds;            
        }
      } Catch (Exception e){
        // Do nothing
      }
    }
  }
  
  // Test code for this class
  private static testMethod void testCloseAllRoundsAccount(){
    Account testAccount;
      Contact testContact;
   
      testAccount = new Account();
      testAccount = (Account) ST_Utilities.Populate_sObject(testAccount);
      insert testAccount;
      testContact = new Contact();
      testContact = (Contact) ST_Utilities.Populate_sObject(testContact);
      testContact.AccountId = testAccount.Id;
      insert testContact;
    // Create an MI Round on the Contact
    FRLS_Round__c testRound=new FRLS_Round__c();
    testRound.Name='Open Round';
    testRound.Task__c='MI';
    testRound.Contact__c=testContact.Id;
    testRound.Callback_Date__c=date.today();
    insert testRound;
    // Start the test
    Test.startTest();
    // Run the method on a test list of Accounts
    List<Account> testAccounts = [Select a.Id From Account a Where a.Id=: testContact.AccountId];
    if (testAccounts!=null){
      closeAllRoundsAccount(testAccounts);
    }
    // Go to the detail view of the Account
    Test.setCurrentPage(new PageReference('/' + testContact.AccountId));
    // Click on the Close All Rounds button
    Test.setCurrentPage(Page.ST_CloseAllRoundsAccount);
    // Instantiate the controller (executes the Constructor code)
    ST_CloseAllRoundsAccount controller=new ST_CloseAllRoundsAccount(new ApexPages.StandardController(testAccounts[0]));
    // Instantiate the controller (executes the Constructor code)
//    ApexPages.StandardController stdController=new ApexPages.StandardController(testAccounts[0]));
    controller.closeAllRoundsAccountPage();
    // End the test
    Test.stopTest();
  }  
}