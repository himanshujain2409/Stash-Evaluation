/**
 *  Apttus Approvals Management
 *  CustomApprovalsConstants
 *   
 *  @2014 Apttus Inc. All rights reserved.
 */
public virtual class CustomApprovalsConstants {

    // approvals related params
    public static final String PARAM_RET_ID = 'retId';
    public static final String PARAM_RET_PAGE = 'retPage';
    public static final String PARAM_ACTION = 'action';
    public static final String PARAM_RET_URL = 'retURL';
    public static final String PARAM_RETURNID = 'returnId';
    public static final String PARAM_RETURNPAGE = 'returnPage';
    public static final String PARAM_QUOTE_ID = 'quoteId';
    public static final String PARAM_OPPTY_ID = 'opptyId';
    public static final String PARAM_IS_DIALOG = 'isDialog';
    public static final String PARAM_SF1MODE = 'sf1Mode';
    public static final String PARAM_CONFIG_ID = 'Id';
    public static final String PARAM_SOBJECTID = 'sObjectId';
    public static final String PARAM_SOBJECTTYPE = 'sObjectType';
    public static final String PARAM_SHOW_HEADER = 'showHeader';
    public static final String PARAM_SHOW_SIDEBAR = 'showSidebar';
    public static final String PARAM_HIDE_SUBMIT_WITH_ATTACHMENTS = 'hideSubmitWithAttachments';
    public static final String PARAM_LINEITEM_IDS = 'lineItemIds';
    public static final String PARAM_ACTION_TAKEN = 'actionTaken';
    public static final String PARAM_APPROVAL_TYPE = 'approvalType';
    public static final String PARAM_FINALIZE_CLASS = 'finalizeClass';
    public static final String PARAM_AR_FIELDSET_NAME = 'arFieldSetName'; 
    public static final String PARAM_CONFIG_REQUEST_ID = 'configRequestId';
    public static final String PARAM_RETURN_BUTTON_LABEL = 'returnButtonLabel';
    public static final String PARAM_INCLUDE_HEADER_APPROVALS = 'includeHeaderApprovals';
    
    // actions
    public static final String ACTION_SHOW = 'show';
    public static final String ACTION_CANCEL = 'cancel';
    public static final String ACTION_SUBMIT = 'submit';
    public static final String ACTION_PREVIEW = 'preview';
    public static final String ACTION_SUBMIT_WITH_ATTACHMENTS = 'submitWithAttachments';
    public static final String ENABLE_ATTACHMENTS = 'enableAttachments';
    
    // context types
    public static final String CONTEXT_TYPE_SINGLE = 'Single';
    public static final String CONTEXT_TYPE_MULTIPLE = 'Multiple';
    
    // approval preview status
    public static final String APPROVAL_PREVIEW_STATUS_PENDING = 'Pending';
    public static final String APPROVAL_PREVIEW_STATUS_COMPLETE = 'Complete';
    
    // approval status
    public static final String STATUS_NONE = 'None';
    public static final String STATUS_NOT_SUBMITTED = 'Not Submitted';
    public static final String STATUS_PENDING_APPROVAL = 'Pending Approval';
    public static final String STATUS_APPROVAL_REQUIRED = 'Approval Required';
    
    // approval context
    public static final String APPROVALCTX_HEADER = 'header';
    public static final String APPROVALCTX_LINEITEM = 'lineItem';
    public static final String APPROVALCTX_CART = 'cart';
    public static final String APPROVALCTX_NONE = 'none';

    // cpq-config status
    public static final String STATUS_SAVED = 'Saved';
    public static final String STATUS_FINALIZED = 'Finalized';
    public static final String STATUS_READY_FOR_FINALIZATION = 'Ready For Finalization';
    
    public static final String SOBJECT_OPPORTUNITY = 'Opportunity';
    public static final String SOBJECT_QUOTE = 'Apttus_Proposal__Proposal__c';
    public static final String SOBJECT_CART_HEADER = 'Apttus_Config2__ProductConfiguration__c';
    public static final String QUOTE_CONFIG_PAGE = 'Apttus_QPConfig__ProposalConfiguration';
    public static final String USE_ADVANCED_APPROVAL = 'useAdvancedApproval';
    
    public static final String PREVIEW_PENDING = 'Pending';
    public static final String PREVIEW_COMPLETE = 'Complete';

    // customer portal user types
    public static final String USERTYPE_HIGHVOLUMEPORTAL = 'CspLitePortal';
    public static final String USERTYPE_CUSTOMERPORTAL_USER = 'CustomerSuccess';
    public static final String USERTYPE_CUSTOMERPORTAL_MANAGER = 'PowerCustomerSuccess';
    public static final String USERTYPE_PARTNER = 'PowerPartner';

}