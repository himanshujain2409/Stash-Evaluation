public with sharing class SignupRequestExt {
	public signuprequest signuprequest;
    public SignupRequestExt(ApexPages.StandardController con) {
    	signuprequest=(signuprequest)con.getRecord();

    }

     public List<SelectOption> getItems() {

     	    List<TSOTemplate__c> templates = new List<TSOTemplate__c>();
     	    templates = [select name, TemplateID__c from TSOTemplate__c where name != 'SFDCSpin'];
            List<SelectOption> options = new List<SelectOption>();
            for (TSOTemplate__c t : templates) {
            options.add(new SelectOption(t.TemplateID__c, t.name));
            }
          
            return options;
        }
}