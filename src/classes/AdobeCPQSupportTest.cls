/*
* Unit test for AdobeCPQSupport class
* @author Copyright (c) 2014 Apttus.
* @author cpatel@apttus.com
*/
@isTest
private class AdobeCPQSupportTest {

	static testmethod void myUnitTest(){
		
        APTS_TestClassUtility util 				= new APTS_TestClassUtility();
		Account accountSO	 					= util.CreateAccount('Test acc');
		insert accountSO;	
		Product2 prodSO 						= util.CreateProduct('test prod', true);
		insert prodSO;
		Opportunity opptySO						= util.CreateOppty('test oppty',accountSO.id,system.today(),'Launch');
        opptySO.OwnerId =  UserInfo.getUserId();
        insert opptySO;
		Apttus_Config2__PriceList__c plistSO	= util.CreatePriceList('test plist');
        insert plistSO;
        Apttus_Proposal__Proposal__c propSO		= util.CreateProposal( 'Test Prop', accountSO.id, 'cpatel@apttus.com', plistSO.id,'Draft');
        insert propSO;
   		  
        Apttus_Config2__ProductConfiguration__c prodConfigSO = new Apttus_Config2__ProductConfiguration__c();
        prodConfigSO.name = 'test cart';
        prodConfigSO.Apttus_Config2__BusinessObjectType__c = 'Proposal';
        prodConfigSO.Apttus_Config2__AccountId__c = accountSO.id;
        prodConfigSO.Apttus_Config2__PriceListId__c = plistSO.id;
        prodConfigSO.Apttus_QPConfig__Proposald__c = propSO.id;
        prodConfigSO.Apttus_Config2__Status__c = 'Finalized';
        prodConfigSO.Apttus_Config2__BusinessObjectId__c =  propSO.id;
        insert prodConfigSO;
        
		AdobeCPQSupport.createQuoteOrProposal(opptySO); 
        AdobeCPQSupport.createDealFromProposal(propSO);
        AdobeCPQSupport.getOpportunitySO(opptySO.id);
        AdobeCPQSupport.getCartSO(prodConfigSO.id);
        
        AdobeCPQSupport.getInstanceUrl();
        AdobeCPQSupport.nullOrEmpty('test str');
        AdobeCPQSupport.isNilValue('test str');
        AdobeCPQSupport.nullValue('test str', 'test str1');
 
	}

}