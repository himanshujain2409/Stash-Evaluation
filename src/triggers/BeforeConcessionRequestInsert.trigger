trigger BeforeConcessionRequestInsert on Concession_Request__c (before insert) {
    
    if(Trigger.New.size() < 0) return;
    
    for(Concession_Request__c request : Trigger.New)
    {
        request.Requestor__c = UserInfo.getUserId();
    }

}