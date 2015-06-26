/*
* Helper class for the install management schedule functionality
* @author Copyright (c) 2013 Apttus.
* @author lferreira@altimetrik.com
*/
public with sharing class ACPTrainingScheduleUtils {
	
	/*
	* Create a email with
	* a report about the training downloads.
	*/
	
	public static void sendReport(){
		
		List<ACP_Course_Download__c> downloads = null;
		downloads = [	SELECT	
								User__c,
								User__r.Name,
								Created_Date__c,
								Course__c,
								Course__r.Name,
								isEmail__c	
						FROM ACP_Course_Download__c
						WHERE Created_Date__c = YESTERDAY];
		
		
		Contact myContact = ACPUtils.getDummyContact(Label.ACPCustomerSuccessStaffEmail);
		
		/* create the email body */
		
		String bodyEmail = '- The following courses were downloaded - \n \n';
		
		for(ACP_Course_Download__c d: downloads){
			
			String userAction = (d.isEmail__c == true)? 'Email' : 'Download';
			
			String download_detail = 'User: ' + d.User__r.Name + '\n'
			+ 'Course: ' + d.Course__r.Name + '\n'
			+ 'User Action: ' + userAction + '\n'
			+ 'Date: ' + d.Created_Date__c + '\n'
			+'------------------------------------------------------------------------------------' + ' \n \n';
			bodyEmail = bodyEmail+download_detail; 
		}
		
		//Send email
		
		String todayDate = system.today().month() + '/' + system.today().day()+ '/'+ system.today().year();
		String subject = Label.ACPTrainingCustomerSuccessStaffEmailSubject + ' ' + todayDate;
		ACPUtils.sendEmail(myContact.Id, bodyEmail, subject);
		
		//Delete dummy data
		ACPUtils.deleteDummyObjects();
	}
	
}