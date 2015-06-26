@isTest
public class APTPS_RequestOrderFormControllerTest {

    
    @isTest
    public static void testAPTPS_RequestOrderFormController() {
    
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
        insert HCOpp;
        
        
        //Create new proposal
        
        //Proposal #1
        Apttus_Proposal__Proposal__c prop1 = new Apttus_Proposal__Proposal__c();
        prop1.Apttus_Proposal__Proposal_Name__c = 'Test Proposal';
        prop1.Apttus_Proposal__Opportunity__c = HCOpp.Id;
        prop1.Apttus_QPConfig__PriceListId__c = priceList.ID;
        prop1.Apttus_Proposal__Primary_Contact__c = contObj.Id;
        prop1.Apttus_Proposal__Account__c = accountObj.Id;
        prop1.Apttus_Proposal__Presented_Date__c = Date.today();
        prop1.Apttus_Proposal__Proposal_Expiration_Date__c = Date.today();
        insert prop1;
        
        //ApexPages.standardController pcsc = new ApexPages.standardController(prop1); 
        ApexPages.currentPage().getParameters().put('Id',prop1.id);
        Test.startTest();
        APTPS_RequestOrderFormController obj = new APTPS_RequestOrderFormController();
        obj.sendEmail();
        Test.stopTest();
        
       
    }
    
    
}