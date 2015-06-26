/*
    This is a Utility Class for the Test classes.
    Repeated methods in each test classes are available in this class
    Methods Available are
    1. Create Account
    2. Create Product
    3. Create Opportunity
    4. Create Price List
    5. Create Proposal
    6. Create Approval Request
    7. Create Proposal Line Items
    8. Create Line Items
    9. Create Product Configuration
    10. Create Price List Item
    11. Create Attachment
*/
public with sharing class APTS_TestClassUtility {
    public Account CreateAccount(string name) {
        Account accountSO = new Account();
        accountSO.Name = name;
        
         
        return accountSO;
    }
    public Product2 CreateProduct(string prodName, boolean isActive) {
        //Create new Product Item
        Product2 prodSO = new Product2();
        prodSO.name = prodName; 
        prodSO.IsActive = isActive;
        return prodSO;
    }
    public Opportunity CreateOppty(string oppName, ID accountID, Date closeDate, string stage ) {
        Opportunity opptySO = new Opportunity();
        opptySO.Name = oppName;
        opptySO.AccountId = accountID;
        opptySO.CloseDate = closeDate;
        opptySO.StageName = stage;
        return opptySO;
    }
    public Apttus_Config2__PriceList__c CreatePriceList(string plistName) {
        Apttus_Config2__PriceList__c plistSO = new Apttus_Config2__PriceList__c();
        plistSO.name = plistName;
        return plistSO;
    }
    public Apttus_Proposal__Proposal__c CreateProposal(string propName, ID accountID, string endUserEmail, ID priceListID,string apprStage){
        Apttus_Proposal__Proposal__c propSO = new Apttus_Proposal__Proposal__c();
        propSO.Apttus_Proposal__Proposal_Name__c = propName ;
        propSO.Apttus_Proposal__Account__c = accountID;
         
        propSO.Apttus_QPConfig__PriceListId__c = priceListID;
        propSO.Apttus_Proposal__Approval_Stage__c = apprStage;
        return propSO;
    }
   /* public Apttus_Approval__Approval_Request__c CreateApprovalRequest(decimal stepSequence, string stepName, string assigneeType, string objectType, ID proposalID) {
        Apttus_Approval__Approval_Request__c apprReqSO = new Apttus_Approval__Approval_Request__c();
        apprReqSO.Apttus_Approval__StepSequence__c = stepSequence;
        apprReqSO.Apttus_Approval__Step_Name__c = stepName;
        apprReqSO.Apttus_Approval__Assigned_To_Type__c = assigneeType;
        apprReqSO.Apttus_Approval__Object_Type__c = objectType;
        apprReqSO.Apttus_QPApprov__ProposalId__c = proposalID;
        return apprReqSO;
    }
    public Apttus_Proposal__Proposal_Line_Item__c CreateProposalLineItemSO(Double basePrice,string chargeType, Double listPrice, decimal quantity, Double netPrice, 
                                                    ID proposalID, string lineType,ID productID,ID productConfigurationID, decimal itemSequence, decimal lineNumber) {
        Apttus_Proposal__Proposal_Line_Item__c pli = new Apttus_Proposal__Proposal_Line_Item__c();
        
        pli.Apttus_QPConfig__BasePrice__c = basePrice;
        pli.Apttus_QPConfig__ChargeType__c = chargeType;
        pli.Apttus_QPConfig__ListPrice__c = listPrice;
        pli.Apttus_QPConfig__Quantity2__c = quantity;
        pli.Apttus_QPConfig__NetPrice__c = netPrice;
        pli.Apttus_QPConfig__LineType__c = lineType;
        pli.Apttus_Proposal__Product__c = productID;
        pli.Apttus_QPConfig__OptionId__c = productID;
        pli.Apttus_QPConfig__ItemSequence__c = itemSequence;
        pli.Apttus_QPConfig__LineNumber__c = lineNumber;
        pli.Apttus_Proposal__Proposal__c = proposalID;
        pli.Apttus_QPConfig__ConfigurationId__c = productConfigurationID;
        return pli;
    }
    public Apttus_Config2__LineItem__c CreateLineItemSO(Double basePrice,string chargeType, Double listPrice, Decimal quantity, Double netPrice, 
                                                    ID prodConfigID, string lineType,ID productID) {
        Apttus_Config2__LineItem__c li = new Apttus_Config2__LineItem__c();
        
        li.Apttus_Config2__BasePrice__c = basePrice;
        li.Apttus_Config2__ChargeType__c = chargeType;
        li.Apttus_Config2__ListPrice__c = listPrice;
        li.Apttus_Config2__Quantity__c = quantity;
        li.Apttus_Config2__NetPrice__c = netPrice;
        li.Apttus_Config2__ConfigurationId__c = prodConfigID;
        li.Apttus_Config2__LineType__c = lineType;
        li.Apttus_Config2__ProductId__c = productID;
        li.Apttus_Config2__ItemSequence__c = 1;
        li.Apttus_Config2__LineNumber__c = 1;
        return li;
    }
    public Apttus_Config2__ProductConfiguration__c CreateProductConfiguration (string name, string businessObjectType, ID accountID, ID priceListID, ID proposalID, string status){
        Apttus_Config2__ProductConfiguration__c prodConfigSO = new Apttus_Config2__ProductConfiguration__c();
        prodConfigSO.name = name;
        prodConfigSO.Apttus_Config2__BusinessObjectType__c = businessObjectType;
        prodConfigSO.Apttus_Config2__AccountId__c = accountID;
        prodConfigSO.Apttus_Config2__PriceListId__c = priceListID;
        prodConfigSO.Apttus_QPConfig__Proposald__c = proposalID;
        prodConfigSO.Apttus_Config2__Status__c = 'Finalized';
        prodConfigSO.Apttus_Config2__BusinessObjectId__c =  proposalID;
        return prodConfigSO;
    }*/
    /*public Apttus_Config2__PriceListItem__c CreatePriceListItem(ID priceListId, ID productId,  String chargeType, String priceType, String priceMethod, Decimal listPrice) {
        // create a new pricelist item
        Apttus_Config2__PriceListItem__c itemSO = new Apttus_Config2__PriceListItem__c(Apttus_Config2__PriceListId__c = priceListId);
        itemSO.Apttus_Config2__ProductId__c = productId;
        itemSO.Apttus_Config2__ChargeType__c = chargeType;
        itemSO.Apttus_Config2__PriceType__c = priceType;
        itemSO.Apttus_Config2__PriceMethod__c = priceMethod;
        itemSO.Apttus_Config2__ListPrice__c = listPrice;
        return itemSO;
    } */
    
    public Attachment CreateAttachment(string attName, ID parentID, String body) {
        Attachment attSO = new Attachment();
        attSO.Name = attName;
        attSO.ParentId = parentID;
        Blob bodyBlob=Blob.valueOf(body);
        attSO.body=bodyBlob;
        return attSO;
    }

    public static User getUserObj(Id profileId){
            Decimal counter = Math.random();
            User us = new User();
            us.ProfileId = profileId;
            us.IsActive = TRUE;
            us.LastName = 'Test User: '+counter;
            us.Alias = 'ut'+(String.valueof(counter)).left(5);
            us.Email = 'noreply@email.com';
            us.Username = 'unittester'+counter+'@testerpro.com';
            us.CommunityNickname = 'unittester'+counter;
            us.TimeZoneSidKey = 'America/Los_Angeles';
            us.LocaleSidKey = 'en_US';
            us.EmailEncodingKey = 'UTF-8';
            us.LanguageLocaleKey = 'en_US';
            return us;
    }

    public static MBO__c createMBO(User employee,User manager,String year,String quarter){
        Decimal counter = Math.random();
        MBO__c mbo =  new MBO__c();
        mbo.Name = 'TestMbo'+year+counter;
        mbo.Employee__c = employee.Id;
        mbo.Manager__c = manager.Id;
        mbo.MBO_Year__c = year;
        mbo.Year_Quarter__c = quarter;
        mbo.Enable_Self_Review__c = true;
        return mbo;
    }

    public static Performance_Reviews__c createPerformanceFeedback(MBO__c mbo){
        Decimal counter = Math.random();
        Performance_Reviews__c perfRev = new Performance_Reviews__c();
        perfRev.Employee__c = mbo.Employee__c;
        perfRev.Manager__c = mbo.Manager__c;
        perfRev.MBO_Year__c = mbo.MBO_Year__c;
        perfRev.MBO_Q1_Q2__c = mbo.Id;
        return perfRev;
    }

    public static Performance_Reviews__c createPerformanceFeedback(User employee,User manager,String year){
        Decimal counter = Math.random();
        Performance_Reviews__c perfRev = new Performance_Reviews__c();
        perfRev.name = 'PF-'+counter;
        perfRev.Employee__c = employee.Id;
        perfRev.Manager__c = manager.Id;
        perfRev.MBO_Year__c = year;
        return perfRev;
    }
}