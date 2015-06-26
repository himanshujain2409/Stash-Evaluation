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
@isTest
private class ApttusMbosTest {

    static testMethod void testApttusMbos() {
       
       ID profileID = UserInfo.getProfileId();
       
        User tuser = new User();
        tuser.Username= 'tuser1@apttus.com';
        tuser.Email = 'tuser1@apttus.com';
        tuser.Lastname = 'tuser1';
        tuser.Firstname = 'Apts1';
        tuser.Alias = 'atuse1';
        tuser.CommunityNickname = 'tuser1';
        tuser.ProfileID = profileID;
        tuser.TimeZoneSidKey = 'GMT';
        tuser.LocaleSidKey = 'en_US';
        tuser.EmailEncodingKey = 'ISO-8859-1';
        tuser.LanguageLocaleKey = 'en_US';
        insert tuser;
   
        User tuser1 = new User();
        tuser1.Username= 'tuser2@apttus.com';
        tuser1.Email = 'tuser2@apttus.com';
        tuser1.Lastname = 'tuser2';
        tuser1.Firstname = 'Apts2';
        tuser1.Alias = 'atuse2';
        tuser1.CommunityNickname = 'tuser2';
        tuser1.ProfileID = profileID;
        tuser1.TimeZoneSidKey = 'GMT';
        tuser1.LocaleSidKey = 'en_US';
        tuser1.EmailEncodingKey = 'ISO-8859-1';
        tuser1.LanguageLocaleKey = 'en_US';
        insert tuser1;
        
        MBO__c mbo =  new MBO__c();
        mbo.Employee__c = tuser.Id;
        mbo.Manager__c = tuser.Id;
        mbo.Name = 'TestMbo';
        insert mbo;
         MBO__c mbo1 =  new MBO__c();
        mbo1.Employee__c = tuser.Id;
        mbo1.Manager__c = tuser.Id;
        mbo1.Name = 'TestMbo';
        insert mbo1;
        
        List<MBO__c> setMbos = new List<MBO__c>();
        setMbos.add(mbo);
        setMbos.add(mbo1);
        
         ApexPages.standardSetController ssc = new ApexPages.standardSetController(setMbos);
         ApttusMbos aMbos = new ApttusMbos(ssc);
         PageReference pr = Page.APT_My_MBOs;
        Test.setCurrentPage(pr);
        aMbos.getMyMbos();
        aMbos.getMyTeamMbos();
        aMbos.setSortDirection('name');
        aMbos.setSortDirection('ASC');
        aMbos.getSortDirection();
        aMbos.sortExpression = 'name';
        aMbos.sortExpression = 'MBO_1__c';
        aMbos.sortRequestRecords();
        aMbos.goMbo();
        mbo.Employee__c = tuser1.Id;
        mbo.Manager__c = tuser1.Id;
        update mbo;
    }
}