@isTest
public class TestRFP_AJAXInterface {
	static testMethod void testRFPForce()
          {     
            test.startTest();
              RFP_AJAXInterface trt=new RFP_AJAXInterface();
            PorterStemmer.testPorterStemmer();
            RFP_AJAXInterface i = new RFP_AJAXInterface();
        
            PageReference pg = Page.RFP_GetResponses; 
            Test.setCurrentPage(pg); 
            ApexPages.currentPage().getParameters().put('question', null);    
            ApexPages.currentPage().getParameters().put('search', 'questions');    
            RFP_AJAXInterface.Response[] r = i.getResponses();
        
            ApexPages.currentPage().getParameters().put('question', 'What are your competitive differentiators?');    
        
            String[] fixedSearchResults = new String[]{'a03E0000001DzCV', 'a03E0000001DzEC' };
            Test.setFixedSearchResults(fixedSearchResults);
            r = i.getResponses();
            
            fixedSearchResults = new String[]{'a03E0000001DzCV', 'a03E0000001DzEC'};
            Test.setFixedSearchResults(fixedSearchResults);
            ApexPages.currentPage().getParameters().put('search', 'responses');    
            r = i.getResponses();   
            
            // Trigger Test: Create a duplicate usage entry
            Question__c u = new Question__c();
            u.Question__c = 'Test Question';
            u.Original_Response__c = false;
            u.Response__c = 'a03E0000001DzIX';
            u.RFP__c = 'a01E0000000CFo8';
            try
            {
              insert u;
            }
            catch (DMLException e)
            {
              System.debug(e.getMessage());
              // expected behavior.
            }
            
            Integer result = RFP_AJAXInterface.getStopWordCount();
              
              //trt.batchDeleteStopWords();
              RFP_AJAXInterface.Response r12 =new RFP_AJAXInterface.Response();
              RFP_AJAXInterface.RFP_Document r21= new RFP_AJAXInterface.RFP_Document();
              trt.deleteStopWords();
             // trt.batchDeleteStopWords();
              String [] str=new String[]{'hgf','34'};
                  String typeName = 'Account';
        
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(typeName);
        sObject obj = targetType.newSObject();
              trt.getResponseText();
            Test.stopTest();
          }
}