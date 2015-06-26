trigger PopulateAssignedNameOnConcessionRequest on Apttus_Approval__Approval_Request__c (after insert,after update) {
    ApprovalRequestTrigger.PopulateAssignedToNameOnConcessionRequest(Trigger.New);

}