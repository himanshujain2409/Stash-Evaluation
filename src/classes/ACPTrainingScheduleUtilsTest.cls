/*
* Unit test for ACPTrainingScheduleUtils class
* @author Copyright (c) 2013 Apttus.
* @author lferreira@altimetrik.com
*/
@isTest
private class ACPTrainingScheduleUtilsTest {

    /* 
		test method for sendReport
		Only code coverage because the method only sends emails
	*/
	static testmethod void testSendReportToSuccessStuff(){
		
		ACP_Course__c testCourse = ACPTestUtils.createCourse();
		insert testCourse;
		
		User testUser = ACPTestUtils.getCurrentUser();
		
		ACP_Course_Download__c testDownload = ACPTestUtils.createCourseDownload(testCourse.Id, DateTime.now().addDays(-1));
		insert testDownload; 
		
		test.startTest();
		ACPTrainingScheduleUtils.sendReport();
		test.stopTest();
	}
}