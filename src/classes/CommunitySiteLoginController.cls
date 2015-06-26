public class CommunitySiteLoginController{
    public String userName{get;set;}
    public String password{get;set;}
    public Boolean rememberUser {get; set;}
    public Boolean isForgotPassword{get;set;}
    public Boolean isShowForgotPasswordConfirmationMsg{get;set;}
    public Boolean isShowLogin{get;set;}
    
    
    public CommunitySiteLoginController(){
        isShowLogin = true;
        isForgotPassword = false;
        isShowForgotPasswordConfirmationMsg = false;
        
        Cookie remember = ApexPages.currentPage().getCookies().get('rememberPortalUser');
        Cookie user     = ApexPages.currentPage().getCookies().get('portalUser');
        if(remember != null){
            if ((remember.getValue() == 'true') && user != null) {
                rememberUser = true;
                username = user.getValue();
            }
        }else{
            rememberUser = false;
        }
    }
    
    public Pagereference login(){
        String rememberUserValue = rememberUser ? 'true' : 'false';
        Cookie remember = new Cookie('rememberPortalUser',rememberUserValue,null,315360000,false);
        ApexPages.currentPage().setCookies(new Cookie[]{remember});
        if(rememberUser){
            Cookie user = new Cookie('portalUser',username,null,315360000,false);
            ApexPages.currentPage().setCookies(new Cookie[]{user});
        }
        String startURL = '';
        List<User> portalUserList = [Select Id, ContactId from User where UserName =: username];
        List<Terms_of_Use_Agreement__c> aggreementList = [Select Id from Terms_of_Use_Agreement__c where Active_Agreement__c = true limit 1];
        
        if(portalUserList.size() > 0 && portalUserList[0].ContactId != null){
            if(aggreementList.size() > 0){
                List<Agreement_Made__c> portalUserMadeOfAgreements = [Select Id, Terms_of_Use_Agreement__c from Agreement_Made__c 
                                                                        where Contact__c =: portalUserList[0].ContactId and 
                                                                        Terms_of_Use_Agreement__c =: aggreementList[0].Id];
                if(portalUserMadeOfAgreements != null && portalUserMadeOfAgreements.size() > 0){
                    //startURL = '/home/home.jsp';
                    startURL='/CCPortalHomeCopy';
                } else {
                    startURL = Site.getPathPrefix()+'/apex/APTTUSTermsOfUse';
                }
            } else {
                //startURL = '/home/home.jsp';
                startURL='/CCPortalHomeCopy';
            }
        }
        system.debug('***startURL***'+startURL);
        return Site.login(username, password, startURL);
    }
    
    public void forgotPassword(){
        isForgotPassword = true;
        isShowLogin = false;
    }
    
    public Pagereference backToLogin(){
        isForgotPassword = false;
        isShowLogin = true;
        return null;
    }
    
    public PageReference submit(){
        Boolean isSuccess = Site.forgotPassword(username);
        system.debug('***isSuccess :'+isSuccess);
        if(isSuccess == true){
            isForgotPassword = false;
            isShowForgotPasswordConfirmationMsg = true;
        } 
        return null;
    }
    public void returnToLogin(){
        isShowForgotPasswordConfirmationMsg = false;
        isForgotPassword = false;
        isShowLogin = true;
    }
}