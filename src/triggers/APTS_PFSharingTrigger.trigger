/*************************************************************
@Name: APTS_PFSharingTrigger
@Author: KrishnaRajani Yadlapalli,PS - Apttus
@CreateDate:  03/30/2015
@Description: Trigger for Perfamance Feedback Sharing 
@UsedBy: 
******************************************************************
@ModifiedBy: 
@ModifiedDate: 
@ChangeDescription: 

******************************************************************/
trigger APTS_PFSharingTrigger on Performance_Reviews__c (after insert,after update) {
	 List<Performance_Reviews__Share> sharesToCreate = new List<Performance_Reviews__Share>();
	
      if(Trigger.isInsert) {
          for (Performance_Reviews__c pr: Trigger.new) {
           if (pr.manager__c != null && pr.manager__c != pr.OwnerId ) { 
                sharesToCreate.add(createPFShare(pr.Id,pr.manager__c));
           }
           if (pr.employee__c != null && pr.employee__c != pr.OwnerId ) { 
           	
                sharesToCreate.add(createPFShare(pr.Id,pr.employee__c));
           } 
       }
          // do the DML to create shares
          if (!sharesToCreate.isEmpty())
            insert sharesToCreate;
       } else if (Trigger.isUpdate) {
           //List<Performance_Reviews__Share> sharesToCreate = new List<Performance_Reviews__Share>();
            List<ID> shareParentIdsToDelete = new List<ID>();
 
            for (Performance_Reviews__c pr : Trigger.new) {
 
             // if the manager changed -- delete the existing share
              if (Trigger.oldMap.get(pr.id).Manager__c != pr.Manager__c) {
                if (Trigger.oldMap.get(pr.id).Manager__c != null)
                    shareParentIdsToDelete.add(pr.id);
      
                // create the new share with read/write access
	                if(pr.Manager__c != null ) 
	                {
	                	if(pr.manager__c != pr.OwnerId)
	                		sharesToCreate.add(createPFShare(pr.Id,pr.manager__c));
	                	if(pr.Employee__c != pr.OwnerId)
	                		sharesToCreate.add(createPFShare(pr.Id,pr.Employee__c));
	                }
                }
             // if the employee changed -- delete the existing share
              if (Trigger.oldMap.get(pr.id).Employee__c != pr.Employee__c ) {
                if (Trigger.oldMap.get(pr.id).Employee__c != null)
                    shareParentIdsToDelete.add(pr.id);
      
                // create the new share with read/write access
                if(pr.Employee__c != null) 
                {
                	if(pr.Employee__c != pr.OwnerId)
                		sharesToCreate.add(createPFShare(pr.Id,pr.Employee__c));
                	if(pr.manager__c != pr.OwnerId)
                		sharesToCreate.add(createPFShare(pr.Id,pr.manager__c));
                }
                }
          }
          List<Performance_Reviews__Share> sharesToDelete = [SELECT Id 
                                                FROM Performance_Reviews__Share 
                                                WHERE ParentId IN :shareParentIdsToDelete  
                                                AND RowCause = 'Manual'];
         if(!sharesToDelete.isEmpty()){
            Database.Delete(sharesToDelete, false);
         }
         if (!sharesToCreate.isEmpty())
            insert sharesToCreate;
 
       }
       
     
    private Performance_Reviews__Share createPFShare(Id parentId, Id userId) {
                // create the new share with read/write access
                Performance_Reviews__Share ms = new Performance_Reviews__Share();
                ms.AccessLevel = 'Edit';
                ms.ParentId = parentId;
                ms.UserOrGroupId =  userId;
                return ms;
    }

}