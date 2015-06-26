@isTest
private class APTTUSTermsOfUseControllerTest{
    static testMethod void myUnitTest(){
        // Create Terms Of Use Agreement
        Terms_of_Use_Agreement__c agreement = new Terms_of_Use_Agreement__c();
        agreement.Agreement_Text__c = 'test agreement text';
        agreement.Active_Agreement__c = true;
        
        insert agreement;
        
        APTTUSTermsOfUseController controller = new APTTUSTermsOfUseController();
        controller.iAgree();
        Pagereference pg = controller.doNotAgree();
        system.assert(pg != null);
    }
}