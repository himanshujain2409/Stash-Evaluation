@isTest
public class APTPS_CreateSignUpRequestTest {
    Private static RecordType orgReqRecType;
    static testMethod void testProductAttributeDetailCustomController() {
        Test.startTest();
        getRecTypes();
        
        Source_Org__c sourceOrg = new Source_Org__c();
        sourceOrg.Name = 'Test';
        sourceOrg.Username_Addon__c = 'test';
        sourceOrg.Source_Org_ID__c = '00Di0000000kPV8';
        insert sourceOrg;
        
        Source_Org_Template__c sOrgTemp = new Source_Org_Template__c();
        sOrgTemp.Name = 'Test Template';
        sOrgTemp.Active__c = true;
        sOrgTemp.Source_Org__c = sourceOrg.id;
        sOrgTemp.Latest_Version__c = true;
        sOrgTemp.Template_ID__c = '0TTi0000003USx9';
        insert sOrgTemp;
        
        India_Service_Request__c isr = new India_Service_Request__c();
        isr.Org_Engagement_Name__c = '12324Test';
        isr.Org_Request_Submitted__c = False;
        isr.RecordTypeId = orgReqRecType.Id;
        isr.Org_Type__c = sourceOrg.Id;
        isr.Requester__c = getUser().Id;
		insert isr;
                
        Test.stopTest();
        
        India_Service_Request__c isr1 = [Select Org_Type__c ,Org_Provisioning_Template_ID__c from India_Service_Request__c where Id =: isr.id];
        isr1.Org_Request_Submitted__c = True;
        update isr1;
    }
    
    private static void getRecTypes() {      
        List<RecordType> recTypes = [SELECT Id, Name FROM RecordType WHERE Name= 'Org Request' AND SobjectType =: 'India_Service_Request__c' limit 1];
        if (!recTypes.isEmpty()) {
            orgReqRecType = recTypes[0];
        }
    }
    
    private static User getUser(){
        User mike = new User();
        mike.Username= 'mike@apttus.com';
        mike.Email = 'mike@apttus.com';
        mike.Lastname = 'mike';
        mike.Firstname = 'Apttus';
        mike.Alias = 'mApttus';
        mike.CommunityNickname = 'Don';
        mike.ProfileID = UserInfo.getProfileID();
        //mike.CurrencyIsoCode = 'USD';
        mike.TimeZoneSidKey = 'GMT';
        mike.LocaleSidKey = 'en_US';
        mike.EmailEncodingKey = 'ISO-8859-1';
        mike.LanguageLocaleKey = 'en_US';
        mike.UserPermissionsMobileUser = false;
        insert mike;
        return mike;
}

}