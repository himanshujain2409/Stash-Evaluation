@isTest
public class batchContactUpdateTest {

    static testMethod void batchContactUpdateTest () {
        
        Account acc =new Account();
        acc.name='apttus test account';
        insert acc;
        
        contact c=new contact();
         c.LastName='test';
         c.accountid = acc.id;
         c.Active_Portal_User__c = true;
         c.LeadSource ='Inbound';
         insert c; 
         batchContactUpdate b = new batchContactUpdate ();
         database.executeBatch (b);

                    
                   
    }
}