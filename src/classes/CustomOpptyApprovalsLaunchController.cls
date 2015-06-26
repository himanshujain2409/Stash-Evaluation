/**
 *  Apttus Approvals Management
 *  CustomOpptyApprovalsLaunchController
 *   
 *  @2014 Apttus Inc. All rights reserved.
 */
public with sharing class CustomOpptyApprovalsLaunchController extends CustomApprovalsConstants {

    // context id
    private ID ctxObjId = null;
    // error indicator
    public Boolean hasErrors { public get; private set; }

    /**
     * Class Constructor
     * @param stdController the standard controller
     */
    public CustomOpptyApprovalsLaunchController(ApexPages.StandardController stdController) {
        // get context id
        ctxObjId = stdController.getId();
    }
    
    /**
     * Gets context object Id
     */
    public ID getCtxObjectId() {
        return ctxObjId;
    }
    
    /**
     * Launch approvals
     * @return pageRef page reference to appropriate page
     */
    public PageReference doLaunchApprovals() {
        // redirect to opportunity approvals page
        PageReference pageRef = Page.CustomOpptyApprovals;
        pageRef.getParameters().put(PARAM_OPPTY_ID, ctxObjId);
        pageRef.getParameters().put(PARAM_RETURN_BUTTON_LABEL, Label.Apttus_Approval.Return);
        pageRef.getParameters().put(PARAM_RETURNID, ctxObjId);
        
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    /**
     * Return to opportunity
     */
    public PageReference doReturn() {
        PageReference pageRef = new PageReference(CustomApprovalsUtil.getPageUrlForObjectId(ctxObjId));
        pageRef.setRedirect(true);
        return pageRef;
    }

}