public with sharing class APTSHelperCaseTrigger {
    //static method
    public static List<Contact> sendEmail(List<Contact> contacts , Case caseobj) {

        //query on template object
        EmailTemplate et=[Select id from EmailTemplate where name=:'Expert Review Notification'];

        //list of emails
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
    System.debug('contactss'+contacts);
        //loop
              //initiallize messaging method
Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage();

List<String> emailtosend =new List<String>();
//System.Debug('Contacts12'+contacts);
for(Contact c : contacts)
{
//System.Debug('Contacts11'+c.email);

    if(c.email!=null)
    emailtosend.add(''+c.email);
}
singleMail.setToAddresses(emailtosend);
//flag to false to stop inserting activity history
singleMail.setSaveAsActivity(false);
String body='<!DOCTYPE html> <html> <body> Hi,</br> </br> Case Status is set to Expert Review, Please take a note for the same. <style type="text/css"> .tftable {font-size:12px;color:#333333;width:100%;border-width: 1px;border-color: #729ea5;border-collapse: collapse;} .tftable th {font-size:12px;background-color:#acc8cc;border-width: 1px;padding: 8px;border-style: solid;border-color: #729ea5;text-align:left;} .tftable tr {background-color:#d4e3e5;} .tftable td {font-size:12px;border-width: 1px;padding: 8px;border-style: solid;border-color: #729ea5;} .tftable tr:hover {background-color:#ffffff;} </style> </br></br> Case Details are as below:</br> </br> <table class="tftable" border="1"> <tr><td>Case Number</td><td>'+caseobj.CaseNumber+'</td></tr> <tr><td>Product</td><td>'+caseobj.Product__c+'</td></tr> <tr><td>Currently Assigned To</td><td>'+caseobj.Currently_Assigned_To_Name__c+'</td></tr> <tr><td>Case Category</td><td>'+caseobj.Case_Category__c+'</td></tr> <tr><td>Subject</td><td>'+caseobj.Subject+'</td></tr> <tr><td>Status</td><td>'+caseobj.Status+'</td></tr> <tr><td>Global Expert</td><td>'+caseobj.Global_Expert__c+'</td></tr> <tr><td>PS Expert</td><td>'+caseobj.PS_Expert__c+'</td></tr> <tr><td>Project Manager</td><td>'+caseobj.Project_Manager__c+'</td></tr> <tr><td>Practice</td><td>'+caseobj.PS_Practice__c+'</td></tr> <tr><td>Priority</td><td>'+caseobj.Priority+'</td></tr> </table> </br> <a href='+URL.getSalesforceBaseUrl().toExternalForm()+'/'+caseobj.Id+'>Link To Case</a> </body> </html> ';
singleMail.setHtmlBody(body);
singleMail.setSubject('Case number : '+caseobj.casenumber+' set to Expert Review');

Messaging.sendEmail(new Messaging.SingleEmailMessage[]{singleMail});
          

        return contacts;
    }
}