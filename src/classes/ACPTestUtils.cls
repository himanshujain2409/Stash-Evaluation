/*
* Helper class for the unit test
* @author Copyright (c) 2013 Apttus.
* @author lferreira@altimetrik.com
*/
public with sharing class ACPTestUtils {
    
    private static User currentUser = null;
    
    /* create an instance of the CASE std object */
    
    public static Case createCase(String subject){
        return new Case(Subject = subject);
    }
    
    public static Case createCase(){
        return createCase('test case');
    }
    
    /* create an instance of the ACCOUNT std object */
    
    public static Account createAccount(String name, String supportLevel){
        return new Account(Name = name, CurrencyIsoCode = 'USD', Support_Level__c = supportLevel);
    }
    
    public static Account createAccount(){
        return createAccount('test account', 'normal');
    }
    
    public static SucessPortalOverrideProfile__c  createSettingPortal(string name, string tabvalue, string profilename) {
        return new SucessPortalOverrideProfile__c (Name = name, Available_Tabs__c = tabvalue, Profile_Name__c = profilename);
    }
    
    /* create an instance of the CONTACT std object */
    
    public static Contact createContact(String name, Id accountId){
        return new Contact(LastName = name, AccountId = accountId, CurrencyIsoCode = 'USD');
    }
    
    /* create an instance of the USER std object */

    public static User createUserCustomerPortal(Id contactId){
        return createUser(contactId, 'High Volume Customer Portal User');
    }
    
    public static User createUser(Id contactId){
        return createUser(contactId, 'System Administrator');
    }
    
    public static User createUser(Id contactId, String profileName){
        
        Profile p = [SELECT Id FROM Profile WHERE Name= :profileName];
        
        return new User(    Alias = 'standt', Email='standarduser@testorg.com', 
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles',
                            UserName='standarduser@testorg.com', ContactId = contactId);
    }

    public static User getCurrentUser(){
        
        if(currentUser == null)
            currentUser = [SELECT ContactId, AccountId, Contact.AccountId  FROM User WHERE Id = :UserInfo.getUserId()];
            
        return currentUser;
    }
    
    
    /* create an instance of sflma__package object */
    
    public static sfLma__Package__c createPackage(String name){
        return new sfLma__Package__c(Name = name);
    }
    
    
    /* create an instance of sflma__package_version object */
    
    public static sfLma__Package_Version__c createPackageVersion(String name, Id packageId){
        return new sfLma__Package_Version__c(Name = name, sfLma__Package__c = packageId);
    }
    
    
    /* create an instance of sflma__license object */
    
    public static sfLma__License__c createLicense(Id packageVersionId, Id accountId){
        return new sfLma__License__c(sfLma__Package_Version__c = packageVersionId, sfLma__Account__c = accountId);
    }
    
    
    /* create an instance of ACP_Package_Download__c object */
    
    public static ACP_Package_Download__c createPackageDownload(Id accountId, Id packageVersionId, Id userId, Date createDate){
        return new ACP_Package_Download__c(Account__c = accountId,Created_Date__c = createDate,Package_Version__c = packageVersionId, User__c = userId);
    }
    
    
    /* creates an instance of ACP_Excecutable_File__c object */
    
    public static ACP_Executable_File__c createExecutableFile(){
        return new ACP_Executable_File__c(Name = 'test file', Customer_Portal_Category__c = 'test category');
    }
    
    
    /* creates an instance of ACP_Course__c object */
    
    public static ACP_Course__c createCourse(){
        return createCourse(true);
    }
    
    public static ACP_Course__c createCourse(Boolean showOnPortal){
        return new ACP_Course__c(
                        Name = 'test course', 
                        Description__c = 'test course description', 
                        Link__c = 'test link',
                        LinkName__c = 'test link name',
                        Category__c = 'test category',
                        Show_On_Customer_Portal__c = showOnPortal
                    );
    }
    
    public static ACP_Course_Download__c createCourseDownload(Id courseId, DateTime createDate){
        return new ACP_Course_Download__c(
            Course__c = courseId,
            User__c = ACPUtils.getCurrentUser().Id,
            isEmail__c = true,
            Created_Date__c = createDate
        );
    }
}