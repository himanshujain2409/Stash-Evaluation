@isTest

private class GainsightDAL_Test {

    static testMethod void GainsightDAL_Test() 
    {
         Account a = ACPTestUtils.createAccount('TestAccount', 'Premium');
          insert a;
        Contact contactTest = ACPTestUtils.createContact('TestContact', a.Id); 
        insert contactTest;

        GainsightDAL.RecacheAlertAtrributes();
        GainsightDAL.RecacheAccounts();
        GainsightDAL.GetCustomers(new List<JBCXM__CustomerInfo__c>(), 'JBara', new List<String>());
        GainsightDAL.GetAccounts(new List<Account>(), 'JBara', new List<String>());
        GainsightDAL.GetMilestoneAttributeBySystemName('000000000000000000');
        GainsightDAL.GetMilestoneAttributeById('000000000000000000');
        GainsightDAL.GetAlertStatusBySystemName('000000000000000000');
        GainsightDAL.GetAlertTypeBySystemName('000000000000000000');
        GainsightDAL.GetAlertSeverityBySystemName('000000000000000000');
        GainsightDAL.GetAlertReasonBySystemName('000000000000000000');
        GainsightDAL.GetAdoptionAttributeBySystemName('000000000000000000');
        GainsightDAL.GetAdoptionAttributeById('000000000000000000');
  
    }
}