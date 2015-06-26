@isTest(SeeAllData = True)
private class AvoidDuplicateUsageEntryTest {

    static testMethod void testAvoidDuplicateUsageEntry() {
      Test.startTest();
      try{
         Response__c response = new Response__c();
         response.Name = 'Response Test';
         response.CurrencyIsoCode = 'USD';
         insert response;
         
         ID rtID = Schema.SObjectType.RFP__c.getRecordTypeInfosByName().get('Open RFP').getRecordTypeID();
         RFP__c rfp = new RFP__c();
         rfp.Name = 'RFP Test';
         rfp.Due_Date__c = system.today()+30;
         rfp.RecordTypeId = rtID;
         insert rfp;
         
         Question__c question = new Question__c();
         question.Override_Warning__c = false;
         question.CurrencyIsoCode = 'USD';
         question.Response__c = response.Id;
         question.RFP__c = rfp.Id;
         question.Question__c = 'Question test';
         insert question;
         
         Question__c question1 = new Question__c();
         question1.Override_Warning__c = false;
         question1.CurrencyIsoCode = 'USD';
         question1.Response__c = response.Id;
         question1.RFP__c = rfp.Id;
         question1.Question__c = 'Question test1';
         insert question1;
      }catch(Exception e){
        System.assert(e.getMessage().contains('timesUsed:'));
      }
      Test.stopTest();
    }
}