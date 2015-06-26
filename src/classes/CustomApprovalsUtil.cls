/**
 *  Apttus Approvals Management
 *  CustomApprovalsUtil
 *   
 *  @2014 Apttus Inc. All rights reserved.
 */
public with sharing class CustomApprovalsUtil {

    // system properties
    static final String PROP_SYSTEM_PROPERTIES = 'System Properties';

    /**
     * Checks if the given string value is null or empty.
     * @param strValue the string to check
     * @return <code>true</code> if the string value is null or empty, <code>false</code> otherwise
     */
    public static Boolean nullOrEmpty(String strValue) {
        // check if null or zero length string
        return (strValue == null || strValue.trim().length() == 0);
        
    }
    
    /**
     * Checks if the given list of objects is null or empty.
     * @param objList the list of objects to check
     * @return <code>true</code> if the list is null or empty, <code>false</code> otherwise
     */
    public static Boolean nullOrEmpty(List<Object> objList) {
        // check if null or empty
        return (objList == null || objList.isEmpty());
        
    }

    /**
     * Gets the page url for the given page
     * @param pageName the name of the page
     * @return the page url 
     */
    public static String getPageUrl(String pageName) {
        
        // instance url
        String instanceUrl = getInstanceUrl();
        // build the custom page url
        String pageURL = (instanceUrl != null ? instanceUrl : '');
        // check if force.com domain    
        if (!isCommunitiesUser(UserInfo.getUserType())) {
            // not a communities user, add apex
            pageURL += '/apex';
            
        } 
        
        // page name
        pageURL += '/' + pageName;
        
        return pageURL;
        
    }
    
    /**
     * Gets the page url for the given object id
     * @param objectId the id of the object to navigate to
     * @return the page url 
     */
    public static String getPageUrlForObjectId(ID objectId) {
        
        // instance url
        String instanceUrl = getInstanceUrl();
        // build the custom page url
        String pageURL = (instanceUrl != null ? instanceUrl : '');
        
        // page name
        pageURL += '/' + objectId;
        
        return pageURL;
        
    }
    
    /**
     * Gets the instance url
     * @return the instance url 
     */
    public static String getInstanceUrl() {
        
        // check the user type
        if (isCommunitiesUser(UserInfo.getUserType()) &&
            //Site.getCurrentSiteUrl() != null) {
            Site.getBaseUrl() != null) {    
                
            String siteUrl = Site.getBaseUrl();
            
            if (siteUrl.endsWith('/')) {
                siteUrl = siteUrl.substring(0, siteUrl.length()-1);
                
            }
            
            return siteUrl;
            
        } 
        
        // get the system property dataset
        Apttus_Approval__ApprovalsSystemProperties__c prop = getSystemProperties();
                                
        return (prop != null && !nullOrEmpty(prop.Apttus_Approval__InstanceUrl__c) 
                ? prop.Apttus_Approval__InstanceUrl__c 
                : null);
                
    }
    
    /**
     * Checks if the given user indicates a communities user
     * @return <code>true</code> if communities user, <code>false</code> otherwise 
     */
    public static Boolean isCommunitiesUser(String userType) {
        return (CustomApprovalsConstants.USERTYPE_PARTNER == userType ||
                CustomApprovalsConstants.USERTYPE_CUSTOMERPORTAL_MANAGER == userType ||
                CustomApprovalsConstants.USERTYPE_HIGHVOLUMEPORTAL == userType ||
                CustomApprovalsConstants.USERTYPE_CUSTOMERPORTAL_USER == userType );
                
    }

    /**
     * Gets the system properties sobject
     * @return the system properties sobject
     */
    private static Apttus_Approval__ApprovalsSystemProperties__c getSystemProperties() {
        return Apttus_Approval__ApprovalsSystemProperties__c.getInstance(PROP_SYSTEM_PROPERTIES);
        
    }

    /**
     * Gets the opportunity associated with the given id
     * @param opptyId opportunity id
     * @return opportunity associated with the given id
     */
    public static Opportunity getOpportunity(ID opptyId) {
        
        // get approval context object - opportunity
        List<Opportunity> opptyList =  [select Id,Name,
                                            Type,
                                            StageName,
                                            Probability,
                                            Pricebook2Id,
                                            IsWon,
                                            IsClosed,
                                            HasOpportunityLineItem,
                                            ForecastCategoryName,
                                            ForecastCategory,
                                            FiscalYear,
                                            FiscalQuarter,
                                            Fiscal,
                                            Description,
                                            CloseDate,
                                            CampaignId,
                                            Amount,
                                            AccountId,
                                            Apttus_Approval__Approval_Status__c
                                        from Opportunity o
                                        where Id=:opptyId];
        
        if (nullOrEmpty(opptyList)) {
            return null;
        }
        return opptyList[0];
    }

    /**
     * Get opportunity products line items
     * @param opptyId opportunity id
     * @return collection opportunity line item objects
     */
    public static List<OpportunityLineItem> getOpptyProducts(ID opptyId) {
        
        return [SELECT Id,
                       OpportunityId,
                       Opportunity.Name,
                       PricebookEntryId,
                       PricebookEntry.Name,
                       PricebookEntry.Product2.Id,
                       PricebookEntry.Product2.Name,
                       PricebookEntry.Product2.ProductCode,
                       PricebookEntry.Product2.Description,
                       Quantity,
                       TotalPrice,
                       UnitPrice,
                       ListPrice,
                       Description,
                       Apttus_Approval__Approval_Status__c
                FROM OpportunityLineItem
                WHERE OpportunityId = :opptyId];
                
    }
    

}