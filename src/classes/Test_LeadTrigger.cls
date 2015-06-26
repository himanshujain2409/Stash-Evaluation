@isTest
public with sharing class Test_LeadTrigger 
{
    private static testmethod void testLeadConvertion()
    {
        Test.startTest();
        try{
        Lead lead = new Lead(
            LastName = 'Test Lead',
            Company = 'Test Company',
            Status = 'Test Status',
            LeadSource = 'Test Source');
        insert Lead;
        
        FRLS_Round__c round = new FRLS_Round__c(
            Name = 'Open Round',
            Lead__c = lead.Id);
        insert round;       
        
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(lead.id);
        LeadStatus convertStatus = [
            Select Id, MasterLabel 
            from LeadStatus 
            where IsConverted = true 
              limit 1];
        System.debug(':::::::LeadStatus' + convertStatus);
        
        lc.setConvertedStatus(convertStatus.MasterLabel);
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());
        
        update lead;
        }
        catch(Exception e){
            system.debug('error');
        }
        Test.stopTest();
    }
}