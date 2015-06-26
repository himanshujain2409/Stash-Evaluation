/*************************************
Class Name : AttachmentTriggerProcessor
Developed by : Sekhar Babu
Developed Date :
Modified By:
Modified Date:
Comments:

**************************************/
public class AttachmentTriggerProcessor {
    //Adding the attachment on Account object when attaching the doucments on the project.
    //Passing the List of Attachments as parameter.
    public void InsertAttachmentForProject(List<Attachment> lstAttachments) {
        Set<Id> setParentIds = new Set<Id>();
        Map<Id,List<Attachment>> mapAttachments = new Map<Id,List<Attachment>>();
        List<Attachment> lstAttachmentsToInsert;
        for(Attachment a : lstAttachments) {
            if(a.ParentId.getSObjectType() == pse__Proj__c.getSObjectType()) {
                setParentIds.add(a.ParentId);
            }
        }
        if(setParentIds.size() > 0) {
            Map<Id,pse__Proj__c> mapProjects = new Map<Id,pse__Proj__c>([Select Id,pse__Account__c from pse__Proj__c Where Id IN :setParentIds]);
           
            if(mapProjects.size() < 0) {
                return;
            }           
            lstAttachmentsToInsert = new List<Attachment>();
             
             for(Attachment a  : lstAttachments) {
                if(mapProjects.containsKey(a.ParentId) && mapProjects.get(a.ParentId).pse__Account__c != null) {
                        Attachment attach = a.clone();
                        attach.ParentId = mapProjects.get(a.ParentId).pse__Account__c;
                        lstAttachmentsToInsert.add(attach);
                }
            }
            if(lstAttachmentsToInsert.size() > 0) {
                try
                {
                   insert lstAttachmentsToInsert;
                }
                catch(Exception ex)
                {
                    throw ex;
                }
            }
        }
 
    }
            
}