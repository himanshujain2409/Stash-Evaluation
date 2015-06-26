/*
* Controller for ApttusCustomerPortalLatestCases component
* @author Copyright (c) 2012 Apttus.
* @author lferreira@altimetrik.com
*/ 
public with sharing class ACPLatestCasesController {
	
	/* Latest 5 cases to display */
	
	public List<Case> latestCases{get; set;}
	
	
	public ACPLatestCasesController(){
			
		
		/* get the current user */
		
		User currentUser = ACPUtils.getCurrentUser();
		
		
		/* get the lastest 5 cases */
		
		latestCases = [SELECT CaseNumber, Subject FROM Case c WHERE ContactId = :currentUser.ContactId ORDER BY CreatedDate DESC LIMIT 5];
		
	}
}