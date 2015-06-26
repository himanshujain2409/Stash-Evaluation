/**
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
@isTest (seeAllData=true)
private class CustomOpptyApprovalsControllerTest extends CustomApprovalsConstants {
    
    
    // context user
    User user = null;

    Opportunity opptySO = null;
    OpportunityLineItem opptyLineItemSO = null;
    
    /**
     * Tests the controller
     */
    static testmethod void test() {
        
        CustomOpptyApprovalsControllerTest testController = new CustomOpptyApprovalsControllerTest();
        
        // create necessary data
        testController.createTestData();
        
        // start
        Test.startTest();
        
        // test approval context type lineItem
        testController.testLineItemCtx();
        
        // test  approval context type opportunity (header & lineItem)
        testController.testOpptyCtx();
        
        // test approval context type header
        testController.testHeaderCtx();
        
        // test from opportunity
        testController.testFromOppty();

        // stop
        Test.stopTest();
    }
    
    /**
     * Test approval context type lineItem
     */
    private void testLineItemCtx() {
        
        // set approval status
        OpportunityLineItem li = new OpportunityLineItem(
            Id = opptyLineItemSO.Id,
            Apttus_Approval__Approval_Status__c = STATUS_APPROVAL_REQUIRED);
        update li;
        
        PageReference pageRef = Page.CustomOpptyApprovals;
        pageRef.getParameters().put(PARAM_OPPTY_ID, opptySO.Id);
        pageRef.getParameters().put(PARAM_LINEITEM_IDS, opptyLineItemSO.Id); 
        pageRef.getParameters().put(PARAM_ACTION, ACTION_SUBMIT); 
        pageRef.getParameters().put(PARAM_RETURN_BUTTON_LABEL, 'Return');
        pageRef.getParameters().put(PARAM_APPROVAL_TYPE, APPROVALCTX_LINEITEM);
        pageRef.getParameters().put(PARAM_RET_ID, opptyLineItemSO.Id);
        pageRef.getParameters().put(PARAM_FINALIZE_CLASS, 'DefaultActionCallback');
        pageRef.getParameters().put(PARAM_IS_DIALOG, 'true');
        pageRef.getParameters().put(PARAM_AR_FIELDSET_NAME, null);
        pageRef.getParameters().put(PARAM_HIDE_SUBMIT_WITH_ATTACHMENTS, 'false');
        
        Test.setCurrentPage(pageRef);
        
        CustomOpptyApprovalsController controller = new CustomOpptyApprovalsController();
        
        System.assert(controller.getContextInfo() != null);
        System.assert(controller.getReturnLabel() == null);
        
        controller.doReturnToCaller();
    }
    
    /**
     * Test approval context type opportunity (header & lineItem)
     */
    private void testOpptyCtx() {
        
        // set approval and approval-preview status
        opptySO.Approval_Preview_Status__c = STATUS_APPROVAL_REQUIRED;
        opptySO.Apttus_Approval__Approval_Status__c = APPROVAL_PREVIEW_STATUS_PENDING;
        update opptySO;
        
        PageReference pageRef = Page.CustomOpptyApprovals;
        pageRef.getParameters().put(PARAM_OPPTY_ID, opptySO.Id);
        pageRef.getParameters().put(PARAM_LINEITEM_IDS, opptyLineItemSO.Id); 
        pageRef.getParameters().put(PARAM_SHOW_HEADER, 'true');
        pageRef.getParameters().put(PARAM_SHOW_SIDEBAR, 'false');
        pageRef.getParameters().put(PARAM_INCLUDE_HEADER_APPROVALS, 'true');
        pageRef.getParameters().put(PARAM_ACTION_TAKEN, 'submit');
        
        Test.setCurrentPage(pageRef);
        
        CustomOpptyApprovalsController controller = new CustomOpptyApprovalsController();
        
        System.assert(controller.getContextInfo() != null);
        System.assert(controller.getFieldSetName() == null);
        System.assert(controller.getShowHeader() == true);
        System.assert(controller.getShowSidebar() == false);
        System.assert(controller.getContextInfo() != null);
        System.assert(controller.getHideSubmitWithAttachments() == false);
        System.assert(controller.getCanCancel() == false);
        
        // since we have not setup any entry criteria, approval status will be null/None
        System.assert(controller.getCanSubmit() == false);
        
        controller.doReturnToCaller();

        // test sf1 mode
        controller = new CustomOpptyApprovalsController();
        controller.setInSf1Mode(true);
        controller.doLaunchSObjectApprovals();
        
        controller.doReturnToCaller();
        controller.doReturn();
        
    }
    
    /**
     * Test approval context type header 
     */
    private void testHeaderCtx() {
        
        // set approval status
        OpportunityLineItem li = new OpportunityLineItem(
            Id = opptyLineItemSO.Id,
            Apttus_Approval__Approval_Status__c = STATUS_APPROVAL_REQUIRED);
        update li;
        
        PageReference pageRef = Page.CustomOpptyApprovals;
        pageRef.getParameters().put(PARAM_OPPTY_ID, opptySO.Id);
        pageRef.getParameters().put(PARAM_ACTION, ACTION_SUBMIT); 
        pageRef.getParameters().put(PARAM_RETURN_BUTTON_LABEL, 'Return to Opportunity');
        pageRef.getParameters().put(PARAM_APPROVAL_TYPE, APPROVALCTX_HEADER);
        pageRef.getParameters().put(PARAM_ACTION_TAKEN, 'return');
        
        Test.setCurrentPage(pageRef);
        
        CustomOpptyApprovalsController controller = new CustomOpptyApprovalsController();
        
        System.assert(controller.getContextInfo() != null);
        System.assert(controller.getReturnLabel() == 'Return to Opportunity');
        
        controller.doReturnToCaller();

        opptySO.Apttus_Approval__Approval_Status__c = 'Approved';
        update opptySO;
    }
    
    /**
     * Test approval requests for opportunity
     */
    private void testFromOppty() {

        PageReference pageRef = Page.CustomOpptyApprovals;
        pageRef.getParameters().put(PARAM_OPPTY_ID, opptySO.Id);
        pageRef.getParameters().put(PARAM_RETURNID, opptySO.Id);
        pageRef.getParameters().put(PARAM_RETURN_BUTTON_LABEL, 'Return to Opportunity');
        
        Test.setCurrentPage(pageRef);
        
        CustomOpptyApprovalsController controller = new CustomOpptyApprovalsController();
        
        controller.doReturn();
        controller.doSubmit();
        controller.doSubmitWithAttachments();
        controller.doCancel();
        controller.doReturnToCaller();
        
        // test other methods
        User userSO = CustomApprovalsTestSupport.getCurrentUser();
        userSO = CustomApprovalsTestSupport.getUserSO(user.Id);
        Opportunity oppSO = CustomApprovalsUtil.getOpportunity(opptySO.Id);
        List<OpportunityLineItem> oppProducts = CustomApprovalsUtil.getOpptyProducts(opptySO.Id);
        
    }   
    
    /**
     * Test the approval request view 
     */
    private void createTestData() {
        
        // create custom settings first - used by the Trigger...
        Apttus_Approval__ApprovalsCustomConfig__c configSO = new Apttus_Approval__ApprovalsCustomConfig__c(Name = 'Opportunity');
        configSO.Apttus_Approval__ApprovalContextType__c = CONTEXT_TYPE_MULTIPLE;
        // insert custom configuration
        insert configSO;
                
        // get the system admin user
        user = CustomApprovalsTestSupport.getSysAdminUser();
        // if no system admin user, default to the current user
        if (user == null) {
            user = CustomApprovalsTestSupport.getCurrentUser();
            
        }

        // STEP I - Get the standard price book
        ID pricebookId = CustomApprovalsTestSupport.getStandardPriceBookId();
        
        // STEP II - Create a new opportunity
        opptySO = CustomApprovalsTestSupport.createOpportunity(user, 
                                                            'Test Opportunity Discount Approval Process', 
                                                            'Opportunity with Acme Computers for $250000', 
                                                            Decimal.valueOf(250000), 
                                                            'Closed Won', 
                                                            Date.today());
        
        // set values
        opptySO.TotalOpportunityQuantity = 2500;
        opptySO.Apttus_Approval__Approval_Status__c = STATUS_NOT_SUBMITTED;
        opptySO.Pricebook2Id = pricebookId;
        update opptySO;
        
        // STEP III - Create a new product
        Product2 productSO = CustomApprovalsTestSupport.createProduct(user,
                                                                   'Patient Accounting',
                                                                   'PA01',
                                                                   'HMS',
                                                                   'Patient Accounting');
        
        // add the product to the standard price book
        if (pricebookId != null) {
            PricebookEntry entrySO = CustomApprovalsTestSupport.createPricebookEntry(user, pricebookId, productSO.Id, 0);
            
            // STEP IV - Create a new opportunity line item
            opptyLineItemSO = CustomApprovalsTestSupport.createOpportunityLineItem(user,
                                                                                opptySO.Id,
                                                                                entrySO.Id,
                                                                                5,
                                                                                5000,
                                                                                'Patient Accounting');

        }
        
        Apttus_Approval__Approval_Process__c processSO = Apttus_Approval.TestSupport.createApprovalProcess(
                                                              'Opportunity Discount Approval Process', 
                                                              1,
                                                              'Opportunity',
                                                              null,
                                                              null,
                                                              null,
                                                              null, 
                                                              null, 
                                                              true);
                                                              

    }


}