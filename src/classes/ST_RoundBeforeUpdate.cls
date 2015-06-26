public class ST_RoundBeforeUpdate {
  public static void calcCallbackDate(List<FRLS_Round__c> updatedRounds){
    // Loop through the Rounds
    for(FRLS_Round__c cr : updatedRounds){
      if (cr.Callback_Date__c==null && cr.Task__c!='Do Not Call'){
        if (cr.Task__c=='Callback'){
          cr.Callback_Date__c=addBusinessDays(Date.today(),3);
        } else if (cr.Task__c=='Hot'){
          cr.Callback_Date__c=addBusinessDays(Date.today(),1);
        } else if (cr.Task__c=='Recycle'){
          cr.Callback_Date__c=addBusinessDays(Date.today(),30);
        }
      } else if (cr.Callback_Date__c!=null && cr.Task__c=='Do Not Call'){
        cr.Callback_Date__c=null;
      }
    }
  }
  public static void setAccountLookup(List<FRLS_Round__c> updatedRounds){
    Set<Id> uniqueContactIds=new Set<Id>();
    List<Contact> contactObjs=new List<Contact>();
    Map<Id,Id> mapContactIdToAccountId=new Map<Id,Id>();
    // Loop through the Rounds to get the unique Contacts
    for(FRLS_Round__c cr : updatedRounds){
      if (cr.Contact__c!=null){
        uniqueContactIds.add(cr.Contact__c);
      }
    }
    if (uniqueContactIds.isEmpty()==False){
      // Look up the AccountIds on the uniqueContacts
      Try {
        contactObjs=[Select c.Id,c.AccountId From Contact c Where c.Id IN: uniqueContactIds];
      } catch (Exception e){
        // Do nothing
      }
      if (contactObjs.isEmpty()==False){
        // Create the map from ContactId->AccountId
        for(Contact cc:contactObjs){
          mapContactIdToAccountId.put(cc.Id, cc.AccountId);
        }
        // Loop through the Rounds and set the Account lookup field
        for(FRLS_Round__c cr : updatedRounds){
          if (cr.Contact__c!=null){
            cr.Account__c=mapContactIdToAccountId.get(cr.Contact__c);
          }
        }
      }
    }
  }
    public static Boolean isWeekendDay(Date dateParam)
    {
       boolean result     = false;
        
       //Recover the day of the week
       Date startOfWeek   = dateParam.toStartOfWeek();
//       Integer dayOfWeek  = dateParam.day() - startOfWeek.day();
//  Original dayOfWeek line above... corrected line below
       Integer dayOfWeek  = startOfWeek.daysBetween(date.newInstance(dateParam.year(),dateParam.month(),dateParam.day()));
       System.debug('startOfWeek: ' + startOfWeek); 
           
       result = dayOfWeek == 0 || dayOfWeek == 6 ? true : false;
       System.debug('dayOfWeek: ' + dayOfWeek); 
       return result;
    } 
    
    
    public static Date addBusinessDays(Date StartDate, integer BusinessDaysToAdd )
    {
       //Add or decrease in BusinessDaysToAdd days 
       Date finalDate = StartDate;
       
       integer direction = BusinessDaysToAdd < 0 ? -1 : 1;

        while(BusinessDaysToAdd != 0)
        {
            finalDate = finalDate.AddDays(direction);            
            
            if (!isWeekendDay(finalDate))
            {
                BusinessDaysToAdd -= direction;
            }
        }

        return finalDate;
    }
    
  // Test code for this class
  private static testMethod void testRoundBeforeUpdate(){
    Account testAccount;
      Contact testContact;
   
      testAccount = new Account();
      testAccount = (Account) ST_Utilities.Populate_sObject(testAccount);
      insert testAccount;
      testContact = new Contact();
      testContact = (Contact) ST_Utilities.Populate_sObject(testContact);
      testContact.AccountId = testAccount.Id;
      insert testContact;
    // Create a test Round record
    FRLS_Round__c testRound=new FRLS_Round__c();
    FRLS_Round__c testRoundAfter=new FRLS_Round__c();
    testRound.Name='Open Round';
    testRound.Task__c='Callback';
    testRound.Contact__c=testContact.Id;
    insert testRound;
    // Start the test
    Test.startTest();
    // Change the round to Hot and see if the date is set
    testRound.Task__c='Hot';
    testRound.Callback_Date__c=null;
    update testRound;
    testRoundAfter=[Select r.Callback_Date__c From FRLS_Round__c r Where r.Id=: testRound.Id];
    System.assertNotEquals(testRoundAfter.Callback_Date__c,null);
    // Change the round to Callback and see if the date is set
    testRound.Task__c='Callback';
    testRound.Callback_Date__c=null;
    update testRound;
    testRoundAfter=[Select r.Callback_Date__c From FRLS_Round__c r Where r.Id=: testRound.Id];
    System.assertNotEquals(testRoundAfter.Callback_Date__c,null);
    // Change the round to Recycle and see if the date is set
    testRound.Task__c='Recycle';
    testRound.Callback_Date__c=null;
    update testRound;
    testRoundAfter=[Select r.Callback_Date__c From FRLS_Round__c r Where r.Id=: testRound.Id];
    System.assertNotEquals(testRoundAfter.Callback_Date__c,null);
    // Change the round to Do Not Call - it should clear the date
    testRound.Task__c='Do Not Call';
    testRound.Callback_Date__c=Date.today();
    update testRound;
    testRoundAfter=[Select r.Callback_Date__c From FRLS_Round__c r Where r.Id=: testRound.Id];
//    System.assertEquals(testRoundAfter.Callback_Date__c,null);
    // End the test
    Test.stopTest();
  }
}