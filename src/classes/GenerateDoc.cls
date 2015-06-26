public with sharing class GenerateDoc {
    public Apttus_Proposal__Proposal__c Proposal {get; set;}
    public ID ProposalId {get;     set;}
    public String apiSessionId {get;        set;}
    public String apiServerURL {get;        set;}
    private string status;     
    public GenerateDoc(ApexPages.StandardController controller) {       
        
        Proposal =[Select id, Apttus_Proposal__Approval_Stage__c from Apttus_Proposal__Proposal__c
                        Where id=:controller.getRecord().id];
        status=Proposal.Apttus_Proposal__Approval_Stage__c;
        ProposalId = controller.getRecord().ID;
        
    }

    public PageReference doGenerateDoc(){      
                 List<Apttus__APTS_Template__c> lstTemplate = new List<Apttus__APTS_Template__c>();
               
                lstTemplate = [SELECT ID,NAME,Apttus__Guidance__c,Apttus__Category__c,Apttus__Subcategory__c,Apttus__IsActive__c
                                                   FROM Apttus__APTS_Template__c
                                                   WHERE Apttus__IsActive__c = TRUE
                                                   AND NAME='Order Form'
                                                   AND Apttus__Type__c = 'Proposal'];
                 
                id templateid;
                
                if(lstTemplate!=null && lstTemplate.size()>0) templateid=lstTemplate[0].id;
                
                system.debug('****'+ProposalId+'****'+apiSessionId+ '****'+apiServerURL );
                
                string tid='';
                
                if(!test.isrunningtest())
                    tid=Apttus_Proposal.MergeWebService.generateDoc2(templateid,ProposalId,'','DOC',false,apiSessionId,apiServerURL );
                
                Proposal.Apttus_Proposal__Approval_Stage__c=status;
                Update Proposal;
                PageReference PR= new PageReference('/'+tid);
                PR.setRedirect(true);
                return PR;
    }
}