/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest (seeAllData=false)
private class beforeServiceRequestInsertUpdateTest{

    static testmethod void testServiceRequest() {
    
        Profile testprofile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User testUser = new User(Alias = 'testus1', Email='testusertest1@test.com', 
                            EmailEncodingKey='UTF-8', LastName='TestLast1',FirstName = 'testFirst1', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', ProfileId = testprofile.Id, 
                            TimeZoneSidKey='America/Los_Angeles', UserName='testusertest1@test.com');
        insert testUser;
        Id recordTypeId = [select id from recordtype where name ='Pre-Sales Sales Engineering' and SobjectType = 'India_Service_Request__c' limit 1].Id;
        
        System.runAs(testUser){
            India_Service_Request__c serviceRequestobj = new India_Service_Request__c();
            serviceRequestobj.Presales_Request_Type__c = 'Standard Demo';
            serviceRequestobj.recordTypeId = recordTypeId;
            serviceRequestobj.Requester__c = testUser.id;
            serviceRequestobj.SE_Assigned_to_Build__c = testUser.id;
            serviceRequestobj.SE_Assigned_To_Request__c = testUser.id;
            serviceRequestobj.Description__c = 'testing description';
            serviceRequestobj.Products__c= 'Author';
            serviceRequestobj.Request_Date__c = Date.today();
            serviceRequestobj.Project_Name__c = 'Test Project';
            
            insert serviceRequestobj;
            serviceRequestobj.ownerid = testUser.id;
            update serviceRequestobj;
        }
    }
}