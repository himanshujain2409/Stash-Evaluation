public with sharing class LiveAgentPreChatController {
	@RemoteAction
	public static Id createLead(String firstName,String lastName,String email,String company, String country, String state) {	    
	    //we only need to check for fields that are not required by the Lead object
	    if (email.equals(''))
	    	return null;
	    	
	    //state shouldn't be set without country
	    if (country.equals('') && !state.equals(''))
	    	return null;
	    	
	    	
	    Lead newLead= new Lead(
		    FirstName = firstName,
		    LastName = lastName,
		    Email = email,
		    Company = company,
		    Country = country,
	    	State = state,
	    	LeadSource = 'Inbound',
	    	Lead_Source_Details__c = 'Inbound - Chat');
	    	
	    insert newLead;
	    
	    return newLead.Id;
	}
}