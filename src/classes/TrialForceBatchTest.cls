@isTest
public class TrialForceBatchTest {
    public static testMethod void unittest(){
 		Test.startTest();
        try
        {
         Trialforce_Demo_Orgs__c trialForceDemo = new Trialforce_Demo_Orgs__c();
            trialForceDemo.Name = 'Testing Cov 1';
            trialForceDemo.Salesforce_com_Organization_ID__c = '00Dj0000000IaR0';
            insert trialForceDemo;       
        }
        catch(Exception e){
            system.debug('error');
        }
       TrialForceBatch c = new TrialForceBatch();
       Database.executeBatch(c,200);
       Test.stopTest();
    }
}