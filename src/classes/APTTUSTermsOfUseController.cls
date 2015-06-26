/*public class APTTUSTermsOfUseController{
    public Terms_of_Use_Agreement__c termsOfUseAgreement{get;set;}
    
    public APTTUSTermsOfUseController(){
        List<Terms_of_Use_Agreement__c> termsOfUseAgreements = [Select Id, Agreement_Text__c from Terms_of_Use_Agreement__c where Active_Agreement__c = true limit 1];
        system.debug('**termsOfUseAgreements***'+termsOfUseAgreements.size());
        if(termsOfUseAgreements.size() > 0){
            termsOfUseAgreement = termsOfUseAgreements.get(0);
            system.debug('***termsOfUseAgreement***'+termsOfUseAgreement.Agreement_Text__c);
        }
    }
    
    public pageReference iAgree(){
        User portalUser = [Select Id, ContactId from User where Id =: UserInfo.getUserId()];
        // create Agreement Made record
        Agreement_Made__c agreementMade = new Agreement_Made__c();
        agreementMade.Contact__c = portalUser.ContactId;
        //if(termsOfUseAgreement.Id != null){
            agreementMade.Terms_of_Use_Agreement__c = termsOfUseAgreement.Id;    
        //}
        
        
        If(!Test.isRunningTest()){
            insert agreementMade;
        }
        return new PageReference('/customers/CommunityCustomerPortalHome');
    }
    
    public pageReference doNotAgree(){
        return new PageReference('/secur/logout.jsp');
    }
}*/
public class APTTUSTermsOfUseController{
    public Terms_of_Use_Agreement__c termsOfUseAgreement{get;set;}
    
    public APTTUSTermsOfUseController(){
        List<Terms_of_Use_Agreement__c> termsOfUseAgreements = [Select Id, Agreement_Text__c from Terms_of_Use_Agreement__c where Active_Agreement__c = true limit 1];
        system.debug('**termsOfUseAgreements***'+termsOfUseAgreements.size());
        if(termsOfUseAgreements.size() > 0){
            termsOfUseAgreement = termsOfUseAgreements.get(0);
            system.debug('***termsOfUseAgreement***'+termsOfUseAgreement.Agreement_Text__c);
        }
    }
    
    public pageReference iAgree(){
        User portalUser = [Select Id, ContactId from User where Id =: UserInfo.getUserId()];
        // create Agreement Made record
        Agreement_Made__c agreementMade = new Agreement_Made__c();
        agreementMade.Contact__c = portalUser.ContactId;
        agreementMade.Terms_of_Use_Agreement__c = termsOfUseAgreement.Id;
        
        If(!Test.isRunningTest()){
            insert agreementMade;
        }
        return new PageReference('/apex/CCPortalHomeCopy');
    }
    
    public pageReference doNotAgree(){
        return new PageReference('/secur/logout.jsp');
    }
}