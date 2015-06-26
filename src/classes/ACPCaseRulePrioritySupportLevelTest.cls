/*
* Unit test for ACPCaseRulePrioritySupportLevel class
* @author Copyright (c) 2012 Apttus.
* @author dberriel@altimetrik.com
*/ 
@isTest
private class ACPCaseRulePrioritySupportLevelTest {

    /* Test method to send email with cases that are marked as “critical” or customer support level is “premium”*/
    static testMethod void sendCasesMail() {
        //Objective: code coverage to can send email.
        Account a = ACPTestUtils.createAccount('TestAccount', 'Premium');
        insert a;
        Contact contactTest = ACPTestUtils.createContact('TestContact', a.Id); 
        insert contactTest;
        
        List<Case> cases = new List<Case>();
        
        for(Integer i = 0; i < 10; i++){
            Case caseTst = ACPTestUtils.createCase();
            caseTst.Priority ='Critical';
            caseTst.ContactId = contactTest.Id;
            caseTst.AccountId = contactTest.AccountId;
            cases.add(caseTst);
        }
        
        insert cases;
        
       ACPCaseRulePrioritySupportLevel ruleClass = new ACPCaseRulePrioritySupportLevel();
       test.startTest();
       ruleClass.execute(null);
       Test.stopTest();
    }
    
    /* Test schedule job */
    static testMethod void scheduleJob(){
        Test.startTest();
        
        ACPCaseRulePrioritySupportLevel ruleClass = new ACPCaseRulePrioritySupportLevel();
        
        String jobId = ACPCaseRulePrioritySupportLevel.scheduleJob('TestJob');
        
        // Get the information from the CronTrigger API object 
    
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
         FROM CronTrigger WHERE id = :jobId];

   // Verify the expressions are the same 
    
      System.assertEquals(ACPCaseRulePrioritySupportLevel.CRON_EXP, ct.CronExpression);

   // Verify the job has not run 
    
      System.assertEquals(0, ct.TimesTriggered);
        
        Test.stopTest();
    }
}