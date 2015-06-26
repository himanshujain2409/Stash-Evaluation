@isTest
public class DellOpptyProposalCopyControllerTest {
    
    static testMethod void testDellOpptyProposalCopyControllerTest(){
            
               
            //Create Account
            
            Account accountObj = new Account();
            accountObj.Name = '3M Company'; 
            accountObj.Type = 'Prospect';
            accountObj.BillingCountry = 'US';
            insert accountObj;
                    
            //Create Contact
            Contact contObj = new Contact();
            contObj.LastName = 'Test';
            contObj.AccountId = accountObj.id;
            insert contObj;
            
          //  RecordType rt = [select id,Name from RecordType where SobjectType='Opportunity' Limit 1];
            
          //  Opportunity opp = new Opportunity(Name = '3M Company - OppName', AccountId = accountObj.id, StageName = '00 - Marketing Lead', CloseDate = Date.parse('1/7/2015'), recordTypeid=rt.id );  
            //Create Opportunity
            Opportunity opp = new Opportunity();
            opp.name = '3M Company - OppName';
            opp.AccountId = accountObj.id;
            opp.StageName = '00 - Marketing Lead';
            opp.CloseDate = Date.parse('1/7/2015');
            insert opp;    
        
        
            ApexPages.standardController pcsc = new ApexPages.standardController(opp); 
            ApexPages.currentPage().getParameters().put('Id',opp.id);
            Test.startTest();
            DellOpptyProposalCopyController  dellOppCtrl = new DellOpptyProposalCopyController(pcsc);
            dellOppCtrl.onLoad();
            dellOppCtrl.getHasErrors();
            dellOppCtrl.doCancel();
            Test.stopTest();
    }
    

}