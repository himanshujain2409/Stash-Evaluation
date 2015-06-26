trigger APTPS_SetPrimaryContactFromOppty on Apttus_Proposal__Proposal__c (before insert) {

    List<Opportunity> opptyList = [select Id, Primary_Contact__c from Opportunity where id =: trigger.new[0].Apttus_Proposal__Opportunity__c];
    
    if(opptyList != null && opptyList.size() > 0) {
        trigger.new[0].Apttus_Proposal__Primary_Contact__c = opptyList[0].Primary_Contact__c;
    }

}