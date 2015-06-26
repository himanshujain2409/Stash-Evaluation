@isTest
public class TForceLicenseBatchTest {
    public static testMethod void unitTest(){        
       Test.startTest();
       try 
		{
		/*
		sfLma__Package__c testPackage = ACPTestUtils.createPackage('test package');
		testPackage.Category__c = 'test category';
		testPackage.Show_On_Customer_Portal__c = true;
		insert testPackage;
		
		
		sfLma__Package_Version__c testPackageVersion = ACPTestUtils.createPackageVersion('test package version', testPackage.Id);
		insert testPackageVersion;
		
		
		testPackage.Latest_Package_Version__c = testPackageVersion.Id;
		update testPackage;
		
		Account testAccount = ACPTestUtils.createAccount();
		insert testAccount;
		
		Contact testContact = ACPTestUtils.createContact('test contact', testAccount.Id);
		testContact.Email = 'testContact@example.com';
		insert testContact;
		
		List<UserRole> roleLst = [select id from userrole where name = 'Symantec Customer User'];
		
		User testUser = ACPTestUtils.createUserCustomerPortal(testContact.Id);
		
		insert testUser;
		
		sfLma__License__c testLicense = ACPTestUtils.createLicense(testPackageVersion.Id, testAccount.Id);
		
		
            testLicense.TDO_Name__c = null;
        testLicense.sfLma__Org_Status_Formula__c = 'TRIAL';       
            testLicense.sfLma__Subscriber_Org_ID__c = '00DW0000008wpv2';
		    insert testLicense;
            */
            
               sfLma__License__c sflmaLicence = new sfLma__License__c();
            
            sflmaLicence.sfLma__Subscriber_Org_ID__c = '00DU0000000Y1FY';
            sflmaLicence.sfLma__License_Type__c = 'Editable';
            sflmaLicence.sfLma__Used_Licenses__c = 10;
            sflmaLicence.sfLma__Status__c = 'Active';
            //sflmaLicence.sfLma__Package_Version__c = 'a0SW0000000h5op';
            sflmaLicence.sfLma__Seats__c = 10;
         sflmaLicence.TDO_Name__c = null;
        sflmaLicence.sfLma__Org_Status_Formula__c = 'TRIAL';  
            insert sflmaLicence;  
            
             sfLma__License__c testObj = new sfLma__License__c();
        testObj.TDO_Name__c = null;
        testObj.sfLma__Org_Status_Formula__c = 'TRIAL';       
            testObj.sfLma__Subscriber_Org_ID__c = '00DW0000008wpv2';
        insert testObj;
            
		}
		catch(Exception e){
            system.debug('errors: ' + e.getMessage());
        }  
        
        sfLma__License__c[] lic = [Select Id,TDO_Name__c, sfLma__Subscriber_Org_ID__c FROM sfLma__License__c WHERE TDO_Name__c = NULL and sfLma__Org_Status__c='TRIAL'];
        
        for(sfLma__License__c l : lic)
        {
            system.debug('lic found');
        }           
            
       TForceLicenseBatch c = new TForceLicenseBatch();
       Database.executeBatch(c,200);
       Test.stopTest();
    }
}