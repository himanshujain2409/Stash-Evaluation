/*
* Helper class for the install management functionality
* @author Copyright (c) 2012 Apttus.
* @author lferreira@altimetrik.com
*/
public with sharing class ACPInstallHelper {
    
    /* Create a email with with suggested training and documentation.*/
    
    public static void emailWithSuggestedTrainingAndDocumentation(User aUser, Id packageVersionId){
        
        List<sfLma__Package_Version__c> packageVersion = [
                            SELECT  sfLma__Package__c,
                                    sfLma__Package__r.Name,
                                    sfLma__Version__c,
                                    sfLma__Package__r.Customer_Portal_Information__c,
                                    Name,
                                    Customer_Portal_Information__c,
                                    sfLma__Package__r.Suggested_Training_and_Information__c
                            FROM    sfLma__Package_Version__c
                            WHERE   Id = :packageVersionId ];
        
        if(packageVersion.size() > 0){
            
            /* create the email */
            Messaging.SingleEmailMessage mail = createEmailForPackage(packageVersion[0]);
            mail.setCcAddresses(new List<String>{aUser.Email});
            /* send the email */
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
    
    
    /* Create a email with with suggested training and documentation for the exe files.*/
    
    public static void emailWithSuggestedTrainingAndDocumentationExe(User aUser, Id exeFileId){
        
        
        List<ACP_Executable_File__c> exeFile = [
            SELECT  Name,
                    Customer_Portal_Category__c,
                    Customer_Portal_File_Url__c,
                    Customer_Portal_Information__c,
                    Customer_Portal_Release_Date__c,
                    Customer_Portal_Version__c,
                    Suggested_Training_and_Information__c
            FROM    ACP_Executable_File__c
            WHERE   Id = :exeFileId
        ];
        
        if(exeFile.size() > 0){
            
            /* create the email */
            Messaging.SingleEmailMessage mail = createEmailForExe(exeFile[0]);
            mail.setCcAddresses(new List<String>{aUser.Email});

            /* send the email */
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
    
    /* Helper method to create an email with suggested training and documentation for package */
    private static Messaging.SingleEmailMessage createEmailForPackage(sfLma__Package_Version__c packageVersion){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setUseSignature(false);
            mail.setSaveAsActivity(false);
            mail.setSubject(Label.ACPInstallSuggestedTrainingMailHeader + ' ' + packageVersion.Name);
            String body = Label.ACPInstallSuggestedTrainingMailBody;
            body += (packageVersion.sfLma__Package__r.Suggested_Training_and_Information__c != null && packageVersion.sfLma__Package__r.Suggested_Training_and_Information__c != '') ? packageVersion.sfLma__Package__r.Suggested_Training_and_Information__c : '';
            mail.setPlainTextBody(body);
            mail.setHtmlBody(body);
            return mail;
    }
    
    /* Helper method to create an email with suggested training and documentation for exe files */
    private static Messaging.SingleEmailMessage createEmailForExe(ACP_Executable_File__c exeFile){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setUseSignature(false);
            mail.setSaveAsActivity(false);
            mail.setSubject(Label.ACPInstallSuggestedTrainingMailHeader + ' ' + exeFile.Name);
            String body = Label.ACPInstallSuggestedTrainingMailBody;
            body += (exeFile.Suggested_Training_and_Information__c != null && exeFile.Suggested_Training_and_Information__c != '') ? exeFile.Suggested_Training_and_Information__c : '';
            mail.setPlainTextBody(body);
            mail.setHtmlBody(body);
            return mail;
    }
    
    
    /* notify there is a new package version */

    public static void notifyNewPackageVersion(Map<Id, sflma__Package__c> newPackagesMap, Map<Id, sflma__Package__c> oldPackagesMap){
        
        List<sflma__Package__c> packages = new List<sflma__Package__c>();
        
        for(sflma__Package__c p : newPackagesMap.values()){
            if(p.Latest_Package_Version__c != oldPackagesMap.get(p.Id).Latest_Package_Version__c){
                packages.add(p);
            }
        }
        
        
        List<sflma__license__c> licenses = [SELECT sfLma__Account__c, sflma__package_version__r.sflma__package__c FROM sflma__license__c WHERE sflma__package_version__r.sflma__package__c = :packages AND sfLma__Account__c != null];
        
        
        /* package id, List<account id> */
        
        Map<Id, List<Id>> packageAccountsMap = new Map<Id, List<Id>>();
        
        /* account ids*/
        Set<Id> accountIds = new Set<Id>();
        
        /* fill the map */
        for(sflma__license__c l : licenses){
            
            accountIds.add(l.sfLma__Account__c);
            
            if(!packageAccountsMap.containsKey(l.sflma__package_version__r.sflma__package__c)){
                /* if the package is not in the map create a new list of accounts and add it to the map */
                packageAccountsMap.put(l.sflma__package_version__r.sflma__package__c, new List<Id>{l.sfLma__Account__c});
            } else {
                /* the package is already on the map so add the account to the list*/
                packageAccountsMap.get(l.sflma__package_version__r.sflma__package__c).add(l.sflma__Account__c);
            }
        }
        
        Map<Id, User> users = new Map<Id, User>([SELECT Id, Contact.AccountId, Email FROM User WHERE Contact.AccountId != null AND Contact.AccountId =:accountIds]);
        
        /* map<AccountId, List<User id>> */
        
        Map<Id, List<Id>> userMap = new Map<Id, List<Id>>();
        
        
        /* fill the map */
        
        for(User u : users.values()){
            if(!userMap.containsKey(u.Contact.AccountId)){
                /* if the the account is not in the map add it */
                userMap.put(u.Contact.AccountId, new List<Id>{u.id});
            } else {
                /* if the account is in the map add the contact to the list */
                userMap.get(u.Contact.AccountId).add(u.id);
            }
        }
        
        
        /* send an email for every package */
        
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        //EmailTemplate e = ACPUtils.emailTemplate('Apttus_Customer_Portal_Package_Updated');
        
        for(sflma__package__c p : packages){
            
            /* account with the current package */
            List<Id> packageAccounts = new List<Id>();
            
            if(packageAccountsMap.get(p.Id) != null) {
                packageAccounts.addAll(packageAccountsMap.get(p.Id));
            }
            
            /* contact to send the email */
            List<Id> emailUsers = new List<Id>();
            
            for(Id accountId : packageAccounts){
                if(userMap.containsKey(accountId)){
                    emailUsers.addAll(userMap.get(accountId));
                }
            }
            
            for(Id i : emailUsers){
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.saveAsActivity = false;
                email.setToAddresses( new List<String>{users.get(i).Email});
                email.setWhatId(p.Id);
                email.setUseSignature(false);
                email.setSaveAsActivity(false);
                email.setSubject(Label.ACPInstallNewVersionMailHeader + ' ' + p.Name);
                String body = Label.ACPInstallNewVersionMailBody;
                String plainTextBody = body + '\n ' + URL.getSalesforceBaseUrl().toExternalForm() + '/apex/ApttusCustomerPortalInstall';
                email.setPlainTextBody(plainTextBody);
                emails.add(email);
            }
        }
        
        Messaging.sendEmail(emails);
    }
}