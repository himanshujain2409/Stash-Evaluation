public class ST_RoundAfterUpsert {
    public static void setLastTouched(List<FRLS_Round__c> updatedRounds){
        Map<Id,DateTime> mapAcctIdToLastTouched=new Map<Id,DateTime>();
        List<Account> accountObjs=new List<Account>();
        // Loop through the Rounds to get the unique Account Ids
        for(FRLS_Round__c cr : updatedRounds){
            if (cr.Account__c!=null){
                mapAcctIdToLastTouched.put(cr.Account__c,cr.LastModifiedDate);
            }
        }
        if (mapAcctIdToLastTouched.isEmpty()==False){
            // Get the Account objects so we can modify the Last_Touched__c field
            Try {
                accountObjs=[Select a.Last_Touched__c From Account a Where a.Id IN: mapAcctIdToLastTouched.keySet()];
            } catch (Exception e){
                // Do nothing
            }
            if (accountObjs.isEmpty()==False){
                // Loop through the Accounts and set the Last Touched field
                for(Account ca : accountObjs){
                    ca.Last_Touched__c=mapAcctIdToLastTouched.get(ca.Id);
                }
                update accountObjs;
            }
        }
    }
    
    public static void updateReferenceFields(List<FRLS_Round__c> updateRounds) {
        /*
        This sets fields on the round object that are meant to merge lead and contact fields
        for reporting on leads and contacts at the same time
        
        Keep in mind, although this is in a class called RoundAfterUpsert, it actually
        happens BeforeUpsert...
        */
        Set<Id> related_contact_ids = new Set<Id>();
        Set<Id> related_lead_ids = new Set<Id>();
        
        // get the ids for related leads/contacts you're going to query
        for(FRLS_Round__c round: updateRounds){
            if (round.Contact__c != null){
                related_contact_ids.add((Id) round.Contact__c);
            } else if(round.Lead__c != null){
                related_lead_ids.add((Id) round.Lead__c);
            }
        }
        // query for related leads/contacts
        List<Contact> related_contacts = [SELECT c.id, c.phone, c.title, c.createdDate, c.email, c.name, c.owner.name, c.AssistantName, c.account.name 
                                            FROM Contact c WHERE c.id IN: related_contact_ids];
        List<Lead> related_leads = [SELECT l.id, l.phone, l.company, l.name, l.createdDate, l.email, l.PPM_Assistant__c, l.owner.name, l.title, l.LeadSource
                                    FROM Lead l WHERE l.id IN: related_lead_ids];

        // put them in a dictionary for easier lookups by id                                    
        Map<Id, SObject> related_lookup = new Map<Id, SObject>();
        for(SObject c : related_contacts) {
            related_lookup.put(c.Id, c);
        }
        for(SObject l : related_leads) {
            related_lookup.put(l.Id, l);
        }

        // loop through one more time and update corresponding fields
        for(FRLS_Round__c round: updateRounds){
            if (round.Contact__c != null/* && round.Contact__c != ''*/){
                Contact rel = (Contact) related_lookup.get((Id) round.Contact__c);
                round.Rel_Phone_Number__c = rel.phone;
                round.Rel_Company__c = rel.Account.name;
                round.Rel_Title__c = rel.title; 
                round.Rel_Owner__c = rel.owner.name;
                round.Rel_e_mail__c = rel.email;
                round.Rel_assistant__c = rel.AssistantName;
                round.Rel_Created_Date__c = rel.createdDate;
            } else if(round.Lead__c != null/* && round.Lead__c.id != ''*/){
                Lead rel = (Lead) related_lookup.get((Id) round.Lead__c);
                round.Rel_Phone_Number__c = rel.phone;
                round.Rel_Company__c = rel.Company;
                round.Rel_Title__c = rel.title; 
                round.Rel_Owner__c = rel.owner.name;
                round.Rel_Lead_Source__c = rel.LeadSource;
                round.Rel_e_mail__c = rel.email;
                round.Rel_assistant__c = rel.PPM_Assistant__c;
                round.Rel_Created_Date__c = rel.createdDate;
            }
        }   
        
    }

    // Test code for this class
    private static testMethod void testRoundAfterUpsert(){
        Account testAccount;
        Contact testContact;
        Lead testLead;
   
        testAccount = new Account();
        testAccount = (Account) ST_Utilities.Populate_sObject(testAccount);
        insert testAccount;
        testContact = new Contact();
        testContact = (Contact) ST_Utilities.Populate_sObject(testContact);
        testContact.AccountId = testAccount.Id;
        insert testContact;
        
        testLead = new Lead();
        testLead = (Lead)ST_Utilities.Populate_sObject((sObject)testLead);
        insert testLead;
        // Start the test
        Test.startTest();
        // Create a test Round record
        FRLS_Round__c testRound=new FRLS_Round__c();
        FRLS_Round__c testRoundAfter=new FRLS_Round__c();
        
        testRound.Name='Open Round';
        testRound.Task__c='Callback';
        testRound.Contact__c=testContact.Id;
        
        insert testRound;
        
        testRoundAfter.Name='Closed Round';
        testRoundAfter.Task__c='Hot';
        testRoundAfter.Lead__c=testLead.Id;
        insert testRoundAfter;
        
        // Make sure Last Touched was set on the Account
        testAccount=[Select a.Last_Touched__c From Account a Where a.Id=: testContact.AccountId];
        System.assertNotEquals(testAccount.Last_Touched__c,null);
        // Reset the Last Touched field to null
        testAccount.Last_Touched__c=null;
        update testAccount;
        // Change the round
        testRound.Task__c='Hot';
        testRound.Callback_Date__c=null;
        update testRound;
        
        // Make sure Last Touched was set on the Account
        testAccount=[Select a.Last_Touched__c From Account a Where a.Id=: testContact.AccountId];
        System.assertNotEquals(testAccount.Last_Touched__c,null);
        // End the test
        Test.stopTest();
    }
}