/*
* Schedule job that runs daily
* @author Copyright (c) 2012 Apttus.
* @author lferreira@altimetrik.com
*/
global with sharing class ACPScheduleJob implements Schedulable {

	/* String to set the frequency of schedule */
	public static final String CRON_EXP = '0 0 9 * * ?';

	global void execute(SchedulableContext SC) {
		
		/* daily mail sended to support stuff with the status of cases */
		ACPCaseRuleSupportLevelTimeSLA.CaseRuleSupportLevelTimeSLA();
		
		/* daily mail sended to the customer success stuff with the report of the downloaded packages */
		ACPInstallScheduleUtils.sendReportToSuccessStuff();
		
		/* daily mail sended to the customer success stuff with the report of learning downloads */
		ACPTrainingScheduleUtils.sendReport();
	}
	
	/* helper method to schedule this scheduler class */
	public static String scheduleJob(String pName) {
        ACPScheduleJob job = new ACPScheduleJob();
        return System.schedule(pName, CRON_EXP, job);
    }
}