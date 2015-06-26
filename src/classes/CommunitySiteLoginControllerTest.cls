@isTest(SeeAllData=true)
private class CommunitySiteLoginControllerTest{
    static testMethod void myUnitTest(){
        Apexpages.currentPage().getParameters().put('rememberPortalUser','true');
        CommunitySiteLoginController controller = new CommunitySiteLoginController();
        controller.userName = 'test@test.com';
        controller.password = 'tets1234';
        controller.login();
        controller.submit(); 
        controller.forgotPassword();
        controller.backToLogin();
        controller.returnToLogin();
       
    }
    
    static testMethod void myUnitTest2(){
        List<User> portalUserList = [Select Id, ContactId, UserName from User where ContactId != null limit 1];
        
        if(!portalUserList.isEmpty()){
            Terms_of_Use_Agreement__c agreement = new Terms_of_Use_Agreement__c();
            agreement.Active_Agreement__c  = true;
            agreement.Agreement_Text__c = 'test text';
            insert agreement;
            
            Agreement_Made__c am = new Agreement_Made__c();
            am.Contact__c = portalUserList.get(0).ContactId;
            am.Terms_of_Use_Agreement__c = agreement.Id;
            
            insert am;
            
            CommunitySiteLoginController controller = new CommunitySiteLoginController();
            controller.userName = portalUserList.get(0).UserName;
            controller.password = 'tets1234';
            controller.login();
        }
    }
}