public class ST_OppNew {
   public Event miEvent;
   public String miAccountId;
   public String miAccountName;
   public String closeEntireAccount {get;set;}
   // Constructor
    public ST_OppNew(ApexPages.StandardController stdController) {
        Event tempEvent=(Event) stdController.getRecord();
      closeEntireAccount='n';
      miEvent=[Select e.Id,e.WhatId,e.WhoId,e.Event_Status__c,e.IsReminderSet From Event e Where e.Id=: tempEvent.Id Limit 1];
      if (miEvent.WhoId!=null){
         try{
            Contact miContact=[Select c.Id,c.AccountId,c.Account.Name From Contact c Where c.Id=: miEvent.WhoId Limit 1];
            if (miContact!=null){
               miAccountId=String.valueOf(miContact.AccountId).substring(0,15);
               miAccountName=miContact.Account.Name;
            }
         } catch (Exception e){
            System.debug('*** Cannot create miContact');
         }
      }
/*
      if (miEvent.WhatId!=null){
         try{
            FRLS_Round__c miRound=[Select r.Id,r.Name,r.Task__c,r.Contact__c From FRLS_Round__c r Where r.Id=: miEvent.WhatId];
         } catch (Exception e){
            System.debug('*** Cannot create miRound');
         }
      }
*/
    }
    // Close All Rounds Options
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('n','On just this Contact')); 
        options.add(new SelectOption('y','On the entire Account')); 
        return options; 
    }
   // Set the value of closeEntireAccount
    public void setCloseEntireAccount(String cea) {
      this.closeEntireAccount = cea;
    }
    // Get closeEntireAccount
   public String getCloseEntireAccount(){
      return closeEntireAccount;
   }    
    // Method for Create Opportunity button
   public PageReference createOpp(){
         if (miAccountName!=null && miAccountId!=null){
         // Make sure CloseEntireAccount has a value
         if (closeEntireAccount==null || closeEntireAccount==''){
            closeEntireAccount='n';
         }
         // Fetch the Ids of the custom fields to create the URL to the new Opportunity
         // Create a map of the PPM Settings
         Map<String,String> mapSettingNameToValue=new Map<String,String>();
         try{
            List<PPM_Setting__c> ppmSettings=[Select s.Name,s.Value__c From PPM_Setting__c s];
            for (PPM_Setting__c s : ppmSettings){
               mapSettingNameToValue.put(s.Name,s.Value__c);
            }
         } catch (Exception e) {
            System.debug('*** Cannot create ppmSettings');
               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Values may need to be added to the PPM Settings object. Please contact your administrator.'));
            return null;
         }
         // Check for the PPM Settings that we need
         if (mapSettingNameToValue.keySet().contains('MI_Event_Id__c')==false || mapSettingNameToValue.keySet().contains('Close_Entire_Account__c')==false){
               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please make sure values for MI_Event_Id__c and Close_Entire_Account__c have been added to the PPM Settings object. Please contact your administrator.'));
            return null;
         } else {
            // Return the page reference
            return new PageReference('/006/e?' + mapSettingNameToValue.get('MI_Event_Id__c') + '=' + miEvent.Id + '&opp4=' + EncodingUtil.urlEncode(miAccountName, 'UTF-8') + '&opp4_lkid=' + miAccountId + '&' + mapSettingNameToValue.get('Close_Entire_Account__c') + '=' + closeEntireAccount + '&retURL=%2F' + miEvent.Id);
         }
         } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please associate the Event with a Contact'));
            return null;
         }
      return null;
   }
   // Method for Cancel New Opportunity button
   public PageReference cancelOpp(){
      return new PageReference('/' + miEvent.Id);
   }
   // Method for Opportunity After Insert Trigger
   public static void linkMIEvent(List<Opportunity> newOpps){
      String closeEntireAccount='n';
      // Create the needed vars
      Set<Id> relatedAccountIds=new Set<Id>();
      Set<Id> relatedContactIds=new Set<Id>();
      Set<Id> relatedEventContactIds=new Set<Id>();
      List<Account> relatedAccounts=new List<Account>();
      List<Contact> relatedContacts=new List<Contact>();
      List<Contact> relatedEventContacts=new List<Contact>();
      List<Event> relatedEvents=new List<Event>();
      List<Event> relatedEventsForCloseContacts=new List<Event>();
      List<Id> closeContactEventIds=new List<Id>();
      // Get just the Opps that have a MI Event Id
      List<Opportunity> eventOpps=new List<Opportunity>();
      // Only execute for manual processes (1 Oppty only)
      if (newOpps.size()==1){
         for (Opportunity o : newOpps){
            if (o.MI_Event_Id__c!=null){
               eventOpps.add(o);
            }
            // Get the Event Ids that are Close Contact only
            if (o.Close_Entire_Account__c!='y' && o.MI_Event_Id__c!=''){
               closeContactEventIds.add(o.MI_Event_Id__c);
            }
         }
      }
      // Create a map from the MI Event Ids to the Opp Id
      // Also create a List of the AccountIds on the Opps that are marked 'Close Entire Account'
      Map<String,String> mapEventIdToOppId=new Map<String,String>();
      for (Opportunity o : eventOpps){
         mapEventIdToOppId.put(o.MI_Event_Id__c,o.Id);
         if (o.Close_Entire_Account__c=='y'){
            relatedAccountIds.add(o.AccountId);
         }
         
      }
      // Get a list of the MI Events designated by the MI Event Ids
      try{
         relatedEvents=[Select e.Id,e.WhatId,e.WhoId,e.Event_Status__c,e.IsReminderSet From Event e Where e.Id IN: mapEventIdToOppId.keySet()];
         relatedEventsForCloseContacts=[Select e.Id,e.WhatId,e.WhoId,e.Event_Status__c,e.IsReminderSet From Event e Where e.Id IN: closeContactEventIds];
      } catch (Exception e){
         System.debug('*** Cannot create relatedEvents');
      }
      // Get all of the Contacts attached to the Accounts that are named on the Opps
      //   (for only the Opps that are marked 'Close Entire Account')
//    if (relatedAccountIds!=null){
//       for (Contact c :[Select c.Id,c.AccountId From Contact c Where c.AccountId IN: relatedAccountIds]){
//          relatedContacts.add(c);
//       }
//    }
      // Close the related rounds (for Opptys marked Close Entire Account)
      if (relatedAccountIds!=null){
         Try{
            relatedAccounts=[Select a.Id From Account a Where a.Id IN: relatedAccountIds Limit 1];
            if (relatedAccounts!=null){
               ST_CloseAllRoundsAccount.closeAllRoundsAccount(relatedAccounts);
            }
         } catch (Exception e){
            // Do nothing
         }
      }
      // Create Set of all the Contact Ids named in the MI Events (where just the Contact Rounds need to be closed)
      if (relatedEventsForCloseContacts!=null){
         for (Event e : relatedEventsForCloseContacts){
            if (e.WhoId!=null){
               relatedEventContactIds.add(e.WhoId);
            }
         }
      }
      // Add to the list of related Contacts all of the Contacts attached to Events
      if (relatedEventContactIds!=null){
         // Create a List of the Contacts that are attached to Events
         try{
            relatedEventContacts=[Select c.Id From Contact c Where c.Id IN: relatedEventContactIds];
         } catch (Exception e) {
            System.debug('*** Cannot create relatedEventContacts');
         }
         // Add those contacts to the main list of related Contacts
//       for (Contact c : relatedEventContacts){
//          relatedContacts.add(c);
//       }
      }
      // Close the rounds attached to the related contacts (for Opptys marked Close Contact Only)
      if (relatedEventContacts!=null){
         ST_CloseAllRoundsAccount.closeAllRoundsContact(relatedEventContacts);
      }
      // Loop through the Events and change the Round references to Opp references
      //   (also set the Event Status to 'Inactive')
      //   (also set IsRemdinderSet to False)
      //   (Note: only executes for manual processes... size==1)
      if (relatedEvents!=null && relatedEvents.size()==1){
         for (Event e : relatedEvents){
            e.WhatId=mapEventIdToOppId.get(e.Id);
            e.Event_Status__c='Inactive';
            e.IsReminderSet=False;
         }
         update relatedEvents;
      }
   }
   
 
}