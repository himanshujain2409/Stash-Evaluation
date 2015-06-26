/*
* Controller for ApttusCustomerPortalDocumentation page
* @author Copyright (c) 2012 Apttus.
* @author dberriel@altimetrik.com
*/

public with sharing class ACPDocumentationController {

	//List of documents
	private List<Document> documents;
	
	//Map of wrapper class.
	//Each wrapper represent a folder with his documents.
	private Map<String, DocumentWrapper> wMapWrapper;
	
	//Constructor
	public ACPDocumentationController(){
		//Init estructure
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