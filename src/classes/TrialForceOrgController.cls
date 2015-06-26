public with sharing class TrialForceOrgController {
    //public List<Trialforce_Demo_Orgs__c> trialforceorgs {get;set;}
    public String username;
    public string jstring {get;set;}

    public List<Trialforce_Demo_Orgs__c> trialorgs;
    public TrialForceOrgController() {
         //  Id userid = userinfo.getUserId();

           username = userinfo.getFirstName() + ' ' + userinfo.getLastName();

           trialorgs = new List<Trialforce_Demo_Orgs__c>();
          
    }

    public List<Trialforce_Demo_Orgs__c> gettrialforceorgs() {
           trialorgs = [select id, name, Apttus_Licenses_Expiration_Date__c, Org_Expiration_Date__c, Service_Request__c, 
           Service_Request__r.name, Salesforce_com_Organization_ID__c, Org_Description_Features__c from Trialforce_Demo_Orgs__c
           where Username__c = :username];
            system.debug('trialforceorgs are ' + trialorgs);
           return trialorgs;
         
    }

    public pagereference updateJSONToDB(){
        list<TrialOrg> orgs = new List<TrialOrg>();
        orgs = (List<TrialOrg>)JSON.deserialize(jstring, List<TrialOrg>.class);

        // update the contacts in Database
        list<Trialforce_Demo_Orgs__c> updateOrgs = new list<Trialforce_Demo_Orgs__c>();
        for(TrialOrg o : orgs)
        {
            Trialforce_Demo_Orgs__c thisOrg = new Trialforce_Demo_Orgs__c(Id = o.sf_id);
            thisOrg.Org_Description_Features__c = o.OrgFeature;
            updateOrgs.add(thisOrg);
        }
        update updateOrgs;
        //pagereference newpage = new pagereference('/'+acctid+'&nooveride=1' );
        PageReference newpage = new PageReference(ApexPages.currentPage().getUrl());
        newpage.setredirect(false);
        return newpage;
        // Ostring = JSON.serialize(conts);
        // return null;
    }

    public class TrialOrg{
        public String sf_id;
        public String Name;
        public String ServiceRequest;
        public String ApttusLicenseExp;
        public String OrgExp;
        public String OrgFeature;  
    }
}