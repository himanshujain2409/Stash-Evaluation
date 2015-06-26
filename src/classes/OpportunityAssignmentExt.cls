public with sharing class OpportunityAssignmentExt {
    private ApexPages.StandardController con;

    public List<String> selectedUsers { get; set; }
    //private List<SelectOption> usersSO;


    public OpportunityAssignmentExt(ApexPages.StandardController controller) {
        con = controller;
        selectedUsers = new List<String>();
        
        String id = ApexPages.currentPage().getParameters().get('id');
        
        if(id != null && id != ''){
            
            OpportunityAssignment__c OA = [select User_Roles__c from OpportunityAssignment__c where id=:id];
            List<String> OAs = OA.User_Roles__c.split('\n');
            
            if(OAs.size() > 0){
                for(String o : OAs){
                    selectedUsers.add(o);   
                }
            }
        }
        
    }

    public PageReference doSave(){

        system.debug('con: '+selectedUsers);
        OpportunityAssignment__c ops = (OpportunityAssignment__c)con.getRecord();

        String sRole='';
        
        for(String s : selectedUsers) {
            
            sRole = sRole + s + '\n';
            
        }       
        
        system.debug('sRole: '+sRole);
        system.debug('con2: '+ops);
        
        ops.User_Roles__c = sRole.trim();
        
        //con.save();
        upsert ops;

        //PageReference pr = new PageReference(ApexPages.currentPage().getParameters().get('retURL'));
        PageReference pr = new PageReference('/apex/OpportunityAssignmentView?id='+ops.id+'&sfdc.override=1');
        pr.setRedirect(true);
        return pr;
    }


    public List<selectOption> getOs() {
        List<selectOption> options = new List<selectOption>();
        options.add(new selectOption('', '--Select--')); 
        for (OpportunityStage stage : [SELECT Id, MasterLabel FROM OpportunityStage]) { 
            options.add(new selectOption(stage.MasterLabel, stage.MasterLabel));
        }
        return options; 
    }

    public List<selectOption> getUR() {
        List<selectOption> options = new List<selectOption>();
        //options.add(new selectOption('', '- None -')); 
        for (UserRole ur : [SELECT Id, Name FROM UserRole]) { 
            options.add(new selectOption(ur.Name, ur.Name));
        }
        return options; 
    }   
    
    
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

			PageReference tcPage = new PageReference(''+Page.OpportunityAssignmentNew);
			tcPage.getParameters().put('retUrl', 'test');
			tcPage.getParameters().put('id', OA.id);
			Test.setCurrentPage(tcPage);

        	OpportunityAssignment__c tc = new OpportunityAssignment__c();
			OpportunityAssignmentExt tcn = new OpportunityAssignmentExt(new ApexPages.StandardController(tc));
			tcn.getOs();
			tcn.getUR();
			
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