@isTest
private class TestProjectApprovalEmailController {
                              
    private TestProjectApprovalEmailController () {
    }
    
    static testmethod void test1() {
        
        TestProjectApprovalEmailController testController = new TestProjectApprovalEmailController ();
        // test the approval email 
        testController.testApprovalEmail1();
        
    }
    
  
    private void testApprovalEmail1() {
        
           
        List<pse__Proj__c> projectList = TestUtility.CreateProject('Test Project','Pipeline',1);
        insert projectList;
        
        List<Concession_Request__c> cRequestList = TestUtility.CreateConcessionRequest(projectList[0].Id,'PS','Pending Approval',10);
        insert cRequestList;

        List<Apttus_Approval__Approval_Request__c > requestSOList = TestUtility.CreateApprovalRequest(projectList[0],cRequestList,'Test User');
        insert requestSOList;

        User userSO = null;
       
        System.runAs(new User(Id = System.UserInfo.getUserId())) {
            userSO = Apttus_Approval.TestSupport.createUser('assignee1@approvals.xyz.com', 
                                                            'ast1', 
                                                            'assignee1',
                                                            'tester',
                                                            'assignee1@approvals.xyz.com',
                                                            ID.valueOf(UserInfo.getProfileId()));
                                         
            // fetch the assignee 
            userSO = Apttus_Approval.TestSupport.getUserSO(userSO.Id);
           
        
        }
       
        PS_ProjectApprovalEmailController controller = new PS_ProjectApprovalEmailController();
       
        Test.startTest();
        
        Apttus_Approval.ContextApprovalEmailController context = controller.getContext();
        
        context.setRequestSO(requestSOList[0]);
        context.setRecipientSO(userSO);
       
        System.assertNotEquals(context.getRequestSO(), null);
       
        System.assertNotEquals(controller.getEmailWrapper(), null);
       
        // end the test 
        Test.stopTest();
        
    }
    
    
}