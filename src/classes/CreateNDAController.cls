public with sharing class CreateNDAController {
    public Apttus__APTS_Agreement__c agreement{get;set;}
    public Opportunity opp{get;set;}
    public Account acc{get;set;}
    
    public CreateNDAController(ApexPages.StandardController controller) {
        agreement = new Apttus__APTS_Agreement__c();
        acc = [select Id,Name from Account where id=: Apexpages.CurrentPage().getparameters().get('id')];
    }
    
    public Pagereference createNDAAgreement(){
        DateTime myDate = date.today();
        agreement.Name = acc.Name + ' NDA ' + myDate.format('MM-dd-yyyy');
        agreement.Apttus__Account__c = acc.Id;
        agreement.RecordType = [select Id,Name from recordType where Name = 'NDA'];
        
        agreement.Apttus__Contract_Start_Date__c = date.Today();
        agreement.Apttus__Status__c = 'Request';
        agreement.Apttus__Perpetual__c = True;
        insert agreement;
        
        return new pagereference('/'+agreement.Id);
    }
    
    static testmethod void testcase1(){
		
		Account acc = new Account();
		acc.Name = 'Test Account';
		insert acc;
		Contact con = new Contact();
		con.lastname = 'Test';
		con.accountId = acc.Id;
		insert con;
		
		ApexPages.StandardController staCon = new ApexPages.StandardController(acc);
		Apexpages.CurrentPage().getparameters().put('id',acc.id);
		CreateNDAController cNDA = new CreateNDAController(staCon);
		cNDA.createNDAAgreement();
		
	}

}