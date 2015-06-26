@isTest
public class setFinalizeDateTest {

    static testMethod void testFinalizeDate(){
       
       //Create Account
        Account accountObj = new Account();
        accountObj.Name = '3M Company'; 
        accountObj.Type = 'Prospect';
        accountObj.BillingCountry = 'US';
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
        sampleProduct.Family = 'Subscription';
        sampleProduct.IsActive = true;
        insert sampleProduct;
        
        
        //Create Opportunity
        Opportunity HCOpp = new Opportunity();
        HCOpp.name = '3M Company - OppName';
        HCOpp.AccountId = accountObj.id;
        HCOpp.StageName = '00 - Marketing Lead';
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
        
                       
        //Proposal #2
        Apttus_Proposal__Proposal__c prop2 = new Apttus_Proposal__Proposal__c();
        prop2.Apttus_Proposal__Proposal_Name__c = 'Test Proposal';
        prop2.Apttus_Proposal__Opportunity__c = HCOpp.Id;
        prop2.Apttus_QPConfig__PriceListId__c = priceList.ID;
        prop2.Apttus_Proposal__Primary_Contact__c = contObj.Id;
        prop2.Apttus_Proposal__Account__c = accountObj.Id;
        prop2.Apttus_Proposal__Presented_Date__c = Date.today();
        prop2.Apttus_Proposal__Proposal_Expiration_Date__c = Date.today();
        insert prop2;
        
        //Create Proposal Line Items
        
        //Proposal Line Item #1
        Apttus_Proposal__Proposal_Line_Item__c propLI1 = new Apttus_Proposal__Proposal_Line_Item__c();
        propLI1.Apttus_Proposal__Description__c = sampleProduct.Name;
        propLI1.Apttus_Proposal__Product__c = sampleProduct.Id;
        propLI1.Apttus_QPConfig__Quantity2__c = 1;
        propLI1.Apttus_QPConfig__ListPrice__c = 1500;
        propLI1.Apttus_QPConfig__ExtendedPrice__c = 1500;
        propLI1.Apttus_QPConfig__NetPrice__c = 2000;
        propLI1.Apttus_QPConfig__ItemSequence__c = 1;
        propLI1.Apttus_QPConfig__LineNumber__c = 1;
        propLI1.Apttus_Proposal__Proposal__c = prop1.Id;
        insert propLI1;
        
        
        //Proposal Line Item #2
        Apttus_Proposal__Proposal_Line_Item__c propLI2 = new Apttus_Proposal__Proposal_Line_Item__c();
        propLI2.Apttus_Proposal__Description__c = sampleProduct.Name;
        propLI2.Apttus_Proposal__Product__c = sampleProduct.Id;
        propLI2.Apttus_QPConfig__Quantity2__c = 1;
        propLI2.Apttus_QPConfig__ListPrice__c = 2500;
        propLI2.Apttus_QPConfig__ExtendedPrice__c = 2500;
        propLI2.Apttus_QPConfig__NetPrice__c = 3000;
        propLI2.Apttus_QPConfig__ItemSequence__c = 1;
        propLI2.Apttus_QPConfig__LineNumber__c = 1;
        propLI2.Apttus_Proposal__Proposal__c = prop2.Id;
        insert propLI2;
        
        //Create Agreement
        Apttus__APTS_Agreement__c agreementObj = new Apttus__APTS_Agreement__c();
        agreementObj.Apttus__Account__c = accountObj.Id;
        agreementObj.Apttus__Related_Opportunity__c = HCOpp.Id;
        agreementObj.Name = 'TestAgreement';
        agreementObj.Apttus__Description__c = 'Test Description';
        agreementObj.Apttus_QPComply__RelatedProposalId__c = prop1.Id;
        insert agreementObj; 
        
        
        Attachment attach=new Attachment();    

        attach.Name='Unit Test Attachment Final';

        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');

        attach.body=bodyBlob;

        attach.parentId=agreementObj.id;
		Test.startTest();
        insert attach;
 		Test.stopTest();
        
    }
    
}