public with sharing class OpportunityPopupController {

	ApexPages.StandardController controller;
	public Opportunity opp {get;set;}
	public Opportunity oppFull {get;set;}
	public List<lmscons__Training_User_License__c> tu {get;set;}
	public lmscons__Training_User_License__c tu_item {get;set;}
	public String UserName {get;set;}
	public String ModuleName {get;set;}


	public OpportunityPopupController(ApexPages.StandardController controller){

		this.controller = controller;
		opp = (Opportunity)controller.getRecord();
		oppFull = [SELECT Id, Name, Amount, CloseDate, Training_Content_Ids__c FROM Opportunity WHERE Id = :opp.Id];
		if (oppFull.Training_Content_Ids__c != null){
			List<String> modulesIds = oppFull.Training_Content_Ids__c.split(',');
			tu = [SELECT Id, lmscons__Content_License__r.lmscons__Training_Content__r.lmscons__Title__c FROM lmscons__Training_User_License__c WHERE lmscons__Content_License__r.lmscons__Training_Content__c = :modulesIds[0] AND lmscons__User__c = :UserInfo.getUserId()];
			tu_item = tu[0];
			ModuleName = tu_item.lmscons__Content_License__r.lmscons__Training_Content__r.lmscons__Title__c;
		}
		UserName = UserInfo.getName();

	}

	public PageReference openModule(){

		oppFull.Training_Content_Ids__c = null;
		update oppFull;

		return null;
	}

	public PageReference NoOpenModule(){

		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		User u = [SELECT Id, Email FROM User WHERE Id = :userInfo.getUserId()];
		String[] toAddresses = new String[] {u.Email};
		mail.setToAddresses(toAddresses);
		mail.setSubject('Assigned module');
		String Msg = 'You\'ve been assigned the "'+tu_item.lmscons__Content_License__r.lmscons__Training_Content__r.lmscons__Title__c+'" module in regards to the "'+oppFull.Name+'" opportunity';
		mail.setPlainTextBody (Msg);
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

		oppFull.Training_Content_Ids__c = null;
		update oppFull;

		return null;
	}



}