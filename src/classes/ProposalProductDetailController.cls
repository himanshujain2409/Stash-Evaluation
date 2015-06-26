public with sharing class ProposalProductDetailController {
    
    public string proposalid{get; set;}
    
    public ProposalProductDetailController (){}
    
     
    public list<Apttus_Proposal__Proposal_Line_Item__c> getListOfProposalLineItems(){
        list<Apttus_Proposal__Proposal_Line_Item__c> ls=[Select id , Name,
                                                        Product_Option_Name__c,
                                                        Quantity_Display__c,
                                                        List_Price_Display__c,
                                                        Net_Price_Display__c,
                                                        Apttus_QPConfig__NetAdjustmentPercent__c , 
                                                        Apttus_QPConfig__AdjustmentType__c ,
                                                        Apttus_QPConfig__NetPrice__c ,
                                                        Salesforce_Royalty__c                 
                                                        From Apttus_Proposal__Proposal_Line_Item__c
                                                        Where Apttus_Proposal__Proposal__c=:proposalid];
                                                        
        return ls;
    }
}