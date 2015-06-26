/**
 * Apttus Approvals Management
 * CustomMyApprovalsEmailControllerTest
 *   
 * @2014 Apttus Inc. All rights reserved.
 *
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class CustomMyApprovalsEmailControllerTest {
				  
	/**
	 * Class Constructor
	 */
	private CustomMyApprovalsEmailControllerTest() {
	}
	
	/**
	 * Tests the controller
	 */
	static testmethod void test1() {
	 	
        CustomMyApprovalsEmailControllerTest testController = new CustomMyApprovalsEmailControllerTest();
        
        // test the approval email 
        testController.testApprovalEmail1();
        
    }
    
    /**
	 * Test the approval email 
	 */
	private void testApprovalEmail1() {
		 
		// Create approval users
		User userSO = null;
		User userSO2 = null;
		
		System.runAs(new User(Id = System.UserInfo.getUserId())) {
			userSO = Apttus_Approval.TestSupport.createUser('assignee1@approvals.apttus.com', 
							    'ast1', 
							    'assignee1',
							    'tester',
							    'assignee1@approvals.apttus.com',
							    ID.valueOf(UserInfo.getProfileId()));
									     
			// fetch the assignee 
			userSO = Apttus_Approval.TestSupport.getUserSO(userSO.Id);
			
			userSO2 = Apttus_Approval.TestSupport.createUser('assignee2@approvals.apttus.com', 
							     'ast2', 
							     'assignee2',
							     'tester',
							     'assignee2@approvals.apttus.com',
							     ID.valueOf(UserInfo.getProfileId()));
								     												     					  
			// fetch the assignee 
			userSO2 = Apttus_Approval.TestSupport.getUserSO(userSO2.Id);
		
		}

		// STEP I - Create a new opportunity
		Opportunity opptySO = new Opportunity(Name = 'Test Opportunity',
											  OwnerId = userSO.Id,
											  Description = 'Opportunity with Acme Computers for $250000',
											  Amount = Decimal.valueOf(250000),
											  StageName = 'Prospecting',
											  CloseDate = Date.today());
		insert opptySO;
																				      
		// STEP II - Create a new process
		Apttus_Approval__Approval_Process__c processSO = Apttus_Approval.TestSupport.createApprovalProcess('TEST-' + Datetime.now().format(), 
															  1,
															  'Opportunity',
															  null,
															  null,
															  null,
															  null, 
															  null, 
															  true);

		// use consolidation
		processSO.Apttus_Approval__ConsolidateApprovals__c = true;
		processSO.Apttus_Approval__ConsolidateNotifications__c = true;
		update processSO;
		
        // create process step group
        Apttus_Approval__Approval_Process__c stepGroupSO = CustomApprovalsTestSupport.createStepGroup(userSO,processSO.Id,'Group 1',1);                             
        
        // create process steps
        Apttus_Approval__Approval_Process__c stepSO1 = CustomApprovalsTestSupport.createStep(userSO,stepGroupSO.Id,'Step 1',1,'User',userSO.Name,false,false,true);                          
        Apttus_Approval__Approval_Process__c stepSO2 = CustomApprovalsTestSupport.createStep(userSO,stepGroupSO.Id,'Step 2',2,'User',userSO.Name,false,false,true);                          
        Apttus_Approval__Approval_Process__c stepSO3 = CustomApprovalsTestSupport.createStep(userSO,stepGroupSO.Id,'Step 3',3,'User',userSO.Name,false,false,true);
						
        // add additional step properties
        stepSO1.Apttus_Approval__StepType__c = 'Standard';
        stepSO1.Apttus_Approval__StepDisplayFieldNames__c = 'Name,Amount,StageName,CloseDate';
        stepSO1.Apttus_Approval__StepFilterConditionDescription__c = 'Amount > $25K and Stage = Closed';
        stepSO1.Apttus_Approval__Step_Assignee_Id__c = userSO.Id;
        update stepSO1;

        stepSO2.Apttus_Approval__StepType__c = 'Standard';
        stepSO2.Apttus_Approval__StepDisplayFieldNames__c = 'Name,Amount';
        stepSO2.Apttus_Approval__StepFilterConditionDescription__c = 'Amount > $50K and Stage = Closed';
        stepSO2.Apttus_Approval__Step_Assignee_Id__c = userSO.Id;
        update stepSO2;
					     												     					  													   	      				  	 				   	   										   
        stepSO3.Apttus_Approval__StepType__c = 'Standard';
        stepSO3.Apttus_Approval__StepDisplayFieldNames__c = 'Name';
        stepSO3.Apttus_Approval__StepFilterConditionDescription__c = 'Amount > $75K and Stage = Closed';
        stepSO3.Apttus_Approval__Step_Assignee_Id__c = userSO.Id;
        update stepSO3;


		// STEP IV - Create a new approval request
        /**Apttus_Approval__Approval_Request__c requestSO = Apttus_Approval.TestSupport.createAssignmentRequest(userSO, 
                                                                                                             processSO.Id, 
                                                                                                             opptySO.Id, 
                                                                                                             'Oppty-3456');*/
		Apttus_Approval__Approval_Request__c requestSO = new Apttus_Approval__Approval_Request__c(OwnerId = userSO.Id);
		requestSO.Apttus_Approval__Approval_Process__c = processSO.Id;
		requestSO.Apttus_Approval__Approval_Status__c = 'Assigned';
		requestSO.Apttus_Approval__Assigned_To_Id__c = userSO.Id;
		requestSO.Apttus_Approval__Assigned_To_Name__c = userSO.Name;
		requestSO.Apttus_Approval__Assigned_To_Type__c = 'User';
        requestSO.Apttus_Approval__Step__c = stepSO1.Id;
		requestSO.Apttus_Approval__Object_Id__c = opptySO.Id;
		requestSO.Apttus_Approval__Object_Type__c = 'Opportunity';
		requestSO.Apttus_Approval__Object_Name__c = opptySO.Name;
		
		// insert approval request
		insert requestSO;
		
        /**Apttus_Approval__Approval_Request__c requestSO2 = Apttus_Approval.TestSupport.createAssignmentRequest(userSO2, 
                                                                                                              processSO.Id, 
                                                                                                              opptySO.Id, 
                                                                                                              'Oppty-3457');*/
		Apttus_Approval__Approval_Request__c requestSO2 = new Apttus_Approval__Approval_Request__c(OwnerId = userSO.Id);
		requestSO2.Apttus_Approval__Approval_Process__c = processSO.Id;
		requestSO2.Apttus_Approval__Approval_Status__c = 'Assigned';
		requestSO2.Apttus_Approval__Assigned_To_Id__c = userSO.Id;
		requestSO2.Apttus_Approval__Assigned_To_Name__c = userSO.Name;
		requestSO2.Apttus_Approval__Assigned_To_Type__c = 'User';
        requestSO2.Apttus_Approval__Step__c = stepSO2.Id;
		requestSO2.Apttus_Approval__Object_Id__c = opptySO.Id;
		requestSO2.Apttus_Approval__Object_Type__c = 'Opportunity';
		requestSO2.Apttus_Approval__Object_Name__c = opptySO.Name;
		
		// insert approval request
		insert requestSO2;
		
        /**Apttus_Approval__Approval_Request__c requestSO3 = Apttus_Approval.TestSupport.createAssignmentRequest(userSO2, 
                                                                                                              processSO.Id, 
                                                                                                              opptySO.Id, 
                                                                                                              'Oppty-3457');*/
		Apttus_Approval__Approval_Request__c requestSO3 = new Apttus_Approval__Approval_Request__c(OwnerId = userSO.Id);
		requestSO3.Apttus_Approval__Approval_Process__c = processSO.Id;
		requestSO3.Apttus_Approval__Approval_Status__c = 'Assigned';
		requestSO3.Apttus_Approval__Assigned_To_Id__c = userSO.Id;
		requestSO3.Apttus_Approval__Assigned_To_Name__c = userSO.Name;
		requestSO3.Apttus_Approval__Assigned_To_Type__c = 'User';
        requestSO3.Apttus_Approval__Step__c = stepSO3.Id;
		requestSO3.Apttus_Approval__Object_Id__c = opptySO.Id;
		requestSO3.Apttus_Approval__Object_Type__c = 'Opportunity';
		requestSO3.Apttus_Approval__Object_Name__c = opptySO.Name;
		
		// insert approval request
		insert requestSO3;

		// STEP V - Create the controller
		// Create the email component controller
		CustomMyApprovalsEmailController controller = new CustomMyApprovalsEmailController();
		
		// STEP VI - Test methods
		
		// start the test
		Test.startTest();
		
		controller.setRequestSO(requestSO);
		controller.setRecipientSO(userSO);
		
		// request and recipient paraneters
		System.assertNotEquals(controller.getRequestSO(), null);
		System.assertNotEquals(controller.getRecipientSO(), null);
		
		// requests
		System.assert(controller.getUserApprovals().size() > 0);
		// completion comments - empty
		System.assert(controller.getCompletionComments().isEmpty() == true);
		// comments labels
		System.assert(controller.getComment1Label()== null);
		System.assert(controller.getComment2Label()== null);
		System.assert(controller.getComment3Label()== null);
		
		// status
		System.assert(controller.getAreActionsSupported());
		System.assert(!controller.getIsStatusCancelled());
		
		// email response
		System.debug('EmailApprovalResponseEnabled=' + controller.getIsEmailApprovalResponseEnabled());
		
		// email links
		System.debug('MyApprovalsPageUrl=' + controller.getMyApprovalsPageUrl());
		
		// approval history
		System.assert(!controller.getApprovalHistory().isEmpty());

		// end the test 
		Test.stopTest();
		
	}

}