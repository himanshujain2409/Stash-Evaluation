/**
 *  Apttus Approvals Management
 *  CustomOpptyMyApprovalsController
 *   
 *  @2014 Apttus Inc. All rights reserved.
 */
public with sharing class CustomOpptyMyApprovalsController extends CustomApprovalsConstants {

    // context id
    private ID ctxObjId = null;
    // context object type
    private String ctxObjType = null;
    // return to object id
    private ID returnId = null;
    // return to custom page
    private String returnPage = null;
    // salesforce1 mode indicator
    private Boolean inSf1Mode = false;
    // page initially loaded
    private Boolean pageLoaded = false;
    // page URL
    private String pageURL = null;
    
    /**
     * Class Constructor 
     * @param stdController the base myapprovals controller
     */
    public CustomOpptyMyApprovalsController(Apttus_Approval.MyApprovalsController baseController) {
        this();

    }

    /**
     * Class Constructor 
     */
    public CustomOpptyMyApprovalsController() {

        // context object id
        String ctxObjIdStr = ApexPages.currentPage().getParameters().get(PARAM_SOBJECTID);
        if (! CustomApprovalsUtil.nullOrEmpty(ctxObjIdStr)) {
            ctxObjId = String.escapeSingleQuotes(ctxObjIdStr);
        }
        
        // context object type
        String ctxObjTypeStr = ApexPages.currentPage().getParameters().get(PARAM_SOBJECTTYPE);
        if (! CustomApprovalsUtil.nullOrEmpty(ctxObjTypeStr)) {
            ctxObjType = String.escapeSingleQuotes(ctxObjTypeStr);
        }
        
        // return-to object id
        String retIdStr = ApexPages.currentPage().getParameters().get(PARAM_RETURNID);
        if (! CustomApprovalsUtil.nullOrEmpty(retIdStr)) {
            returnId = String.escapeSingleQuotes(retIdStr);
        }
        
        // return-to custom page
        String retPageStr = ApexPages.currentPage().getParameters().get(PARAM_RETURNPAGE);
        if (! CustomApprovalsUtil.nullOrEmpty(retPageStr)) {
            returnPage = String.escapeSingleQuotes(retPageStr);
        }

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
     * Load MyApprovals - launch base MyApprovals page
     * @return pageRef page reference to appropriate page
     */
    public PageReference doLoadMyApprovals() {
        
        // navigate to the correct page based on whether we are in Salesforce1 or not
        PageReference pageRef = (getInSf1Mode())
                ? new PageReference(CustomApprovalsUtil.getPageUrl('Apttus_Approval__MyApprovalsSf1'))
                : new PageReference(CustomApprovalsUtil.getPageUrl('Apttus_Approval__MyApprovals'));

        pageRef.getParameters().put(PARAM_SOBJECTID, ctxObjId);
        pageRef.getParameters().put(PARAM_SOBJECTTYPE, ctxObjType);

        // return to id or custom page but not both, id takes preference        
        if (! CustomApprovalsUtil.nullOrEmpty(returnPage)) {
            pageRef.getParameters().put(PARAM_RETURNPAGE, returnPage);
        } else {
            pageRef.getParameters().put(PARAM_RETURNID, returnId);
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
    
    /**
     * Return to quote
     */
    public PageReference doReturn() {
        
        // create a page reference that is communities aware
        PageReference pageRef = new PageReference(CustomApprovalsUtil.getPageUrlForObjectId(returnId));

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

}