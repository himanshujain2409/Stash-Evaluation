/* APTS_MyTeamMBOHierarchialStructure
 * Controller for APTS_MyTeamMBOHierarchialTree component.
 *
 * Developer: Harish Emmadi, APTTUS
 * Business Owner: 
 *
 * Scenario:
 * 
 * 
 *
 * History:
 
 * 02/20/2015, Harish Emmadi, APTTUS - created APTS_MyTeamMBOHierarchialStructure class.
 */
public with sharing class APTS_MyTeamMBOHierarchialStructure {
	public String year {get;set;}
	
	Map<Id, Id> employeetomanagermap = new Map<Id, Id>();
	Id loggedinuserId;

	public APTS_MyTeamMBOHierarchialStructure() {
		loggedinuserId = UserInfo.getUserId();
	}

	public List<APTS_mbowrapper> getmyteammbos(){
		 

		List<APTS_mbowrapper> myteammbos = new List<APTS_mbowrapper>();
		Map<String, List<MBO__c>>  employeeIdtombosMap = new Map<String, List<MBO__c>>();
		Set<Id> employeeIds = new Set<Id>();
		
		for(MBO__c mbo : [Select Id, Name, Manager__c, Employee__c, Employee__r.Name 
											From MBO__c 
											Where Manager__c = :loggedinuserId
												  AND MBO_Year__c = :year
												  	Order by Employee__c, Year_Quarter__c Asc])
		{
			Id employeeId = mbo.Employee__c;
			Id managerId = mbo.Manager__c;
			
			employeetomanagermap.put(employeeId, managerId);
			String branchId = getbranchId(employeeId);
			
			
			List<MBO__c> mbos_raw = employeeIdtombosMap.containsKey(branchId) ? employeeIdtombosMap.get(branchId) : new List<MBO__c>();
			mbos_raw.add(mbo);
			employeeIdtombosMap.put(branchId, mbos_raw);
			
			if(employeeId != null
				&& employeeId != managerId)
				employeeIds.add(employeeId);
		}

		while(!employeeIds.isEmpty())
		{
			Set<Id> employeeIdsclone = employeeIds.clone();
			employeeIds.clear();
			for(MBO__c mbo : [Select Id, Name, Manager__c, Employee__c, Employee__r.Name
											From MBO__c 
												Where Manager__c IN :employeeIdsclone
													  AND MBO_Year__c = :year
													  	Order by Employee__c, Year_Quarter__c ASC])
			{
				Id employeeId = mbo.Employee__c;
				Id managerId = mbo.Manager__c;
				employeetomanagermap.put(employeeId, managerId);
				String branchId = getbranchId(employeeId);
				
				List<MBO__c> mbos_raw = employeeIdtombosMap.containsKey(branchId) ? employeeIdtombosMap.get(branchId) : new List<MBO__c>();
				mbos_raw.add(mbo);
				employeeIdtombosMap.put(branchId, mbos_raw);
				
				if(employeeId != null
					&& employeeId != managerId)
					employeeIds.add(employeeId);
			}
			// break if number of SOQL queries that have been issued is greater than 90.
			if(Limits.getQueries() > 90)
				break;
		}

		for(String branchId : employeeIdtombosMap.keySet())
		{
			myteammbos.add(new APTS_mbowrapper(branchId, employeeIdtombosMap.get(branchId)));
		}
		myteammbos.sort();
		return myteammbos;
	}

	private String getbranchId(Id employeeId){
		List<String> branches = new List<String>();
		String branchId = '';
		branches.add(employeeId);
		while(employeetomanagermap.containsKey(employeeId))
		{
			employeeId = employeetomanagermap.get(employeeId); 
			branches.add(employeeId);
		}
		for(Integer i = branches.size()-1; i >= 0; i--)
			branchId += branches.get(i);
		return branchId;
	}
}