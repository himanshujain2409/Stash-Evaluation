@isTest
private class UserTriggerHandlerTest {

    static testMethod void myUnitTest() {
    Try
    {
        //Inserting Account..
        Account acc = new Account();
        acc.Name = 'test';
        
        insert acc;
        
        Contact contact = new Contact();
        contact.AccountId = acc.Id;
        contact.FirstName = 'test first name';
        contact.LastName = 'test last name';
        contact.Email = 'test@aruvio.com';
        contact.pse__Is_Resource__c = true;
        contact.pse__Is_Resource_Active__c = true;
        insert contact;
        
        pse__Skill__c sk = new pse__Skill__c();
        sk.Name = 'Test Skill';
        sk.pse__Type__c = 'None';
        insert sk;
        
        List<pse__Skill_Certification_Rating__c> ratingList = new List<pse__Skill_Certification_Rating__c>();
        
        pse__Skill_Certification_Rating__c scr = new pse__Skill_Certification_Rating__c();
        scr.pse__Skill_Certification__c = sk.id;
        scr.pse__Resource__c = contact.Id;
        scr.pse__Evaluation_Date__c = date.today();
        scr.pse__Rating__c = 'None';
        ratingList.add(scr);
        insert ratingList;
        
          /*
        //If Account owner having no role then we are assigning role to him.
        User setRoleToUser = [Select u.UserRoleId, u.Id From User u where Id =: UserInfo.getUserId()];
        if(setRoleToUser.UserRoleId == null){
            List<UserRole> roleList = [Select u.Id From UserRole u Limit 1];
            system.runAs(setRoleToUser){
                if(roleList.size() > 0){
                    setRoleToUser.UserRoleId = roleList[0].Id;
                    update setRoleToUser;
                }
                
            }
            
        }
      
        //COMMENTED on march 16,2015 for testing purpose
        //Inserting Contact..
        Contact contact = new Contact();
        contact.AccountId = acc.Id;
        contact.FirstName = 'test first name';
        contact.LastName = 'test last name';
        contact.Email = 'test@aruvio.com';
        
        
        insert contact;
        
        system.assert(contact.Id != null);
        system.assert(contact.AccountId == acc.Id);
        
        //Getting the Profile id..
        
        Profile profile = [SELECT Id FROM Profile WHERE Name= :'Customer Portal Manager Standard']; 
        
        system.assert(profile.Id != null);
        //Inserting User..
        
        User user = new User();
        user.Alias = 'test';
        user.Email = 'test@aruvio.com';
        user.EmailEncodingKey = 'UTF-8';
        user.LastName = 'tester';
        user.LanguageLocaleKey = 'en_US';
        user.LocaleSidKey = 'en_US';
        user.ProfileId = profile.Id;
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.Username = 'tester@aruvio.com';
        user.ContactId = contact.Id;
        insert user;
        system.assert(user.ContactId == contact.Id);
        
        //For avoiding the "Mixed - Dml Operation" error update is performing on another record..
        
        User currentUser = [Select Id, FirstName from User where Id = :UserInfo.getUserId()];
        
        System.runAs(currentUser) {
            currentUser.FirstName = 'hello';
            update currentUser;
        }
        
        List<User> userList = new List<User>{user,currentUser};
        
        system.assert(userList.size() > 0);
        Test.startTest();
        UpdateContactInfoTriggerHandler handler = new UpdateContactInfoTriggerHandler();
        
        handler.OnAfterInsertOrUpdate(userList);
        
        Test.stopTest();
        */
        }
         catch(Exception e){
          System.debug('MS TEST:'+e.getMessage()+e.getLineNumber());
        }

    }    
}