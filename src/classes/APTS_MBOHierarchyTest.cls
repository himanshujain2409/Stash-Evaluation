/*************************************************************
@Name: APTS_MBOHierarchyTest
@Author: KrishnaRajani Yadlapalli,PS - Apttus
@CreateDate: 03/24/2015
@Description: Test class for my team mbos tree hierarachy class
@UsedBy: APTS_mbowrapper,APTS_MyTeamMBOHierarchialStructure
******************************************************************
@ModifiedBy: 
@ModifiedDate: 
@ChangeDescription: 

******************************************************************/
@isTest
private class APTS_MBOHierarchyTest {
	
	@isTest static void testMyTeamMbos() {
		Profile profile  = [Select Id, Name FROM Profile where Name = 'System Administrator'];
	    User psManager = APTS_TestClassUtility.getUserObj(profile.Id);
        insert psManager;

	    User manager = APTS_TestClassUtility.getUserObj(profile.Id);
	    manager.Manager = psManager;
        insert manager;

    	User employee = APTS_TestClassUtility.getUserObj(profile.Id);
    	employee.Manager = manager;
    	insert employee;

    	Parm__c parm = new Parm__c();
    	parm.Name = APTS_CONSTANTS.PARM_TABSCOUNT_MBOPAGE;
    	parm.Parm_number__c = 3;
    	insert parm;

    	String year = String.valueOf(Date.today().year());
    	MBO__c mbo1 = APTS_TestClassUtility.createMBO(employee,manager,year,'Q1/Q2');
    	insert mbo1;

    	MBO__c mbo2 = APTS_TestClassUtility.createMBO(employee,manager,year,'Q3/Q4');
    	insert mbo2;

    	MBO__c managerMbo1 = APTS_TestClassUtility.createMBO(manager,psManager,year,'Q1/Q2');
    	insert managerMbo1;

    	MBO__c managerMbo2 = APTS_TestClassUtility.createMBO(manager,psManager,year,'Q3/Q4');
    	insert managerMbo2;

        System.runAs (psManager) {     	

        	PageReference pr = Page.APTS_MyTeamMBOs;
        	Test.setCurrentPage(pr);
         	APTS_MyTeamMBOHierarchialStructure mboCtrl = new APTS_MyTeamMBOHierarchialStructure();
         	mboCtrl.year = year;
        	mboCtrl.getmyteammbos();
        }

	}
}