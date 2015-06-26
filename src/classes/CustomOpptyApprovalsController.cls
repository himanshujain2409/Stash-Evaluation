/**
 *  Apttus Approvals Management
 *  CustomOpptyApprovalsController
 *   
 *  @2014 Apttus Inc. All rights reserved.
 */
public with sharing class CustomOpptyApprovalsController extends CustomApprovalsConstants {

    // opportunity id
    private ID opptyId = null;

    // user initiated action (submit/cancel/return)    
    private String actionTaken = null;   

    // return button label
    private String returnButtonLabel = null;
    
    // show header & sidebar ?
    private Boolean showHeader = false;
    private Boolean showSidebar = false;
    
    // approval request fieldset name
    private String arFieldSetName = null;
        
    // component params
    private Apttus_Approval.SObjectApprovalContextParam2 ctxParam2 = null;

    // context header
    private Opportunity opptySO = null;

    // single context
    private ID lineItemId = null;
    
    // return id or page but not both, id takes preference
    private ID returnId = null;
    private String returnPage = null;
    
    // approvals not invoked from within dialog
    private Boolean isDialog = false;
    // show submit with attachments button by default
    private Boolean hideSubmitWithAttachments = false;
    
    // salesforce1 mode indicator
    private Boolean inSf1Mode = false;
    // page initially loaded
    private Boolean pageLoaded = false;
    // page URL
    private String pageURL = null;

    /**
     * Class Constructor 
     */
    public CustomOpptyApprovalsController() {

        // show header
        String showHeaderStr = ApexPages.currentPage().getParameters().get(PARAM_SHOW_HEADER);
        if (! CustomApprovalsUtil.nullOrEmpty(showHeaderStr)) {
            showHeader = Boolean.valueOf(String.escapeSingleQuotes(showHeaderStr));
        }
        
        // show sidebar
        String showSidebarStr = ApexPages.currentPage().getParameters().get(PARAM_SHOW_SIDEBAR);
        if (! CustomApprovalsUtil.nullOrEmpty(showSidebarStr)) {
            showSidebar = Boolean.valueOf(String.escapeSingleQuotes(showSidebarStr));
        }
        
        // approval request fieldset name?
        String arFieldSetNameStr = ApexPages.currentPage().getParameters().get(PARAM_AR_FIELDSET_NAME);
        if (arFieldSetNameStr != null) {
            arFieldSetName = String.escapeSingleQuotes(arFieldSetNameStr);
        }

        // return/exit button label shown inside the component
        String returnButtonLabelStr = ApexPages.currentPage().getParameters().get(PARAM_RETURN_BUTTON_LABEL);
        if (returnButtonLabelStr != null) {
            returnButtonLabel = String.escapeSingleQuotes(returnButtonLabelStr);
        }
        
        // oppty id
        String opptyIdStr = ApexPages.currentPage().getParameters().get(PARAM_OPPTY_ID);
        if (! CustomApprovalsUtil.nullOrEmpty(opptyIdStr)) {
            opptyId = String.escapeSingleQuotes(opptyIdStr);
        }
        
        // return id
        String returnIdStr = ApexPages.currentPage().getParameters().get(PARAM_RETURNID);
        if (! CustomApprovalsUtil.nullOrEmpty(returnIdStr)) {
            returnId = ID.valueOf(String.escapeSingleQuotes(returnIdStr));
        }
        
        // return page
        String returnPageStr = ApexPages.currentPage().getParameters().get(PARAM_RETURNPAGE);
        if (! CustomApprovalsUtil.nullOrEmpty(returnPageStr)) {
            returnPage = String.escapeSingleQuotes(returnPageStr);
        }

        // get selected line item id
        String lineItemIdStr = ApexPages.currentPage().getParameters().get(PARAM_LINEITEM_IDS);
        if (lineItemIdStr != null) {
            lineItemId = String.escapeSingleQuotes(lineItemIdStr);
        }
        
        // are we within a iframe?
        String isDialogStr = ApexPages.currentPage().getParameters().get(PARAM_IS_DIALOG);
        if (! CustomApprovalsUtil.nullOrEmpty(isDialogStr)) {
            isDialog = Boolean.valueOf(String.escapeSingleQuotes(isDialogStr));
        }
        
        // hide submit with attachments button?
        String hideSubmitWithAttStr = ApexPages.currentPage().getParameters().get(PARAM_HIDE_SUBMIT_WITH_ATTACHMENTS);
        if (! CustomApprovalsUtil.nullOrEmpty(hideSubmitWithAttStr)) {
            hideSubmitWithAttachments = Boolean.valueOf(String.escapeSingleQuotes(hideSubmitWithAttStr));
        }
        
        // get opportunity
        List<Opportunity> opptySOList = [select Id, Apttus_Approval__Approval_Status__c
                                                , Approval_Preview_Status__c
                                         from Opportunity
                                         where Id = :opptyId];
        if ( ! CustomApprovalsUtil.nullOrEmpty(opptySOList)) {
            opptySO = opptySOList[0];
        }   

        // prepare context
        prepareContext();
        
        // LOAD ANY ADDITIONAL DATA FOR DISPLAY.......

    }
    
    /**
     * Gets context param object for component
     */
    private void prepareContext() {             
        
        // prepare param
        ctxParam2 = new Apttus_Approval.SObjectApprovalContextParam2();
        
        ctxParam2.ctxSObjectType = SOBJECT_OPPORTUNITY;
        ctxParam2.ctxSObjectId = opptySO.Id;
        
        // single context?
        if (lineItemId != null) {
            ctxParam2.ctxChildSObjectId = lineItemId;
        }
        
        ctxParam2.ctxApprovalStatus = opptySO.Apttus_Approval__Approval_Status__c;
        
        // auto-preview?
        if ((STATUS_APPROVAL_REQUIRED == opptySO.Apttus_Approval__Approval_Status__c)
                && (APPROVAL_PREVIEW_STATUS_PENDING == opptySO.Approval_Preview_Status__c)) {
            ctxParam2.autoPreviewIndicator = true;
        }
        
        ctxParam2.returnButtonLabel = returnButtonLabel;
        ctxParam2.processingMode = Apttus_Approval.SObjectApprovalContextParam2.PROCESSING_MODE_PREVIEW;
        ctxParam2.inDialogMode = isDialog;
        
        // use return id or page but not both, id takes preference
        if (! CustomApprovalsUtil.nullOrEmpty(returnPage)) {
            // return to custom page
            ctxParam2.returnPage = returnPage;

        } else {
            // return to oppty
            ctxParam2.returnId = opptyId;
        }

        if (arFieldSetName != null) {
            ctxParam2.dspFieldSetName = arFieldSetName;
        }

        // hide cart header and return button if approvals are being reviewed within a dialog
        if (isDialog) {
            returnButtonLabel = null;
            ctxParam2.returnButtonLabel = null;     
        }                                       

        // the submit with attachments button is hidden by default for cart approvals
        // set the parameter below to false or pass in the URL parameter to show the button
        ctxParam2.hideSubmitWithAttachments = hideSubmitWithAttachments;

        // in salesforce1 mode?
        ctxParam2.inSf1Mode = inSf1Mode;

    }
    
    /**
     * Set the controller mode to Salesforce1 when assignTo is passed in actionFunction param
     * @param mode true if we are in Salesforce1 mode, false otherwise
     */
    public void setInSf1Mode(Boolean mode) {
        inSf1Mode = mode;
    }

    /**
     * Check if the controller is in Salesforce1 mode
     * @return true if we are in Salesforce1 mode, false otherwise
     */
    public Boolean getInSf1Mode() {
        return inSf1Mode;
    }
    
    /**
     * Test if the page has been initially loaded
     * @return true if the page has been initially loaded, false otherwise
     */
    public Boolean getPageLoaded() {  
        return pageLoaded;  
    }
    
    /**
     * Get the page URL
     * @return the page URL
     */
    public String getPageURL() {  
        return pageURL;  
    }
    
    /**
     * Launch SObject approvals
     * @return pageRef page reference to appropriate page
     */
    public PageReference doLaunchSObjectApprovals() {
        // save the sf1 mode
        ctxParam2.inSf1Mode = inSf1Mode;
        
        // indicate we have initially loaded the page
        pageLoaded = true;
        
        // stay on same page so we can use sforce1 redirection in the visualforce page
        pageURL = null;
        return null;
    
    }
    
    /**
     * Get appropriate label based on caller
     */
    public String getReturnLabel() {
        return returnButtonLabel;
    }
    
    /*
     * Get approval request fieldset name
     */
    public String getFieldSetName() {
        return arFieldSetName;
    }
    
    /**
     * Gets show header indicator
     */
    public Boolean getShowHeader() {
        return showHeader;
    }
    
    /**
     * Gets show sidebar indicator
     */
    public Boolean getShowSidebar() {
        return showSidebar;
    }   

    /**
     * Gets context param object for component
     */
    public Apttus_Approval.SObjectApprovalContextParam2 getContextInfo() {
        return ctxParam2;
    }

    /**
     * Sets context param object
     * @param ctxInfo 
     */
    public void setContextInfo(Apttus_Approval.SObjectApprovalContextParam2 info) {
        
    }

    /**
     * Can cancel?
     */
    public Boolean getCanCancel() {
        return (ctxParam2.ctxApprovalStatus == STATUS_PENDING_APPROVAL);
    }
    
    /**
     * Can submit?
     */
    public Boolean getCanSubmit() {
        return ((ctxParam2.ctxApprovalStatus == STATUS_APPROVAL_REQUIRED)
             || (ctxParam2.ctxApprovalStatus == STATUS_NOT_SUBMITTED));
    }
    
    /**
     * Return to Opportunity
     */
    public PageReference doReturn() {
        
        // preview complete
        doUpdatePreviewStatus(APPROVAL_PREVIEW_STATUS_COMPLETE, null);
        
        // get page reference for opportunity
        PageReference pageRef = new PageReference(CustomApprovalsUtil.getPageUrlForObjectId(opptyId));

        // redirect to the target page
        if (getInSf1Mode()) {
            // mark the page as loaded
            pageLoaded = true;
            
            // stay on same page so we can use sforce1 redirection in the visualforce page
            pageURL = pageRef.getURL();
            return null;
            
        } else {
            // navigate to the new page
            pageRef.setRedirect(true);
            return pageRef;
            
        }

    }

    /**
     * Initial call to submit page
     */
    public PageReference doSubmit() {
        actionTaken = ACTION_SUBMIT;
        return doReturnInternal();
    }
    
    /**
     * Initial call to submit page
     */
    public PageReference doSubmitWithAttachments() {
        actionTaken = ACTION_SUBMIT_WITH_ATTACHMENTS;
        return doReturnInternal();
    }
    
    /**
     * Gets if we are hiding the submit for attachments button
     */
    public Boolean getHideSubmitWithAttachments() {
        return hideSubmitWithAttachments;
    }
    
    /**
     * Cancel approvals and return
     */
    public PageReference doCancel() {
        // cancel webservice  
        Apttus_Approval.ApprovalsWebService.cancelApprovals(SOBJECT_OPPORTUNITY, opptyId);
        return doReturn();
    }
    
    public PageReference doReturnToCaller() {
        // get the action taken from the page parameters
        String actionTakenStr = ApexPages.currentPage().getParameters().get('actionTaken');
        if (! CustomApprovalsUtil.nullOrEmpty(actionTakenStr)) {
            actionTaken = String.escapeSingleQuotes(actionTakenStr);
        }
        return doReturnInternal();
    }

    /**
     * Return
     */    
    private PageReference doReturnInternal() {

        // return url
        PageReference pageRef = null;
        if ((actionTaken == ACTION_SUBMIT) ||
            (actionTaken == ACTION_SUBMIT_WITH_ATTACHMENTS)) {
            
            pageRef = new PageReference(CustomApprovalsUtil.getPageUrl('SObjectApprovals2Submit'));

            // specify cart header and cart id parameters
            pageRef.getParameters().put(PARAM_SOBJECTTYPE, SOBJECT_OPPORTUNITY);
            pageRef.getParameters().put(PARAM_SOBJECTID, opptyId);

            // return to quote or custom page but not both, quote takes preference
            if (! CustomApprovalsUtil.nullOrEmpty(returnPage)) {
                pageRef.getParameters().put(PARAM_RETURNPAGE, returnPage);
            } else {                                
                pageRef.getParameters().put(PARAM_RETURNID, opptyId);
            }

            if (actionTaken == ACTION_SUBMIT_WITH_ATTACHMENTS) {
                pageRef.getParameters().put(ENABLE_ATTACHMENTS, 'true');
            }
            // preview complete
            doUpdatePreviewStatus(APPROVAL_PREVIEW_STATUS_COMPLETE, null);

        } else {
            if (actionTaken == ACTION_CANCEL) {
                // reset oppty approval status to approval required
                doUpdatePreviewStatus(APPROVAL_PREVIEW_STATUS_PENDING, STATUS_APPROVAL_REQUIRED);
            }

            if (! CustomApprovalsUtil.nullOrEmpty(returnPage)) {
                // return page provided, use it
                pageRef = new PageReference(CustomApprovalsUtil.getPageUrl(returnPage));
                
            } else {
                // return to oppty
                pageRef = new PageReference(CustomApprovalsUtil.getPageUrlForObjectId(opptyId));

            }
        }

        // redirect to the target page
        if (getInSf1Mode()) {
            // mark the page as loaded
            pageLoaded = true;
            
            // stay on same page so we can use sforce1 redirection in the visualforce page
            pageURL = pageRef.getURL();
            return null;
            
        } else {
            // navigate to the new page
            pageRef.setRedirect(true);
            return pageRef;
            
        }

    }
    
    // update preview status
    private void doUpdatePreviewStatus(String previewStatus, String approvalStatus) {
        
        // save preview (and approval) status
        Opportunity opptySO = new Opportunity(Id = opptyId);
        opptySO.Approval_Preview_Status__c = previewStatus;
        if (approvalStatus != null) {
            opptySO.Apttus_Approval__Approval_Status__c = approvalStatus;
        }
        update opptySO;
    }

}