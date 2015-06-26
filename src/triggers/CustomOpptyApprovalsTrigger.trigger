/**
 *  Apttus Approvals Management
 *  CustomOpptyApprovalsTrigger
 *   - performs approval required check
 *
 *  2014 Apttus Inc. All rights reserved.
 */
trigger CustomOpptyApprovalsTrigger on Opportunity (before update) {
    
    // preview status pending
    private String PREVIEW_STATUS_PENDING = 'Pending';
    
    // status none
    private String STATUS_NONE = 'None';
    
    // status approved
    private String STATUS_APPROVED = 'Approved';
    
    // status pending approval
    private String STATUS_PENDING_APPROVAL = 'Pending Approval';
    
    // null string
    private String VALUE_NULL = 'null';
    
    // skip checking under following conditions
    //    - trigger size is greater than 1
    //    - current approval status is pending approval
    //        , meaning it is the initial submission action approval status update OR process in progress
    //    - old approval status is pending approval and new approval status is other thatn pending approval
    //        meaning, it is process completion approval status update
    if ((Trigger.new.size() > 1) 
            || (Trigger.new[0].Apttus_Approval__Approval_Status__c == STATUS_PENDING_APPROVAL)
            || ((Trigger.old[0].Apttus_Approval__Approval_Status__c == STATUS_PENDING_APPROVAL) 
                && (Trigger.new[0].Apttus_Approval__Approval_Status__c != Trigger.old[0].Apttus_Approval__Approval_Status__c))){
        return;
    }
    
    if (Trigger.isBefore && Trigger.isUpdate) {
        doCheckIfApprovalRequired(Trigger.new[0]);
        
    }
    
    /**
     * Performs approval required check for header and child objects
     */
    private void doCheckIfApprovalRequired(Opportunity oppty) {
        String doubleUnderscore = '__';
        
        // header param
        String headerIdStatus = null;
        Map<ID, String> headerStatusById = new Map<ID, String>();
        headerStatusById.put(oppty.Id, oppty.Apttus_Approval__Approval_Status__c);
        headerIdStatus = oppty.Id + doubleUnderscore + oppty.Apttus_Approval__Approval_Status__c;
        
        // child objects param
        List<String> childIdStatusList = new List<String>();
        Map<ID, String> childObjectsStatusById = new Map<ID, String>();
        // modified child object ids
        List<ID> modifiedChildObjectIds = new List<ID>();
        
        // get all opportunity products 
        // NOTE - INCLUDE ADDITIONAL 'where' CLAUSE, AS REQUIRED, TO IDENTIFY MODIFIED LINES
        for (OpportunityLineItem lineItem : [select Id, Apttus_Approval__Approval_Status__c from OpportunityLineItem
                                                    where OpportunityId = :oppty.Id
                                                    and Apttus_Approval__Approval_Status__c != :STATUS_APPROVED]) {
                                                        
            childObjectsStatusById.put(lineItem.Id, lineItem.Apttus_Approval__Approval_Status__c);
            childIdStatusList.add(lineItem.Id + doubleUnderscore + lineItem.Apttus_Approval__Approval_Status__c);
            
            modifiedChildObjectIds.add(lineItem.Id);                                            
            
        }
        
        // cache uncommited version of the context object for the rule evaluation routine to use
        Apttus_Approval.ApprovalsWebService.addSObjectToCache(oppty);
        
        // perform the check
        List<String> resultList = Apttus_Approval.ApprovalsWebService.CheckIfApprovalRequired2(headerIdStatus
                                                                , childIdStatusList, modifiedChildObjectIds);
        
        System.debug('resultList >>>>>' + resultList);
        
        // construct map by spliting the string by '__'
        Map<ID, String> resultMap = new Map<ID, String>();   
        for (String resultStr : resultList) {
            List<String> resultSplitList = resultStr.split(doubleUnderscore);
            String statusValue = resultSplitList[1];
            if (statusValue == VALUE_NULL) {
                statusValue = STATUS_NONE;
            }
            resultMap.put(resultSplitList[0], statusValue);
        }
        
        // lines
        List<OpportunityLineItem> childUpdateList = new List<OpportunityLineItem>();
        
        for (ID objId : resultMap.keySet()) {
            if (objId == oppty.Id) {
                if (resultMap.get(objId) != oppty.Apttus_Approval__Approval_Status__c) {
                    oppty.Apttus_Approval__Approval_Status__c = resultMap.get(objId);
                }
                // always reset approval preview status to Pending
                oppty.Approval_Preview_Status__c = PREVIEW_STATUS_PENDING;
            } else {
                
                if (resultMap.get(objId) != childObjectsStatusById.get(objId)) {
                    OpportunityLineItem child = new OpportunityLineItem(Id = objId
                                                        , Apttus_Approval__Approval_Status__c = resultMap.get(objId));
                    childUpdateList.add(child);                                 
                }
            }
        }   
        
        // save changes 
        if (!childUpdateList.isEmpty()) {
            update childUpdateList;
        }                                                   
    }                                           
}