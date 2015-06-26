public class clsUserCreation
{
    public List<cUserReg> UserRegistrationList{get; set;}
    public String[] status = new String[]{};
    
    public String selectedStatus{get; set;}

    public String errorLevel {get; set;}
    public String messageName {get; set;}
    public List<Id> lstUsers {get; set;}
    public List<User> users  {get; set;}
    
    public String[] getstatus () 
    {
        return status;
    }
            
    public void setstatus(String[] status) 
    {
        this.status = status;
    }
    
    public void showMessage() 
    {
        if(errorLevel == 'WARNING') 
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, messageName));
        }
    }

    public List<SelectOption> getItems() 
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Pending for approval','Pending for approval'));
        options.add(new SelectOption('Approved and User Created','Approved and User Created'));
        options.add(new SelectOption('Rejected','Rejected'));
        return options;
    }

    public clsUserCreation() 
    {
    }
    
    //This method uses a simple SOQL query to return a List of Contacts
    public clsUserCreation(ApexPages.StandardController controller) 
    {
        bindUserRequest();
    }
    
    public void bindUserRequest()
    {
        UserRegistrationList = new List<cUserReg>();
        for(UserRegistration__c userreg: [Select Id, Email_Address__c, First_Name__c, Job_Title__c,
            Last_Name__c, Phone__c, Status__c, Username__c,Organization__c from UserRegistration__c
            ]) 
        {
            if(userreg.Status__c == 'Approved and User Created')
            {
                system.debug('approved for user: ' + userreg.Email_Address__c);
                UserRegistrationList.add(new cUserReg(userreg, true, false));
            }
            else
            {
                system.debug('pending for approval for user: ' + userreg.Email_Address__c + ' current status: ' + userreg.Status__c);
                // As each contact is processed we create a new cContact object and add it to the contactList
                UserRegistrationList.add(new cUserReg(userreg, false, false));
            }
        }
    }
    
    public void deleteRequest()
    {
        Savepoint sp = Database.setSavepoint();
        try        
        {
            List<Id> requestDelete = new List<Id>();
            
            for(cUserReg user: UserRegistrationList)
            {
                if(user.selected == true)
                {
                    requestDelete.Add(user.userReg.Id);
                }
            }
            
            List<UserRegistration__c> deleteRecords = [Select Id from UserRegistration__c where id in : requestDelete];
            
            delete deleteRecords ;
            
            Apexpages.addMessage(new  Apexpages.Message(ApexPages.Severity.Confirm, 'User Registration request(s) deleted successfully.'));
            
            bindUserRequest();
        }
        catch(Exception ex) 
        {
            Apexpages.addMessage(new  Apexpages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
            Database.rollback(sp);
        }
    }
    
    public void rejectRequest()
    {
        Savepoint sp = Database.setSavepoint();
             
        try        
        {
            List<UserRegistration__c> requestUpdate = new List<UserRegistration__c>();
            
            for(cUserReg user: UserRegistrationList)
            {
                if(user.selected == true)
                {
                    user.userReg.status__c = 'Rejected';
                    
                    requestUpdate.Add(user.userReg);
                }
            }
            
            Update requestUpdate;
            
            for(cUserReg user: UserRegistrationList)
            {
                if(user.selected == true)
                {                        
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    
                    mail.setSubject('User Registration Request');
                    mail.setPlainTextBody('Dear ' + user.userReg.First_Name__c + ' ' + user.userReg.Last_Name__c + ',\n\n' +
                    'We are unable to process your request at this time. Please contact training@apttus.com if you have further questions.\n\n'+
                    'Thank You,\n'+
                    'Apttus University');
                    
                    mail.setToAddresses(new List<String>{user.userReg.Email_Address__c});
                    mail.setSaveAsActivity(false);
    
                    Messaging.SendEmailResult[] emailresult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                    system.debug(emailresult);
                    
                    user.selected = false;
                }
            }
            Apexpages.addMessage(new  Apexpages.Message(ApexPages.Severity.Confirm, 'User Registration request(s) rejected.'));
        }
        catch(Exception ex) 
        {
            Apexpages.addMessage(new  Apexpages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
            Database.rollback(sp);
        }
    }
    
    public void registationList()
    {
        if(selectedStatus != '--All--')
        {
            UserRegistrationList.clear();
            for(UserRegistration__c userreg: [Select Id, Email_Address__c, First_Name__c, Job_Title__c,
                Last_Name__c, Phone__c, Status__c, Username__c,Organization__c from UserRegistration__c
                where status__c=:selectedStatus]) 
            {
                if(userreg.Status__c=='Approved and User Created')
                {
                    system.debug('approved for user: ' + userreg.Email_Address__c);
                    UserRegistrationList.add(new cUserReg(userreg, true, false));
                }
                else
                {
                    system.debug('pending for approval for user: ' + userreg.Email_Address__c + ' current status: ' + userreg.Status__c);
                    // As each contact is processed we create a new cContact object and add it to the contactList
                    UserRegistrationList.add(new cUserReg(userreg, false, false));
                }
            }
        }
        else
        {
            UserRegistrationList.clear();
            for(UserRegistration__c userreg: [Select Id, Email_Address__c, First_Name__c, Job_Title__c,
                Last_Name__c, Phone__c, Status__c, Username__c,Organization__c from UserRegistration__c
                ]) 
            {
                if(userreg.Status__c=='Approved and User Created')
                {
                    system.debug('approved for user: ' + userreg.Email_Address__c);
                    UserRegistrationList.add(new cUserReg(userreg, true, false));
                }
                else
                {
                    system.debug('pending for approval for user: ' + userreg.Email_Address__c + ' current status: ' + userreg.Status__c);
                    // As each contact is processed we create a new cContact object and add it to the contactList
                    UserRegistrationList.add(new cUserReg(userreg, false, false));
                }
            }
        }
    }
    
    public void createUser() 
    { 
        try        
        {
            List<User> useRequest = new List<User>();

            List<UserRegistration__c> requestUpdate = new List<UserRegistration__c>();
             
            for(cUserReg user: UserRegistrationList)
            {
                if(user.selected == true)
                {
                    Contact objContact = new Contact(
                        FirstName = user.userReg.First_Name__c,
                        Lastname = user.userReg.Last_Name__c,
                        AccountId = user.userReg.Organization__c,
                        Email = user.userReg.Email_Address__c,
                        Phone = user.userReg.Phone__c,
                        Title = user.userReg.Job_Title__c 
                    );
                    System.debug('Start Contact Insert.'); 
                    
                    Insert objContact; 
    
                    System.debug('End Contact Insert.'); 
                    
                    User objUser = new User();
                    objUser.firstname = user.userReg.First_Name__c;
                    objUser.lastname = user.userReg.Last_Name__c;
                    objUser.username = user.userReg.Username__c;
                    objUser.email = user.userReg.Email_Address__c;
                    objUser.phone = user.userReg.Phone__c;
                    objUser.title = user.userReg.Job_Title__c;
                    
                    if(user.userReg.Last_Name__c.length() > 7)
                    {
                        objUser.alias = user.userReg.First_Name__c.subString(0,1) + user.userReg.Last_Name__c.substring(0,7);
                    }
                    else                    
                    {
                       objUser.alias = user.userReg.First_Name__c.subString(0,1) + user.userReg.Last_Name__c;
                    }
                    
                    system.debug('ProfileInformation: ' + Label.ProfileInformation);
                    
                    Id profileID = [Select id from Profile where name=: Label.ProfileInformation].Id;
    
                    system.debug('profileID : ' + profileID );
                    
                    objUser.ProfileId = profileID;
    
                    objUser.ContactID = objContact.Id;
                    objUser.EmailEncodingKey = 'ISO-8859-1';
                    objUser.TimeZoneSidKey = 'GMT';
                    objUser.CurrencyIsoCode = 'USD';
                    objUser.LocaleSidKey = 'en_US';
                    objUser.LanguageLocaleKey = 'en_US';
                    objUser.UserPermissionsMobileUser = false;
    
                    //String[] semail= user.userReg.Email_Address__c.split('@');
                    
                    objUser.CommunityNickname = user.userReg.Email_Address__c;
                    
                    useRequest.Add(objUser);
                    
                    user.userReg.status__c = 'Approved and User Created';
                    
                    requestUpdate.Add(user.userReg);
                }
            }
            
            Database.DMLOptions dmo = new Database.DMLOptions();

            dmo.optAllOrNone = true;
            dmo.EmailHeader.triggerUserEmail = true;
            dmo.EmailHeader.triggerAutoResponseEmail= true;
            
            System.debug('Start User Insert.'); 
            
            System.debug('useRequest.size(): ' + useRequest.size()); 
            System.debug('dmo: ' + dmo); 
            System.debug('useRequest: ' + useRequest); 
            
            Database.SaveResult[] srList = Database.insert(useRequest, dmo);
            
            System.debug('End User Insert.'); 
            
            lstUsers = new List<Id>();
            users = new List<User>();
            
            for (Database.SaveResult sr : srList) 
            {
                if (!sr.isSuccess()) 
                {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) 
                    {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Account fields that affected this error: ' + err.getFields());
                    }
                }
                else
                {    
                    lstUsers.Add(sr.getId());
                }
           }

            Update requestUpdate;

            for(cUserReg user: UserRegistrationList)
            {
                if(user.selected == true)
                {
                    //Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    
                    //mail.setSubject('Welcome to Apttus University');
                    //mail.setPlainTextBody('Dear ' + user.userReg.First_Name__c + ' ' + user.userReg.Last_Name__c + ',\n\n' +
                    //'Your Apttus Customer Success Portal login and password information is below.\n\n'+
                    //'Thank You,\n'+
                    //'Apttus University');
                    
                    //mail.setToAddresses(new List<String>{user.userReg.Email_Address__c});
                    //mail.setSaveAsActivity(false);
    
                    //Messaging.SendEmailResult[] emailresult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                    //system.debug(emailresult);
                    
                    user.selected = false;
                }
            }
            Apexpages.addMessage(new  Apexpages.Message(ApexPages.Severity.Confirm, 'User(s) created successfully.'));
            users = [SELECT id FROM User where id in : lstUsers ];
        }
        catch(Exception ex) 
        {
            Apexpages.addMessage(new  Apexpages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
        }        
    }
    
    public void createLMSUsers()
    {
        if(users!=null)
        {
            if(users.size() > 0)
            {
                System.debug('users size: ' + users.size()); 
                System.debug('Start User Insert.'); 
                try
                {
                    lmscons.ConsumerUserWebservice.CreateConsumerUsers(users , false);
                    Apexpages.addMessage(new  Apexpages.Message(ApexPages.Severity.Confirm, 'Consumer User(s) created successfully.'));
                }
                catch(Exception ex) 
                {
                    System.debug('Error from CreateConsumerUsers: ' + ex.getMessage()); 
                    Apexpages.addMessage(new  Apexpages.Message(ApexPages.Severity.ERROR, 'Error from CreateConsumerUsers: ' + ex.getMessage()));
                }
                System.debug('End User Insert.');   
            }
            else
            {
                Apexpages.addMessage(new  Apexpages.Message(ApexPages.Severity.ERROR, 'There was some error while creating user. Please check the request details and try again.'));
            }
        }
        else
        {
            Apexpages.addMessage(new  Apexpages.Message(ApexPages.Severity.ERROR, 'There was some error while creating user. Please check the request details and try again.'));
        }
    }
    
     // This is our wrapper/container class. A container class is a class, a data structure, or an abstract data type whose instances are collections of other objects. In this example a wrapper class contains both the standard salesforce object Contact and a Boolean value
    public class cUserReg {
        public UserRegistration__c userReg{get; set;}
        public Boolean selected {get; set;}
        public Boolean disabled {get; set;}
        
        //This is the contructor method. When we create a new cContact object we pass a Contact that is set to the con property. We also set the selected value to false
        public cUserReg (UserRegistration__c user, Boolean isdisabled, Boolean isselected) 
        {
            userReg = user;
            selected = isselected;
            disabled = isdisabled;
        }
    }
}