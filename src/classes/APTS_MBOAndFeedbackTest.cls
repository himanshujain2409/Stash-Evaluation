/*************************************************************
@Name: APTS_MBOAndFeedbackTest
@Author: KrishnaRajani Yadlapalli,PS - Apttus
@CreateDate:  03/23/2015
@Description: Test Class for MBO and Perfamance controller files
@UsedBy: APTS_MyTeamMBOsController,APTS_MBOPerformanceReviewController
******************************************************************
@ModifiedBy: 
@ModifiedDate: 
@ChangeDescription: 

******************************************************************/
@isTest
private class APTS_MBOAndFeedbackTest {
	
	@isTest static void testEmployeeMBOs() {
		Profile profile  = [Select Id, Name FROM Profile where Name = 'System Administrator'];
	    User psManager = APTS_TestClassUtility.getUserObj(profile.Id);
        insert psManager;

	    User manager = APTS_TestClassUtility.getUserObj(profile.Id);
	    manager.Manager = psManager;
        insert manager;

    	User employee = APTS_TestClassUtility.getUserObj(profile.Id);
    	employee.Manager = manager;
    	insert employee;

    	MBO__c mbo1 = APTS_TestClassUtility.createMBO(employee,manager,'2014','Q1/Q2');
    	insert mbo1;

    	MBO__c mbo2 = APTS_TestClassUtility.createMBO(employee,manager,'2014','Q3/Q4');
    	insert mbo2;
        
        System.runAs (employee) {     	

        	PageReference pr = Page.APTS_MyTeamMBOs;
        	Test.setCurrentPage(pr);
         	APTS_MyTeamMBOsController mboCtrl = new APTS_MyTeamMBOsController();
            try{
                mboCtrl.getTabbedView();
            }catch(Exception e){
                System.assert(e!= null);
            }
            Parm__c parm = new Parm__c();
            parm.Name = APTS_CONSTANTS.PARM_TABSCOUNT_MBOPAGE;
            parm.Parm_number__c = 3;
            insert parm;

            mboCtrl.getTabbedView();

        	mboCtrl.selectedyearValue = mbo2.MBO_Year__c;
        	mboCtrl.addPerformanceFeedback();
        	mboCtrl.getTabbedView();

        	List<Performance_Reviews__c> prs = [Select Id,Manager__c From Performance_Reviews__c Where Employee__c =:employee.Id];
        	System.assert(prs != null && !prs.isEmpty());
        	System.debug(mboCtrl.selfReviewCompleted);
        	APTS_MBOHelper mboHelper = new APTS_MBOHelper();
            APTS_CONSTANTS constants = new APTS_CONSTANTS();

        	Test.startTest();
                Performance_Reviews__c performanceReview = prs.get(0);
                performanceReview.Overall_Rating__c = APTS_CONSTANTS.PR_OVERALLRATING_1;
            	Apexpages.Standardcontroller stdCtrl = new Apexpages.Standardcontroller(performanceReview);
                APTS_MBOPerformanceReviewController perfRevCtrl = new APTS_MBOPerformanceReviewController(stdCtrl);
                performanceReview = perfRevCtrl.performanceReview;
                performanceReview.Overall_Rating__c = APTS_CONSTANTS.PR_OVERALLRATING_1;
                performanceReview.Review_Visible_to_Employee__c = APTS_CONSTANTS.PR_REVIEW_VISIBLE_EMP_YES;
                perfRevCtrl.performanceReview = performanceReview;
                perfRevCtrl.getrendersavebuttons();
                perfRevCtrl.saveAndPending();
                perfRevCtrl.saveAndSubmit();
                perfRevCtrl.makeresultsvisibletoemployee();
                perfRevCtrl.gotoMBO();
                try{
                     performanceReview.MBO_Q3_Q4__c = employee.Id;
                     perfRevCtrl.performanceReview = performanceReview;
                     perfRevCtrl.saveAndPending();
                }catch(Exception e){
                    System.assert(e!= null);
                }

                try{
                     performanceReview.MBO_Q3_Q4__c = employee.Id;
                     perfRevCtrl.performanceReview = performanceReview;
                     perfRevCtrl.makeresultsvisibletoemployee();
                }catch(Exception e){
                    System.assert(e!= null);
                }
        	Test.stopTest();
        }

	}
	
	@isTest static void testManagerMBOs() {
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

    	MBO__c mbo1 = APTS_TestClassUtility.createMBO(employee,manager,'2014','Q1/Q2');
    	insert mbo1;

    	MBO__c mbo2 = APTS_TestClassUtility.createMBO(employee,manager,'2014','Q3/Q4');
    	insert mbo2;

    	Performance_Reviews__c perRev = APTS_TestClassUtility.createPerformanceFeedback(mbo2);
    	perRev.Status__c = APTS_CONSTANTS.PR_STATUS_EMP_COMPLETE;
        insert perRev;

        System.runAs (manager) {     	

        	MBO__c managerMbo1 = APTS_TestClassUtility.createMBO(manager,psManager,'2014','Q1/Q2');
        	insert managerMbo1;

        	MBO__c managerMbo2 = APTS_TestClassUtility.createMBO(manager,psManager,'2014','Q3/Q4');
        	insert managerMbo2;

        	Performance_Reviews__c managerPerRev = APTS_TestClassUtility.createPerformanceFeedback(managerMbo2);
        	insert managerPerRev;

        	PageReference pr = Page.APTS_MyTeamMBOs;
        	Test.setCurrentPage(pr);
         	APTS_MyTeamMBOsController mboCtrl = new APTS_MyTeamMBOsController();
        	mboCtrl.getTabbedView();

            Test.startTest();
                Apexpages.Standardcontroller stdCtrl = new Apexpages.Standardcontroller(perRev);
                APTS_MBOPerformanceReviewController perfRevCtrl = new APTS_MBOPerformanceReviewController(stdCtrl);
                perRev = perfRevCtrl.performanceReview;
                perRev.Overall_Rating__c = '2. Orbited Earth';
                perRev.Review_Visible_to_Employee__c = APTS_CONSTANTS.PR_REVIEW_VISIBLE_EMP_YES;
                perfRevCtrl.performanceReview = perRev;
                perfRevCtrl.getrendersavebuttons();
                perfRevCtrl.saveAndPending();
                perfRevCtrl.saveAndSubmit();
                perfRevCtrl.makeresultsvisibletoemployee();
                perfRevCtrl.getrendersavebuttons();
                try{
                     perRev.Overall_Rating__c = null;
                     perRev.MBO_Q3_Q4__c = employee.Id;
                     perfRevCtrl.performanceReview = perRev;
                     perfRevCtrl.saveAndSubmit();
                }catch(Exception e){
                    System.assert(e!= null);
                }

            Test.stopTest();
        	
        }
	}


	
}