@isTest
public class TestUpdateTDOOnLicense {
    
    @isTest(SeeAllData=true)
    public static Void TestTrialForceId(){
        
      /*  sfLma__License__c sflmaLicence = new sfLma__License__c();
            
            sflmaLicence.sfLma__Subscriber_Org_ID__c = '00DU0000000Y1FY';
            sflmaLicence.sfLma__License_Type__c = 'Editable';
            sflmaLicence.sfLma__Used_Licenses__c = 10;
            sflmaLicence.sfLma__Status__c = 'Active';
            //sflmaLicence.sfLma__Package_Version__c = 'a0SW0000000h5op';
            sflmaLicence.sfLma__Seats__c = 10;
        
            insert sflmaLicence;  */
        
        Trialforce_Demo_Orgs__c trialForceDemo = new Trialforce_Demo_Orgs__c();
            trialForceDemo.Name = 'Testing Cov 1';
            trialForceDemo.Salesforce_com_Organization_ID__c = '00Dj0000000IaR0';
            insert trialForceDemo;
        
       /* sflmaLicence = [Select id,sfLma__Subscriber_Org_ID__c,TDO_Name__c  
                         FROM sfLma__License__c WHERE id = : sflmaLicence.Id];
        
        System.assertEquals(sflmaLicence.TDO_Name__c, trialForceDemo.id);  */
        
    }
}