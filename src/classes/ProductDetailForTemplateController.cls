global with sharing class ProductDetailForTemplateController {

    public string proposalid{get; set;}
    
    public ProductDetailForTemplateController(){}
    
    public list<Apttus_Approval__Approval_Request__c> getListOfApprovalRequests(){
        list<Apttus_Approval__Approval_Request__c> ls=[Select id ,
                                                        Apttus_Approval__Step_Name__c,
                                                        Apttus_Approval__Approval_Status__c,
                                                        Apttus_Approval__ActualApproverName__c,
                                                        Apttus_Approval__Approver_Comments__c,
                                                        Apttus_Approval__DependsOn__c,
                                                        Apttus_Approval__Assigned_To_Name__c,
                                                        Apttus_Approval__Date__c                                                        
                                                        From Apttus_Approval__Approval_Request__c
                                                        Where Apttus_QPApprov__ProposalId__c=:proposalid];
                                                        
        return ls;
    }
     
}