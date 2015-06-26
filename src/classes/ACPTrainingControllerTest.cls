/*
* Unit test for ACPTrainingController class
* @author Copyright (c) 2013 Apttus.
* @author lferreira@altimetrik.com
*/
@isTest
private class ACPTrainingControllerTest {
	
	/* test the normal flow with one course */
	static testmethod void testControllerNormaFlow(){
		
		/* create a new course*/
		ACP_Course__c course = ACPTestUtils.createCourse();
		insert course;
		
		
		test.startTest();
		
		/* create an instance of the controller */
		ACPTrainingController con = new ACPTrainingController();
		con.courseId = course.Id;
        con.askForItTrack();
        con.downloadTrack();
		/* assert the size of the collection */
		System.assertEquals(1, con.courses.size());
		
		test.stopTest();
	}
	
	/* test without courses */
	static testmethod void testControllerWithoutCourses(){
		
		test.startTest();
		
		/* create an instance of the controller */
		ACPTrainingController con = new ACPTrainingController();
		
		/* assert the size of the collection */
		System.assertEquals(0, con.courses.size());
		
		test.stopTest();
	}
	
	/* test with one course with the display on portal unchecked */
	static testmethod void testControllerWithACourseWithDisplayOnPortalUnchecked(){
		
		/* create a new course*/
		ACP_Course__c course = ACPTestUtils.createCourse(false);
		insert course;
		
		test.startTest();
		
		/* create an instance of the controller */
		ACPTrainingController con = new ACPTrainingController();
		
		/* assert the size of the collection */
		System.assertEquals(0, con.courses.size());
		
		test.stopTest();
	}
	
	/* test the categories */
	static testmethod void testCategories(){
		
		/* get the categories */
		List<Schema.PicklistEntry> catList = ACP_Course__c.Category__c.getDescribe().getPicklistValues();
		
		test.startTest();
		
		/* create an instance of the controller */
		ACPTrainingController con = new ACPTrainingController();
		
		/* assert the size of the collection */
		System.assertEquals(catList.size(), con.categoriesToDisplay.size());
		
		test.stopTest();
	}
	
	/* test the inner class, just code coverage */
	static testmethod void testInnerClass(){
		ACPTrainingController.CourseWrapper wrapper = new ACPTrainingController.CourseWrapper();
	}
}