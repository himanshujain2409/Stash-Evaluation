/*
* Unit test for controller ACPCaseViewsController
* @author Copyright (c) 2012 Apttus.
* @author dberriel@altimetrik.com
*/ 
@isTest(SeeAllData=true)
private class ACPCaseViewsControllerTest {
    
     /* Test the controller without cases */
    
    static testMethod void testControllerWithoutCases(){
         User u;
    Contact testContact;  
    Account acc;    
    User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
    System.runAs ( thisUser ) {
        /* Create an instance of the controller */
        Profile p = [SELECT Id FROM Profile WHERE Name='Apttus Customer Portal User']; 
        acc = new Account (
Name = 'newAcc1'
);  
insert acc;
        testContact = new Contact();
        testContact.firstName='ACPCaseViewsControllerTest';
        testContact.lastName='ACPCaseViewsControllerTest';
        testContact.email = 'rbhatt@apttus.com';
        testContact.pse__Is_Resource__c = true;
        testContact.accountId = acc.id;
        insert testContact;
        List<UserRole> roleLst = [select id from userrole where name = 'Apttus Customer User'];
        
        //List<Contact> contactLst= [select id from Contact where firstName = 'ACPCaseViewsControllerTest'];
      u = new User(Alias = 'rbhatt', Email='rbhatt@apttus.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, /*UserRoleId = roleLst[0].Id,*/
      TimeZoneSidKey='America/Los_Angeles', UserName='rbhatt2@apttus.com', ContactId=testContact.id);
      }
      System.runAs(u) {
        /* Create an instance of the controller */
        
        ACPCaseViewsController controller = new ACPCaseViewsController();
        
        System.Test.startTest();
                
        /* Assert that no cases were retrieved */
            
       // System.assertEquals(0, controller.getMyCasesList().size());
        
        System.Test.stopTest();
        
        }
        
    }
         
    /* Test the controller cases */
    
        static testmethod void testControllerWithTenCases(){
        
         User u;
    Contact testContact;  
    Account acc;    
    User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
    System.runAs ( thisUser ) {
        /* Create an instance of the controller */
        Profile p = [SELECT Id FROM Profile WHERE Name='Apttus Customer Portal User']; 
        acc = new Account (
Name = 'newAcc1'
);  
insert acc;
        testContact = new Contact();
        testContact.firstName='ACPCaseViewsControllerTest';
        testContact.lastName='ACPCaseViewsControllerTest';
        testContact.email = 'rbhatt@apttus.com';
        testContact.pse__Is_Resource__c = true;
        testContact.accountId = acc.id;
        insert testContact;
        List<UserRole> roleLst = [select id from userrole where name = 'Apttus Customer User'];
        
        //List<Contact> contactLst= [select id from Contact where firstName = 'ACPCaseViewsControllerTest'];
      u = new User(Alias = 'rbhatt', Email='rbhatt@apttus.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id,/*UserRoleId = roleLst[0].Id,*/
      TimeZoneSidKey='America/Los_Angeles', UserName='rbhatt2@apttus.com', ContactId=testContact.id);
      }
      System.runAs(u) {
        Contact contactTst = new Contact();
        
        
        /* Create 10 cases to test the first page*/
        
        List<Case> cases = new List<Case>();
        
        for(Integer i = 0; i < 10; i++){
            cases.add(ACPTestUtils.createCase());
        }
        
        insert cases;
        
        
        /* Create an instance of the controller */
        
        ACPCaseViewsController controller = new ACPCaseViewsController();
        
        System.test.startTest();
        
        
        /* Assert that 10 cases were retrieved in the first page*/
            
       // System.assertEquals(10, controller.getMyCasesList().size());
                
        System.test.stopTest();
        
        }
    }
    
    /* Test the controller cases */
    
        static testmethod void testControllerWithFifteenCases(){
        
       User u;
    Contact testContact;  
    Account acc;    
    User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
    System.runAs ( thisUser ) {
        /* Create an instance of the controller */
        Profile p = [SELECT Id FROM Profile WHERE Name='Apttus Customer Portal User']; 
        acc = new Account (
Name = 'newAcc1'
);  
insert acc;
        testContact = new Contact();
        testContact.firstName='ACPCaseViewsControllerTest';
        testContact.lastName='ACPCaseViewsControllerTest';
        testContact.email = 'rbhatt@apttus.com';
        testContact.pse__Is_Resource__c = true;
        testContact.accountId = acc.id;
        insert testContact;
        List<UserRole> roleLst = [select id from userrole where name = 'Apttus Customer User'];
        
        //List<Contact> contactLst= [select id from Contact where firstName = 'ACPCaseViewsControllerTest'];
      u = new User(Alias = 'rbhatt', Email='rbhatt@apttus.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id,/*UserRoleId = roleLst[0].Id,*/
      TimeZoneSidKey='America/Los_Angeles', UserName='rbhatt2@apttus.com', ContactId=testContact.id);
      }
      System.runAs(u) {
         /* Create 15 cases to test the first page*/
        
        List<Case> cases = new List<Case>();
        
        for(Integer i = 0; i < 15; i++){
            cases.add(ACPTestUtils.createCase());
        }
        
        insert cases;
        
        
        /* Create an instance of the controller */
        
        ACPCaseViewsController controller = new ACPCaseViewsController();
        
        System.test.startTest();
        
        
        /* Assert that 10 cases were retrieved in the first page*/
       // System.assertEquals(10, controller.getMyCasesList().size());
        /* Assert that 5 cases were retrieved in the second page*/
        //System.assert(controller.hasNext);
        controller.next();
        //System.assertEquals(5, controller.getMyCasesList().size());
        
        /* Assert that 10 cases were retrieved in the first page*/
     //   System.assert(controller.hasPrevious);
        controller.previous();
      //  System.assertEquals(10, controller.getMyCasesList().size());
                
        System.test.stopTest();
        }
    }
    
    /* Test the controller closed case*/
    static testMethod void testControllerClosedCases() {
        
         User u;
    Contact testContact;  
    Account acc;    
    User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
    System.runAs ( thisUser ) {
        /* Create an instance of the controller */
        Profile p = [SELECT Id FROM Profile WHERE Name='Apttus Customer Portal User']; 
        acc = new Account (
Name = 'newAcc1'
);  
insert acc;
        testContact = new Contact();
        testContact.firstName='ACPCaseViewsControllerTest';
        testContact.lastName='ACPCaseViewsControllerTest';
        testContact.email = 'rbhatt@apttus.com';
        testContact.pse__Is_Resource__c = true;
        testContact.accountId = acc.id;
        insert testContact;
        List<UserRole> roleLst = [select id from userrole where name = 'Apttus Customer User'];
        System.debug('***** roleLst.size(): '+roleLst.size());
        System.debug('***** roleLst: '+roleLst);
        //List<Contact> contactLst= [select id from Contact where firstName = 'ACPCaseViewsControllerTest'];
      u = new User(Alias = 'rbhatt', Email='rbhatt@apttus.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id,/*UserRoleId = roleLst[0].Id,*/
      TimeZoneSidKey='America/Los_Angeles', UserName='rbhatt2@apttus.com', ContactId=testContact.id);
      }
      System.runAs(u) {

        /* Create cases to test the first page*/
        
        List<Case> cases = new List<Case>();
        
        for(Integer i = 0; i < 10; i++){
            cases.add(ACPTestUtils.createCase());
        }

        Case c = ACPTestUtils.createCase('Test case');
        cases.add(c);
        
        insert cases;
        
        //Modify case's status to closed
        c.Status = 'Closed';
        //Update case to execute close workflows rules.
        update c;

        ACPCaseViewsController controller = new ACPCaseViewsController();

        System.test.startTest();

        controller.myView = 'ClosedCases';
        controller.selectedCasesView();
    controller.myView = 'MyCompanyCases';
        controller.selectedCasesView();
            controller.myView = 'MyCompanyOpenCases';
        controller.selectedCasesView();
                    controller.myView = 'MyCompanyClosedCases';
        controller.selectedCasesView();
        /* Assert that 1 cases were retrieved as closed*/
        //System.assertEquals(1, controller.getMyCasesList().size());
        System.test.stopTest();
        }
    }
    
    /* Test the controller open case*/
    static testMethod void testControllerOpenCases() {
        
        
            User u;
    Contact testContact;  
    Account acc;    
    User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
    System.runAs ( thisUser ) {
        /* Create an instance of the controller */
        Profile p = [SELECT Id FROM Profile WHERE Name='Apttus Customer Portal User']; 
        acc = new Account (
Name = 'newAcc1'
);  
insert acc;
        testContact = new Contact();
        testContact.firstName='ACPCaseViewsControllerTest';
        testContact.lastName='ACPCaseViewsControllerTest';
        testContact.email = 'rbhatt@apttus.com';
        testContact.pse__Is_Resource__c = true;
        testContact.accountId = acc.id;
        insert testContact;
        List<UserRole> roleLst = [select id from userrole where name = 'Apttus Customer User' Limit 1];
        
        //List<Contact> contactLst= [select id from Contact where firstName = 'ACPCaseViewsControllerTest'];
      u = new User(Alias = 'rbhatt', Email='rbhatt@apttus.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, /*UserRoleId = roleLst[0].Id,*/
      TimeZoneSidKey='America/Los_Angeles', UserName='rbhatt2@apttus.com', ContactId=testContact.id);
      }
      System.runAs(u) {
        List<Case> cases = new List<Case>();
        
        for(Integer i = 0; i < 10; i++){
            cases.add(ACPTestUtils.createCase());
        }
        
        insert cases;
        ACPCaseViewsController controller = new ACPCaseViewsController();
        
        System.test.startTest();
        
        controller.myView = 'OpenCases';
        controller.selectedCasesView();
        /* Assert that 10 cases were retrieved as open */
       // System.assertEquals(10, controller.getMyCasesList().size());
        
        System.test.stopTest();
        
        }
    }
    
    static testMethod void testControllerUserAllCases() {
    
       User u;
    Contact testContact;  
    Account acc;    
    User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
    System.runAs ( thisUser ) {
        /* Create an instance of the controller */
        Profile p = [SELECT Id FROM Profile WHERE Name='Apttus Customer Portal User']; 
        acc = new Account (
Name = 'newAcc1'
);  
insert acc;
        testContact = new Contact();
        testContact.firstName='ACPCaseViewsControllerTest';
        testContact.lastName='ACPCaseViewsControllerTest';
        testContact.email = 'rbhatt@apttus.com';
        testContact.pse__Is_Resource__c = true;
        testContact.accountId = acc.id;
        insert testContact;
        List<UserRole> roleLst = [select id from userrole where name = 'Apttus Customer User'];
        
        //List<Contact> contactLst= [select id from Contact where firstName = 'ACPCaseViewsControllerTest'];
      u = new User(Alias = 'rbhatt', Email='rbhatt@apttus.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, /*UserRoleId = roleLst[0].Id,*/
      TimeZoneSidKey='America/Los_Angeles', UserName='rbhatt2@apttus.com', ContactId=testContact.id);
      }
      System.runAs(u) {
        //Create auxiliar data
        User u2 = ACPTestUtils.getCurrentUser();
        
        List<Contact> contactList = new List<Contact>();
        Contact testContactF = ACPTestUtils.createContact('FirstTestContact'+Datetime.now().format(), u2.AccountId);
        contactList.add(testContactF);
        for(Contact con : contactList){
              con.pse__Is_Resource__c = true;
          }
        
        insert contactList;
        
        /* Create cases to test the first page*/
        
        List<Case> cases = new List<Case>();
        
        for(Integer i = 0; i < 10; i++){
            Case aux = ACPTestUtils.createCase();
            aux.AccountId = u.AccountId;
            cases.add(aux);
        }

        Case c = new Case();
        c.Subject = 'Test case';
        c.ContactId = testContactF.Id;
        cases.add(c);
        
        insert cases;
        
        /* Create an instance of the controller */
        
        ACPCaseViewsController controller = new ACPCaseViewsController();
        
        System.test.startTest();
        
        controller.myView = 'AllCases';
        controller.selectedCasesView();
        /* Assert that 11 cases were retrieved*/
       // System.assertEquals(10, controller.getMyCasesList().size());
        controller.next();
       // System.assertEquals(1, controller.getMyCasesList().size());

        System.test.stopTest();
        
        }
    }
    
    /*Test my cases*/
    static testMethod void testControllerMyCases() {
    
       User u;
    Contact testContact;  
    Account acc;    
    User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
    System.runAs ( thisUser ) {
        /* Create an instance of the controller */
        Profile p = [SELECT Id FROM Profile WHERE Name='Apttus Customer Portal User']; 
        acc = new Account (
Name = 'newAcc1'
);  
insert acc;
        testContact = new Contact();
        testContact.firstName='ACPCaseViewsControllerTest';
        testContact.lastName='ACPCaseViewsControllerTest';
        testContact.email = 'rbhatt@apttus.com';
        testContact.pse__Is_Resource__c = true;
        testContact.accountId = acc.id;
        insert testContact;
        List<UserRole> roleLst = [select id from userrole where name = 'Apttus Customer User'];
        
        //List<Contact> contactLst= [select id from Contact where firstName = 'ACPCaseViewsControllerTest'];
      u = new User(Alias = 'rbhatt', Email='rbhatt@apttus.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, /*UserRoleId = roleLst[0].Id,*/
      TimeZoneSidKey='America/Los_Angeles', UserName='rbhatt2@apttus.com', ContactId=testContact.id);
      }
      System.runAs(u) {
        /* Assert that 10 cases were retrieved in myCases */
        User u2 = ACPTestUtils.getCurrentUser();
        
        List<Contact> contactList = new List<Contact>();
        Contact testContactF = ACPTestUtils.createContact('FirstTestContact'+Datetime.now().format(), u2.AccountId);
        contactList.add(testContactF);
        for(Contact con : contactList){
              con.pse__Is_Resource__c = true;
          }
        insert contactList;
        
        /* Create cases to test the first page*/
        
        List<Case> cases = new List<Case>();
        
        for(Integer i = 0; i < 10; i++){
            Case aux = ACPTestUtils.createCase();
            aux.AccountId = u.AccountId;
            cases.add(aux);
        }

        Case c = new Case();
        c.Subject = 'Test case';
        c.ContactId = testContactF.Id;
        cases.add(c);
        
        insert cases;
        
        /* Create an instance of the controller */
        
        ACPCaseViewsController controller = new ACPCaseViewsController();
        
        System.test.startTest();
        controller.myView = 'MyCases';
        controller.selectedCasesView();
       // System.assertEquals(10, controller.getMyCasesList().size());
        //System.assert(!controller.hasNext);
        System.test.stopTest();
        
        }
    }
    
    /*Test page number of pagination */
    static testMethod void testControllerPageNumber() {
        
        
           User u;
    Contact testContact;  
    Account acc;    
    User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
    System.runAs ( thisUser ) {
        /* Create an instance of the controller */
        Profile p = [SELECT Id FROM Profile WHERE Name='Apttus Customer Portal User']; 
        acc = new Account (
Name = 'newAcc1'
);  
insert acc;
        testContact = new Contact();
        testContact.firstName='ACPCaseViewsControllerTest';
        testContact.lastName='ACPCaseViewsControllerTest';
        testContact.email = 'rbhatt@apttus.com';
        testContact.pse__Is_Resource__c = true;
        testContact.accountId = acc.id;
        insert testContact;
        List<UserRole> roleLst = [select id from userrole where name = 'Apttus Customer User'];
        
        //List<Contact> contactLst= [select id from Contact where firstName = 'ACPCaseViewsControllerTest'];
      u = new User(Alias = 'rbhatt', Email='rbhatt@apttus.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, /*UserRoleId = roleLst[0].Id,*/
      TimeZoneSidKey='America/Los_Angeles', UserName='rbhatt2@apttus.com', ContactId=testContact.id);
      }
      System.runAs(u) {
        List<Case> cases = new List<Case>();
        
        for(Integer i = 0; i < 15; i++){
            cases.add(ACPTestUtils.createCase());
        }
        
        insert cases;
                
        ACPCaseViewsController controller = new ACPCaseViewsController();
        
        System.test.startTest();
        
        /* Assert number of pages*/
        Integer pn = controller.pageNumber;
       // System.assertEquals(1, pn);
        controller.next();
        pn += 1;
       // System.assertEquals(2, pn);
        System.test.stopTest();
        }
    }
    
    /*Test page reference method redirect to create a new case*/
    static testMethod void testControllerPageReference(){
       User u;
    Contact testContact;  
    Account acc;    
    User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
    System.runAs ( thisUser ) {
        /* Create an instance of the controller */
        Profile p = [SELECT Id FROM Profile WHERE Name='Apttus Customer Portal User']; 
        acc = new Account (
Name = 'newAcc1'
);  
insert acc;
        testContact = new Contact();
        testContact.firstName='ACPCaseViewsControllerTest';
        testContact.lastName='ACPCaseViewsControllerTest';
        testContact.email = 'rbhatt@apttus.com';
        testContact.pse__Is_Resource__c = true;
        testContact.accountId = acc.id;
        insert testContact;
        List<UserRole> roleLst = [select id from userrole where name = 'Apttus Customer User'];
        
        //List<Contact> contactLst= [select id from Contact where firstName = 'ACPCaseViewsControllerTest'];
      u = new User(Alias = 'rbhatt', Email='rbhatt@apttus.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, /*UserRoleId = roleLst[0].Id,*/
      TimeZoneSidKey='America/Los_Angeles', UserName='rbhatt2@apttus.com', ContactId=testContact.id);
      }
      System.runAs(u) {
        ACPCaseViewsController controller = new ACPCaseViewsController();
        
        System.test.startTest();
        controller.newCase();
        System.test.stopTest();
        }
    }
    
    /* Test Selection options of views */
    static testMethod void testControllerSelectionoptions() {
       User u;
    Contact testContact;  
    Account acc;    
    User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
    System.runAs ( thisUser ) {
        /* Create an instance of the controller */
        Profile p = [SELECT Id FROM Profile WHERE Name='Apttus Customer Portal User']; 
        acc = new Account (
Name = 'newAcc1'
);  
insert acc;
        testContact = new Contact();
        testContact.firstName='ACPCaseViewsControllerTest';
        testContact.lastName='ACPCaseViewsControllerTest';
        testContact.email = 'rbhatt@apttus.com';
        testContact.pse__Is_Resource__c = true;
        testContact.accountId = acc.id;
        insert testContact;
        List<UserRole> roleLst = [select id from userrole where name = 'Apttus Customer User'];
        
        //List<Contact> contactLst= [select id from Contact where firstName = 'ACPCaseViewsControllerTest'];
      u = new User(Alias = 'rbhatt', Email='rbhatt@apttus.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, /*UserRoleId = roleLst[0].Id,*/
      TimeZoneSidKey='America/Los_Angeles', UserName='rbhatt2@apttus.com', ContactId=testContact.id);
      }
      System.runAs(u) {
        ACPCaseViewsController controller = new ACPCaseViewsController();
        
        System.test.startTest();
        List<Selectoption> testList = controller.getListViews();
       // System.assert(testList.size()==4);
        System.test.stopTest();
        }
    }
    
    /*Test sort case's list*/
    static testMethod void testControllerSortList() {
      User u;
    Contact testContact;  
    Account acc;    
    User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
    System.runAs ( thisUser ) {
        /* Create an instance of the controller */
        Profile p = [SELECT Id FROM Profile WHERE Name='Apttus Customer Portal User']; 
        acc = new Account (
Name = 'newAcc1'
);  
insert acc;
        testContact = new Contact();
        testContact.firstName='ACPCaseViewsControllerTest';
        testContact.lastName='ACPCaseViewsControllerTest';
        testContact.email = 'rbhatt@apttus.com';
        testContact.pse__Is_Resource__c = true;
        testContact.accountId = acc.id;
        insert testContact;
        List<UserRole> roleLst = [select id from userrole where name = 'Apttus Customer User'];
        
        //List<Contact> contactLst= [select id from Contact where firstName = 'ACPCaseViewsControllerTest'];
      u = new User(Alias = 'rbhatt', Email='rbhatt@apttus.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, /*UserRoleId = roleLst[0].Id,*/
      TimeZoneSidKey='America/Los_Angeles', UserName='rbhatt2@apttus.com', ContactId=testContact.id);
      }
      System.runAs(u) {
        /* Assert that 10 cases were retrieved in myCases */
        User u2 = ACPTestUtils.getCurrentUser();
        
        List<Contact> contactList = new List<Contact>();
        Contact testContactF = ACPTestUtils.createContact('FirstTestContact'+Datetime.now().format(), u2.AccountId);
        contactList.add(testContactF);
          for(Contact con : contactList){
              con.pse__Is_Resource__c = true;
          }
        insert contactList;
        
        /* Create cases to test the first page*/
        
        List<Case> cases = new List<Case>();
        
        for(Integer i = 1; i <= 5; i++){
            Case aux = ACPTestUtils.createCase(i+'Case');
            aux.AccountId = u.AccountId;
            cases.add(aux);
        }
        
        insert cases;
        
        /* Create an instance of the controller */
        
        ACPCaseViewsController controller = new ACPCaseViewsController();
        
        System.test.startTest();
        controller.FieldSort = 'Subject';
        
        controller.sortCases();
        List<Case> auxCases = new List<Case>();
        for(Case c:controller.getMyCasesList()){
            auxCases.add(c);
        }
        controller.setOrder1('ASC');
       // System.assertEquals(auxCases.get(0).Subject,'1Case');
        
        controller.FieldSort = 'Subject';
        String order = controller.getOrder1();
        controller.sortCases();
        auxCases.clear();
        for(Case c:controller.getMyCasesList()){
            auxCases.add(c);
        }
       // System.assertEquals(auxCases.get(0).Subject,'5Case');
     //   System.assertEquals(order,'DESC');
        controller.FieldSort = null;
        order = controller.getOrder1();
        
        controller.SearchTerm = '*12?*';
        controller.FieldSort = 'Id';
        controller.SearchCases();
        
       // System.assertEquals(order,'ASC');
        System.test.stopTest();
        }
    }

}