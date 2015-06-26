@isTest
private class Test_OpportunityRoundsController 
{
	static testMethod void testOpportunityRoundsController() 
	{
		Account account = new Account(
			Name = 'Test Account');
		insert account;
		
		Contact contact = new Contact(
			LastName = 'Test Contact');
		insert contact;
		
		List<FRLS_Round__c> rounds = new List<FRLS_Round__c>();
		for (Integer i=0; i<5; i++)
		{
			rounds.add(new FRLS_Round__c(
				Account__c = account.Id,
				Name = 'Open Round',
				Contact__c = contact.Id));
		}
		insert rounds;
		
		Opportunity opportunity = new Opportunity(
			AccountId = account.Id,
			CloseDate = Date.today().addMonths(1),
			Name = 'Test Name',
			StageName = 'Test Stage');
		insert opportunity;
		
		ApexPages.StandardController standardController = new ApexPages.StandardController(opportunity);
		
		Test.startTest();
		OpportunityRoundsController controller = new OpportunityRoundsController(standardController);
		Test.stopTest();
	}
}