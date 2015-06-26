/*
* Unit test for sflma_package trigger
* @author Copyright (c) 2013 Apttus.
* @author lferreira@altimetrik.com
*/

@isTest
private class ACPSflma_PackageTriggerTest {
	
	
	/* 
		fire the trigger updating the package version
		only code coverage because the trigger has no logic in it
	*/
	
	static testmethod void testUpdatePackageVersion() {
		sfLma__Package__c testPackage  = ACPTestUtils.createPackage('test package');
		insert testPackage;
		
		sfLma__Package_Version__c testVersion = ACPTestUtils.createPackageVersion('test version', testPackage.Id);
		insert testVersion;
		
		test.startTest();
		
		testPackage.Latest_Package_Version__c = testVersion.Id;
		
		update testPackage;
		
		test.stopTest();
	}
}