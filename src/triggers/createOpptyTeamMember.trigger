trigger createOpptyTeamMember on Account (after insert, after update) {

    Map<Id,Id> accountCSMIdMap = new Map<Id,Id>();
    Map<Id,Id> accountOldCSMIdMap = new Map<Id,Id>();
    Map<Id,Id> createShareMap = new Map<Id,Id>();
    Map<Id,Set<Id>> accountOppIdSetMap = new Map<Id,Set<Id>>();
    Map<Id,Id> oppTeamDelteMap = new Map<Id,Id>();
    Set<Id> csmUsers = new Set<Id>();
    Map<Id,List<Opportunity>> accRelOpptyInsertMap = new Map<Id,List<Opportunity>>();
    Map<Id,List<Opportunity>> accRelOpptyDeleteMap = new Map<Id,List<Opportunity>>();
    List<OpportunityTeamMember> insertTeamMember = new List<OpportunityTeamMember>();
    
    for(Account acc: trigger.new){
        
        if(acc.CSM__c != null && (trigger.isInsert || acc.CSM__c != trigger.oldMap.get(acc.Id).CSM__c)){
            accountCSMIdMap.put(acc.Id, acc.CSM__c);
        }
        
        if(trigger.isUpdate){
            if(trigger.oldMap.get(acc.Id).CSM__c != null && trigger.oldMap.get(acc.Id).CSM__c != acc.CSM__c){
                accountOldCSMIdMap.put(acc.Id, trigger.oldMap.get(acc.Id).CSM__c);
            }
        }
    }
    
    if(accountCSMIdMap.size()>0){
        for(Account acc: [Select Id, CSM__c, (Select Id, OwnerId From Opportunities) FROM Account WHERE Id IN: accountCSMIdMap.keySet()]){
            if(acc.Opportunities.size()>0){
                
                for(Opportunity opp: acc.Opportunities){
                    if(accountCSMIdMap.get(acc.Id) != opp.OwnerId){
                        OpportunityTeamMember member = new OpportunityTeamMember();
                        member.OpportunityId = opp.Id;
                        member.UserId = accountCSMIdMap.get(acc.Id);
                        member.TeamMemberRole = 'Client Success Manager';
                        insertTeamMember.add(member);
                        
                        csmUsers.add(acc.CSM__c);
                        createShareMap.put(opp.Id, acc.CSM__c);
                        if(accountOppIdSetMap.containsKey(acc.Id)){
                            accountOppIdSetMap.get(acc.Id).add(opp.Id);
                        } else {
                            accountOppIdSetMap.put(acc.Id, new Set<Id>{opp.Id});
                        }
                    }
                    
                } // Enf for loop....
            }
        } // End for loop....
    } // End of if condition....
    
    for(Id accId: accountOldCSMIdMap.keySet()){
        if(accountOppIdSetMap.containskey(accId))
            for(Id oppId: accountOppIdSetMap.get(accId)){
                oppTeamDelteMap.put(oppId, accountOldCSMIdMap.get(oppId));
            }
    }
    
    if(insertTeamMember.size()>0)
        OpportunityTeamAssignment.inserOpptyTeamMembers(insertTeamMember);
        
    if(oppTeamDelteMap.size()>0)
        OpportunityTeamAssignment.deleteOpptyTeamMembers(oppTeamDelteMap);
        
    if(createShareMap.size()>0 || oppTeamDelteMap.size()>0)
        OpportunityTeamAssignment.createOpptyShare(createShareMap, oppTeamDelteMap, csmUsers);  
}