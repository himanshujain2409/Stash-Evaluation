/*
* Unit test for controller CCPOrganizationController
* @author Copyright (c) 2012 Apttus.
* @author lferreira@altimetrik.com
*/ 
@isTest//(seeAllData=true)
private class CCPOrganizationControllerTest {

    /* test the controller normal flow */
    
    static testmethod void testControllerNormalFlow(){
        
        /* create an account */
        
        Account testAccount = ACPTestUtils.createAccount('test account', 'Basic');
        insert testAccount;
        
        
        /* create a contact for the account */
        
        Contact testContact = ACPTestUtils.createContact('test contact', testAccount.Id);
        insert testContact;
        
        string CurrentProfileName = '';
        List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        if(PROFILE != null)
            CurrentProfileName = PROFILE[0].Name;
        
        SucessPortalOverrideProfile__c setting = ACPTestUtils.createSettingPortal('SucessPortalCommunityProfile','Home,Ideas,Knowledge,Document,Install Center',CurrentProfileName);
        insert setting ;
        
        /* assign the contact id to the current user */
        List<UserRole> roleLst = [select id from userrole where name = 'Symantec Customer User'];
        User testUser = ACPTestUtils.createUserCustomerPortal(testContact.Id);
        //testUser.UserRoleId = roleLst[0].Id;
        insert testUser;
        
        
        System.test.startTest();
        
        System.runAs(testUser){
        
            /* create an instance of the controller to test */
            
            CCPOrganizationController controller = new CCPOrganizationController();
            
            controller.ideaFlag=true;
            controller.caseFlag =true;
            controller.articleFlag=true;
            controller.docFlag=true;
            controller.TrainingFlag=true;
                       
            /* assert the Account.Support_Level__c, Account.Name, Account.Case_Response_Time__c */
            
           // System.assertEquals('Basic', controller.contactInformation.Account.Support_Level__c);
          //  System.assertEquals('test account', controller.contactInformation.Account.Name);
          //  System.assertEquals('2 Business Days', controller.contactInformation.Account.Case_Response_Time__c);
        }
        
        System.test.stopTest();
    }
    
    static testMethod void myUnitTest2(){
        User currentUser = [Select Id, Name, Profile.Name from User where Id =: Userinfo.getUserId()];
        
        SucessPortalOverrideProfile__c overrideProfile = new SucessPortalOverrideProfile__c();
        overrideProfile.Name = currentUser.Profile.Name;
        overrideProfile.Profile_Name__c = currentUser.Profile.Name;
        overrideProfile.Available_Tabs__c = 'Home,Ideas,Knowledge,Document,Training,Install Center';
        
        insert overrideProfile;
        
        CCPOrganizationController controller = new CCPOrganizationController();
        
    }
}