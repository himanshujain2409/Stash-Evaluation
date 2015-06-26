/*
* Helper class for the install management schedule functionality
* @author Copyright (c) 2012 Apttus.
* @author lferreira@altimetrik.com
*/
public with sharing class ACPInstallScheduleUtils {
	
	/*
	* Create a email with
	* a report about the downloaded packages.
	*/
	
	public static void sendReportToSuccessStuff(){
		
		List<ACP_Package_Download__c> downloads = null;
		downloads = [	SELECT	Account__c,
								Account__r.Name,
								Package_Version__c,
								Package_Version__r.sfLma__Package__r.Name,
								Package_Version__r.sfLma__Version__c,
								User__c,
								User__r.Name,
								Created_Date__c
						FROM ACP_Package_Download__c
						WHERE Created_Date__c = YESTERDAY];
		
		
		Contact myContact = ACPUtils.getDummyContact(Label.ACPCustomerSuccessStaffEmail);
		
		/* create the email body */
		
		String bodyEmail = '- The following packages were downloaded - \n \n';
		
		for(ACP_Package_Download__c d: downloads){
			String download_detail = 'Account: ' + d.Account__r.Name + '\n'
			+ 'User: ' + d.User__r.Name + '\n'
			+ 'Package: ' + d.Package_Version__r.sfLma__Package__r.Name + '\n'
			+ 'Package Version: ' + d.Package_Version__r.sfLma__Version__c + '\n'
			+ 'Date: ' + d.Created_Date__c + '\n'
			+'------------------------------------------------------------------------------------' + ' \n \n';
			bodyEmail = bodyEmail+download_detail; 
		}
		
		//Send email
		
		String todayDate = system.today().month() + '/' + system.today().day()+ '/'+ system.today().year();
		String subject = Label.ACPInstallCustomerSuccessStaffEmailSubject + ' ' + todayDate;
		ACPUtils.sendEmail(myContact.Id, bodyEmail, subject);
		
		//Delete dummy data
		ACPUtils.deleteDummyObjects();
	}
}