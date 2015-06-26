/*
* Unit test for ACPInstallScheduleUtils class
* @author Copyright (c) 2013 Apttus.
* @author lferreira@altimetrik.com
*/
@isTest
private class ACPInstallScheduleUtilsTest {
	
	/* 
		test method for sendReportToSuccessStuff
		Only code coverage because the method only sends emails
	*/
	static testmethod void testSendReportToSuccessStuff(){
		
		sfLma__Package__c testPackage  = ACPTestUtils.createPackage('test package');
		insert testPackage;
		
		sfLma__Package_Version__c testVersion = ACPTestUtils.createPackageVersion('test version', testPackage.Id);
		insert testVersion;
		
		Account testAccount = ACPTestUtils.createAccount();
		insert testAccount;
		
		sfLma__License__c testLicense = ACPTestUtils.createLicense(testVersion.Id, testAccount.Id);
		//insert testLicense;
		
		User testUser = ACPTestUtils.getCurrentUser();
		
		ACP_Package_Download__c testDownload = ACPTestUtils.createPackageDownload(testAccount.Id, testVersion.Id, testUser.Id, Date.today());
		insert testDownload;
		
		test.startTest();
		ACPInstallScheduleUtils.sendReportToSuccessStuff();
		test.stopTest();
	}
}