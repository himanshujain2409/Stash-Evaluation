public with sharing class APTS_Generate_Template {
       
        public Apttus_Proposal__Proposal__c agmt {get; set;}
        public ID agreementId {get;     set;}
        public String outputFormat {get; set;}
        public List<SelectOption> outputFormats {get; set;}
        public List<TemplateWrapper> templates {get; set;}
        public Boolean hasTemplates {get; set;}
        public String apiSessionId {get;        set;}
        public String apiServerURL {get;        set;}
       
        public APTS_Generate_Template(ApexPages.standardController stdcon){
                agmt = (Apttus_Proposal__Proposal__c)stdcon.getRecord();
                templates = new List<TemplateWrapper>();
                agreementId = ApexPages.currentPage().getParameters().get('id');
                //agmt = [SELECT ID,RecordType.Name FROM Apttus_Proposal__Proposal__c WHERE ID = :agreementId LIMIT 1];
                
                /*String aRecordTypeName = agmt.RecordType.Name;
               
                List<String> commaSD = new List<String>();
                 
               
                List<Apttus__APTS_Template__c> lstTemplate = new List<Apttus__APTS_Template__c>();
               
                if(commaSD.size() > 0){
                        lstTemplate = [SELECT ID,NAME,Apttus__Guidance__c,Apttus__Category__c,Apttus__Subcategory__c,Apttus__IsActive__c
                                                   FROM Apttus__APTS_Template__c
                                                   WHERE Apttus__IsActive__c = TRUE
                                                   AND NAME='Order Form'
                                                   AND Apttus__Type__c = 'Proposal'];
                }
               
                outputFormats = new List<SelectOption>();
                outputFormats.add(new SelectOption('DOC','DOC'));
                outputFormats.add(new SelectOption('PDF','PDF'));
                outputFormats.add(new SelectOption('RTF','RTF'));
                outputFormat = 'DOC';
               
                hasTemplates = (lstTemplate.size() > 0) ? true : false;
               
                if(hasTemplates){
                        for(Apttus__APTS_Template__c tmplt : lstTemplate){
                                templates.add(new TemplateWrapper(tmplt));
                        }
                }*/
        }
       
        public PageReference doReturn(){
                return new PageReference('/'+agmt.ID);
        }
       
        public PageReference doSelect(){
                //return new PageReference('/'+agmt.ID);
                return null;
        }
       
        public PageReference doGenerateDoc(){
               
                /*String templateIDs = '';
                for(TemplateWrapper tmplt : templates){
                        if(tmplt.selected){
                                templateIDs += tmplt.templateSO.id + ',';
                        }                              
                }
                ApexPages.currentPage().setCookies(new Cookie[]{new Cookie('outputFormat','DOC',null,-1,false)});
                ApexPages.currentPage().setCookies(new Cookie[]{new Cookie('sessionID',apiSessionId,null,-1,false)});
                ApexPages.currentPage().setCookies(new Cookie[]{new Cookie('sessionURL',apiServerURL,null,-1,false)});
                ApexPages.currentPage().setCookies(new Cookie[]{new Cookie('template',templateIDs,null,-1,false)}); */
                
                system.debug('****' +agreementId + '****' +apiSessionId+ '****' +apiServerURL );
                string tid='';
                 
                if(!test.isrunningtest())
                    tid=Apttus_Proposal.MergeWebService.generateDoc2('a035000000L56oB',agreementId,'','DOC',true,apiSessionId,apiServerURL );
                return new PageReference('/'+tid);
        }
       
        public PageReference GenerateDoc(){
                return null;
        }
       
        public PageReference doInit(){
                System.debug('apiSessionId: ' + apiSessionId);
         System.debug('apiServerURL: ' + apiServerURL);
                return null;
        }
       
        public PageReference doStartAsyncCall(){
                //return new PageReference('/'+agmt.ID);
                return null;
        }
       
        public class TemplateWrapper{
                public Apttus__APTS_Template__c templateSO {get; set;}
                public Boolean selected {get; set;}
               
                public TemplateWrapper(Apttus__APTS_Template__c templateSO){
                        this.templateSO = templateSO;
                        this.selected = true;
                }
        }       
}