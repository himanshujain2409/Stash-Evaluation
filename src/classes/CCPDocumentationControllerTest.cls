@isTest(SeeAllData=true)
public with sharing class CCPDocumentationControllerTest{

 static testMethod void testCCPDocumentationControllerTest(){
 
 List<Folder> folder = [SELECT Id, Name, DeveloperName FROM Folder where Type = 'Document' LIMIT 1];
 
 Document document = new Document();
 document.AuthorId = UserInfo.getUserId();
 document.FolderId = folder[0].Id;
 document.Name = 'Desc';
 document.Description = 'Explanation of folder';
 insert document;
 
 Test.startTest();
 CCPDocumentationController obj = new CCPDocumentationController();
 obj.findDocument();
 obj.clearSearch();
 Test.stopTest();
 
 }


}