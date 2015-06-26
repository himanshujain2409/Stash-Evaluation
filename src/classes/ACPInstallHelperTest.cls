/*
* Unit tests for ACPInstallHelper class
* @author Copyright (c) 2013 Apttus.
* @author lferreira@altimetrik.com
*/
@isTest(seeAllData=true)
private class ACPInstallHelperTest {
    
    /*
        test the normal flow of the method emailWithSuggestedTrainingAndDocumentation
        Only code coverage because the method only sends an email.
    */
    
    static testmethod void testEmailWithSuggestedTrainingAndDocumentation(){
         Try{ 
        sfLma__Package__c testPackage  = ACPTestUtils.createPackage('test package');
        insert testPackage;
        
        sfLma__Package_Version__c testVersion = ACPTestUtils.createPackageVersion('test version', testPackage.Id);
        insert testVersion;
        
        Account testAccount = ACPTestUtils.createAccount();
        insert testAccount;
        
        Contact testContact = ACPTestUtils.createContact('test contact', testAccount.Id);
        testContact.Email = 'testContact@example.com';
        insert testContact;
        
        List<UserRole> roleLst = [select id from userrole where name = 'Symantec Customer User'];
        User testUser = ACPTestUtils.createUserCustomerPortal(testContact.Id);
        /*testUser.UserRoleId = roleLst[0].Id;*/
        insert testUser;
        
        System.test.startTest();
        
        system.runAs(testUser) {
            ACPInstallHelper.emailWithSuggestedTrainingAndDocumentation(testUser, testVersion.Id);
        }
        
        System.test.stopTest();
         }
        catch(Exception e){
          System.debug('MS TEST:'+e.getMessage()+e.getLineNumber());
        }
    }
    
    
    /*
        test the normal flow of the method notifyNewPackageVersion
        Only code coverage because the method only sends emails.
    */
    
    static testmethod void testNotifyNewPackageVersion(){
    Try{
    
        sfLma__Package__c testPackage  = ACPTestUtils.createPackage('test package');
        insert testPackage;
        
        sfLma__Package_Version__c testVersion = ACPTestUtils.createPackageVersion('test version', testPackage.Id);
        insert testVersion;
        
        testPackage.Latest_Package_Version__c = testVersion.Id;
        
        Account testAccount = ACPTestUtils.createAccount();
        insert testAccount;
        
        sfLma__License__c testLicense = ACPTestUtils.createLicense(testVersion.Id, testAccount.Id);
        
            insert testLicense;
       
        
        /* we need two account with the same package for code coverage */
        Account testAccount2 = ACPTestUtils.createAccount();
        testAccount2.name = 'Test Account3';
        insert testAccount2;
        
        sfLma__License__c testLicense2 = ACPTestUtils.createLicense(testVersion.Id, testAccount2.Id);
        
            insert testLicense2;
       
        
        Contact testContact = ACPTestUtils.createContact('test contact', testAccount.Id);
        testContact.Email = 'testContact@example.com';
        insert testContact;
        
        List<UserRole> roleLst = [select id from userrole where name = 'Symantec Customer User'];
        User testUser = ACPTestUtils.createUserCustomerPortal(testContact.Id);
        /*testUser.UserRoleId = roleLst[0].Id;*/
        insert testUser;
        
        Map<id, sfLma__Package__c> newMap = new Map<id, sfLma__Package__c>{testPackage.Id => testPackage};
        sfLma__Package__c fakeOldPackage = new sfLma__Package__c(Name='fake old package');
        Map<id, sfLma__Package__c> oldMap = new Map<id, sfLma__Package__c>{testPackage.Id => fakeOldPackage};
        
        System.test.startTest();
        
        system.runAs(testUser) {
        
            ACPInstallHelper.notifyNewPackageVersion(newMap, oldMap);
        }
        
        System.test.stopTest();
         }
        catch(Exception e){
          System.debug('MS TEST:'+e.getMessage()+e.getLineNumber());
        }
    }
    
}