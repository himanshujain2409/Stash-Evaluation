@isTest
public class AfterTaskInsertTest {

    static testmethod void testAfterTaskInsert(){
    
            //Create Account
            
            Account accountObj = new Account();
            accountObj.Name = '3M Company'; 
            accountObj.Type = 'Prospect';
            accountObj.BillingCountry = 'US';
            insert accountObj;
        
            Task t = new Task();
            t.Subject = 'Sent For Review';
            t.WhatId = accountObj.Id;
            t.Status='New';
            t.Priority='Normal';
            
            insert t;

            
        
    }
    
    
}