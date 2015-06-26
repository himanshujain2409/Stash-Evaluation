/*
* Unit test for controller ApttusIdeaSearchController
* @author Copyright (c) 2012 Apttus.
* @author dberriel@altimetrik.com
*/ 
@isTest(SeeAllData=true)
private class TestApttusIdeaSearchController {

     static testMethod void testIdeaSearch(){
         User u;
        Contact testContact;  
        Account acc;    
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ) {
            /* Create an instance of the controller */
            Profile p = [SELECT Id FROM Profile WHERE Name='Apttus Customer Portal User']; 
            acc = new Account (Name = 'newAcc1');  
            
        }
        
        Community com = [select id from Community limit 1];
        
        PageReference pageRef = Page.ApttusIdeaSearch;
        Test.setCurrentPage(pageRef);
        ApexPages.CurrentPage().getparameters().put('q', 'test');
        Idea ideaTest = new Idea();
        ideaTest.Title = 'Test Idea';
        ideaTest.Body = 'This is Test Idea How it is ?';
        ideaTest.CommunityId = com.id;
        ideaTest.Categories = 'Test';
        insert ideaTest;
        ApexPages.StandardController sc = new ApexPages.StandardController(ideaTest);
        ApttusIdeaSearchController controller = new ApttusIdeaSearchController(sc);
        controller.doSearchIdeas();
        

        
    }


}