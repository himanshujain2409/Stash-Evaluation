/********************************************
Trigger Name : AttachmentTrigger
Developed By : Sekhar Babu
Developed Date:
Modified Date:
Modified By:
Comments:
*********************************************/

trigger AttachmentTrigger on Attachment (after insert) {
    AttachmentTriggerProcessor attachmentTriggerProcessor = new AttachmentTriggerProcessor();
    if(Trigger.isAfter && Trigger.isInsert) {
        //Calling the InsertAttachmentForProject Method from AttachmentTriggerProcessor Class.
        attachmentTriggerProcessor.InsertAttachmentForProject(Trigger.New);
    }
}