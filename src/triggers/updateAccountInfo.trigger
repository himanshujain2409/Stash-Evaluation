trigger updateAccountInfo on CampaignMember (before insert, before update) {
	
    system.debug('********* trigger.new: '+trigger.new);
    Set<String> CompanyOrAccounts = new Set<String>();
    Map<String,Account> accountMap = new Map<String,Account>();
    List<Account> accList = new List<Account>();
    for(CampaignMember member: Trigger.new){
        if(Trigger.isInsert || (Trigger.isUpdate && Trigger.oldMap.get(member.Id).Company_or_Account__c != member.Company_or_Account__c)){
            CompanyOrAccounts.add(member.Company_or_Account__c);
        }        
    }
    system.debug('********* CompanyOrAccounts: '+CompanyOrAccounts);
    if(CompanyOrAccounts.size()>0){
        for(Account acc: [Select Id, Name, Owner.Name, CSM__r.Name, Core_AE__r.Name FROM Account WHERE Name IN: CompanyOrAccounts]){
            accountMap.put(acc.Name, acc);
        }
    }
    system.debug('********* accountMap: '+accountMap);
    if(accountMap.size()>0){
        for(CampaignMember member: Trigger.new){
        	member.Account_Owner__c = accountMap.get(member.Company_or_Account__c).Owner.Name;
            member.Account_CSM__c = accountMap.get(member.Company_or_Account__c).CSM__R.Name;
            member.Core_AE__c = accountMap.get(member.Company_or_Account__c).Core_AE__r.Name;
        }
    }
}