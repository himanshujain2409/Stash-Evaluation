@isTest
public class testClassMethods{

    static Account acc=new Account();
    static Contact con = new Contact();
    static Apttus__APTS_Agreement__c agrmnt;
    static Attachment attachment;



    public static void createData(){

        if(acc==null){
            acc=new Account();
            acc.Name='TestAcc';
            acc.BillingStreet = '1400 Fashion Island Blvd';
            acc.BillingCity = 'San Mateo';
            acc.BillingState = 'CA';
            acc.BillingCountry = 'US';
            acc.BillingPostalCode = '94404';

            insert acc;
        }

        if(con==null){
            con = new Contact();
            con.FirstName = 'Minkesh';
            con.LastName = 'Patel';
            con.AccountId = acc.Id;
            insert con;
        }


        if(agrmnt==null){
            agrmnt=new Apttus__APTS_Agreement__c();
            agrmnt.name='TEst';
            agrmnt.Apttus__Account__c=Acc.id;
            insert agrmnt;
        }

        if(attachment ==null){
              attachment = new Attachment();
              attachment.Body = Blob.valueOf('Test');
              attachment.Name = String.valueOf('test.txt');
              attachment.ParentId = agrmnt.id;
              insert attachment;
        }
    }

    testMethod static void TestSendForReviewController(){
     /*   User u;
        //list<User> lu= [select id from user where firstName='Michael' and LastName='Comans' and isActive=true];
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1];
        UserRole r = [SELECT Id From UserRole LIMIT 1];
        u = new User(Alias = 'test', Email='testuser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId = r.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='testUserComans1@testorg.com');
        //if (lu!=null && lu.size()>0) u=lu[0];
        Test.startTest();


        createData();
		
        ApexPages.standardController pcsc = new ApexPages.standardController(agrmnt); 
        ApexPages.currentPage().getParameters().put('Id',agrmnt.id);
        
        PageReference ref = new PageReference('/apex/APTPS_SendForReviewPage?Id=' + agrmnt.Id);
        ref.getParameters().put('isinternal','true');
        Test.setCurrentPage(ref);

        Apexpages.currentPage().getParameters().put('isinternal','true');
        APTPS_SendForReviewController  SendForReviewController=new APTPS_SendForReviewController(pcsc);
       // APTPS_SendForReviewController  SendForReviewController=new APTPS_SendForReviewController(new ApexPages.StandardController(agrmnt));
       // System.runAs(u){
        SendForReviewController.doInit();
       //  }
        SendForReviewController.generateDocument();
       // System.runAs(u){
        SendForReviewController.goBack();
      //  }
        Test.stopTest(); */
        
        User u;
        //list<User> lu= [select id from user where firstName='Michael' and LastName='Comans' and isActive=true];
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1];
        UserRole r = [SELECT Id From UserRole LIMIT 1];
        u = new User(Alias = 'test', Email='testuser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId = r.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='testUserComans1@testorg.com');
        //if (lu!=null && lu.size()>0) u=lu[0];
        Test.startTest();


        createData();

        PageReference ref = new PageReference('/apex/APTPS_SendForReviewPage?Id=' + agrmnt.Id);
        ref.getParameters().put('isinternal','true');
        Test.setCurrentPage(ref);

        Apexpages.currentPage().getParameters().put('isinternal','true');
        APTPS_SendForReviewController  SendForReviewController=new APTPS_SendForReviewController(new ApexPages.StandardController(agrmnt));
        System.runAs(u){
        SendForReviewController.doInit();
         }
        SendForReviewController.generateDocument();
        System.runAs(u){
        SendForReviewController.goBack();
        }
        Test.stopTest();

    }
	
    testMethod static void TestSendForReviewController2(){

        User u;
        //list<User> lu= [select id from user where firstName='Michael' and LastName='Comans' and isActive=true];
        //if (lu!=null && lu.size()>0) u=lu[0];
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1];
        UserRole r = [SELECT Id From UserRole LIMIT 1];
        u = new User(Alias = 'test', Email='testuser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId = r.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='testUserComans2@testorg.com');
        Test.startTest();


        createData();

        PageReference ref = new PageReference('/apex/APTPS_SendForReviewPage?Id=' + agrmnt.Id);
        ref.getParameters().put('isinternal','false');
        Test.setCurrentPage(ref);

        Apexpages.currentPage().getParameters().put('isinternal','false');
        APTPS_SendForReviewController  SendForReviewController=new APTPS_SendForReviewController(new ApexPages.StandardController(agrmnt));
        System.runAs(u){
        SendForReviewController.doInit();
         }
        SendForReviewController.generateDocument();
         System.runAs(u){
        SendForReviewController.goBack();
        }
        Test.stopTest();

    }

    testMethod static void TestAPTS_Generate_Template(){

         APTS_TestClassUtility Utility=new APTS_TestClassUtility ();

         account acc1=Utility.CreateAccount('test'); Upsert Acc1;
         Product2 prod=Utility.CreateProduct('test',true); Upsert prod;
        Opportunity opp=Utility.CreateOppty('test',acc1.id,date.today(),'prospective'); Upsert opp;
        Apttus_Config2__PriceList__c  PL= Utility.CreatePriceList('TEST');Upsert PL;
        Apttus_Proposal__Proposal__c Prop=Utility.CreateProposal('TEST',acc1.id,'a@a.com',PL.id,'request');Upsert Prop;
        Apttus__APTS_Template__c Tem=new Apttus__APTS_Template__c();
        Tem.Apttus__Type__c = 'Proposal';
        Tem.name='Order Form';
        Tem.Apttus__IsActive__c=true;
        Tem.Apttus__Agreement_Types__c='Default; Order Form; Proposal';
        Insert Tem;

        Attachment attSO =  Utility.CreateAttachment('test',tem.id,'test');Upsert attSo;
        APTS_Generate_Template  TEMP=new APTS_Generate_Template (new ApexPages.StandardController(Prop));
        TEMP.apiSessionId=UserInfo.getSessionId();
        TEMP.apiServerURL =System.URL.getSalesforceBaseURL().getHost();
        TEMP.doReturn();
        TEMP.doSelect();
        TEMP.GenerateDoc();
        TEMP.doGenerateDoc();
        TEMP.doStartAsyncCall();

    }

    testMethod static void TestGenerateDoc (){

         APTS_TestClassUtility Utility=new APTS_TestClassUtility ();

         account acc1=Utility.CreateAccount('test'); Upsert Acc1;
         Product2 prod=Utility.CreateProduct('test',true); Upsert prod;
        Opportunity opp=Utility.CreateOppty('test',acc1.id,date.today(),'prospective'); Upsert opp;
        Apttus_Config2__PriceList__c  PL= Utility.CreatePriceList('TEST');Upsert PL;
        Apttus_Proposal__Proposal__c Prop=Utility.CreateProposal('TEST',acc1.id,'a@a.com',PL.id,'request');Upsert Prop;
        Apttus__APTS_Template__c Tem=new Apttus__APTS_Template__c();
        Tem.Apttus__Type__c = 'Proposal';
        Tem.name='Order Form';
        Tem.Apttus__IsActive__c=true;
        Tem.Apttus__Agreement_Types__c='Default; Order Form; Proposal';
        Insert Tem;

        Attachment attSO =  Utility.CreateAttachment('test',tem.id,'test');Upsert attSo;
        GenerateDoc TEMP=new GenerateDoc(new ApexPages.StandardController(Prop));
        TEMP.apiSessionId=UserInfo.getSessionId();
        TEMP.apiServerURL =System.URL.getSalesforceBaseURL().getHost();
        TEMP.doGenerateDoc();


    }

     testMethod static void TestEchoSignAgreementTrigger(){
             Test.startTest();

                createData();

                Contact alWest = new Contact(FirstName='Al',LastName='West', AccountId=acc.id, email ='awest@apttus.com');
                Contact kirkKrappe= new Contact(FirstName='kirk',LastName='krappe', AccountId=acc.id, email ='kkrappe@apttus.com');
                Contact csupple = new Contact(FirstName='Chris',LastName='Supple', AccountId=acc.id, email ='csupple@apttus.com');

                insert new List<Contact>{alWest, kirkKrappe, csupple};

                list<recordtype> lr=[select id from recordtype where name='MSA'];

                if(lr.size()>0) agrmnt.recordtypeid=lr[0].id;

                update agrmnt;

                echosign_dev1__SIGN_Agreement__c Agreement=new echosign_dev1__SIGN_Agreement__c();



                Agreement.Apttus_Echosign__Apttus_Agreement__c=agrmnt.id;

                insert Agreement;

             Test.stopTest();
    }

    testMethod static void TestProposalTrigger(){
        APTS_TestClassUtility Utility=new APTS_TestClassUtility ();
             account acc1=Utility.CreateAccount('test'); Upsert Acc1;
         Product2 prod=Utility.CreateProduct('test',true); Upsert prod;
        Opportunity opp=Utility.CreateOppty('test',acc1.id,date.today(),'prospective'); Upsert opp;
        Apttus_Config2__PriceList__c  PL= Utility.CreatePriceList('TEST');Upsert PL;
        Apttus_Proposal__Proposal__c Prop=Utility.CreateProposal('TEST',acc1.id,'a@a.com',PL.id,'request');Upsert Prop;
        Apttus__APTS_Template__c Tem=new Apttus__APTS_Template__c();
        Tem.Apttus__Type__c = 'Proposal';
        Tem.name='Order Form';
        Tem.Apttus__IsActive__c=true;
        Tem.Apttus__Agreement_Types__c='Default; Order Form; Proposal';
        Insert Tem;
        Prop.Apttus_QPConfig__ConfigurationFinalizedDate__c=system.today();
        update prop;

    }

    @isTest
    public static void testBatchLic() {

       Test.startTest();
       TForceLicenseBatch c = new TForceLicenseBatch();
       Database.executeBatch(c,200);
       Test.stopTest();
    }

    @isTest
    public static void testTrialForceExpiration() {
       Test.startTest();
       TrialForceBatch c = new TrialForceBatch();
       Database.executeBatch(c,200);
       Test.stopTest();

    }
}