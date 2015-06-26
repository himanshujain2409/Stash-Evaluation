/*
* Helper class for classes and controllers
* @author Copyright (c) 2012 Apttus.
* @author lferreira@altimetrik.com
*/
public with sharing class ACPUtils {
    
    /* user info */
    
    private static User currentUser = null;
    private static Account dummyAccount = null;
    private static Contact dummyContact = null;
    
    public static User getCurrentUser(){
        
        if(currentUser == null)
            currentUser = [SELECT ContactId, Contact.AccountId, Email, Community_Profile__c, Profile_Name__c, lmscons__Cornerstone_Id__c  FROM User WHERE Id = :UserInfo.getUserId()];
            
        return currentUser;
    }
    
    
    /* email template info */
    
    public static EmailTemplate emailTemplate(String tmplName){
        
        EmailTemplate template = [SELECT Name, Id, DeveloperName FROM EmailTemplate WHERE DeveloperName =:tmplName];
        
        return template;
    }
    
    /*Set a ficticious contact in the org, to do schedule tasks*/
    
    public static Contact getDummyContact(){
        if(Test.isRunningTest()) return getDummyContact('test123@yahoo.com');
        return getDummyContact(Label.ACPSupportEmail);
    }
    
    public static Contact getDummyContact(String contactEmail){
        //Email to set to contact
        String email = contactEmail;
        //Fictitious Account
        dummyAccount = new Account();
        dummyAccount.Name = 'DummyAccount'+Datetime.now().format();
        
        try{
            insert dummyAccount;
            
            //Fictitious Contact
            dummyContact = new Contact();
            dummyContact.LastName = 'DummyContact'+Datetime.now().format();
            dummyContact.AccountId = dummyAccount.Id;
            dummyContact.Email = email;
        
            insert dummyContact;
            system.debug('$$$$$$$$$$$$$dummy account: ' + dummyContact);
        }
        catch(System.DmlException exAcc){
            System.debug(exAcc.getMessage());
        }

        return dummyContact;    
    }
    
    /*Clean dummy data from org*/
    
    public static void deleteDummyObjects(){
        if(dummyAccount != null && dummyContact == null){
            try{
                delete dummyAccount;
            }
            catch(System.DmlException ex){
                System.debug(ex.getMessage());
            }
        }
        if(dummyAccount != null && dummyContact != null){
            try{
                delete dummyContact;
                delete dummyAccount;
            }
            catch(System.DmlException ex){
                System.debug(ex.getMessage());
            }
        }
    }
    
    /*Action to send an email rules*/
    
    public static void sendEmail(Id contactId, String body){
        sendEmail(contactId, body, '');
    }
    
    public static void sendEmail(Id contactId, String body, String subject){
        
        //Creat an email and set data to email
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        mail.setTargetObjectId(contactId);
        mail.setSubject(subject);
        mail.setPlainTextBody(body);
        mail.saveAsActivity = false;
        
        // send the email
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    
    }
    
    /*Action to sort a list according a selected field and order*/
    public static void sortList(List<Sobject> items, String sortField, String order){

       List<Sobject> resultList = new List<Sobject>();
   
       //Create a map that can be used for sorting 
       Map<object, List<Sobject>> objectMap = new Map<object, List<Sobject>>();
       //Particular to sort cases by Contact.Name
       if(sortField=='ContactName'){
            for(Sobject ob : items){
                Case myCase = (Case)ob;
                if(objectMap.get(myCase.Contact.Name) == null){  // For non Sobject use obj.ProperyName
                    objectMap.put(myCase.Contact.Name, new List<Sobject>()); 
                }
                objectMap.get(myCase.Contact.Name).add(ob); 
            }
       }else{
            for(Sobject ob : items){
                //Sort if the key is string. Without case sensitive 
                if(ob.get(sortField) instanceof String ) {
                    String myKey = ((String)ob.get(sortField)).toLowerCase();
                    if(objectMap.get(myKey) == null){  // For non Sobject use obj.ProperyName
                        objectMap.put(myKey, new List<Sobject>()); 
                    }
                    objectMap.get(myKey).add(ob);
                }
                else{
                    if(objectMap.get(ob.get(sortField)) == null){  // For non Sobject use obj.ProperyName
                        objectMap.put(ob.get(sortField), new List<Sobject>()); 
                    }
                    objectMap.get(ob.get(sortField)).add(ob);
                }
            }       
       }
        //Sort the keys
        List<object> keys = new List<object>(objectMap.keySet());
        keys.sort();
       
        for(object key : keys){ 
            resultList.addAll(objectMap.get(key)); 
        }
       
        //Apply the sorted values to the source list
        items.clear();
        if(order.toLowerCase() == 'asc'){
            for(Sobject ob : resultList){
                items.add(ob); 
            }
        }else if(order.toLowerCase() == 'desc'){
            for(integer i = resultList.size()-1; i >= 0; i--){
                items.add(resultList[i]);  
            }
        }
    } 
    
    /*Test method to sorList method. ASC and DESC order*/
    static testmethod void testsortList() {
        
        User u = ACPTestUtils.getCurrentUser();
        List<Case> myList = new List<Case>();
        
        for(Integer i = 1; i <= 5; i++){
            Case aux = ACPTestUtils.createCase(i+'Case');
            aux.AccountId = u.AccountId;
            myList.add(aux);
        }
        
        System.test.startTest();
        ACPUtils.sortList(myList, 'Subject', 'ASC');
        
        System.assertEquals(myList.get(0).Subject,'1Case');
        
        ACPUtils.sortList(myList, 'Subject', 'DESC');
        
        System.assertEquals(myList.get(0).Subject,'5Case');
        
        System.test.stopTest();
    }
    
    /*Only code coverage to ACPUtils class*/
    
    /*Test Current User*/
    static testmethod void testGetCurrentUser(){
        System.test.startTest();
        User u = ACPUtils.getCurrentUser();
        System.test.stopTest();
    }
    
    /*Test Email template
    static testmethod void testEmailTemplate(){
        test.startTest();
        EmailTemplate eT= new EmailTemplate();
        eT.Body = 'Body Area';
        eT.Name = 'Email_Template_Test';
        eT.Subject = 'Test Subject';
        eT.DeveloperName = 'DBTest';
        eT.TemplateType = 'Text';
        eT.FolderId = ;
        insert eT;
        EmailTemplate template = ACPUtils.emailTemplate('Email template test');
        test.stopTest();
    }*/ 
    
    /*Test ficticious contact in the org, to do schedule tasks*/
    static testmethod void testGetDummyContact(){
        System.test.startTest();
        Contact c = ACPUtils.getDummyContact('contact@test.com');
        Contact c1 = ACPUtils.getDummyContact();
        System.test.stopTest();
    }

    /*Test dummy delete data from org*/
    
    static testmethod void testDeleteDummyObjects(){
        System.test.startTest();
        ACPUtils.deleteDummyObjects();
        System.test.stopTest();
    }
    
    /*Test action to send an email rules*/
    
    static testMethod void testSendEmail(){
        System.test.startTest();
        Contact c = new Contact();
        c.LastName = 'Test Contact';
        c.Email = 'test@contact.com';
        insert c;
        sendEmail(c.Id, 'Email body test');
        System.test.stopTest();
    }
    
}