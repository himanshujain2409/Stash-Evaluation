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
@isTest (seeAllData=true)
private class CSForce_SearchControllerTest {

    static testmethod void testConstructor() {
    
        CSForce_TestingUtil tu = new CSForce_testingutil();
        tu.addData('test__1');
    
        CSForce_SearchController sc = new CSForce_SearchController();
        system.assert(sc.productsSelect != null);
        system.assert(sc.competitorsSelect != null);
        system.assert(sc.vertIndustrySelect != null);
    }

    static testmethod void testSearch() {
    
        CSForce_TestingUtil tu = new CSForce_TestingUtil();
        tu.addData('test__2');
        
        CSForce_SearchController sc = new CSForce_SearchController();
        sc.productSelected = 'All';
        sc.competitorSelected = 'All';
        sc.vertIndustrySelected = 'All';
        
        sc.doSearch();
        //system.assert(sc.csHelperList.size() > 0);
        
        sc.tSearch = 'blah';
        sc.doSearch();  
        system.assert(sc.csHelperList != null);
        
        sc.productSelected = 'test';
        sc.competitorSelected = 'test';
        sc.vertIndustrySelected = 'test';
        
        sc.csSearch.Name = 'test';
        sc.csSearch.Account__c = null;
        sc.csSearch.Products__c = 'test';
        sc.csSearch.Win_Against__c = 'Ariba';
        sc.csSearch.Vertical_Industry__c = 'Technology';
        sc.csSearch.Story_Type__c = 'test';
        sc.csSearch.Sales_Reference__c = 'blah';
        sc.csSearch.Sharing_Restriction__c = 'blah';        
        
        sc.tSearch = 'blah';
        sc.doSearch();
        
        sc.tSearch = '';
        sc.doSearch();
    }

}