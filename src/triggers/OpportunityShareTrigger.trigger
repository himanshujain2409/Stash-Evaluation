/**Trigger Name: OpportunityShareTrigger
 * Author: Sarma Peri
 * Requirement Description: Opportunity should be shared with PS pre-sales assigned. PS pre-sales assigned should be the Team Member on the opportunity
 *                          with Edit access to opportunity everytime an opportunity is created or updated.
 */

trigger OpportunityShareTrigger on Opportunity (after insert, after update) {

    Map<Id,Id> preSalesUserIdMap = new Map<Id,Id>();
    Map<Id,Id> salesUserIdDeleteMap = new Map<Id,Id>();
    Set<Id> salesRepIds = new Set<Id>();
    List<OpportunityTeamMember> teamMembers = new List<OpportunityTeamMember>();
    
    for(Opportunity opp: trigger.new){
        if(opp.PS_pre_sales_assigned__c != null && opp.OwnerId != opp.PS_pre_sales_assigned__c && (trigger.isInsert || 
            (opp.PS_pre_sales_assigned__c != trigger.oldMap.get(opp.Id).PS_pre_sales_assigned__c))){
            
            salesRepIds.add(opp.PS_pre_sales_assigned__c);
            preSalesUserIdMap.put(opp.Id, opp.PS_pre_sales_assigned__c);
            
            OpportunityTeamMember member = new OpportunityTeamMember();
            member.OpportunityId = opp.Id;
            member.UserId = opp.PS_pre_sales_assigned__c;
            member.TeamMemberRole = 'Solutions Group';
            teamMembers.add(member);
        }
        
        if(trigger.isUpdate){
            if(trigger.oldMap.get(opp.Id).PS_pre_sales_assigned__c != null && trigger.oldMap.get(opp.Id).PS_pre_sales_assigned__c != opp.PS_pre_sales_assigned__c){
                salesUserIdDeleteMap.put(opp.Id, trigger.oldMap.get(opp.Id).PS_pre_sales_assigned__c);
            }
        }
        
        if(teamMembers.size()>0)
            OpportunityTeamAssignment.inserOpptyTeamMembers(teamMembers);
            
        if(salesUserIdDeleteMap.size()>0)
            OpportunityTeamAssignment.deleteOpptyTeamMembers(salesUserIdDeleteMap);
        
        if(preSalesUserIdMap.size()>0 || salesUserIdDeleteMap.size()>0)
            OpportunityTeamAssignment.createOpptyShare(preSalesUserIdMap, salesUserIdDeleteMap, salesRepIds);        
        
    }
}