/*
* Unit test for controller ACPDocumentationController
* @author Copyright (c) 2013 Apttus.
* @author dberriel@altimetrik.com
*/ 
@isTest
private class ACPDocumentationControllerTest {

    static testMethod void myUnitTest() {
        List<Document> listDocs = new List<Document>();
        List<Folder> lstFolder = [Select Id From Folder Where Name = 'Configure, Price, Quote'];
                
        if(lstFolder.size() > 0)
        {
            for (Integer i = 1; i<=5; i++){
                Document d = new Document();
                d.Name = 'my text file '+i;
                String myContent = 'TestContent';
                d.Body = Blob.valueOf(myContent);
                d.ContentType = 'text/plain';
                d.Type = 'txt';
                d.FolderId = lstFolder.get(0).Id;
                listDocs.add(d);
            }
        }       
        
        lstFolder = [Select Id From Folder Where Name = 'Apttus Author' ];
        
        if(lstFolder.size() > 0)
        {
            for (Integer i = 1; i<=6; i++){
                Document d = new Document();
                d.Name = 'my text file '+i;
                String myContent = 'TestContent';
                d.Body = Blob.valueOf(myContent);
                d.ContentType = 'text/plain';
                d.Type = 'txt';
                d.FolderId = lstFolder.get(0).Id;
                listDocs.add(d);
            }
        }       
        
        test.startTest();
        insert listDocs;
        ACPDocumentationController acpDoc = new ACPDocumentationController();
        List<ACPDocumentationController.DocumentWrapper> tstList = acpDoc.listWrapperDocuments;
        try{
            //System.assert(tstList.size()==2);
            //System.assert(tstList.get(0).documents.size()==6);
            //System.assert(tstList.get(1).documents.size()==5);
        }catch(Exception e){
        }
        test.stopTest();
    }
}