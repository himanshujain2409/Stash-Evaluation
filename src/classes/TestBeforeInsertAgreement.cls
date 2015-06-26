@isTest
public class TestBeforeInsertAgreement {

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
    testMethod static void TestAgreement(){
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
				agrmnt=new Apttus__APTS_Agreement__c();
            agrmnt.name='TEst';
            agrmnt.Apttus__Account__c=Acc.id;
        ID rtID = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('NDA').getRecordTypeID();
        	agrmnt.RecordTypeId =rtID;
        agrmnt.Apttus__Source__c='Phone';
            insert agrmnt;
         agrmnt.Apttus__Source__c='Web2';
        update agrmnt;
        agrmnt=new Apttus__APTS_Agreement__c();
            agrmnt.name='TEst';
            agrmnt.Apttus__Account__c=Acc.id;
        ID rtID1 = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('MSA').getRecordTypeID();
        	agrmnt.RecordTypeId =rtID1;
        agrmnt.Apttus__Source__c='Web';
            insert agrmnt;
         agrmnt.Apttus__Source__c='Web1';
        update agrmnt;
             Test.stopTest();
    }

}