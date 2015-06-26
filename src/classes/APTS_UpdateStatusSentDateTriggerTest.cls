@isTest(SeeAllData=true)
public with sharing class APTS_UpdateStatusSentDateTriggerTest
{
	// Start: Mod by Nimit S on 06/10/14 Test class for APTS_UpdateStatusSentDate
	static testMethod void testMethod1() 
    {
        system.debug('Start creating project');
        //pse__Proj__c project1 = new pse__Proj__c(Name = 'APTS Test Project 1', CurrencyIsoCode='UDS- U.S. Dollar', pse__Stage__c='Pipeline');
        List<pse__Proj__c> lstProject = [select id from pse__Proj__c limit 1];
        //insert project1;
        System.debug('End creating project');
        
        //Create Output history
        
        list<ob1__Output_History__c> outputHistories = new list<ob1__Output_History__c>();
        ob1__Output_History__c outputHistory1 = new ob1__Output_History__c(Project__c = lstProject[0].id, ob1__To__c = 'a@a.com', ob1__Status__c= 'sent');
        outputHistories.add(outputHistory1);

        ob1__Output_History__c outputHistory2 = new ob1__Output_History__c(Project__c = lstProject[0].id, ob1__To__c = 'a@a.com', ob1__Status__c= 'saved');
        outputHistories.add(outputHistory2);

        system.debug('Start creating output history');
        insert outputHistories;
        system.debug('End creating output history');
        
        outputHistory2 = new ob1__Output_History__c(id=outputHistory2.Id, ob1__To__c = 'b@b.com', ob1__Status__c= 'sent');
        
        system.debug('Start updating output history');
        update outputHistory2;
        system.debug('End updating output history');
    }
    // End: Mod by Nimit S on 06/10/14 Test class for APTS_UpdateStatusSentDate
}