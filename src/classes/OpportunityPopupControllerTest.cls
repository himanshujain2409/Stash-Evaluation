/*
* Unit test for OpportunityPopupController class
* @author Copyright (c) 2014 Apttus.
* @author cpatel@apttus.com
*/
@isTest
private class OpportunityPopupControllerTest {

	static testmethod void myUnitTest(){
    	
        test.startTest();
        APTS_TestClassUtility Utility=new APTS_TestClassUtility ();
         
        account acc1=Utility.CreateAccount('test'); 
        Upsert Acc1;
        
        Profile profile = [select id from profile where name='System Administrator'];
    	User u = new User(alias = 'test', email='test@test.com', emailencodingkey='UTF-8', lastname='test', languagelocalekey='en_US', localesidkey='en_US', profileid = profile.Id, timezonesidkey='America/Los_Angeles', username='test@testSF22223c.com', lmscons__Cornerstone_ID__c='newtest 261');
        insert u;
        system.runAs(u){
        lmscons__Transcript__c t = new lmscons__Transcript__c(lmscons__Trainee__c = UserInfo.getUserId());
    	insert t;
        lmscons__Training_Content__c c = new lmscons__Training_Content__c( lmscons__Title__c = 'Training me', lmscons__Cornerstone_ID__c = 'af' );
    	insert c;
        lmscons__Training_Content_License__c cl =  new lmscons__Training_Content_License__c( lmscons__Training_Content__c = c.id );
    	insert cl;
        lmscons__Training_User_License__c tul = new lmscons__Training_User_License__c( lmscons__Content_License__c = cl.id, lmscons__User__c = UserInfo.getUserId()  );
        insert tul;
        
        String TrainingContentId =  c.id;   
        Opportunity opp=Utility.CreateOppty('test',acc1.id,date.today(),'prospective'); 
        opp.Training_Content_Ids__c = TrainingContentId;
        Upsert opp;
        
        ApexPages.StandardController opptyController = new ApexPages.StandardController(opp);

        OpportunityPopupController opptyPopupController = new OpportunityPopupController(opptyController);
        
        opptyPopupController.openModule();
        opptyPopupController.NoOpenModule();
        }
        test.stopTest();
        
    }

}