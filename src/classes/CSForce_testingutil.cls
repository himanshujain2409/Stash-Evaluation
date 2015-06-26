public with sharing class CSForce_testingutil {

    public CSForce_testingutil() {
    }

    public void addData(){
       addData('Test Account');
    }
    
    public void addData(string sname){
       Account ac = new Account(Name = sName);
        ac.BillingCountry = 'United States'; 
        ac.LID__LinkedIn_Company_Id__c ='123'; 
        
        
        insert ac;
        system.assert(ac != null);
            
        CustomerStory__c cs = new CustomerStory__c();
        cs.Name = 'test';
        cs.Account__c = ac.id;
        cs.Business_Focus__c = 'testing';
        cs.Lessons_Learned__c = 'blah';
        cs.Sharing_Restriction__c='no';
        cs.Solutions__c = 'blah';
        cs.Story_Type__c = 'winner';
        cs.Synopsis__c = 'we won';
        cs.Team__c ='Lary, Moe, and Curly';
        cs.Status__c = 'Available';
        cs.Products__c = 'test';
        cs.Win_Against__c = 'Ariba';
        cs.Vertical_Industry__c = 'Technology';
        
        insert cs;
        system.assert(cs != null);
    }

}