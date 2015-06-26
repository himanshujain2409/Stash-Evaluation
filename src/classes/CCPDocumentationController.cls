/*
* Controller for ApttusCustomerPortalDocumentation page
* @author Copyright (c) 2012 Apttus.
* @author dberriel@altimetrik.com
*/

public with sharing class CCPDocumentationController {

    public String findDoc {get;set;}
    public  boolean ShowList{get;set;} 
    public String displayTreeview{get;set;}
    public boolean flag{get;set;}
        
    //List of documents
    private List<Document> documents;
    public List<Document> docs{get;set;}    
    //Map of wrapper class.
    //Each wrapper represent a folder with his documents.
    private Map<String, DocumentWrapper> wMapWrapper;

    //Constructor
    public CCPDocumentationController(){
        //Init estructure
        flag = true;
        wMapWrapper = new Map<String, DocumentWrapper>();
        getDocuments();
    }
    
    public List<DocumentWrapper> listWrapperDocuments{
        get
        {
            return wMapWrapper.values();
        }
        private set;
    }
    
    //This method get all documents of org
    private void getDocuments(){
        documents = [SELECT Name, Folder.DeveloperName, 
                        Folder.Name, FolderId, Description, CreatedDate, 
                        CreatedById 
                        FROM Document
                            ORDER BY Folder.Name];
        
        //Create a wrapper class for each folder                
        for(Document d: documents){
            system.debug('======>Folder Names  '+d.folder.Name);
            system.debug(d);
            //If wrapper of folder doesn't exist, this will be created.
            //Otherwise document will be add to the list of folder
            if(!wMapWrapper.containsKey(d.Folder.Name)){
                DocumentWrapper dw = new DocumentWrapper();
                dw.folderName = d.Folder.Name;
                dw.documents.add(d);
                wMapWrapper.put(dw.folderName, dw);
            }
            else{
                DocumentWrapper dw = wMapWrapper.get(d.Folder.Name);
                dw.documents.add(d);
            }
        }
        system.debug(wMapWrapper.values());
    }
    public pagereference findDocument(){
        
        if(findDoc != null && findDoc.length() >= 2){
            ShowList = true;
            displayTreeview = 'none';
            flag = true;
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter a search string at least 2 characters long.'));
            ShowList = false;
            displayTreeview = 'block'; 
            flag = false;          
        }
        docsList();
        return null;
    }
    
    public void ClearSearch(){
        showlist = false;
        displayTreeview = 'block';
        flag = true;
      
    }
    public List<Document> docsList(){
        
        String searchDocQuery = 'SELECT d.Id,d.Name,d.Description,d.Type,d.Folder.Name,d.Author.Name,d.LastModifiedDate FROM Document d  where d.Name like \'%'+findDoc+'%\' ORDER BY d.Folder.Name Limit 20';
          
        return docs=Database.query(searchDocQuery);
                              
    }
    
   
    
    
   
        
    /* Wrapper class for the package information */
    /* Folder information and all his documents */ 
    public class DocumentWrapper{
        
        public String folderName{get; private set;}
        public List<Document> documents{get; private set;}
        
        public DocumentWrapper(){
            folderName = '';
            documents = new List<Document>();
        }
    }

}