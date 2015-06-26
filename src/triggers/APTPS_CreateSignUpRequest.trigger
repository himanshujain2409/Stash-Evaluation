trigger APTPS_CreateSignUpRequest on India_Service_Request__c (after update) {
	List<RecordType> recordTypes = [select Id, Name, isActive, SobjectType From RecordType  where SobjectType =: 'India_Service_Request__c']; 
    Id recordTypeId = null;
    for(RecordType recordType : recordTypes) {
        if(recordType.Name == 'Org Request' && recordType.isActive) {
            recordTypeId = recordType.Id;
        }
    }
    Set<Id> userIds = new Set<Id>();
    for(India_Service_Request__c isr : Trigger.New) {
    	userIds.add(isr.Requester__c);	
    } 
    
    List<User> users = [SELECT firstName , lastName FROM User WHERE id in : userIds];
    Map<Id,String> userFirstMap = new Map<Id,String>();
    Map<Id,String> userLastMap = new Map<Id,String>();
    for(India_Service_Request__c isr : Trigger.New) {
        for(User u : users) {
            if(isr.Requester__c == u.id) {
            	userFirstMap.put(isr.id, u.FirstName);
                userLastMap.put(isr.id, u.lastName);
            }    
        }	
    } 
    
    List<SignupRequest> signupRequestList = new List<SignupRequest>();
    for(India_Service_Request__c isr : Trigger.New) {
        if(isr.recordTypeId == recordTypeId && isr.Org_Request_Submitted__c && Trigger.oldMap.get(isr.Id).Org_Request_Submitted__c != Trigger.newMap.get(isr.Id).Org_Request_Submitted__c) {
            for(Integer i=0; i<isr.Orgs_Requested__c;i++) {
                system.debug('### first name : ' +  userFirstMap.get(isr.id));
                SignupRequest sr = new SignUpRequest();	 
            	sr.Company = isr.Org_Engagement_Name__c;
                sr.Country = 'US';
                sr.SignupEmail = isr.Org_Signup_Email_Calculated__c;
                sr.FirstName = userFirstMap.get(isr.id);
                sr.LastName = userLastMap.get(isr.id);
                //sr.TrialSourceOrgId = isr.Org_Provisioning_Trial_Source_Org_ID__c;
                sr.TemplateId = isr.Org_Provisioning_Template_ID__c;
                if(i > 0) {
                	sr.Username = isr.Org_1_Username__c + i;    
                } else {
                	sr.Username = isr.Org_1_Username__c;   	   
                }
                
                sr.Service_Request__c = isr.id;
                
            	signupRequestList.add(sr);    
            }
        }    
    }
    
    if(signupRequestList.size() > 0) {
    	insert signupRequestList;    
    }
}