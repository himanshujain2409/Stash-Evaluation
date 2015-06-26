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
@isTest (seealldata=true)
private class MilestoneProjectTriggerTest {

    static testMethod void mileStoneUpdateProjectTest() {
       pse__Proj__c p = new pse__Proj__c();
    	p.Name = 'ProjectTest';
    	p.pse__Is_Active__c = true;
    	p.Training_MS_Count__c=0;
    	insert p;
    	
    	pse__Milestone__c pmt = new pse__Milestone__c();
    	pmt.Name = 'MilestoneTrainTgTest';
    	pmt.Training_Milestone__c = 'Training';
    	pmt.pse__Project__c = p.Id;
    	DateTime dt = System.now();
		Date d = dt.date();
    	pmt.pse__Target_Date__c = d;
    	pmt.pse__Milestone_Amount__c = 1000;
    	insert pmt;
        
        pse__Milestone__c pmt1 = new pse__Milestone__c();
    	pmt1.Name = 'MilestoneTrainTgTest1';
    	pmt1.Training_Milestone__c = 'Project';
    	pmt1.pse__Project__c = p.Id;
    	pmt1.pse__Target_Date__c = d;
    	pmt1.pse__Milestone_Amount__c = 0;
    	insert pmt1;
        
        pse__Milestone__c pmt2 = new pse__Milestone__c();
    	pmt2.Name = 'MilestoneTrainTgTest2';
    	pmt2.Training_Milestone__c = 'Financial';
    	pmt2.pse__Project__c = p.Id;
    	pmt2.pse__Target_Date__c = d;
    	pmt2.pse__Milestone_Amount__c = 1000;
    	insert pmt2;
        
        pmt.pse__Milestone_Amount__c = 2000;
        update pmt;
    	 
    	 //pse__Proj__c pt = [SELECT Id,Name,Training_MS_Count__c FROM pse__Proj__c WHERE ID=:p.Id];
    	//system.assertEquals(pt.Training_MS_Count__c,1);
    }
}