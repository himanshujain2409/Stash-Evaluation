/*
* Scheduler to run every day and check defined criteria:
* Customer has “premier” support and date from opening case is greater than
* the estimated resolution time as listed in their Service License Agreement, a daily email gets sent to support staff – in the “red”
* @author Copyright (c) 2012 Apttus.
* @author dberriel@altimetrik.com
*/
public with sharing class ACPCaseRuleSupportLevelTimeSLA {
	
	public static void CaseRuleSupportLevelTimeSLA(){
		String subject = Label.ACPSubjectMailInRed;
		String bodyEmail = '- The following cases are in RED status - \n \n'
		+'Criteria \n' 
		+'Customer has “premier” support and date from opening case is greater than the estimated resolution time as listed in their Service License Agreement, a daily email gets sent to support staff \n \n';
		
		List<Case> caseList = [SELECT Type, Status, Priority, Subject,
								Owner.Email, OwnerId, Id, ContactAssigned__c, CaseOpeningTime__c,
								CaseNumber, Account.Support_Level__c, Account.CaseEstimatedReponseTime__c,
								AccountId FROM Case 
								WHERE Type!='Service Request' AND (
									(IsClosed = False OR Status!='Resolved') AND 
									(Account.Support_Level__c = 'Premium'))
									ORDER BY CaseNumber DESC];
		if(caseList.size() > 0){
			Contact myContact = ACPUtils.getDummyContact();
			
			//Add each cases on the body email
			for(Case c: caseList){
				if(c.CaseOpeningTime__c > c.Account.CaseEstimatedReponseTime__c){
					String caseDetail = 'Case: '+ c.CaseNumber + ': '+ c.Subject + '\n'
					+'Assigned to: ' + c.ContactAssigned__c + ' \n'
					+'Click on the link to access the case: '
					+ URL.getSalesforceBaseUrl().toExternalForm() + '/' + c.Id + ' \n'
					+'------------------------------------------------------------------------------------' + ' \n \n';
					bodyEmail = bodyEmail+caseDetail; 
				}
			}
			//Send email
			ACPUtils.sendEmail(myContact.Id, bodyEmail, subject);
			//Delete dummy data
			ACPUtils.deleteDummyObjects();
		}
	}
}