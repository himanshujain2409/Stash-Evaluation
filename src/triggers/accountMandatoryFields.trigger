trigger accountMandatoryFields on Opportunity (before update) {
    Opportunity oppobj = Trigger.new[0];
   if(oppobj.type != 'Services')
   {
System.debug('oppobj.type'+oppobj.type);
    Set<Id> oppIdSet = new Set<Id>();
    Map<String,Boolean> validateOppMap = new Map<String,Boolean>();
    
    for(Opportunity opp: trigger.new){
        if(Trigger.oldMap.get(opp.Id).StageName != opp.StageName && opp.StageName =='Pending Closed Won'){
            oppIdSet.add(opp.Id);
        }
    }
    
    if(oppIdSet.size()>0){
        for(Opportunity o: [Select Id, StageName, Account.Billing_AP_Email__c, Account.Purchase_Order__c FROM Opportunity Where Id IN:oppIdSet]){
            
            if(o.Account.Billing_AP_Email__c == null ||  o.Account.Purchase_Order__c == null){
                validateOppMap.put(o.Id, true);
            }
        }
    }
    
    for(Opportunity opp: trigger.new){
        if(validateOppMap.containsKey(opp.Id)){
            opp.addError('If Stage is Pending Closed Won, following fields are required on the Account object: Billing/AP Email,  and Purchase Order');
        }
    }
   }
    System.debug('1oppobj.type'+oppobj.type);
}