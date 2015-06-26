@isTest
public class OpportunityWrapperControllerTest {
    
    static testMethod void testOpportunityWrapperControllerTest(){
        
        //Create Account
        Account accountObj = new Account();
        accountObj.Name = '3M Company'; 
        accountObj.Type = 'Prospect';
       // accountObj.BillingCountry = 'US';
        insert accountObj;
                
        //Create Contact
        Contact contObj = new Contact();
        contObj.LastName = 'Acharya';
        contObj.AccountId = accountObj.id;
        insert contObj;
        
        //Create price list
        Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
        priceList.Name = 'Standard Pricelist';
        insert priceList;
        
        //Create Product 
        Product2 sampleProduct = new Product2();
        sampleProduct.Name = 'Additional Production Environment';
        sampleProduct.Apttus_Config2__ConfigurationType__c = 'Standalone';
        sampleProduct.Apttus_Config2__HasAttributes__c = false;
        sampleProduct.ProductCode = 'LI-NPDPE';
        sampleProduct.Apttus_Config2__Customizable__c = false;
        sampleProduct.Family = 'Training';
        sampleProduct.IsActive = true;
        insert sampleProduct;
        
        
        //Create Opportunity
        Opportunity HCOpp = new Opportunity();
        HCOpp.name = '3M Company - OppName';
        HCOpp.AccountId = accountObj.id;
        HCOpp.StageName = 'Launch';
        HCOpp.CloseDate = Date.parse('1/7/2015');
        HCOpp.Training_Content_Ids__c = 'ABC';
        insert HCOpp;
        
        ApexPages.standardController pcsc = new ApexPages.standardController(HCOpp); 
        ApexPages.currentPage().getParameters().put('Id',HCOpp.id);
        Test.startTest();
        OpportunityWrapperController opp = new OpportunityWrapperController(pcsc);
        opp.ModuleName = 'ABC';
        opp.openModule();
        try{opp.NoOpenModule();}
        catch(Exception e){}
        Test.stopTest();
        
        
    }

}