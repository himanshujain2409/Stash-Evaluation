/*************************************************************
@Name: APTS_PFSharingTriggerTest
@Author: KrishnaRajani Yadlapalli,PS - Apttus
@CreateDate:  03/30/2015
@Description: Test Class Perfamance Feedback Sharing trigger
@UsedBy: APTS_PFSharingTrigger
******************************************************************
@ModifiedBy: 
@ModifiedDate: 
@ChangeDescription: 

******************************************************************/
@isTest
private class APTS_PFSharingTriggerTest {
	
	@isTest static void testPerformanceSharing() {
		Profile profile  = [Select Id, Name FROM Profile where Name = 'System Administrator'];
	    User userObj = APTS_TestClassUtility.getUserObj(profile.Id);
        insert userObj;

	    User manager = APTS_TestClassUtility.getUserObj(profile.Id);
	    manager.Manager = userObj;
        insert manager;

    	User employee = APTS_TestClassUtility.getUserObj(profile.Id);
    	employee.Manager = manager;
    	insert employee;
 	    	
    	Performance_Reviews__c perRev = APTS_TestClassUtility.createPerformanceFeedback(employee,manager,'2015');
        insert perRev;

        System.runAs (manager) {     	

        	perRev.Employee__c = userObj.Id;
        	perRev.Manager__c = employee.Id;
        	update perRev;   

        	List<Performance_Reviews__Share> sharesObjs = [SELECT Id 
                                                FROM Performance_Reviews__Share 
                                                WHERE ParentId = :perRev.Id  
                                                AND RowCause = 'Manual'];
           System.assert(!sharesObjs.isEmpty()) ;    	
        }
	}	
}