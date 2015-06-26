/**
 *  Apttus Approvals Management
 *  CustomOpptyMyApprovalsEmailController
 *   
 *  @2014 Apttus Inc. 
 */
public with sharing class CustomOpptyMyApprovalsEmailController {
    
    // state
    
    // email controller
    private Apttus_Approval.MyApprovalsEmailController context = null;
    
    /**
     * Class Constructor
     */
    public CustomOpptyMyApprovalsEmailController() {
        // create the context
        this.context = new Apttus_Approval.MyApprovalsEmailController();
        
    }
    
    /**
     * Gets the context controller
     * @return the context controller
     */
    public Apttus_Approval.MyApprovalsEmailController getContext() {
        return context;
        
    }
    
    /**
     * Gets the approval request sobject
     * @return the approval request sobject
     */
    public Apttus_Approval__Approval_Request__c getRequestSO() {
        return context.getRequestSO();
        
    }
    
    /**
     * Sets the approval request sobject
     * @param requestSO the approval request sobject
     */
    public void setRequestSO(Apttus_Approval__Approval_Request__c requestSO) {
        context.setRequestSO(requestSO);
        
    }
    
    /**
     * Gets the approval email recipient sobject
     * @return the approval email recipient sobject
     */
    public User getRecipientSO() {
        return context.getRecipientSO();
        
    }
    
    /**
     * Sets the approval email recipient sobject
     * @param recipientSO the approval email recipient sobject
     */
    public void setRecipientSO(User recipientSO) {
        context.setRecipientSO(recipientSO);
        
    }
    
    /**
     * Checks if actions are supported by the approval request
     * @return <code>true</code> if actions are supported, <code>false</code> otherwise
     */
    public Boolean getAreActionsSupported() {
        return context.getAreActionsSupported();
        
    }
    
    /**
     * Checks if request status is cancelled
     * @return <code>true</code> if request status is cancelled, <code>false</code> otherwise
     */
    public Boolean getIsStatusCancelled() {
        return context.getIsStatusCancelled();
        
    }
    
    /**
     * Checks if email approval response is enabled
     * @return <code>true</code> if email approval response is enabled, <code>false</code> otherwise
     */
    public Boolean getIsEmailApprovalResponseEnabled() {
        return context.getIsEmailApprovalResponseEnabled();
        
    }
    
    /**
     * Gets the list of approval history associated with the approval request
     * @return the list of approval history sobjects
     */
    public List<Apttus_Approval__Approval_Request__c> getApprovalHistory() {
        return context.getApprovalHistory();
        
    }
    
    /**
     * Gets the my approvals page url
     * @return the my approvals page url
     */
    public String getMyApprovalsPageUrl() {
        //return context.getMyApprovalsPageUrl();
        return Apttus_Approval.ApprovalsWebService.getMyApprovalsPageUrl(getRequestSO());
        
    }
    
    /**
     * Gets user approvals
     * @return list of MyApprovalsController.StepWrapper objects
     */
    public List<Apttus_Approval.MyApprovalsController.StepWrapper> getUserApprovals() {
        return context.getUserApprovals();
        
    }
    
    /**
     * Gets comments entered by approved users
     * @return list of Apttus_Approval__Approval_Request__c objects
     */
    public List<Apttus_Approval__Approval_Request__c> getCompletionComments() {
        return context.getCompletionComments();
        
    }
        
    /**
     * Gets submit comment label-1
     */
    public String getComment1Label() {
        return context.getComment1Label();
        
    }
        
    /**
     * Gets submit comment label-2
     */
    public String getComment2Label() {
        return context.getComment2Label();
        
    }
        
    /**
     * Gets submit comment label-3
     */
    public String getComment3Label() {
        return context.getComment3Label();
        
    }

}