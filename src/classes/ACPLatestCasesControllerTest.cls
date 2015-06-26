/*
* Unit test for Controller ApttusCustomerPortalLatestCases
* @author Copyright (c) 2012 Apttus.
* @author lferreira@altimetrik.com
*/
@isTest
private class ACPLatestCasesControllerTest {

    
    /* test the controller without cases */
    
    static testmethod void testControllerWithoutCases(){
    	
    	
    	/* create an instance of the controller */
    	
    	ACPLatestCasesController controller = new ACPLatestCasesController();
    	
    	test.startTest();
    	
    	
    	/* assert that no cases were retrieved */
    		
    	System.assertEquals(0, controller.latestCases.size());
    	
    	test.stopTest();
    	
    }
    
    
    /* test the controller with 1 case */
    
    static testmethod void testControllerWithOneCase(){
    	
    	
    	/* create a case */
    	
    	Case testCase = ACPTestUtils.createCase();
    	insert testCase;
    	
    	
    	/* get the case information */
    	
    	testCase = [SELECT CaseNumber, Subject FROM Case WHERE Id = :testCase.Id];
    	
    	
    	/* create an instance of the controller */
    	
    	ACPLatestCasesController controller = new ACPLatestCasesController();
    	
    	test.startTest();
    	
    	
    	/* assert that 1 case was retrieved */
    		
    	System.assertEquals(1, controller.latestCases.size());
    	System.assertEquals(testCase.Subject, controller.latestCases[0].Subject);
    	System.assertEquals(testCase.CaseNumber, controller.latestCases[0].CaseNumber);
    	
    	test.stopTest();
    	
    }
    
    
    /* test the controller with 10 cases */
    
        static testmethod void testControllerWithTenCases(){
    	
    	
    	/* create 10 cases */
    	
    	List<Case> cases = new List<Case>();
    	
    	for(Integer i = 0; i < 10; i++){
    		cases.add(ACPTestUtils.createCase());
    	}
    	
    	test.startTest();
    	
    	insert cases;
    	
    	
    	/* create an instance of the controller */
    	
    	ACPLatestCasesController controller = new ACPLatestCasesController();
    	
    	/* assert that 10 cases were retrieved */
    		
    	System.assertEquals(5, controller.latestCases.size());
    	    	
    	test.stopTest();
    	
    }
}