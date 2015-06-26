/**************************************************************
 * Name             : TestPMProductivityReportController
 * Created Date     : Sep 29, 2012.
 * Purpose          : Tests for PMProductivityReportController
 **************************************************************/
@isTest
private class TestPMProductivityReportController {
    
    static testMethod void testPMProductivityReportController() {
        
        init();
        
        PMProductivityReportController controller = new PMProductivityReportController();
        //System.assertEquals(controller.roundSummaryList.size(), 1);
        
        //Change filter condition
        controller.showOption = PMProductivityReportController.SHOW_MY_TOUCH;
        controller.filter();
        //System.assertEquals(controller.roundSummaryList.size(), 1);
        
        controller.showOption = PMProductivityReportController.SHOW_TEAMS_TOUCH;
        controller.filter();
        //System.assertEquals(controller.roundSummaryList.size(), 1);
        
        controller.fromDate.Callback_Date__c = System.today() - 20;
        controller.toDate.Callback_Date__c = System.today() + 1;
        controller.filter();
        //System.assertEquals(controller.roundSummaryList.size(), 1);
        
        PageReference page = controller.xlsExport();
        System.assertEquals(page.getUrl().contains('PMPProductivityExport'), true);
    }
    
    static void init(){
        
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