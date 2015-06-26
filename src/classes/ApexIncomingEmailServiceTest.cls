/*
* Unit test for controller ApexIncomingEmailService
* @author Copyright (c) 2014 Apttus.
* @author rbhatt@apttus.com
*/ 
@isTest
public class ApexIncomingEmailServiceTest{
    


    static testMethod void testHandleInboundEmail(){
        
        /* Create an instance of the controller */
        
        ApexIncomingEmailService controller = new ApexIncomingEmailService();
        controller.blankSubjectInEmailTemplateNameStr =  'ACP_Blank_Subject_in_Email';
      controller.caseNumberMissingInSubjectEmailTemplateNameStr = 'ACP_Case_Number_Missing_in_Subject';
      controller.emailSenderDisplayNameStr = 'Apttus Customer Support';
      controller.emailServiceNameStr = 'ApttusSupport_EmailService';
     controller.emptyEmailBodyEmailTemplateNameStr = 'ACP_Empty_Email_Body';
     controller.invalidCaseNumberInSubjectEmailTemplateNameStr = 'ACP_Invalid_Case_Number_in_Email_Subject';
     controller.invalidContactForCaseEmailTemplateNameStr = 'ACP_Invalid_Contact_For_Case';
     controller.supportEmailIDStr = 'support@apttus.com' ;
        
        Case testCase = new Case();
        testCase.subject = 'ApexIncomingEmailTestClass';
        Account testAccount = new Account();
        testAccount.name = 'Test Account';
        insert testAccount;
        testCase.account = [select id from account where name like '%Test%' limit 1];
        testCase.status = 'New';
        Contact testContact = new Contact();
        //testContact.name = 'Test User';
        testContact.email = 'rbhatt@apttus.com';
        testContact.account = [select id from account where name like '%Test%' limit 1];
        testContact.firstName = 'Rajiv';
        testContact.lastName='Bhatt';
        insert testContact;
        testCase.contact = [select id from contact where email like '%bhatt%' limit 1];
        testCase.description= 'testDesc';
        testCase.External_Contact_Email_1__c = 'rbhatt@apttus.com';
        insert testCase;
        system.debug('case is created');
        List<Case> caseNumberLst = [select caseNumber from case where subject='ApexIncomingEmailTestClass' limit 1];
        system.debug('caseNumber is ' + caseNumberLst[0].caseNumber);
        
      Messaging.InboundEmail email = new Messaging.InboundEmail();
   Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
   Messaging.InboundEmail.BinaryAttachment inAtt = new Messaging.InboundEmail.BinaryAttachment();
   Messaging.InboundEmail.TextAttachment textAtt = new Messaging.InboundEmail.TextAttachment();

   email.subject = 'email subject for case number #'+caseNumberLst[0].caseNumber;
   email.fromAddress='rbhatt@apttus.com';
   String[] toAddressArr = new String[1];
   toAddressArr[0] = 'rbhatt@apttus.com';
   String[] ccAddressesArr = new String[1];
   ccAddressesArr[0] = 'rbhatt@apttus.com';
   email.toAddresses = toAddressArr;
   email.ccAddresses = ccAddressesArr;

   email.plainTextBody = 'Hello world FROM: test user  -----Original Message----- On thursday user wrote: test';
   env.fromAddress = 'rbhatt@apttus.com';

   // set the body of the attachment
   inAtt.body = blob.valueOf('test');
   inAtt.fileName = 'my attachment name';
   inAtt.mimeTypeSubType = 'plain/txt';
   
   textAtt.body = 'test';
   textAtt.fileName = 'my attachment name';
   textAtt.mimeTypeSubType = 'plain/txt';


     email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] {inAtt }; 
     email.textAttachments =  new Messaging.inboundEmail.TextAttachment[] {textAtt}; 
        
        Test.startTest();
                

            
        // regular email 
        controller.handleInboundEmail(email,env);
		controller.isValidSender(testcase.CaseNumber,'sdvsd@sd.com');
    	controller.insertBinaryAttachment(testcase.Id,email);
        controller.insertTextAttachment(testcase.Id,email);
        controller.insertEmailMessage(testcase.Id,email);
        controller.insertCaseComment(testcase.CaseNumber,'email');
        controller.updateCaseFields(email);
        controller.getCaseNumberFromEmailSubject(''+testcase.CaseNumber);
         email.plainTextBody='';
         controller.handleInboundEmail(email,env);

         email.plainTextBody='Hello world FROM: test user  -----Original Message----- On thursday user wrote: test';

        // email with blank subject
        email.subject='';
        controller.handleInboundEmail(email,env);
        
        // email with no case number in email subject
        email.subject='subject with no case number';
        controller.handleInboundEmail(email,env);
        
        // email with invalid case number in email subject
        email.subject='subject #28972348902';
        controller.handleInboundEmail(email,env);        

        // email from invalid contact
        email.subject='email subject for case number #'+caseNumberLst[0].caseNumber;
        email.fromAddress='user@acme.com';
        controller.handleInboundEmail(email,env);  
     
         
       //break from infinite loop
        email.subject='email subject for case number #'+caseNumberLst[0].caseNumber;
        email.fromAddress='support@apttus.com';
        toAddressArr[0] = 'support@apttus.com';
         ccAddressesArr[0] = 'support@apttus.com';
        
         email.ccAddresses = ccAddressesArr;
         email.toAddresses = toAddressArr;
        controller.handleInboundEmail(email,env);  
              
        
        Test.stopTest();
        
    }

    
   
    
   
    
}