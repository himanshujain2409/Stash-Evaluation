/*
* Unit test for ACPInstallController class
* @author Copyright (c) 2013 Apttus.
* @author lferreira@altimetrik.com
*/
@isTest//(SeeAllData=true)
private class ACPInstallControllerTest {

	/* test get the categories of the packages */
	static testmethod void testControllerCategories(){
		
		List<Schema.PicklistEntry> catList = sfLma__Package__c.Category__c.getDescribe().getPicklistValues();
		
		System.test.startTest();
		
		/* create an instance of the controller */
		ACPInstallController controller = new ACPInstallController();
		
		/* assert the number of categories */
		System.assertEquals(catList.size(), controller.categoriesToDisplay.size());
		
		System.test.stopTest();
	}
	
	/* test get the selected category */
	static testmethod void testControllerSelectedCategory(){
		
		List<Schema.PicklistEntry> catList = sfLma__Package__c.Category__c.getDescribe().getPicklistValues();
		
		System.test.startTest();
		
		/* create an instance of the controller */
		ACPInstallController controller = new ACPInstallController();
		
		if(catList.size() > 0){
			controller.categorySelected = catList[0].getValue();
		}
		
		/* assert the number of categories */
		System.assertEquals(catList[0].getValue(), controller.categorySelected);
		
		System.test.stopTest();
	}
	
	/* test get the selected category when there is no category selected */
	static testmethod void testControllerSelectedCategoryWhenThereIsNotSelectedCategory(){
		
		List<Schema.PicklistEntry> catList = sfLma__Package__c.Category__c.getDescribe().getPicklistValues();
		
		System.test.startTest();
		
		/* create an instance of the controller */
		ACPInstallController controller = new ACPInstallController();
		
		/* search for the category in the list of categories */
		Boolean theCategoryIsInTheList = false;
		
		for(Schema.PicklistEntry p : catList){
			if(p.getValue() == controller.categorySelected){
				theCategoryIsInTheList = true;
				break;
			}
		}
		
		System.assert(theCategoryIsInTheList);
		
		System.test.stopTest();
	}
	
	/* test get a package the user does not have */
	static testmethod void testGetAPackageAUserDoesNotHave(){
		
		/* create a package */
		sfLma__Package__c testPackage = ACPTestUtils.createPackage('test package');
		testPackage.Category__c = 'test category';
		testPackage.Show_On_Customer_Portal__c = true;
		insert testPackage;
		
		/* create a package version */
		sfLma__Package_Version__c testPackageVersion = ACPTestUtils.createPackageVersion('test package version', testPackage.Id);
		insert testPackageVersion;
		
		/* set the package version as the lastest version */
		testPackage.Latest_Package_Version__c = testPackageVersion.Id;
		update testPackage;
		
		Account testAccount = ACPTestUtils.createAccount();
		insert testAccount;
		
		Contact testContact = ACPTestUtils.createContact('test contact', testAccount.Id);
		testContact.Email = 'testContact@example.com';
		insert testContact;
		
		List<UserRole> roleLst = [select id from userrole where name = 'Symantec Customer User'];
		
		User testUser = ACPTestUtils.createUserCustomerPortal(testContact.Id);
		/*testUser.UserRoleId = roleLst[0].Id;*/
		insert testUser;
		
		System.test.startTest();
		
		system.runAs(testUser){
			/* create an instance of the controller */
			ACPInstallController controller = new ACPInstallController();
			
			/* assert the number of categories */
			System.assertEquals(1, controller.packagesToDisplay.size());
		}
		
		System.test.stopTest();
	}
	
	/* test get a package the user has */
	static testmethod void testGetAPackageAUserHas(){
		
		/* create a package */
		sfLma__Package__c testPackage = ACPTestUtils.createPackage('test package');
		testPackage.Category__c = 'test category';
		testPackage.Show_On_Customer_Portal__c = true;
		
			insert testPackage;
		
		/* create a package version */
		sfLma__Package_Version__c testPackageVersion = ACPTestUtils.createPackageVersion('test package version', testPackage.Id);
		
			insert testPackageVersion;
		
	
		/* set the package version as the lastest version */
		testPackage.Latest_Package_Version__c = testPackageVersion.Id;
		update testPackage;
		Account testAccount = ACPTestUtils.createAccount();
		insert testAccount;
		
		Contact testContact = ACPTestUtils.createContact('test contact', testAccount.Id);
		testContact.Email = 'testContact@example.com';
		insert testContact;
		
		List<UserRole> roleLst = [select id from userrole where name = 'Symantec Customer User'];
		User testUser = ACPTestUtils.createUserCustomerPortal(testContact.Id);
		/*testUser.UserRoleId = roleLst[0].Id;*/
		insert testUser;
		
		sfLma__License__c testLicense = ACPTestUtils.createLicense(testPackageVersion.Id, testAccount.Id);
		try 
		{
		    insert testLicense;
		}
		catch(Exception e){}
		
		
		System.test.startTest();
		
		system.runAs(testUser){
		
			/* create an instance of the controller */
			ACPInstallController controller = new ACPInstallController();
			
			/* assert the number of categories */
			System.assertEquals(1, controller.packagesToDisplay.size());
		
		}
		
		System.test.stopTest();
	}
	
	/* test get an executable */
	static testmethod void testGetAnExecutableFile(){
		
		/* create an executable */
		ACP_Executable_File__c testFile = ACPTestUtils.createExecutableFile();
		insert testFile;
		
		Account testAccount = ACPTestUtils.createAccount();
		insert testAccount;
		
		Contact testContact = ACPTestUtils.createContact('test contact', testAccount.Id);
		testContact.Email = 'testContact@example.com';
		insert testContact;
		
		List<UserRole> roleLst = [select id from userrole where name = 'Symantec Customer User'];
		User testUser = ACPTestUtils.createUserCustomerPortal(testContact.Id);
		/*testUser.UserRoleId = roleLst[0].Id;*/
		insert testUser;
		
		System.test.startTest();
		
		system.runAs(testUser){
		
			/* create an instance of the controller */
			ACPInstallController controller = new ACPInstallController();
			
			/* assert the number of categories */
			System.assertEquals(1, controller.packagesToDisplay.size());
		
		}
		
		System.test.stopTest();
	}
	
	
	/* test the package download traking functionality */
	static testmethod void testPakcageDownloadTraking(){
		
		/* create a package */
		sfLma__Package__c testPackage = ACPTestUtils.createPackage('test package');
		testPackage.Category__c = 'test category';
		testPackage.Show_On_Customer_Portal__c = true;
		insert testPackage;
		
		/* create a package version */
		sfLma__Package_Version__c testPackageVersion = ACPTestUtils.createPackageVersion('test package version', testPackage.Id);
		insert testPackageVersion;
		
		/* set the package version as the lastest version */
		testPackage.Latest_Package_Version__c = testPackageVersion.Id;
		update testPackage;
		
		Account testAccount = ACPTestUtils.createAccount();
		insert testAccount;
		
		Contact testContact = ACPTestUtils.createContact('test contact', testAccount.Id);
		testContact.Email = 'testContact@example.com';
		insert testContact;
		
		List<UserRole> roleLst = [select id from userrole where name = 'Symantec Customer User'];
		
		User testUser = ACPTestUtils.createUserCustomerPortal(testContact.Id);
		/*testUser.UserRoleId = roleLst[0].Id;*/
		insert testUser;
		
		sfLma__License__c testLicense = ACPTestUtils.createLicense(testPackageVersion.Id, testAccount.Id);
		
		try 
		{
		    insert testLicense;
		}
		catch(Exception e){}
		
		
		System.test.startTest();

		system.runAs(testUser){
		
			/* create an instance of the controller */
			ACPInstallController controller = new ACPInstallController();
			
			controller.packageUrl = '/testUrl';
			controller.sandboxOrProdution = 'sandbox';
			controller.packageVersionId = testPackageVersion.Id;
			
			System.assertEquals(new PageReference('/testUrl').getUrl(), controller.download().getUrl());
			System.assertEquals(1, [SELECT id FROM ACP_Package_Download__c].size());
		
		}
		
		System.test.stopTest();
	}
	
	/* test the package ask for traking functionality */
	static testmethod void testPakcageAskForTraking(){
		
		/* create a package */
		sfLma__Package__c testPackage = ACPTestUtils.createPackage('test package');
		testPackage.Category__c = 'test category';
		testPackage.Show_On_Customer_Portal__c = true;
		
			insert testPackage;
		
		
		/* create a package version */
		sfLma__Package_Version__c testPackageVersion = ACPTestUtils.createPackageVersion('test package version', testPackage.Id);
		
			insert testPackageVersion;
		
		
		/* set the package version as the lastest version */
		testPackage.Latest_Package_Version__c = testPackageVersion.Id;
		update testPackage;
		
		Account testAccount = ACPTestUtils.createAccount();
		insert testAccount;
		
		Contact testContact = ACPTestUtils.createContact('test contact', testAccount.Id);
		testContact.Email = 'testContact@example.com';
		insert testContact;
		
		List<UserRole> roleLst = [select id from userrole where name = 'Symantec Customer User'];
		User testUser = ACPTestUtils.createUserCustomerPortal(testContact.Id);
		/*testUser.UserRoleId = roleLst[0].Id;*/
		insert testUser;
		
		sfLma__License__c testLicense = ACPTestUtils.createLicense(testPackageVersion.Id, testAccount.Id);
		
		try 
		{
		    insert testLicense;
		}
		catch(Exception e){}
		
		
		System.test.startTest();

		system.runAs(testUser){
		
			/* create an instance of the controller */
			ACPInstallController controller = new ACPInstallController();
			
			controller.packageUrl = '/testUrl';
			controller.sandboxOrProdution = 'sandbox';
			controller.packageVersionId = testPackageVersion.Id;
			
			controller.askForTrack();
			System.assertEquals(1, [SELECT id FROM ACP_Package_Download__c].size());
			
		}
		
		System.test.stopTest();
	}
	
	
	/* test executable file traking functionality */
	static testmethod void testExecutableFileTraking(){
		
		/* create an executable */
		ACP_Executable_File__c testFile = ACPTestUtils.createExecutableFile();
		insert testFile;
		
		Account testAccount = ACPTestUtils.createAccount();
		insert testAccount;
		
		Contact testContact = ACPTestUtils.createContact('test contact', testAccount.Id);
		testContact.Email = 'testContact@example.com';
		insert testContact;
		
		List<UserRole> roleLst = [select id from userrole where name = 'Symantec Customer User'];
		
		User testUser = ACPTestUtils.createUserCustomerPortal(testContact.Id);
		/*testUser.UserRoleId = roleLst[0].Id;*/
		insert testUser;
		
		System.test.startTest();
		
		system.runAs(testUser){
		
			/* create an instance of the controller */
			ACPInstallController controller = new ACPInstallController();
			
			controller.packageUrl = '/testUrl';
			
			controller.packageVersionId = testFile.Id;
			
			System.assertEquals(new PageReference('/testUrl').getUrl(), controller.downloadExe().getUrl());
			System.assertEquals(1, [SELECT id FROM ACP_Package_Download__c].size());
		
		}
		
		System.test.stopTest();
	}
}