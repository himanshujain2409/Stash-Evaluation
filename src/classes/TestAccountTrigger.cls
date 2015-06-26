@isTest
public class TestAccountTrigger
{
     static testmethod void TestConcessionRequestStatus()
    {
       
        Account acc= new Account();
        acc.name='testing';
        insert acc;
       
        Concession_Request_CS__c cr= new Concession_Request_CS__c();
        cr.Account__c=acc.id;
        cr.Root_cause_characteristics__c='Lack of skill set in support';
        cr.Hours_Requested__c=11;
        cr.Justification__c='testting sample data';
        cr.Concession_Request_Type__c='Sales';
        //cr.Opportunity__c=opp.id;
        
        insert cr;
        
        acc.Approval_Status__c = 'Pending Approval';
        update acc;
        
    }
}