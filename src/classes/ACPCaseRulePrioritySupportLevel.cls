/* 
* Scheduler to run every other our and check defined criteria:
* Case is marked as “critical” or customer support level is “premium”, 
* reminder emails get send to support staff every other hour – in the “red”.
* @author Copyright (c) 2012 Apttus.
* @author dberriel@altimetrik.com
*/

global with sharing class ACPCaseRulePrioritySupportLevel implements Schedulable { 
	
	//String to set the frequency of schedule
	public static final String CRON_EXP = '0 0 0,2,4,6,8,10,12,14,16,18,20,22 * * ?';
	
	global void execute(SchedulableContext SC) {
		
		createSendData();
		
	}
	
	public void createSendData(){
		String subject = Label.ACPSubjectMailInRed;
		String bodyEmail = '- The following cases are in RED status - \n \n'
		+'Criteria \n' 
		+'Priority: "Critical" or Customer Support Level: "Premium" \n \n';
		
		List<Case> caselist = [SELECT Type, Status, Priority, Subject, ContactAssigned__c,
								Owner.Email, OwnerId, Id, 
								CaseNumber, Account.Support_Level__c, 
								AccountId FROM Case 
								WHERE Type!='Service Request' AND (
									(IsClosed = False OR Status!='Resolved') AND 
									(Priority='Critical' OR Account.Support_Level__c='Premium'))
									ORDER BY CaseNumber DESC];
		if(caselist.size() >0){
			Contact myContact = ACPUtils.getDummyContact();
			
			//Add each cases on the body email
			for(Case c: caselist){
				String caseDetail = 'Case: '+ c.CaseNumber + ': '+ c.Subject + '\n'
				+'Assigned to: ' + c.ContactAssigned__c + ' \n'
				+'Click on the link to access the case: '
				+ URL.getSalesforceBaseUrl().toExternalForm() + '/' + c.Id + ' \n'
				+'------------------------------------------------------------------------------------' + ' \n \n';
				bodyEmail = bodyEmail+caseDetail; 
			}
			//Send email
			ACPUtils.sendEmail(myContact.Id, bodyEmail, subject);
			//Delete dummy data
			ACPUtils.deleteDummyObjects();
		}
	}
	 
	public static String scheduleJob(String pName) {
        ACPCaseRulePrioritySupportLevel psl = new ACPCaseRulePrioritySupportLevel();
        return System.schedule(pName, CRON_EXP, psl);
    }
}