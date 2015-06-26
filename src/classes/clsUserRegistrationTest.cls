@isTest (seealldata=true)
public with sharing class clsUserRegistrationTest{
    static testMethod void testMethod1() 
    {
        Account account1 = new Account(Name = 'APTS Test Account 1');
        insert account1;

        clsRegisterUser objclsRegisterUser = new clsRegisterUser();
        
        UserRegistration__c objuserregistration = new UserRegistration__c();
        
        objuserregistration.Username__c = 'training@apttus.com';   
        objuserregistration.Email_Address__c = 'training@apttus.com';  
        objuserregistration.First_Name__c = 'First Name';
        objuserregistration.Last_Name__c = 'Last Name';
        objuserregistration.Phone__c = '33432432432';
        objuserregistration.Job_Title__c ='Title';
        objuserregistration.Organization__c = account1.Id;
        objuserregistration.status__c = 'Pending for approval';
     
        objclsRegisterUser.userregistration = objuserregistration;

        //objclsRegisterUser.validateCaptcha();
        
        objclsRegisterUser.verified = true;
        
        objclsRegisterUser.submitUserInfo();
        
        objuserregistration = new UserRegistration__c();
        
        objuserregistration.Username__c = 'n21@apttus.com';   
        objuserregistration.Email_Address__c = 'n21@apttus.com';  
        objuserregistration.First_Name__c = 'FirstName';
        objuserregistration.Last_Name__c = 'LastName';
        objuserregistration.Phone__c = '33432432432';
        objuserregistration.Job_Title__c ='Title';
        objuserregistration.Organization__c = account1.Id;
        objuserregistration.status__c = 'Pending for approval';
        objclsRegisterUser.verified = true;
        
        objclsRegisterUser.userregistration = objuserregistration;
        
        //objclsRegisterUser.validateCaptcha();
        
        objclsRegisterUser.verified = true;
        
        objclsRegisterUser.submitUserInfo();
        
        UserRegistration__c objuserregistration2 = new UserRegistration__c();
        
        objuserregistration2.Username__c = 'n211@apttus.com';   
        objuserregistration2.Email_Address__c = 'n211@apttus.com';  
        objuserregistration2.First_Name__c = 'FirstName';
        objuserregistration2.Last_Name__c = 'LastName';
        objuserregistration2.Phone__c = '334324324332';
        objuserregistration2.Job_Title__c ='Title';
        objuserregistration2.Organization__c = account1.Id;
        objuserregistration2.status__c = 'Pending for approval';
        objclsRegisterUser.verified = true;
        
        objclsRegisterUser.userregistration = objuserregistration2;
        
        objclsRegisterUser.verified = true;
        
        objclsRegisterUser.submitUserInfo();
        
        UserRegistration__c objuserregistration3 = new UserRegistration__c();
        
        objuserregistration3.Username__c = 'n2@apttus.com';   
        objuserregistration3.Email_Address__c = 'n2@apttus.com';  
        objuserregistration3.First_Name__c = 'FirstName';
        objuserregistration3.Last_Name__c = 'LastName';
        objuserregistration3.Phone__c = '334324324332';
        objuserregistration3.Job_Title__c ='Title';
        objuserregistration3.Organization__c = account1.Id;
        objuserregistration3.status__c = 'Pending for approval';
        objclsRegisterUser.verified = true;
        
        objclsRegisterUser.userregistration = objuserregistration3;
        
        objclsRegisterUser.verified = true;
        
        objclsRegisterUser.submitUserInfo();
        
        clsUserCreation objclsUserCreation = new clsUserCreation();
        List<clsUserCreation.cUserReg> objList = new List<clsUserCreation.cUserReg>();

        objList.Add(new clsUserCreation.cUserReg(objuserregistration, false, false));
        objList.Add(new clsUserCreation.cUserReg(objuserregistration2, true, true));
        objList.Add(new clsUserCreation.cUserReg(objuserregistration3, true, true));
                  
        objclsUserCreation.UserRegistrationList = objList;
                
        objclsUserCreation.getItems();
        
        objclsUserCreation.rejectRequest();
        
        objList.clear();
        objList.Add(new clsUserCreation.cUserReg(objuserregistration, false, false));
        objList.Add(new clsUserCreation.cUserReg(objuserregistration2, true, true));
        objList.Add(new clsUserCreation.cUserReg(objuserregistration3, true, true));
        
        objclsUserCreation.UserRegistrationList = objList;
        
        objclsUserCreation.createUser();
        
        objclsUserCreation.deleteRequest();
        
        objclsUserCreation.bindUserRequest();
        
        objclsUserCreation.registationList();
    }
}