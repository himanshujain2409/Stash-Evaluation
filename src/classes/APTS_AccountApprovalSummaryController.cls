public class APTS_AccountApprovalSummaryController {

    private ApexPages.StandardController controller {get;set;}
    private Apttus_Approval.ApprovalActionController2 actionController;
    public Apttus_Approval__Approval_Request__c requestSO;
    
    public APTS_AccountApprovalSummaryController(ApexPages.StandardController stdController) {
        actionController = new Apttus_Approval.ApprovalActionController2(stdController);
        requestSO = (Apttus_Approval__Approval_Request__c) stdController.getRecord();
    }
    
    public boolean isPageModeApproveRequest 
    {
        get{
            return actionController.getIsPageModeApproveRequest();
        }
    }
    public boolean isUserAuthorized 
    {
        get{
            return actionController.getIsUserAuthorized();
            }
    }
    
    public String SubmissionComment1Label
    {
        get
        {
            return actionController.getSubmissionComment1Label();
        }
    }
    
    public String SubmissionComment2Label
    {
        get
        {
            return actionController.getSubmissionComment2Label();
        }
    }
    public String SubmissionComment3Label
    {
        get
        {
            return actionController.getSubmissionComment3Label();
        }
    }
    
  
    public PageReference doApprove()
    {
        
        actionController.doApprove();
        PageReference pr = new PageReference('/' +  requestSO.Apttus_Approval__Object_Id__c);
        pr.setRedirect(true);
        return pr;
    }
    
    public PageReference doReject()
    {
        actionController.doReject();
        PageReference pr = new PageReference('/' +  requestSO.Apttus_Approval__Object_Id__c);
        pr.setRedirect(true);
        return pr;
    }
    
    public PageReference doAddComment()
    {
        actionController.doAddComment();
        PageReference pr = new PageReference('/' +  requestSO.Apttus_Approval__Object_Id__c);
        pr.setRedirect(true);
        return pr;
    }
    
    public PageReference doCancel()
    {
        PageReference pr = new PageReference('/' +  requestSO.Apttus_Approval__Object_Id__c);
        pr.setRedirect(true);
        return pr;
    }
    
    public PageReference doAttachFile()
    {
         
         PageReference pr = actionController.doAttachFile();
         return pr;     
    }
    
      
    public List<Attachment> getARAttachments()
    {
        return actionController.getARAttachments();
    }
    
    public Account getAccount() {
      return  [SELECT Name,Owner.Name,AccountStatusGS__c,Account_Status__c,CSM__c,Account_Level__c,Executive_Sponsor__c
                           FROM Account Where Id =: requestSO.Apttus_Approval__Object_Id__c];
    }
    
    public Concession_Request_CS__c getConcessionRequest() {
        return [SELECT Hours_Requested__c,Account__c,Case__c,Concession_Request_Sub_Type__c,Concession_Request_Type__c,
                       Has_CR_been_Negotiated_with_Customer__c,Justification__c,Notes__c,Proposed_Rate__c,
                       Requested_Concession_Amount__c,Requested_Concession_Hours__c,Request_to_waive_FP_uplift__c,
                       Request_to_waive_onsite_rate__c,Root_cause_characteristics__c,SOW_Hours__c FROM Concession_Request_CS__c Where Id =: requestSO.Apttus_Approval__ChildObjectId__c];
    }
}