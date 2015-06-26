@isTest(SeeAllData=true)
public class TestAfterUserInsertUpdate {

    Static testMethod void testUserTrg()
    {
        Test.startTest();
        User u;
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1];
        UserRole r = [SELECT Id From UserRole where name ='Director Sales Engineering' LIMIT 1];
      //UserRole  childUserRoles = [Select Id from UserRole where ParentRoleId =: directorSalesEngineering.Id];
        u = new User(Alias = 'test', Email='testuser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId = r.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='testUserComans2@testorg.com');
        insert u;
        u.Alias = 'test1';
        update u;
        Test.stopTest();
        
    }
}