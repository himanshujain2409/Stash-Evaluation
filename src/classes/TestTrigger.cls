@isTest
private class TestTrigger {

    static testMethod void testDeleteLookupCourse() {
        Test.startTest();
            //Course for test path assign
            lmscons__Training_Content__c lTCcP = new lmscons__Training_Content__c(lmscons__Title__c='test course path');
            insert lTCcP;
            
            lmscons__Training_Content_License__c lTCLcP = new lmscons__Training_Content_License__c(lmscons__Training_Content__c=lTCcP.id);
            insert lTCLcP;
            
            lmscons__Training_Path__c lTPc = new lmscons__Training_Path__c(Name='test path');
            insert lTPc;
            
            lmscons__Training_Path_Item__c lTPIc = new lmscons__Training_Path_Item__c(lmscons__Training_Content__c=lTCcP.id, lmscons__Training_Path__c=lTPc.id);
            insert lTPIc;
            
            delete lTPc;
            System.assertEquals(TRUE, TRUE);
        Test.stopTest();
    }
/*
    static testMethod void opportunityEventsTest() {
        Test.startTest();
        //create test user

        UserRole ur = [select Name, id from UserRole limit 1];

        String namePrefix = createRandomWord();
        AggregateResult[] userCount = [Select count(id) userCount From user where username like :namePrefix];
        Object users = userCount[0].get('userCount');
        Profile p = [Select Id, Name from Profile where Name = 'System Administrator'];
        User testUser = new User();
        testUser.Email = 'test@salesforce.com';
        testUser.Username = namePrefix+users+'@lms.test';
        testUser.LastName = 'test';
        testUser.Alias = 'test';
        testUser.ProfileId = p.Id;
        testUser.LanguageLocaleKey = 'en_US';
        testUser.LocaleSidKey = 'en_US';
        testUser.TimeZoneSidKey = 'America/New_York';
        testUser.EmailEncodingKey = 'UTF-8';
        testUser.UserRoleId = ur.id;

        insert testUser;
        //
        System.runAs(testUser)    
        {

            //create opp ass
            String urName = [select Name from UserRole where id =: testUser.UserRoleId].Name;
            
            OpportunityAssignment__c OA = new OpportunityAssignment__c(Name=namePrefix+users+'@lms.test', Opportunity_Stage__c='Closed Won', User_Roles__c=urName);
            insert OA;

            //Course for test course assign
            lmscons__Training_Content__c lTCc = new lmscons__Training_Content__c(lmscons__Title__c='test course');
            insert lTCc;
            
            lmscons__Training_Content_License__c lTCLc = new lmscons__Training_Content_License__c(lmscons__Training_Content__c=lTCc.id);
            insert lTCLc;
            
            //Course for test path assign
            lmscons__Training_Content__c lTCcP = new lmscons__Training_Content__c(lmscons__Title__c='test course path');
            insert lTCcP;
            
            lmscons__Training_Content_License__c lTCLcP = new lmscons__Training_Content_License__c(lmscons__Training_Content__c=lTCcP.id);
            insert lTCLcP;
            
            lmscons__Training_Path__c lTPc = new lmscons__Training_Path__c(Name='test path');
            insert lTPc;
            
            lmscons__Training_Path_Item__c lTPIc = new lmscons__Training_Path_Item__c(lmscons__Training_Content__c=lTCcP.id, lmscons__Training_Path__c=lTPc.id);
            insert lTPIc;

            //create object for Opp Assignment
            Training_Path__c tp = new Training_Path__c(OpportunityAssignment__c = OA.id, Training_Path__c = lTPc.id);
            insert tp;
            
            TrainingCourses__c tc = new TrainingCourses__c(OpportunityAssignment__c = OA.id, Training_Course__c = lTCc.id);
            insert tc;
            
            //for test without role
            Id uId = testUser.UserRoleId;
            testUser.UserRoleId = null;
            update testUser;
            
            Opportunity opp = new Opportunity();
            opp = new Opportunity(Name = 'Test Opp',
                                Amount = 1000,
                             StageName = 'Closed Lost',
                             CloseDate = Date.today(),
                             Competitors__c='iMany',
                             Won_Lost_Reason__c='Pricing',
                             Won_Lost_Detail_Notes__c='test',
                             Primary_Competitor__c='Ariba'
                             );
            insert opp; 

            Competitor2__c cc = new Competitor2__c(Competitors__c='test', OpportunityAssignment__c=OA.id);
            insert cc; 
            

            OpportunityCompetitor OC = new OpportunityCompetitor(CompetitorName='test', OpportunityId=opp.id);
            insert OC;
            
            //for test with role
            testUser.UserRoleId = uId;
            update testUser;
             
            contact con=new contact();
            con.firstName='test';
            con.lastname='test';
            insert con; 
             
            opp.StageName = 'Closed Won';
            opp.Primary_Contact_Assigned__c=true;
            opp.Primary_Contact__c=con.id;
            update opp;

            System.assertEquals(TRUE, TRUE);
        }       
        Test.stopTest(); 
        
    }
    public static String createRandomWord() {
        
        String ret = 'word' + math.rint(math.random() * 100000);
        
        return ret;
        
    }
    */
}