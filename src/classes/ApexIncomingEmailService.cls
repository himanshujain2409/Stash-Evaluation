public class ApexIncomingEmailService implements Messaging.InboundEmailHandler{
 String caseId;
 List <Case> caseLst;
 
public String blankSubjectInEmailTemplateNameStr;
public  String caseNumberMissingInSubjectEmailTemplateNameStr;
public  String emptyEmailBodyEmailTemplateNameStr;
public  String invalidCaseNumberInSubjectEmailTemplateNameStr;
public  String invalidContactForCaseEmailTemplateNameStr;
public String cannotReopenCaseEmailTemplateNameStr;
public  String supportEmailIDStr;
public  String emailServiceNameStr;
public  String emailSenderDisplayNameStr;
public  Boolean avoidInfiniteEmail = false;
public  Decimal numberOfDays;
 public ApexIncomingEmailService()
 
 {
    Case_Custom_Settings__c caseProperties = Case_Custom_Settings__c.getValues('System Properties');
    if( caseProperties != null)
    {
      blankSubjectInEmailTemplateNameStr =  caseProperties.Blank_Subject_in_Email_Template_Name__c;
      caseNumberMissingInSubjectEmailTemplateNameStr = caseProperties.Case_Number_Missing_Email_Template_Name__c;
      emailSenderDisplayNameStr = caseProperties.Email_Sender_Display_Name__c;
      emailServiceNameStr = caseProperties.Email_Service_Name__c;
     emptyEmailBodyEmailTemplateNameStr = caseProperties.Empty_Email_Body_Template_Name__c;
     invalidCaseNumberInSubjectEmailTemplateNameStr = caseProperties.Invalid_Case_Number_Email_Template_Name__c;
     invalidContactForCaseEmailTemplateNameStr = caseProperties.Invalid_Contact_For_Case__c;
     supportEmailIDStr = caseProperties.Support_Email_Address__c ;
     cannotReopenCaseEmailTemplateNameStr=caseProperties.Cannot_Reopen_Closed_Case_Template_Name__c;
     numberOfDays=caseProperties.Number_of_Days__c;
    }
}
 
public Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {

    // will hold the case number that we are going to parse from the email subject
    String apttusCaseNumber;
    
   
    
    avoidInfiniteEmail = isInfiniteEmailLoop(email);
    
    // prepare the result object
    Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
try
{



if(email.subject!= null && email.subject.length() > 0)
{
   apttusCaseNumber =    getCaseNumberFromEmailSubject(email.subject);
    
    if(isValidCaseNumber(apttusCaseNumber))
    {
    
   if(apttusCaseNumber!= null && apttusCaseNumber.length() > 0)
   {
    
    if(canReopenCase())
    {
    if(isValidSender(apttusCaseNumber,email.fromAddress))
    {
    
    if(email.plainTextBody!=null && email.plainTextBody.length() > 0) 
    {
    
    String customersReplyStr = getCustomersReplyFromEMailChain(email.plainTextBody,email.fromName,email.fromAddress);

    String apptusCaseId = insertCaseComment(apttusCaseNumber, customersReplyStr);
   
    Boolean hasBinaryAttachments = insertBinaryAttachment(apptusCaseId,email); 
    
    Boolean hasTextAttachments = insertTextAttachment(apptusCaseId,email); 
    
    insertEmailMessage(apptusCaseId, email);
    

    updateCaseFields(email);
    
     result.success = true;
     
     }
     else
     {

        replyBackWithExceptionDetails(email, emptyEmailBodyEmailTemplateNameStr);
     }
     
     }
     
     else
     {

        replyBackWithExceptionDetails(email, invalidContactForCaseEmailTemplateNameStr);
     }
     
     }
     else
     {
         replyBackWithExceptionDetails(email, cannotReopenCaseEmailTemplateNameStr);
     }
     
}

else
{
     
   
      replyBackWithExceptionDetails(email, caseNumberMissingInSubjectEmailTemplateNameStr);

}


}

else
{
replyBackWithExceptionDetails(email, invalidCaseNumberInSubjectEmailTemplateNameStr);
}
}

else
{
    // TODO: send email to user informing that the subject line was blank.
     replyBackWithExceptionDetails(email, blankSubjectInEmailTemplateNameStr);

}


 }
 
 


 catch (Exception e) {

          
           // TODO : send email to support admin
    }         
      
  result.success = true;
        return result;

       

}


public Boolean canReopenCase()
{
  Date caseReopenDate = System.Today().adddays(- Integer.ValueOf(numberOfDays));
  system.debug('caseReopenDate is ' + caseReopenDate );
       if(caseLst!=null && caseLst.size() > 0 && caseLst[0].ClosedDate!=null )
        {
        system.debug('Case is closed');
            if(caseLst[0].ClosedDate.Date() < caseReopenDate )
             {
             system.debug('cannot reopen case');
              return false;
             }
             else
             {
                          system.debug('can reopen case');
                return true;
             }
        }
    return true;
}



public Boolean isInfiniteEmailLoop(Messaging.InboundEmail email)
{

Boolean isMailSentToSupportEmailID = false;
Boolean isMailSentFromSupportEmailID = false;
if(email.toaddresses!=null && email.toaddresses.size() > 0)
        {
         for(String toaddress: email.toaddresses)
            {
                if(toaddress!=null && toaddress.length() > 0 && toaddress.toLowerCase().contains(supportEmailIDStr))
                    {
                        isMailSentToSupportEmailID = true;
                    }
            }
        }


 /*   if(email.ccaddresses!=null && email.ccaddresses.size() > 0)
        {
         for(String ccaddress: email.ccaddresses)
            {
                if(ccaddress!=null && ccaddress.length() > 0 && ccaddress.toLowerCase().contains(supportEmailIDStr))
                    {
                        isMailSentToSupportEmailID = true;
                    }
            }
        }
        
      */  
    
    if(email.fromAddress!=null && email.fromAddress.length() > 0 && email.fromAddress.toLowerCase().contains(supportEmailIDStr))
        {
         
                        isMailSentFromSupportEmailID = true;
            
        }
        
        if(isMailSentFromSupportEmailID && isMailSentToSupportEmailID )
        {
            return true;
        }
        
        else
        {
            return false;
        }
        
}

public Boolean isValidCaseNumber(String appttusCaseNumberStr) 
{

caseLst  = [select id, Case_Response_Owner__c, Last_Comment_from__c,ClosedDate  from case where casenumber = :appttusCaseNumberStr];

if(caseLst  !=null && caseLst  .size() > 0)

{
return true;
}

else

{
return false;
}

}

public Boolean isValidSender(String appttusCaseNumberStr, String fromAddressStr)
{

List<Schema.FieldSetMember> fieldSetMemberList= SObjectType.Case.FieldSets.External_contacts.getFields();



String externalContactsStr = '';


for(Schema.FieldSetMember fieldSetMemberObj : fieldSetMemberList)
{
externalContactsStr = externalContactsStr  +  fieldSetMemberObj.getFieldPath() + ',';
}


String queryStr = 'select contact.email, ' + externalContactsStr + ' id from case where casenumber=\'' + appttusCaseNumberStr + '\'';


List <Case> caseRecord= Database.query(queryStr) ;

if(caseRecord!=null && caseRecord.size() > 0)
{

String caseEmailsStr = '';

for(Integer  i=0;i<caseRecord.size();i++)
{
caseEmailsStr = caseEmailsStr + ','+caseRecord[i];
}
this.caseId = caseRecord[0].id;
system.debug('fromAddress is ' + fromAddressStr.toLowerCase());
if(fromAddressStr!=null && fromAddressStr.length() > 0 && (fromAddressStr.equalsIgnoreCase(caseRecord[0].Contact.email) || fromAddressStr.toLowerCase().contains(supportEmailIDStr)))
{

return true;
}


Boolean isValidSender = false;
 Matcher matcher = Pattern.compile('[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\\.[a-zA-Z0-9-.]+').matcher(caseEmailsStr );
 while(matcher.find())
 {
     if(fromAddressStr.equalsIgnoreCase(matcher.group()))
     {

     isValidSender = true;
        break;
     }
 }

return isValidSender;

}

else
{
 // this condition is already taken care of in handleInboudMessage()
 return false;
}


}

public void replyBackWithExceptionDetails(Messaging.InboundEmail email, String emailTemplateNameStr) {

if(!avoidInfiniteEmail)
{
 EmailTemplate templateId = [Select Id, Subject, HtmlValue, Body  from EmailTemplate where developername =  :emailTemplateNameStr];
  LIST<EmailServicesAddress>  localPartLst=  [SELECT localpart FROM EmailServicesAddress where functionid in (select id from emailservicesfunction where functionname = :emailServiceNameStr)];
  LIST<EmailServicesAddress>  domainNameLst  = [SELECT emailDomainName FROM EmailServicesAddress where functionid in (select id from emailservicesfunction where functionname = :emailServiceNameStr)];

  String localPartStr = localPartLst.get(0).localpart;
  String domainNameStr = domainNameLst.get(0).emailDomainName;

Messaging.Singleemailmessage cannotReOpenCaseEmail = new Messaging.Singleemailmessage();
Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
mail.setTemplateID(templateId.Id); 
mail.setSaveAsActivity(false);
List<String> newCCAddressesLst = new List<String>();
if(email.CCAddresses!=null && email.CCAddresses.size() > 0)
{
for(String CCAddress: email.CCAddresses)
{

if(CCAddress!=null && CCAddress.length() > 0 && CCAddress.toLowerCase().contains(supportEmailIDStr))
{

system.debug('do not set the cc address in case of email id');
}
else
{
//system.debug('set the cc address');
// mail.setCcAddresses(email.CCAddresses);
newCCAddressesLst.add(CCAddress);

 }
 
 }
 if(newCCAddressesLst!=null && newCCAddressesLst.size() > 0)
 {
 mail.setCcAddresses(newCCAddressesLst);
 cannotReOpenCaseEmail.setCcAddresses(newCCAddressesLst);
 }
 }
 
if(emailTemplateNameStr.equalsIgnoreCase(cannotReopenCaseEmailTemplateNameStr))

{
String caseNumber =  getCaseNumberFromEmailSubject(email.subject);
 String subject = templateId.Subject;
  subject = subject.replace('{!Case.CaseNumber}', caseNumber );
 String plainBody = templateId.Body;
    plainBody = plainBody.replace('{!Case.CaseNumber}', caseNumber );
    
    Contact con = new Contact();
con.FirstName = 'Test';
con.LastName = 'Contact';
//con.Email = 'rbhatt@apttus.com';
con.Email = email.FromAddress;
insert con;
        //build the email message
    

    cannotReOpenCaseEmail.setReplyTo(supportEmailIDStr);
    cannotReOpenCaseEmail.setSenderDisplayName(emailSenderDisplayNameStr);
    cannotReOpenCaseEmail.setTargetObjectId(con.Id);


    cannotReOpenCaseEmail.setSubject(subject);
    cannotReOpenCaseEmail.setPlainTextBody(plainBody);

    Messaging.sendEmail(new Messaging.SingleEmailmessage[] {cannotReOpenCaseEmail});
    
    delete con;
return;
}
 



      mail.setReplyTo(supportEmailIDStr);
      mail.setSaveAsActivity(false);
      mail.setSenderDisplayName(emailSenderDisplayNameStr);
      mail.setUseSignature(true);
      Contact con = new Contact();
con.FirstName = 'Test';
con.LastName = 'Contact';
//con.Email = 'rbhatt@apttus.com';
con.Email = email.FromAddress;
insert con;
      mail.setTargetObjectId(con.Id);
      mail.setWhatId(this.caseId);
 //     String[] toAddress = new String[1];
 //   toAddress[0] = email.FromAddress;
 //   mail.setToAddresses(toAddress);

Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail});

// Don't Forget!  Clean up!
delete con;
}
     
}
public Boolean insertBinaryAttachment(String apptusCaseId, Messaging.InboundEmail email) {
     Attachment attachment;
if (email.binaryAttachments != null && email.binaryAttachments.size() > 0) {
      for (integer i = 0 ; i < email.binaryAttachments.size() ; i++) {
       attachment = new Attachment();
        // attach to case record
        attachment.ParentId = apptusCaseId;
        attachment.Name = email.binaryAttachments[i].filename;
        attachment.Body = email.binaryAttachments[i].body;
        insert attachment;
        
      }
      return true;
    }
   return false;
}

public Boolean insertTextAttachment(String apptusCaseId, Messaging.InboundEmail email) {
 Attachment attachment;
    if (email.textAttachments!= null && email.textAttachments.size() > 0) {
      for (integer i = 0 ; i < email.textAttachments.size() ; i++) {
        attachment = new Attachment();
        // attach to case record
        attachment.ParentId = apptusCaseId;
        attachment.Name = email.textAttachments[i].filename;
        attachment.Body = Blob.valueOf(email.textAttachments[i].body);
        insert attachment;
      }
      return true;
    }
    return false;
}

public void insertEmailMessage(String apttusCaseId, Messaging.InboundEmail email) {
 EmailMessage emailMessage  = new EmailMessage();
 emailMessage.parentId = apttusCaseId;
 emailMessage.fromname=email.fromname;
 emailMessage.fromaddress=email.fromaddress;

if(email.headers!=null && email.headers.size() > 0)
{
for(Messaging.InboundEmail.Header header: email.headers)
{
emailMessage.headers = emailMessage.headers==null ? header.name + '=' + header.value + ',' : emailMessage.headers + header.name + '=' + header.value + ',';
}
}

if(emailMessage.headers!=null && emailMessage.headers.length() > 0)
{
emailMessage.headers = emailMessage.headers.substring(0, emailMessage.headers.lastIndexOf(','));
}

if(email.ccaddresses!=null && email.ccaddresses.size() > 0)
{
for(String ccaddress: email.ccaddresses)
{
emailMessage.ccaddress= emailMessage.ccaddress==null ? ccaddress + ',' : emailMessage.ccaddress+ ccaddress + ',';
}
}
if(emailMessage.ccaddress!=null && emailMessage.ccaddress.length() > 0)
{
emailMessage.ccaddress = emailMessage.ccaddress.substring(0, emailMessage.ccaddress.lastIndexOf(','));
}

if(email.toaddresses!=null && email.toaddresses.size() > 0)
{
for(String toaddress: email.toaddresses)
{
emailMessage.toaddress = emailMessage.toaddress == null ?  toaddress + ',' : emailMessage.toaddress + toaddress + ',';
}
}

if(emailMessage.toaddress!=null && emailMessage.toaddress.length() > 0)
{
emailMessage.toaddress= emailMessage.toaddress.substring(0, emailMessage.toaddress.lastIndexOf(','));
}

 emailMessage.messagedate=system.now();
 emailMessage.TextBody = email.plainTextBody;
 emailMessage.subject=email.subject;
 emailMessage.status='2';
 emailMessage.Incoming = true;

 insert emailMessage;
}
public String insertCaseComment(String apttusCaseNumber, String customersReplyStr) {
 List<Case> apttusCaseList= [select id,Description from case where casenumber=:apttusCaseNumber];
    
    Case apttusCase = apttusCaseList.get(0);

    CaseComment apttusCaseComment = new CaseComment();
    apttusCaseComment.ParentId= apttusCase.Id;
    apttusCaseComment.commentbody = customersReplyStr;
    apttusCaseComment.IsPublished=true;

    insert apttusCaseComment;
    return apttusCase.Id;
}

public String  getCaseNumberFromEmailSubject(String emailSubjectStr)
{

String apttusCaseNumber;

// get the case number from the subject of the email. 
// match the following patterns 
// #<case_number><colon><text>
// #<case_number><comma><text>
// #<case_number><space><text>   
Matcher matcher = Pattern.compile('#(.*?)[,: ]').matcher(emailSubjectStr);

        if (matcher.find()) {
            apttusCaseNumber= matcher.group(1);
            return apttusCaseNumber;
        }

       // match the pattern of 
       // #<case_number><end_of_line>
            matcher = Pattern.compile('#(.*?)$').matcher(emailSubjectStr);

            if (matcher.find()) {
                apttusCaseNumber= matcher.group(1);
            }

    return apttusCaseNumber;


}

public void updateCaseFields(Messaging.InboundEmail email)

{

     if(caseLst!=null && caseLst.size() > 0)
        {

            caseLst[0].Last_Comment_from__c = email.fromaddress;
            //caseLst[0].Case_Response_Owner__c = email.fromname;
            update caseLst;
        }


}


public String getCustomersReplyFromEMailChain(String emailPlainTextBodyStr, String emailFromNameStr, String emailFromAddressStr) 
{
String customersReplyStr  ,customersReplyStr1,customersReplyStr2,customersReplyStr3;

 Matcher matcher = Pattern.compile('On(.*?)wrote:').matcher(emailPlainTextBodyStr);
 if(matcher.find())
 {

 customersReplyStr1=emailPlainTextBodyStr.substring(0,emailPlainTextBodyStr.indexOf(matcher.group(0)));
 }
 if (emailPlainTextBodyStr.contains('-----Original Message-----'))
        { 

        customersReplyStr2= emailPlainTextBodyStr.substring(0, emailPlainTextBodyStr.indexOf('-----Original Message-----'));
        }
      if(emailPlainTextBodyStr.contains('From:'))
    {

        customersReplyStr3= emailPlainTextBodyStr.substring(0, emailPlainTextBodyStr.indexOf('From:'));
     }
     
     
     if(customersReplyStr1!=null)
{

    if(customersReplyStr2!=null)
        {
            
            
            if(customersReplyStr1.length() < customersReplyStr2.length())
                
                {
                    if(customersReplyStr3!=null)
                    {
                
                        if(customersReplyStr1.length() < customersReplyStr3.length())
                            {
                                customersReplyStr = customersReplyStr1;
                                }
                 
                        else
                        {
                        customersReplyStr = customersReplyStr3;
                        }
                    }
                    customersReplyStr = customersReplyStr1;
                }
                
                else
                {
                customersReplyStr = customersReplyStr3;
                }
                    
        }
        
    else
    {
        if(customersReplyStr3!=null)
        
        {
            if(customersReplyStr1.length() < customersReplyStr3.length())
                
                {
                customersReplyStr = customersReplyStr1;
                }
                
                else
                {
                customersReplyStr = customersReplyStr3;
                }
        }
        
        else
        
        {
        customersReplyStr = customersReplyStr1;
        }
    
    }
        
}

else

{

if(customersReplyStr2!=null)
{

        if(customersReplyStr3!=null)
            {
                if(customersReplyStr2.length() < customersReplyStr3.length())
                
                {
                customersReplyStr = customersReplyStr2;
                }
                
                else
                {
                customersReplyStr = customersReplyStr3;
                }
            }
            
        else
        
        {
        customersReplyStr = customersReplyStr2;
        }
}

else

{
customersReplyStr = customersReplyStr3;
}

}
     
    if(customersReplyStr1==null && customersReplyStr2==null && customersReplyStr3==null)
    {

     customersReplyStr = emailPlainTextBodyStr;
     }
     
        customersReplyStr  =  '\n--------------------------------------------------------------- \n' + '\n ' + emailFromNameStr + ' - ' + emailFromAddressStr +  + ' replied:\n\n' + customersReplyStr;
     
     return customersReplyStr;
}

}