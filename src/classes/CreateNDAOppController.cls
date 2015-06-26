public with sharing class CreateNDAOppController {
    public Apttus__APTS_Agreement__c agreement{get;set;}
    public Opportunity opp{get;set;}
    public Account acc{get;set;}
    public CreateNDAOppController(ApexPages.StandardController controller) {
        agreement = new Apttus__APTS_Agreement__c();
        opp = new Opportunity();
        opp = [select AccountId,Account.Name,Id,Name from Opportunity where id=: Apexpages.CurrentPage().getparameters().get('id')];
    }
    
     public Pagereference createNDAAgreement(){
        if(opp != null && opp.Account != null){
            DateTime myDate = date.today();
            agreement.Name = opp.Account.Name + ' NDA ' + myDate.format('MM-dd-yyyy');
            agreement.Apttus__Account__c = opp.AccountId;
        }
        
        if(opp != null)
            agreement.Apttus__Related_Opportunity__c = opp.id;       
        agreement.RecordType = [select Id,Name from recordType where Name = 'NDA'];
               
        agreement.Apttus__Contract_Start_Date__c = date.Today();
        agreement.Apttus__Status__c = 'Request';
        agreement.Apttus__Perpetual__c = True;
        insert agreement;
        
        return new pagereference('/'+agreement.Id);
    }
    
    static testmethod void testcase1(){
        Try
        {
        
            Account acc = new Account();
            acc.Name = 'Test Account';
            insert acc;
            /*
            Contact con = new Contact();
            con.lastname = 'Test';
            con.accountId = acc.Id;
            insert con;
            */
            Opportunity opp = new Opportunity();
            opp.AccountId = acc.Id;
            opp.StageName = 'Prospecting';
            opp.CloseDate = date.today() + 30;
            opp.Name = 'test Opp';
            opp.Subscription_Length__c = 123;
            insert opp;
            Apexpages.CurrentPage().getparameters().put('id',opp.id);
            ApexPages.StandardController staCon = new ApexPages.StandardController(opp);
            
            CreateNDAOppController cNDA = new CreateNDAOppController(staCon);
            cNDA.createNDAAgreement();
        }
         catch(Exception e){
          System.debug('MS TEST:'+e.getMessage()+e.getLineNumber());
        }
        
    }

}