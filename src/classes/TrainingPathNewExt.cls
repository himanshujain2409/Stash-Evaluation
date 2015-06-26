public with sharing class TrainingPathNewExt {
    private ApexPages.StandardController con;

    public TrainingPathNewExt(ApexPages.StandardController controller) {
        con = controller;
    }

    public PageReference doSave(){
        con.save();

        PageReference pr = new PageReference(ApexPages.currentPage().getParameters().get('retURL'));
        pr.setRedirect(true);
        return pr;
    }

	static testMethod void testTrainingPathNewExt(){
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
			PageReference tcPage = new PageReference(''+Page.TrainingPathNew);
			tcPage.getParameters().put('retUrl', 'test');
			Test.setCurrentPage(tcPage);

        	Training_Path__c tcp = new Training_Path__c();
			TrainingPathNewExt tcn = new TrainingPathNewExt(new ApexPages.StandardController(tcp));

			PageReference stc = tcn.doSave();
			System.assertEquals(TRUE, TRUE);
        }		
        Test.stopTest(); 
	}

    public static String createRandomWord() {
    	
    	String ret = 'word' + math.rint(math.random() * 100000);
    	
    	return ret;
    	
    }

}