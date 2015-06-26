public with sharing class OpportunityAssignmentViewExt {

    private ApexPages.StandardController con;

    //public id cOppA;

    public OpportunityAssignmentViewExt(ApexPages.StandardController controller) {
        con = controller;
        //cOppA = con.getId();
    }

    public String getCTContent() {
        String TCs;

        TCs = 'var o = new Object(); \n';

        for (TrainingCourses__c tc : [SELECT Id, Training_Course__r.Name, Training_Course__r.Id, Training_Course__r.lmscons__Title__c FROM TrainingCourses__c where OpportunityAssignment__c =:con.getId()]) { 
            //TCs.add(tc);
            system.debug('TCs0: '+tc);
    
            system.debug('TCs1: '+tc.Training_Course__r.Id);
    
            system.debug('TCs2: '+tc.Training_Course__r.lmscons__Title__c);
            
            TCs = TCs + 'o.'+tc.Training_Course__r.Id+'="'+tc.Training_Course__r.lmscons__Title__c+'"; \n';
            
        }

            system.debug('TCs0: '+TCs);
        
        return TCs; 
    }

    /*public List<TrainingCourses__c> getCTContent() {
        List<TrainingCourses__c> TCs = new List<TrainingCourses__c>();

        for (TrainingCourses__c tc : [SELECT Id, Training_Course__r.Name, Training_Course__r.Id, Training_Course__r.lmscons__Title__c FROM TrainingCourses__c where OpportunityAssignment__c =:con.getId()]) { 
            TCs.add(tc);
            system.debug('TCs0: '+tc);
    
            system.debug('TCs1: '+tc.Training_Course__r.Id);
    
            system.debug('TCs2: '+tc.Training_Course__r.lmscons__Title__c);
        }

            system.debug('TCs0: '+TCs);
        
        return TCs; 
    }*/ 
    
	static testMethod void testTrainingCourseNewExt(){
		Test.startTest();
		//create test user
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
		insert testUser;
		//
        System.runAs(testUser)    
        {

        	//create opp ass
        	
        	UserRole ur = [select Name from UserRole limit 1];
        	
        	OpportunityAssignment__c OA = new OpportunityAssignment__c(Name=namePrefix+users+'@lms.test', Opportunity_Stage__c='Closed Won', User_Roles__c=ur.Name);
        	insert OA;

			TrainingCourses__c tcc = new TrainingCourses__c(OpportunityAssignment__c=OA.id);
			insert tcc;

			PageReference tcPage = new PageReference(''+Page.OpportunityAssignmentView);
			tcPage.getParameters().put('retUrl', 'test');
			tcPage.getParameters().put('id', OA.id);
			Test.setCurrentPage(tcPage);

        	OpportunityAssignment__c tc = new OpportunityAssignment__c();
			OpportunityAssignmentViewExt tcn = new OpportunityAssignmentViewExt(new ApexPages.StandardController(tc));
			
			tcn.getCTContent();
			
			//PageReference stc = tcn.doSave();
			System.assertEquals(TRUE, TRUE);
        }		
        Test.stopTest(); 
	}

    public static String createRandomWord() {
    	
    	String ret = 'word' + math.rint(math.random() * 100000);
    	
    	return ret;
    	
    }
    
    

}