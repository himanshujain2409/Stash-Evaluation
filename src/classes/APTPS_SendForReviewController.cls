public with sharing class APTPS_SendForReviewController {

    private string agreementid{get; set;}
    public list<AttachmentWrapper> listOfAttachmentWrapper{get; set;}
    public emailTemplate emailTemplate {get; set;}
    public emailTemplate oldEmailTemplate {get; set;}
    private string isInternal;
    public Apttus__APTS_Agreement__c Agreement{get; set;}
    
    public APTPS_SendForReviewController(ApexPages.StandardController controller) {
        
        agreementid=controller.getRecord().id;
        
         
        
        if(Apexpages.currentPage().getParameters().containsKey('isinternal')) 
        isInternal=Apexpages.currentPage().getParameters().get('isinternal');
        
        list<Attachment> listOfAttachment=[select Name,id,ParentId from Attachment where parentid=:agreementid];
        
        listOfAttachmentWrapper=new  list<AttachmentWrapper>();
                
        for(Attachment Att:listOfAttachment){
           listOfAttachmentWrapper.add(new AttachmentWrapper(false,Att));
        }
        
         
        Agreement=[select id, Apttus__Primary_Contact__c 
                            ,Apttus__Status__c
                            ,Apttus__Status_Category__c
                            From Apttus__APTS_Agreement__c 
                            where id=:agreementid];
                            
        Agreement.Apttus__Status_Category__c='In Authoring';       
                     
        
        if(isInternal.toLowerCase()=='false')
                    Agreement.Apttus__Status__c='Other Party Review';
        else{
                    Agreement.Apttus__Status__c='Author Contract';
                    Agreement.Send_For_Internal_Review_Clicked__c=true;
                    Agreement.Apttus__IsInternalReview__c=true;
        }            
                
        
    }
    
    public pageReference doInit(){
        string templateName='Agreement Review (Internal) A4A';
        
        if(isInternal.toLowerCase()=='false')
            templateName='Agreement Review MSA (external) A4A';
            
        list<emailTemplate> listOfETtoDelete=   [Select ApiVersion, IsActive, CreatedById, CreatedDate, 
                                        Description, Body, Id, Name, Encoding, FolderId, HtmlValue, 
                                        LastModifiedById, LastModifiedDate, LastUsedDate, BrandTemplateId, 
                                        Markup, NamespacePrefix, OwnerId, TemplateStyle, Subject, SystemModstamp, 
                                        TemplateType, DeveloperName, TimesUsed 
                                        from emailTemplate 
                                        where DeveloperName=:(templateName.replace(' ','_').replace('(','').replace(')','')+'_Test')];
                                        
        delete listOfETtoDelete;                               
        
        list<emailTemplate> listOfET=   [Select ApiVersion, IsActive, CreatedById, CreatedDate, 
                                        Description, Body, Id, Name, Encoding, FolderId, HtmlValue, 
                                        LastModifiedById, LastModifiedDate, LastUsedDate, BrandTemplateId, 
                                        Markup, NamespacePrefix, OwnerId, TemplateStyle, Subject, SystemModstamp, 
                                        TemplateType, DeveloperName, TimesUsed 
                                        from emailTemplate 
                                        where name=:templateName];
        
         
        
        if(listOfET!=null && listOfET.size()>0){
                oldEmailTemplate=listOfET[0];
                emailTemplate=oldEmailTemplate.clone(false,true);
                emailTemplate.DeveloperName+=String.valueOf(Math.ROUND(1000 *(Math.random())));
                //emailTemplate.Name=;
                insert emailTemplate;
                
         
         }
         
           
         
        return null;
    
    }
    
    public pageReference generateDocument(){
        
        update Agreement;
        
        if(emailTemplate!=null ){
                
                
                list<id> listOfAttids=new list<id>();
                
                for(AttachmentWrapper AW:listOfAttachmentWrapper){
                    if(AW.isChecked) listOfAttids.add(AW.Attachment.id);
                }
                
                list<Attachment> listOfOldAttachment=[select Id  from Attachment where parentid=:oldEmailTemplate.id];
                
                delete listOfOldAttachment;
                
                list<Attachment> listOfAttachment=[select Id, Body, BodyLength, ContentType, CreatedById, 
                                                        CreatedDate, IsDeleted, Description, Name, 
                                                        LastModifiedById, LastModifiedDate, OwnerId, 
                                                        ParentId, IsPrivate, SystemModstamp 
                                                        from Attachment where id in :listOfAttids];
                
                list<Attachment> listOfNewAttachment= new list<Attachment>();
                
                for(Attachment Att:listOfAttachment){
                    //Attachment NAtt=Att.clone(false,true);
                    
                    Attachment NAtt=new Attachment();
                    NAtt.Body=Att.Body;
                    NAtt.ContentType=Att.ContentType;
                    NAtt.Description=Att.Description;
                    NAtt.Name=Att.Name;
                    NAtt.IsPrivate=Att.IsPrivate; 
                   
                    NAtt.ParentId=oldEmailTemplate.id;
                    listOfNewAttachment.add(NAtt);
                }
                
                insert listOfNewAttachment;
                string sendTo='';
               
                
                system.debug('****'+Agreement.Apttus__Status__c);
                
                
                
                
                if(isInternal=='false'){
                    
                                                            
                    
                    if(Agreement.Apttus__Primary_Contact__c!=null) sendTo='&p2_lkid='+Agreement.Apttus__Primary_Contact__c;
                    
                }
                
                string redirectUrl='';
                
                redirectUrl='/_ui/core/email/author/EmailAuthor?new_template=1'+ sendTo +'&p3_lkid=' + agreementid + '&retURL=%2Fapex%2Fapttus__sendtootherpartypostprocess%3Faction%3DSend_To_Other_Party_For_Review%26id%3D' + agreementid + '%26newTemplateId%3D' + emailTemplate.id + '&template_id=' + oldEmailTemplate.id;
                
                //redirectUrl='/_ui/core/email/author/EmailAuthor?new_template=1'+ sendTo +'&p3_lkid=' + agreementid + '&newTemplateId=' + emailTemplate.id + '&template_id=' + emailTemplate.id + 'retURL=' + agreementid ;
                
                pageReference pr=new pagereference(redirectUrl);
                pr.setRedirect(true);
                return pr;
        
        }
        else{
                return GoBack();
        }
        return null;
        
    }
    
    public pageReference GoBack(){
                if(emailTemplate!=null) delete emailTemplate;
                pageReference pr=new pagereference('/' + agreementid);
                pr.setRedirect(true);
                return pr;
    }
    
    public class AttachmentWrapper{
        
        public boolean isChecked{ get; set;}
        public Attachment Attachment{ get; set;}
        
        public AttachmentWrapper(boolean isChecked,Attachment Attachment){
            this.isChecked=isChecked;
            this.Attachment=Attachment;            
        }
    }

}