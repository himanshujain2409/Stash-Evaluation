trigger UpdateTDOTrigger on Trialforce_Demo_Orgs__c(after insert,after update) {

	/*
    Map<String,String> TDOOganizationIdTDOIdMap = new Map<String,String>();
    List<sfLma__License__c> sfLmaLicenseList = new List<sfLma__License__c>();
    
    for(Trialforce_Demo_Orgs__c TDOObj : Trigger.new){
        if(TDOObj.Salesforce_com_Organization_ID__c !=null && TDOObj.Salesforce_com_Organization_ID__c != ''){
            //TDOOganizationIdSet.add();
            TDOOganizationIdTDOIdMap.put(TDOObj.Salesforce_com_Organization_ID__c,TDOObj.id);
        }
    }
    sfLmaLicenseList = [select id,TDO_Name__c,sfLma__Subscriber_Org_ID__c from sfLma__License__c where sfLma__Subscriber_Org_ID__c In : TDOOganizationIdTDOIdMap.keySet()];
    for(sfLma__License__c sfLmaLicenseObj : sfLmaLicenseList){
        if(sfLmaLicenseObj.sfLma__Subscriber_Org_ID__c !=null && sfLmaLicenseObj.sfLma__Subscriber_Org_ID__c != ''){
            sfLmaLicenseObj.TDO_Name__c = TDOOganizationIdTDOIdMap.get(sfLmaLicenseObj.sfLma__Subscriber_Org_ID__c);
        }
    }
    if(sfLmaLicenseList!=null && sfLmaLicenseList.size()>0){
        try{
            update sfLmaLicenseList; 
        }
        catch(Exception e){
            
        }
    }

   */
}