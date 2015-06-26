trigger UpdateContactInfo on User (after insert, after update) {
    UpdateContactInfoTriggerHandler handler = new UpdateContactInfoTriggerHandler();
    
    if((Trigger.isAfter && Trigger.isInsert) || (Trigger.isAfter && Trigger.isUpdate)){
        handler.OnAfterInsertOrUpdate(trigger.new);
    }
}