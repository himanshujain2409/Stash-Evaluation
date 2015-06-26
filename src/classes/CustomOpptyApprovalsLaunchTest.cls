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
@isTest
private class CustomOpptyApprovalsLaunchTest extends CustomApprovalsConstants {

    // context user
    User user = null;

    Opportunity opptySO = null;
    OpportunityLineItem opptyLineItemSO = null;

    /**
     * Class Constructor
     */
    private CustomOpptyApprovalsLaunchTest() {
        
    }
    
    /**
     * Tests the controller
     */
    static testmethod void test() {
        
        CustomOpptyApprovalsLaunchTest testController = new CustomOpptyApprovalsLaunchTest();
        
        // create necessary data
        testController.createTestData();
        
        // start
        Test.startTest();
        
        // test oppty approvals launch
        testController.testOpptyLaunch();
        
        // stop
        Test.stopTest();
    }
    
    /**
     * Test oppty approvals launch 
     */
    private void testOpptyLaunch() {
        
        PageReference pageRef = Page.CustomOpptyApprovalsLaunch;
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(opptySO);
        CustomOpptyApprovalsLaunchController controller = new CustomOpptyApprovalsLaunchController(stdController);
        
        System.assert(controller.getCtxObjectId() == opptySO.Id);
        
        System.assert(controller.doLaunchApprovals() != null);
        System.assert(controller.doReturn() != null);
        
    }

    /**
     * Test the approval request view 
     */
    private void createTestData() {
                                  
        // get the system admin user
        user = CustomApprovalsTestSupport.getSysAdminUser();
        // if no system admin user, default to the current user
        if (user == null) {
            user = CustomApprovalsTestSupport.getCurrentUser();
            
        }

        // STEP IV - Create a new opportunity
        opptySO = CustomApprovalsTestSupport.createOpportunity(user, 
                                                            'Test Opportunity', 
                                                            'Opportunity with Acme Computers for $250000', 
                                                            Decimal.valueOf(250000), 
                                                            'Prospecting', 
                                                            Date.today());

    }
    
}