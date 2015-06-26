trigger DeleteCourseLookup on lmscons__Training_Path__c (before delete) {
    Set<Id> IDs = new Set<ID>();
    for (lmscons__Training_Path__c ltp : Trigger.old) {
        IDs.add(ltp.Id);
    }
    
    list<Training_Path__c> tpc = [select id from Training_Path__c where Training_Path__c IN :IDs];
    
    if(tpc.size()>0){
        delete tpc;
    }
    
}