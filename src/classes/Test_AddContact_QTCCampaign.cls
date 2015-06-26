/*
    Name : Test_AddContact_QTCCampaign
    Created on : 4/22/2014
    Description : This Test class is created to perform unit test for 'AddContact_QTCCampaign' Trigger.
*/

@isTest 
private class Test_AddContact_QTCCampaign{

    static testMethod void addContacttoQTCCampaign_1() {
    
        Campaign testCampaign = New Campaign(Name = Label.QTC_Campaign_Name);
        insert testCampaign;
        
        Account testAccount = New Account(Name = Label.QTC_Account_Name);
        insert testAccount;
        
        Contact testContact = New Contact();
        testContact.FirstName = 'First Name';
        testContact.LastName = 'Last Name';
        testContact.Email = 'test12321@test.com';
        testContact.AccountId = testAccount.Id;
        insert testContact;
        
        Note testNote = New Note();
        testNote.Title = Label.TestCraft_Note_Title_Text+' "APTTUS" (APTTUS) with a score of 100%.';
        testNote.Body = 'Assessment ID: APTTUS\n'+
                        'Assessment Name: APTTUS\n'+
                        'Attempt: 1\n'+
                        'Date Started: 04/21/2014 12:18:03 PM\n'+
                        'Date Completed: 04/21/2014 12:18:27 PM\n'+
                        'Time Used: 00:00:24\n'+
                        'Score: 100%\n'+
                        'Result: Pass';
        testNote.ParentId = testContact.Id;
        insert testNote;

        List<CampaignMember> lstCampaignMember = [Select Id, LeadId From CampaignMember where CampaignId = :testCampaign.Id ];
        List<Lead> lstLead = [Select Id From Lead where Email = :testContact.Email];
        
        System.assertEquals(1, lstCampaignMember.size());
        System.assertEquals(1, lstLead.size());              
        System.assertEquals(lstLead[0].Id, lstCampaignMember[0].LeadId);
    }
    
    static testMethod void addContacttoQTCCampaign_2() {
    
        Campaign testCampaign = New Campaign(Name = Label.QTC_Campaign_Name);
        insert testCampaign;
        
        Account testAccount = New Account(Name = Label.QTC_Account_Name);
        insert testAccount;
        
        Lead testLead = New Lead();
        testLead.FirstName = 'First Name';
        testLead.LastName = 'Last Name';
        testLead.Email = 'test12321@test.com';
        testLead.Company = testAccount.Name;
        insert testLead;
        
        Contact testContact = New Contact();
        testContact.FirstName = 'First Name';
        testContact.LastName = 'Last Name';
        testContact.Email = 'test12321@test.com';
        testContact.AccountId = testAccount.Id;
        insert testContact;
        
        Note testNote = New Note();
        testNote.Title = Label.TestCraft_Note_Title_Text+' "APTTUS" (APTTUS) with a score of 100%.';
        testNote.Body = 'Assessment ID: APTTUS\n'+
                        'Assessment Name: APTTUS\n'+
                        'Attempt: 1\n'+
                        'Date Started: 04/21/2014 12:18:03 PM\n'+
                        'Date Completed: 04/21/2014 12:18:27 PM\n'+
                        'Time Used: 00:00:24\n'+
                        'Score: 100%\n'+
                        'Result: Pass';
        testNote.ParentId = testContact.Id;
        insert testNote;

        List<CampaignMember> lstCampaignMember = [Select Id From CampaignMember where CampaignId = :testCampaign.Id ];
        
        System.assertEquals(1, lstCampaignMember.size());
        
        Contact testContact1 = New Contact();
        testContact1.FirstName = 'First Name';
        testContact1.LastName = 'Last Name';
        testContact1.Email = 'test12321@test.com';
        testContact1.AccountId = testAccount.Id;
        insert testContact1;
        
        Note testNote1 = New Note();
        testNote1.Title = Label.TestCraft_Note_Title_Text+' "APTTUS" (APTTUS) with a score of 100%.';
        testNote1.Body = 'Assessment ID: APTTUS\n'+
                        'Assessment Name: APTTUS\n'+
                        'Attempt: 1\n'+
                        'Date Started: 04/21/2014 12:18:03 PM\n'+
                        'Date Completed: 04/21/2014 12:18:27 PM\n'+
                        'Time Used: 00:00:24\n'+
                        'Score: 100%\n'+
                        'Result: Pass';
        testNote1.ParentId = testContact1.Id;
        insert testNote1;
        
        List<Lead> lstLead = [Select Id From Lead where Email = :testContact.Email];
        List<Note> lstNotes = [Select Id, ParentId From Note where Id = :testNote1.Id];
				                            	
		System.assertEquals(lstLead[0].Id, lstNotes[0].ParentId);    				                            	
    }
}