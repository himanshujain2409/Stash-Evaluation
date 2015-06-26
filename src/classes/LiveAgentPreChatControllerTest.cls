@isTest
public class LiveAgentPreChatControllerTest {
	static testmethod void testCreateLead() {
		String firstName = 'John';
		String lastName = 'Doe';
		String email = 'test@apttus.com';
		String company = 'Apttus';
		String country = 'GERMANY';
		String country_us = 'UNITED STATES';
		String state = 'CA';
		
		//no last name
		try{
			System.assertEquals(null, LiveAgentPreChatController.createLead(firstName, '', email, company, country, state));
		} catch(System.DmlException e) {
			System.assertEquals(StatusCode.REQUIRED_FIELD_MISSING, e.getDmlType(0));
			System.assertEquals('LastName', e.getDmlFieldNames(0)[0]);
		}
		
		//no email
		System.assertEquals(null, LiveAgentPreChatController.createLead(firstName, lastName, '', company, country, state));
		
		//no company
		try{
			System.assertEquals(null, LiveAgentPreChatController.createLead(firstName, lastName, email, '', country, state));
		} catch(System.DmlException e) {
			System.assertEquals(StatusCode.REQUIRED_FIELD_MISSING, e.getDmlType(0));
			System.assertEquals('Company', e.getDmlFieldNames(0)[0]);
		}
		
		//no country but state set
		System.assertEquals(null, LiveAgentPreChatController.createLead(firstName, lastName, email, company, '', state));

		//country but no state
		Id res = LiveAgentPreChatController.createLead(firstName, lastName, email, company, country_us, '');
		System.assertNotEquals(null, res);
		Lead lead = (Lead)[SELECT Id, FirstName, LastName, Email, Company, Country, State, LeadSource, Lead_Source_Details__c FROM Lead WHERE Id = :res];
		checkLead(lead, firstName, lastName, email, company, country_us, null);
		
		//all info set
		res = LiveAgentPreChatController.createLead(firstName, lastName, email, company, country_us, state);
		System.assertNotEquals(null, res);
		lead = (Lead)[SELECT Id, FirstName, LastName, Email, Company, Country, State, LeadSource, Lead_Source_Details__c FROM Lead WHERE Id = :res];
		checkLead(lead, firstName, lastName, email, company, country_us, state); 
	}
	
	private static void checkLead(Lead lead, String firstName,String lastName,String email,String company, String country, String state) {
		System.assertEquals(firstName, Lead.FirstName);
		System.assertEquals(lastName, Lead.LastName);
		System.assertEquals(email, Lead.Email);
		System.assertEquals(company, Lead.Company);
		System.assertEquals(country, Lead.Country);
		System.assertEquals(state, Lead.State);
		System.assertEquals('Inbound', Lead.LeadSource);
		System.assertEquals('Inbound - Chat', Lead.Lead_Source_Details__c);
	}
}