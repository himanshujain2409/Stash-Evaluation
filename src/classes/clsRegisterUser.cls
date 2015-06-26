public class clsRegisterUser
{
    public clsRegisterUser()
    {
        
    }
    
    public String errorLevel {get; set;}
    public String messageName {get; set;}
    public String userExists {get;set;}
    public String adminExp {get;set;}
    
    public UserRegistration__c userregistration{ get; set; }
    ApexPages.StandardController controller;
    
    // The API endpoint for the reCAPTCHA service
    public String baseUrl = 'https://www.google.com/recaptcha/api/verify'; 

    // The keys you get by signing up for reCAPTCHA for your domain
    public String privateKey = '6Le2xfMSAAAAAPMEnJ4VW_d65v4HVKnRWkYU5gbA';
    public String publicKey { 
        get { return '6Le2xfMSAAAAAJOHeG9D5Iklu5V5JAQygT8Eryxf'; }
    } 
    
     // Create properties for the non-VF component input fields generated
    // by the reCAPTCHA JavaScript.
    public String challenge { 
        get {
            return ApexPages.currentPage().getParameters().get('recaptcha_challenge_field');
        }
    }
    public String response  { 
        get {
            return ApexPages.currentPage().getParameters().get('recaptcha_response_field');
        }
    }
    
    // Whether the submission has passed reCAPTCHA validation or not
    public Boolean verified { get; set; }
    
    public PageReference reset() {
        return null; 
    }   

    /* Private helper methods */
    
    public static HttpResponse makeRequest(string url, string body)  {
        HttpResponse response = null;
        HttpRequest req = new HttpRequest();   
        req.setEndpoint(url);
        req.setMethod('POST');
        req.setBody (body);
        try {
            Http http = new Http();
            response = http.send(req);
            System.debug('reCAPTCHA response: ' + response);
            System.debug('reCAPTCHA body: ' + response.getBody());
        } catch(System.Exception e) {
            System.debug('ERROR: ' + e);
        }
        return response;
    }   
        
    public String remoteHost { 
        get { 
            String ret = '127.0.0.1';
            // also could use x-original-remote-host 
            Map<String, String> hdrs = ApexPages.currentPage().getHeaders();
            if (hdrs.get('x-original-remote-addr')!= null)
                ret =  hdrs.get('x-original-remote-addr');
            else if (hdrs.get('X-Salesforce-SIP')!= null)
                ret =  hdrs.get('X-Salesforce-SIP');
            return ret;
        }
    }

    public clsRegisterUser(ApexPages.StandardController sc) 
    {
        controller = sc;
        userregistration = (UserRegistration__c)sc.getRecord();   
    }

    public void validateCaptcha()
    {
        System.debug('reCAPTCHA verification attempt');
        // On first page load, form is empty, so no request to make yet
        if ( challenge == null || response == null ) { 
            System.debug('reCAPTCHA verification attempt with empty form');
        }
                    
        HttpResponse r = makeRequest(baseUrl,
            'privatekey=' + privateKey + 
            '&remoteip='  + remoteHost + 
            '&challenge=' + challenge +
            '&response='  + response
        );
        
        system.debug('Captcha Resonse: '+ r.getBody());
        
        if ( r!= null ) {
            this.verified = (r.getBody().startsWithIgnoreCase('true'));
        }
        
        system.debug('verified: ' + this.verified);
        
        if(!this.verified)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please enter valid Captcha.'));
        }
    }
    
    public void submitUserInfo()
    {  
        try
        {            
            if(!Test.isRunningTest())
            {
            	validateCaptcha();
            }
            if(verified == true)
            {
                string username = userregistration.Username__c;
        
                List<User> lstUser = new List<User>();
                
                lstUser = [select Username from User where Username =: username LIMIT 1];
                
                if(lstUser.size() > 0)
                {
                    userExists = lstUser[0].Username;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Username is not available. Please enter different username.'));
                }
                else
                {
                    System.debug('First Name: ' + userregistration.First_Name__c );
                    System.debug('Last Name: ' + userregistration.Last_Name__c);
                    System.debug('Username: ' + userregistration.Username__c);
                    System.debug('Email Address: ' + userregistration.Email_Address__c);
                    System.debug('Phone: ' + userregistration.Phone__c);
                    System.debug('Job Title: ' + userregistration.Job_Title__c);
                    System.debug('Organization: ' + userregistration.Organization__c);
    
                    userregistration.status__c = 'Pending for approval';
                    
                    String AccountName = [Select Name from Account where id=:userregistration.Organization__c limit 1].Name;
                    
                    Database.SaveResult[] results = Database.insert(new SObject[] {
                    userregistration});
                    
                    Id insertedID;
                    for (Integer i = 0; i < results.size(); i++) 
                    {
                        if (results[i].isSuccess()) 
                        {
                            insertedID = results[i].getId();
                        }
                        else
                        {
                            System.debug('Error: could not create sobject for array element ' + i + '.');
                            System.debug('The error reported was: '+ results[i].getErrors()[0].getMessage() + '\n');
                        }
                    }
                    
                    if(insertedID !=null)
                    {
                        Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
    
                        mail.setSubject('User Registration Request');
                        mail.setHtmlBody('Apttus U Administrator,' + '<br/><br/>' +
                        userregistration.First_Name__c + ' ' + userregistration.Last_Name__c +' from ' + AccountName +' has requested an Apttus U online account.<br/><br/>' +
                        'Please click ' + '<a href=' + '"https://apttus.my.salesforce.com/apex/UserRegistrationList"' +'>here</a>' + ' to review and approve/deny the request.');
                        
                        mail.setToAddresses(new List<String>{Label.EmailSentAfterRegistration});
                        mail.setSaveAsActivity(false);
    
                        Messaging.SendEmailResult[] emailresult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    
                        mail=new Messaging.SingleEmailMessage();
    
                        mail.setSubject('User Registration Request');
                        mail.setPlainTextBody('Dear ' + userregistration.First_Name__c + ' ' + userregistration.Last_Name__c + ',\n\n' +
                        'Thank you for submitting your request for Apttus U Online learning. An Apttus University representative will review your request and reply within 24 hours. Please check your junk mail folder and add “apttus.com” to your safe list for email recipients.\n\n'+
                        'Please contact training@apttus.com if there are any concerns.\n\n'+
                        'Sincerely, \n'+ 
                        'Apttus University');
                
                        mail.setToAddresses(new List<String>{userregistration.Email_Address__c});
                        mail.setSaveAsActivity(false);
    
                        emailresult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                        system.debug(emailresult);
                        
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm, 'User Registration request received successfully. You will receive an email with user credentials on request approval.'));
                    }
                }
            }
        }
        catch(Exception ex)
        {
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Exception from: ' + ex.getMessage()));
        }
    }

    public PageReference showMessage() 
    {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, messageName));
        return null;
    }
}