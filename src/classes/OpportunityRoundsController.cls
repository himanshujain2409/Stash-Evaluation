public with sharing class OpportunityRoundsController 
{
	public List<FRLS_Round__c> rounds {get; set;}
	
	private Id accountId;
	public OpportunityRoundsController(ApexPages.StandardController controller) 
	{
		rounds = new List<FRLS_Round__c>();
		
		if (!Test.isRunningTest())
		{
			controller.addFields(new List<String>{'AccountId'});
			accountId = ((Opportunity)controller.getRecord()).AccountId;
		} else
		{
			accountId = [SELECT AccountId FROM Opportunity WHERE Id = :controller.getId() limit 1].AccountId;
		}
		
		for (FRLS_Round__c round : [
				SELECT Id, Name, Task__c, Callback_Date__c, KP_EM__c, KP_VM__c, Admin_Dialogue__c, KP_Dialogue__c,
					Admin_EM__c, Admin_VM__c, Note__c
				FROM FRLS_Round__c 
				WHERE Account__c = :accountId])
		{
			rounds.add(round);
		}
	}
}