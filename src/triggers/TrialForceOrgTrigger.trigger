trigger TrialForceOrgTrigger on signuprequest(after insert, after update) {
 
   if(trigger.isinsert) {
    List<Trialforce_Demo_Orgs__c>  trials = new List<Trialforce_Demo_Orgs__c>();
    for(signuprequest s : trigger.NEW) {
        system.debug('within insert');
        if(s.Status!='Error') {
          system.debug('status not error');
           Trialforce_Demo_Orgs__c tfdo = new Trialforce_Demo_Orgs__c();
           tfdo.Name = s.Company;
           tfdo.Username__c = s.Username;
           tfdo.Country__c = s.Country;
           tfdo.Source_Org__c = s.Source_MDO__c;
          // tfdo.Salesforce_com_Organization_ID__c = s.CreatedOrgId;
           tfdo.Org_Status__c = 'Active';
           tfdo.Primary_Email__c = s.SignupEmail;
           tfdo.Org_Expiration_Date__c = system.today() + 182;
           tfdo.Apttus_Licenses_Expiration_Date__c = system.today() + 30;
           tfdo.Demo_Industry__c = s.industry__c;
           tfdo.Service_Request__c = s.Service_Request__c;
           tfdo.Demo_Description__c = s.description__c;
           tfdo.Org_Provisioned_Date__c = system.today();
           tfdo.Signup_Request__c = s.id;
           trials.add(tfdo);
        }
    }

     if(trials.size()>0) {
      system.debug('before insert trial force org');
       insert trials;
     }
    
    }

    if(trigger.isUpdate) {
      system.debug('within update');
      Map<Id,Id>  SignupOrgMap = new Map<Id,Id>();
      for(signuprequest s : trigger.NEW) {
        if( s.status == 'Success' ) {
            system.debug('CreatedOrgId generated');
            SignupOrgMap.put(s.id, s.CreatedOrgId);
        }
      }
     
      List<Trialforce_Demo_Orgs__c>  trialsupdate = new List<Trialforce_Demo_Orgs__c>();

      trialsupdate = [select Salesforce_com_Organization_ID__c, Signup_Request__c from Trialforce_Demo_Orgs__c where Signup_Request__c in :SignupOrgMap.keySet()];
      
      system.debug('Trialsupdate is ' + trialsupdate);

      for(Trialforce_Demo_Orgs__c td : trialsupdate) {
        td.Salesforce_com_Organization_ID__c = String.valueOf(SignupOrgMap.get(td.Signup_Request__c)).substring(0,15);
      }

      if(trialsupdate.size()>0)
         update trialsupdate;

    }
  
}