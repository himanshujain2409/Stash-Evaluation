/********************************************************************************************
 Class Name: OpportunityTeamAssignment
 Author: Sarma Peri
 Date: 01/31/2015
 Requirement Description: Class for creating and deleting Opportunity Share records and Team Members.
 ***********************************************************************************************/
 
public class OpportunityTeamAssignment {
    
    // Methos to insert Opportunity Team Members.
    public static void inserOpptyTeamMembers(List<OpportunityTeamMember> teamMembers){
        
        if(!teamMembers.isEmpty()){
            
            try{
                insert teamMembers;
            } catch(exception e){
                system.debug('***** insert failed: '+ e.getMessage());
            }
        }
    }
    
    // Methos to delete Opportunity Team Members.
    public static void deleteOpptyTeamMembers(Map<Id,Id> deleteMemberMap){
        
        List<OpportunityTeamMember> deleteTeamMembers = new List<OpportunityTeamMember>();
        if(deleteMemberMap.size()>0){
            for(OpportunityTeamMember member: [Select Id, UserId, OpportunityId FROM OpportunityTeamMember Where OpportunityId IN: deleteMemberMap.keySet()]){
                if(deleteMemberMap.containsKey(member.OpportunityId) && deleteMemberMap.get(member.OpportunityId) == member.UserId){
                    deleteTeamMembers.add(member);
                }
            }
        }
        
        if(deleteTeamMembers.size()>0){
            try{
                delete deleteTeamMembers;
            } catch(exception e){
                system.debug('******** delete failed: '+e.getMessage());
            }
        }
    }
    
    // Methos to insert and delete Opportunity share records.
    public static void createOpptyShare(Map<Id,Id> createshareMap,Map<Id,Id> deleteshareMap, Set<Id> userIdSet){
        List<OpportunityShare> oppShareInsert = new List<OpportunityShare>();
        List<OpportunityShare> oppShareDelete = new List<OpportunityShare>();
        Map<Id,User> activeUserMap = new Map<Id,User>();
        
        if(deleteshareMap.size()>0){
            for(OpportunityShare share: [Select Id, OpportunityId, UserOrGroupId From OpportunityShare WHERE OpportunityId IN: deleteshareMap.keySet()]){
                
                if(deleteshareMap.get(share.OpportunityId) == share.UserOrGroupId){
                    oppShareDelete.add(share);
                }
            }
        }
        
        if(userIdSet.size() > 0){//Pick only Active user of Type Standard. This ignores Chatter Free users
            activeUserMap = new Map<Id,User>([Select Id from User where IsActive = true and UserType = 'Standard' and Id in :userIdSet]);
        }
        
        if(createshareMap.size()>0){
            for(Id oppId: createshareMap.keySet()){
                if(activeUserMap.containsKey(createshareMap.get(oppId))){
                    
                    OpportunityShare share = new OpportunityShare();
                    share.OpportunityId = oppId;
                    share.UserOrGroupId = createshareMap.get(oppId);
                    share.OpportunityAccessLevel = 'Edit';
                    oppShareInsert.add(share);
                }
            }
        }
        
        if(oppShareDelete.size()>0){
            
            try {
                delete oppShareDelete;
            } catch(exception e){
                
                system.debug('********** delete failed: '+ e.getMessage());
            }
        }
        
        if(oppShareInsert.size()>0){
            
            try{
                insert oppShareInsert;
            } catch(exception e){
                
                system.debug('********** insert failed: '+ e.getMessage());
            }
        }
    }
}