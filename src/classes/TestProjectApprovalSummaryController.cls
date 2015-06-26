@isTest
private class TestProjectApprovalSummaryController {
                              
    /**
     * Class Constructor
     */
    private TestProjectApprovalSummaryController () {
    }
    
    /**
     * Tests the controller
     */
    static testmethod void test1() {
        
        TestProjectApprovalSummaryController testController = new TestProjectApprovalSummaryController ();
        
        // test the approval email 
        testController.testApprovalEmail1();
        
    }
    
    /**
     * Test the approval email 
     */
    private void testApprovalEmail1() {
        
        // STEP I - Create a new case
        pse__Proj__c project = new pse__Proj__c();
        project.Name = 'Test project';
        project.pse__Stage__c = 'Pipeline';
        insert project;
        Concession_Request__c request = new Concession_Request__c();
        request.Project__c = project.Id;
        request.Concession_Type__c = 'PS';
        request.Root_cause__c = 'Communication issues';
        request.Requestor__c = userinfo.getuserid();
        request.Requested_on_behalf__c =  userinfo.getuserid();
        request.Hours_Requested__c = 10;
        request.X1_Has_work_been_delivered__c = '';
        request.Reasons_for_cost_and_time_overruns__c ='test';
        request.Delivery_Confidence__c= 'test';
        request.Risks__c ='test';
        insert request;
        
        
        
        // STEP II - Create a new process
        Apttus_Approval__Approval_Process__c processSO = Apttus_Approval.TestSupport.createApprovalProcess('TEST-' + Datetime.now().format(), 
                                                                                                           1,
                                                                                                           'pse__Proj__c',
                                                                                                           null,
                                                                                                           null,
                                                                                                           null,
                                                                                                           null, 
                                                                                                           null, 
                                                                                                           true);
                                                              
        // STEP III - Create approval users
        User userSO = null;
        User userSO2 = null;
        
        System.runAs(new User(Id = System.UserInfo.getUserId())) {
            userSO = Apttus_Approval.TestSupport.createUser('assignee1@approvals.xyz.com', 
                                                            'ast1', 
                                                            'assignee1',
                                                            'tester',
                                                            'assignee1@approvals.xyz.com',
                                                            ID.valueOf(UserInfo.getProfileId()));
                                         
            // fetch the assignee 
            userSO = Apttus_Approval.TestSupport.getUserSO(userSO.Id);
            
            userSO2 = Apttus_Approval.TestSupport.createUser('assignee2@approvals.xyz.com', 
                                                             'ast2', 
                                                             'assignee2',
                                                             'tester',
                                                             'assignee2@approvals.xyz.com',
                                                             ID.valueOf(UserInfo.getProfileId()));
                                                                                                              
            // fetch the assignee 
            userSO2 = Apttus_Approval.TestSupport.getUserSO(userSO2.Id);
        
        }
                                                                                                                                                                                                                                               
        // STEP IV - Create a new approval request
        Apttus_Approval__Approval_Request__c requestSO = Apttus_Approval.TestSupport.createAssignmentRequest(userSO, 
                                                                                                             processSO.Id, 
                                                                                                             request.Id, 
                                                                                                             'Case-3456');
        
        Apttus_Approval__Approval_Request__c requestSO2 = Apttus_Approval.TestSupport.createAssignmentRequest(userSO2, 
                                                                                                              processSO.Id, 
                                                                                                              request.Id, 
                                                                                                              'Case-3457');
        
        // STEP V - Create the controller
        // Create the email component controller
        Apttus_Approval__Approval_Request__c arequest = new Apttus_Approval__Approval_Request__c();
        requestSO .Apttus_Approval__Object_Id__c = project.Id;
        ApexPages.StandardController sc = new ApexPages.StandardController(requestSO );
        Test.setCurrentPageReference(new PageReference('Page.PSProjectApprovalSummary'));
        //customPage=PSProjectApprovalSummary&actionName=custom_approval_summary&pageMode=approveReject&Id=a0WR0000007FlhBMAS
        System.currentPageReference().getParameters().put('pageMode', 'approveReject');
        System.currentPageReference().getParameters().put('Id', processSO.Id);
        

        PageReference psummary = Page.PSProjectApprovalSummary;
        PS_ProjectApprovalSummaryController controller = new PS_ProjectApprovalSummaryController(sc);
        
        // STEP VI - Test methods
        
        // start the test
        Test.startTest();
        controller.getProject();
        controller.getConcessionRequest();
        controller.getSummaryWrapper();
        controller.doApprove();
        controller.doReject();
        controller.doAddComment();
        controller.doCancel();
        controller.doAttachFile();
        boolean ispage = controller.isPageModeApproveRequest ;
        
        //boolean ispagemode = controller.isPageModeApproveRequest;
        //controller.isUserAuthorized;
        //controller.SubmissionComment1Label;
        
        
        //System.assertNotEquals(controller.getProject(), null);
        //System.assertNotEquals(controller.getConcessionRequest(), null);
        //System.assertNotEquals(controller.getSummaryWrapper(), null);
        //System.assertNotEquals(controller.isPageModeApproveRequest, false);
        //System.assertNotEquals(controller.isUserAuthorized , false);
        //System.assertNotEquals(controller.SubmissionComment1Label, '');
        
        
        
       
        
        // end the test 
        Test.stopTest();
        
    }
    
    
}