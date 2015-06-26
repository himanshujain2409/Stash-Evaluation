/*
* Unit test for class ACPScheduleJob
* @author Copyright (c) 2012 Apttus.
* @author lferreira@altimetrik.com
*/
@isTest
public with sharing class ACPScheduleJobTest {
	
	/* test the execute method */
	static testmethod void testExecute() {
		
		test.startTest();
		
		// Schedule the test job 
    
		String jobId = System.schedule('testACPScheduleJob' + DateTime.now(),
										ACPScheduleJob.CRON_EXP,
										new ACPScheduleJob());
										
		
		// Get the information from the CronTrigger API object 
    
		CronTrigger ct = [	SELECT Id, CronExpression, TimesTriggered, NextFireTime
         					FROM CronTrigger
         					WHERE id = :jobId ];
         					
        
        // Verify the job has not run 
    
		System.assertEquals(0, ct.TimesTriggered);
		
		// Verify the next time the job will run 
		String expectedDate = '';
		
		if(DateTime.now().time() > Time.newInstance(9, 0, 0, 0)){
			expectedDate = String.valueOf(DateTime.newInstance(Date.today().addDays(1), Time.newInstance(9,0,0,0)));
		} else {
			expectedDate = String.valueOf(DateTime.newInstance(Date.today(), Time.newInstance(9,0,0,0)));
		}
		
		System.assertEquals(expectedDate, String.valueOf(ct.NextFireTime));
		
		test.stopTest();
	}
	
	/* test the scheduleJob method */
	static testmethod void testSecheduleJob() {
		test.startTest();
		
		// Schedule the test job 
    
		String jobId = ACPScheduleJob.scheduleJob('testACPScheduleJob' + DateTime.now());
										
		
		// Get the information from the CronTrigger API object 
    
		CronTrigger ct = [	SELECT Id, CronExpression, TimesTriggered, NextFireTime
         					FROM CronTrigger
         					WHERE id = :jobId ];
         					
        
        // Verify the job has not run 
    
		System.assertEquals(0, ct.TimesTriggered);
		
		// Verify the next time the job will run
		String expectedDate = '';
		
		if(DateTime.now().time() > Time.newInstance(9, 0, 0, 0)){
			expectedDate = String.valueOf(DateTime.newInstance(Date.today().addDays(1), Time.newInstance(9,0,0,0)));
		} else {
			expectedDate = String.valueOf(DateTime.newInstance(Date.today(), Time.newInstance(9,0,0,0)));
		}
		
		System.assertEquals(expectedDate, String.valueOf(ct.NextFireTime));
		
		test.stopTest();
	}
}