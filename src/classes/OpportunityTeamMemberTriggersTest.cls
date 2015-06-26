@isTest
public class OpportunityTeamMemberTriggersTest 
{
	public static testMethod void test() 
	{
		
		User u1;
		User u2;
		User u3;
		Account acc1;
		Opportunity opp1;
		Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1];
        UserRole r = [SELECT Id From UserRole WHERE PortalType='None' LIMIT 1];
        
        u1 = new User(Alias = 'test', Email='testuser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId = r.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='testUserComans2@testorg.com');
        insert u1;
        u2 = new User(Alias = 'test', Email='testuser2@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId = r.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='testUserComans3@testorg.com');
        insert u2;
        u3 = new User(Alias = 'test', Email='testuser3@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId = r.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='testUserComans4@testorg.com');
        insert u3;
        System.runAs(u1)
        {
        	acc1 = new Account(Name='ABC Corp',CSM__c=u1.Id);
			insert acc1;
			opp1 = new Opportunity(Name='Test Opp1',AccountId=acc1.Id,StageName='Launch', CloseDate=System.today().addDays(90), Transition_Date__c=System.today().addDays(60));
			insert opp1;
			acc1.CSM__c=u2.Id;
			update acc1;
			opp1.PS_pre_sales_assigned__c=u3.Id;
			update opp1;
        }
	}
}