@isTest
public class TestProposalProductDetailController {

    
    public static Account CreateAccount(string name) {
        Account accountSO = new Account();
        accountSO.Name = name;
        
         
        return accountSO;
    }
    public static Product2 CreateProduct(string prodName, boolean isActive) {
        //Create new Product Item
        Product2 prodSO = new Product2();
        prodSO.name = prodName; 
        prodSO.IsActive = isActive;
        return prodSO;
    }
    public static Opportunity CreateOppty(string oppName, ID accountID, Date closeDate, string stage ) {
        Opportunity opptySO = new Opportunity();
        opptySO.Name = oppName;
        opptySO.AccountId = accountID;
        opptySO.CloseDate = closeDate;
        opptySO.StageName = stage;
        return opptySO;
    }
    public static Apttus_Config2__PriceList__c CreatePriceList(string plistName) {
        Apttus_Config2__PriceList__c plistSO = new Apttus_Config2__PriceList__c();
        plistSO.name = plistName;
        return plistSO;
    }
    public static Apttus_Proposal__Proposal__c CreateProposal(string propName, ID accountID, string endUserEmail, ID priceListID,string apprStage){
        Apttus_Proposal__Proposal__c propSO = new Apttus_Proposal__Proposal__c();
        propSO.Apttus_Proposal__Proposal_Name__c = propName ;
        propSO.Apttus_Proposal__Account__c = accountID;
         
        propSO.Apttus_QPConfig__PriceListId__c = priceListID;
        propSO.Apttus_Proposal__Approval_Stage__c = apprStage;
        return propSO;
    }
	
    
    static testMethod void TestProposalProductDetail() {
       
		Account acc= CreateAccount('test name');
		CreateProduct('test product', true);
		Date closeDate =System.today();
		closeDate.addDays(6);
		CreateOppty('test opp', acc.Id, closeDate, 'stage test' );
		Apttus_Config2__PriceList__c plist = CreatePriceList('test list');
		Apttus_Proposal__Proposal__c proposal = CreateProposal('test name', acc.Id, 'kbhalodiya@apttus.com', plist.Id,'test stage');
		
		test.startTest();
		ProposalProductDetailController ppdc =new ProposalProductDetailController();
		ppdc.proposalid = proposal.Id;
		ppdc.getListOfProposalLineItems();
        Test.stopTest();
    }
    
}