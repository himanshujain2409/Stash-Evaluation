trigger UpdateAgreementEndDate on Apttus__APTS_Agreement__c (before update, before insert) {
    
    if(Trigger.isUpdate) {
        //datetime myDate = DateTime.newInstance(trigger.new[0].Apttus__Contract_Start_Date__c.year(), trigger.new[0].Apttus__Contract_Start_Date__c.month(), trigger.new[0].Apttus__Contract_Start_Date__c.day());
        if(trigger.new[0].Apttus__Contract_Start_Date__c != null && trigger.new[0].Apttus__Term_Months__c != null){
            trigger.new[0].Apttus__Contract_End_Date__c = trigger.new[0].Apttus__Contract_Start_Date__c.addMonths((Integer)trigger.new[0].Apttus__Term_Months__c);
        }
    }
    
    RecordType ndaRecordType = [Select id from RecordType where sObjectType = 'Apttus__APTS_Agreement__c' and name = 'NDA'];
    
    if(Trigger.isInsert){
        for(Apttus__APTS_Agreement__c agreement : Trigger.new){
            if(agreement.Apttus__Contract_End_Date__c == null && agreement.RecordTypeId == ndaRecordType.id){
                agreement.Apttus__Perpetual__c = true;
            }
        }
    }    
}