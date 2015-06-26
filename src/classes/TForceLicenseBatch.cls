global class TForceLicenseBatch implements Database.Batchable<sObject> {
    public String query = 'Select Id,TDO_Name__c, sfLma__Subscriber_Org_ID__c FROM sfLma__License__c WHERE TDO_Name__c = NULL and sfLma__Org_Status__c=\'TRIAL\'';
    
    
    global TForceLicenseBatch() {
        this.query = query;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, list<Sobject> scope) {
    	set<string> orgs = new set<string>();
    	map<Id,Id> license2orgmap = new map<Id,Id>();
    	map<Id,Id> license2TDOmap = new map<Id,Id>();
    	List<sfLma__License__c> liclist = new List<sfLma__License__c> ();
         for ( sObject o : scope){
         	sfLma__License__c lic = (sfLma__License__c)o;
            orgs.add(String.valueOf(lic.sfLma__Subscriber_Org_ID__c).substring(0,15));
            license2orgmap.put(lic.id, lic.sfLma__Subscriber_Org_ID__c);    // lic id to sub id
         }

        system.debug('license2orgmap ' + license2orgmap);
        system.debug('orgs 1 ' + orgs);

        map<Id,Id> orgmap = new map<Id,Id>();
        for(Trialforce_Demo_Orgs__c tdo : [select id, Salesforce_com_Organization_ID__c from Trialforce_Demo_Orgs__c where Salesforce_com_Organization_ID__c in :orgs])
        {

        	orgmap.put(tdo.Salesforce_com_Organization_ID__c, tdo.id);      // sub id to org id
        }	
       
        system.debug('orgmap ' + orgmap.size());
       for(Id licid : license2orgmap.keySet() ) {
       	  System.debug('---------' + licid + '  ' + orgmap.get(license2orgmap.get(licid)));
       	  if(orgmap.containsKey(license2orgmap.get(licid))) {
       	  	   license2TDOmap.put(licid,orgmap.get(license2orgmap.get(licid)));
       	  	   System.debug('---------' + licid + '  ' + orgmap.get(license2orgmap.get(licid)));
       	  } 
       }

            
       for(Id i : license2TDOmap.keySet()) {    
       liclist.add(new sfLma__License__c(id=i, TDO_Name__c=license2TDOmap.get(i) ));
       }

       system.debug('liclist ' + liclist);
       if(liclist.size()>0) {
         try {
       	 update liclist;
        } catch(DmlException e) {
         System.debug('The following exception has occurred: ' + e.getMessage());
        }
      }

    }

    global void finish(Database.BatchableContext BC) {
    //	TrialForceBatch batch = new TrialForceBatch();
 	//	Database.executeBatch(batch, 200);
    }
}