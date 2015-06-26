trigger setFinalizedDate on Attachment (after insert) {
    //Get the attachment SObject.
    Attachment attSO = Trigger.new[0];
    //Get the Attachment Parent ID
    ID attParentID = attSO.ParentId;
    //attchment Name
    String attachmentName = attSO.Name;
    Apttus__APTS_Agreement__c agreement = new Apttus__APTS_Agreement__c();
    
    if(attParentID != null && attachmentName.contains('Final')) {
        List<Apttus__APTS_Agreement__c> agreementList = [select Id, Finalized_Date__c from Apttus__APTS_Agreement__c
                                                         where id=: attParentID];
        if(agreementList != null && agreementList.size() > 0) {
            agreementList[0].Finalized_Date__c = Date.today();
            update agreementList[0];
        }
    }
    
  
}