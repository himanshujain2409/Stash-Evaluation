/**************************************************************
 * Name             : TestMetricsThatMatterController
 * Created Date     : Sep 29, 2012.
 * Purpose          : Tests for MetricsThatMatterController
 **************************************************************/
@isTest
private class TestMetricsThatMatterController {

    static testMethod void testMetricsThatMatterController() {
        
        init();
        Test.startTest();
        MetricsThatMatterController controller = new MetricsThatMatterController();
        //System.assertEquals(controller.metricWrappers.size(), 1);
        
         //Change filter condition
        controller.showOption = MetricsThatMatterController.SHOW_MY_TOUCH;
        controller.filter();
        //System.assertEquals(controller.metricWrappers.size(), 1);
        
        controller.showOption = MetricsThatMatterController.SHOW_TEAMS_TOUCH;
        controller.filter();
        //System.assertEquals(controller.metricWrappers.size(), 1);
        
        controller.fromDate.Callback_Date__c = System.today() - 20;
        controller.toDate.Callback_Date__c = System.today() + 1;
        controller.filter();
        //System.assertEquals(controller.metricWrappers.size(), 1);
        
        PageReference page = controller.exportXls();
        System.assertEquals(page.getUrl().contains('MetricsThatMatterExport'), true);
        Test.stopTest();
    }
    
    static void init(){
        
        //Contact contact= [ SELECT Id FROM Contact LIMIT 1 ];
        Contact contact = new Contact(LastName = 'Test');
        insert contact;
        
        // Create a test Round record
        FRLS_Round__c round = new FRLS_Round__c();
        round.Name = 'Closed Round';
        round.Task__c = 'Callback';
        round.Contact__c = contact.Id;
        round.Admin_Dialogue__c = true;
        round.Admin_EM__c = true;
        round.Admin_VM__c = true;
        round.KP_Dialogue__c = true;
        round.KP_EM__c = true;
        round.KP_VM__c = true;
        round.Referral__c = true;
        insert round;
        
        // Create a test Round record
        FRLS_Round__c round2 = new FRLS_Round__c();
        round2.Name = 'Open Round';
        round2.Task__c = 'Callback';
        round2.Contact__c = contact.Id;
        round2.Admin_Dialogue__c = true;
        round2.Admin_EM__c = true;
        round2.Admin_VM__c = true;
        round2.KP_Dialogue__c = true;
        round2.KP_EM__c = true;
        round2.KP_VM__c = true;
        round2.Referral__c = true;
        insert round2;
    }
}