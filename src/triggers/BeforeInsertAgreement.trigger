trigger BeforeInsertAgreement on echosign_dev1__SIGN_Agreement__c (before Insert, before update) {
    if(trigger.new.size()>1) return;
    
    echosign_dev1__SIGN_Agreement__c newAgreement=trigger.new[0];
    
    //if(newAgreement.AgreementPopulated__c!=null && newAgreement.AgreementPopulated__c==true) return;
    
    newAgreement.echosign_dev1__Authoring__c=true;
    
    system.debug('Echosign Agreement ****'+ newAgreement.Apttus_Echosign__Apttus_Agreement__c);
    
    if(newAgreement.Apttus_Echosign__Apttus_Agreement__c!=null){
        Apttus__APTS_Agreement__c Agreement=[Select id,Name,recordtype.name,Apttus__Account__r.Name, Apttus__Source__c,
                                                Apttus__Primary_Contact__c
                                                from Apttus__APTS_Agreement__c
                                                where id=:newAgreement.Apttus_Echosign__Apttus_Agreement__c];
         
        Contact alwestCont = [Select Id from Contact where Name = 'Al West' limit 1]; 
        Contact kirkCont = [Select Id from Contact where Name = 'Kirk Krappe' limit 1];                                      
                                                
        echosign_dev1__Agreement_Template__c Template=   getTemplate(Agreement.recordtype.name);    
        
        if(Trigger.isInsert) {                                 
            if(Template!=null) newAgreement.echosign_dev1__Message__c=Template.echosign_dev1__Message__c;
        }
        
        String agreementName = 'Apttus-'+Agreement.Name;
        newAgreement.name = agreementName.length()>80 ? agreementName.subString(0,80) : agreementName;
        if(Template!=null) newAgreement.echosign_dev1__SignatureType__c=Template.echosign_dev1__Signature_Type__c;
        newAgreement.AgreementPopulated__c=true;
        if(Agreement.recordtype.name=='MSA') newAgreement.echosign_dev1__Enable_Hosted_Signing__c=false;
        if(Agreement.recordtype.name=='NDA') newAgreement.echosign_dev1__SenderSigns__c=false;
        newAgreement.echosign_dev1__RemindRecipient__c='';
        //newAgreement.echosign_dev1__Recipient__c
        
        if(Agreement.recordtype.name=='NDA' && Agreement.Apttus__Source__c != 'Other Party Paper') {
            newAgreement.echosign_dev1__Recipient2__c = alwestCont.Id;
        }
        
        if(Agreement.recordtype.name=='MSA' && Agreement.Apttus__Source__c != 'Other Party Paper') {
            newAgreement.echosign_dev1__Recipient2__c = kirkCont.Id;
        }
        
        if(Agreement.recordtype.name=='NDA' && Agreement.Apttus__Source__c == 'Other Party Paper') {
            newAgreement.echosign_dev1__Recipient__c = alwestCont.Id;
            newAgreement.echosign_dev1__Recipient2__c = Agreement.Apttus__Primary_Contact__c;
        }
        
        if(Agreement.recordtype.name=='MSA' && Agreement.Apttus__Source__c == 'Other Party Paper') {
            newAgreement.echosign_dev1__Recipient__c = kirkCont.Id;
            newAgreement.echosign_dev1__Recipient2__c = Agreement.Apttus__Primary_Contact__c;
        }
        
        
        //newAgreement.echosign_dev1__DaysUntilSigningDeadline__c =0;
         
    }
    
    private echosign_dev1__Agreement_Template__c getTemplate(string RecordTypeName){
        string TemplateName='';
        if(RecordTypeName=='MSA') TemplateName='MSA Agreement Echosign Template';
        if(RecordTypeName=='NDA') TemplateName='NDA Template';
        
        list<echosign_dev1__Agreement_Template__c> AgreementTemplates=[Select id,Name,echosign_dev1__Message__c,echosign_dev1__Signature_Type__c
                                                                From echosign_dev1__Agreement_Template__c 
                                                                where name=:TemplateName];
        if(AgreementTemplates!=null && AgreementTemplates.size()>0) return AgreementTemplates[0];
        
        return null;
    }
}