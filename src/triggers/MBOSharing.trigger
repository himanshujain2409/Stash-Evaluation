trigger MBOSharing on MBO__c (after insert, after update) {
     List<MBO__Share> sharesToCreate = new List<MBO__Share>();
      if (Trigger.isInsert) {
          for (MBO__c mbo: Trigger.new) {
           if (mbo.manager__c != null && mbo.manager__c != mbo.OwnerId) {
                sharesToCreate.add(createMBOShare(mbo.Id,mbo.manager__c));
           }
           if (mbo.employee__c != null && mbo.employee__c !=  mbo.OwnerId) {
           	
                sharesToCreate.add(createMBOShare(mbo.Id,mbo.employee__c));
           }
            
          }
          // do the DML to create shares
          if (!sharesToCreate.isEmpty())
            insert sharesToCreate;
       } else if (Trigger.isUpdate) {
           //List<MBO__Share> sharesToCreate = new List<MBO__Share>();
            List<ID> shareParentIdsToDelete = new List<ID>();
 
            for (MBO__c mbo : Trigger.new) {
 
             // if the manager changed -- delete the existing share
              if (Trigger.oldMap.get(mbo.id).Manager__c != mbo.Manager__c) {
                if (Trigger.oldMap.get(mbo.id).Manager__c != null)
                    shareParentIdsToDelete.add(mbo.id);
      
                // create the new share with read/write access
	                if(mbo.Manager__c != null)
	                {
                    if(mbo.manager__c != mbo.OwnerId)
	                	  sharesToCreate.add(createMBOShare(mbo.Id,mbo.manager__c));
                    if(mbo.Employee__c != mbo.OwnerId)
	                	  sharesToCreate.add(createMBOShare(mbo.Id,mbo.Employee__c));
	                }
                }
             // if the employee changed -- delete the existing share
              if (Trigger.oldMap.get(mbo.id).Employee__c != mbo.Employee__c) {
                if (Trigger.oldMap.get(mbo.id).Employee__c != null)
                    shareParentIdsToDelete.add(mbo.id);
      
                // create the new share with read/write access
                if(mbo.Employee__c != null)
                {
                  if(mbo.Employee__c != mbo.OwnerId)
                  	sharesToCreate.add(createMBOShare(mbo.Id,mbo.Employee__c));
                  if(mbo.manager__c != mbo.OwnerId)
                	   sharesToCreate.add(createMBOShare(mbo.Id,mbo.manager__c));
                }
                }
          }
          List<MBO__Share> sharesToDelete = [SELECT Id 
                                                FROM MBO__Share 
                                                WHERE ParentId IN :shareParentIdsToDelete  
                                                AND RowCause = 'Manual'];
         if(!sharesToDelete.isEmpty()){
            Database.Delete(sharesToDelete, false);
         }
         if (!sharesToCreate.isEmpty())
            insert sharesToCreate;
 
       }
       
     
    private MBO__Share createMBOShare(Id parentId, Id userId) {
                // create the new share with read/write access
                MBO__Share ms = new MBO__Share();
                ms.AccessLevel = 'Edit';
                ms.ParentId = parentId;
                ms.UserOrGroupId =  userId;
                return ms;
    }
}