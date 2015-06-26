@isTest
public class TestAccountApprovalSummaryController
{
    private TestAccountApprovalSummaryController() {
    }
    
    static testmethod void test1() {
        
        TestAccountApprovalSummaryController testController = new TestAccountApprovalSummaryController();
        
        // test the approval email 
        testController.testApprovalSummary();
        
    }
    
    private void testApprovalSummary() {
        
        // STEP I - Create a new case
        Account acct =new Account(Name='Test Account');
        insert acct;
        
        Opportunity opp = new Opportunity(Name = 'Test -Opp');
        opp.AccountId = acct.Id;
        opp.StageName = 'Negotiate';
        Date myDate = Date.newInstance(1960, 2, 17);
        opp.CloseDate = system.today();
        opp.Type='';
        insert opp;
        
        Concession_Request_CS__c cRequest = new Concession_Request_CS__c();
        cRequest.Concession_Request_Type__c = '';
        cRequest.Concession_Request_Sub_Type__c= 'Rate Discount [# hours, proposed rate]';
        cRequest.Opportunity__c = opp.Id;
        cRequest.Justification__c = 'Testing';
        cRequest.Root_cause_characteristics__c = 'Keep customer happy';
        cRequest.Account__c = acct.Id;        
        insert cRequest;
        
                                                                                                                                                                                                                                                      
        // STEP II - Create a new approval request
        Apttus_Approval__Approval_Request__c requestSO = new Apttus_Approval__Approval_Request__c();
        requestSO.Apttus_Approval__Object_Id__c = acct.Id;
        requestSO.Apttus_Approval__ChildObjectId__c = cRequest.Id;
        insert requestSO;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(requestSO);
       
        Test.setCurrentPageReference(new PageReference('Page.AccountApprovalSummary'));
        System.currentPageReference().getParameters().put('pageMode', 'approveReject');
        System.currentPageReference().getParameters().put('Id', requestSO.Id);
    
        
        APTS_AccountApprovalSummaryController controller = new APTS_AccountApprovalSummaryController(sc);
        
        
        
       
        Test.startTest();
             
        //controller.approvalRequest = requestSO;
        
        System.assertNotEquals(controller.getAccount(), null);
        System.assertNotEquals(controller.getConcessionRequest(),null);
        
        System.assertNotEquals(controller.isPageModeApproveRequest,false);
        System.assertNotEquals(controller.isUserAuthorized ,false);
        string label1 = controller.SubmissionComment1Label;
        string label2 = controller.SubmissionComment2Label;
        string label3 = controller.SubmissionComment3Label;
        System.assertNotEquals(controller.getARAttachments(),null);
        
        controller.doApprove();
        controller.doReject();
        
        controller.doAddComment();
        controller.doCancel();
        controller.doAttachFile();
        
        
        
        
        
        // end the test 
        Test.stopTest();
        
    }
    
    
    
    
    
    
}