@isTest
public class TestGenerateDoc {

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

    testMethod static void GenerateDoc (){

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
}