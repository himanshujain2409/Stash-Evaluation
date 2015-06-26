global class TrialForceBatch implements Database.Batchable<sObject>, Schedulable {
    public String query = 'select id, Apttus_Licenses_Expiration_Date__c, Salesforce_com_Organization_ID__c, (Select sfLma__Expiration__c, sfLma__Subscriber_Org_ID__c FROM Licenses__r where sfLma__License_Status__c = \'Active\') from Trialforce_Demo_Orgs__c';
    
    global TrialForceBatch() {
        this.query = query;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);      
    }
    
    global void execute(Database.BatchableContext BC, list<Sobject> scope) {

    	List<Trialforce_Demo_Orgs__c> lstUpdateOrg = new List<Trialforce_Demo_Orgs__c>();
    	Date expire = Date.valueOf('2100-01-01');
    	
    	for ( sObject o : scope){

    		Trialforce_Demo_Orgs__c org = (Trialforce_Demo_Orgs__c)o;

    		for (sfLma__License__c lic : org.Licenses__r){
    			if (lic.sfLma__Expiration__c < expire){
    				expire = lic.sfLma__Expiration__c;
    			}

    		}

        // if Expiration date is not equal, then update
        if (!expire.isSameDay(org.Apttus_Licenses_Expiration_Date__c)){
          org.Apttus_Licenses_Expiration_Date__c = expire;
          lstUpdateOrg.add(org);         
        }
    	}

    	if (lstUpdateOrg.size() > 0){
    		update lstUpdateOrg;
    	}

    }

    global void execute(SchedulableContext SC) {
        TrialForceBatch batch = new TrialForceBatch();
        Database.executeBatch(batch, 1);
    }

    global void finish(Database.BatchableContext BC) {

  AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
      TotalJobItems, CreatedBy.Email
      FROM AsyncApexJob WHERE Id =
      :BC.getJobId()];
   // Send an email to the Apex job's submitter notifying of job completion.
   Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
   String[] toAddresses = new String[] {a.CreatedBy.Email};
   mail.setToAddresses(toAddresses);
   mail.setSubject('Apex Sharing Recalculation ' + a.Status);
   mail.setPlainTextBody
   ('The batch Apex job processed ' + a.TotalJobItems +
   ' batches with '+ a.NumberOfErrors + ' failures.');
   Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

    }
}