public with sharing class ToolBoxController {
        
    
    public string searchText {get;set;}
    public List<Demo_Toolbox__c> searchresults {get;set;}
    

    public ToolBoxController() {
         

     searchresults = new List<Demo_Toolbox__c>();

    }

      public ToolBoxController(ApexPages.StandardSetController controller) {
     
      searchresults = new List<Demo_Toolbox__c>();
    }
  
   

    public PageReference search(){
       searchresults.clear();
       String queryName = '%' + searchText + '%';
     //  string searchQuery = 'FIND \'' +'*' +searchtext+'*\' IN ALL FIELDS RETURNING Demo_Toolbox__c(name, Description__c, Preview__c, Version__c)';
     //  system.debug(searchQuery);
     //  List<List<SObject>> searchList =search.query(searchQuery);
     
      
  

    //  searchresults = [select name, Description__c, Preview__c, Version__c from Demo_Toolbox__c 
                   //     where name like :queryName OR
                     //   Version__c like :queryName ];

      for(Demo_Toolbox__c dt : [select name, Description__c, Preview__c, Version__c, Package_Link__c, Product__c from Demo_Toolbox__c ]) {
      	if((dt.Description__c != null && dt.Description__c.containsIgnoreCase(searchText))  ||(dt.Preview__c != null && dt.Preview__c.containsIgnoreCase(searchText) )  ||
      		(dt.Name != null && dt.Name.containsIgnoreCase(searchText) ) || (dt.Version__c != null && dt.Version__c.containsIgnoreCase(searchText) ) || (dt.Package_Link__c != null && dt.Package_Link__c.containsIgnoreCase(searchText) )
      		|| (dt.Product__c != null && dt.Product__c.containsIgnoreCase(searchText) )) {
      		  searchresults.add(dt);
      	}
     
      
      //	if(dt.Description__c.contains(searchText) || dt.Preview__c.contains(searchText) || dt.name.contains(searchText) || dt.Version__c.contains(searchText) || dt.Package_Link__c.contains(searchText) || dt.Product__c.contains(searchText)) {
          //    searchresults.add(dt);
      	//}
      }                  
     
       return null;
    }
    

      public PageReference  gotonext() {
      	PageReference pg = new PageReference('/a8p/e?nooverride=1');
      	pg.setRedirect(true);
      	return pg;
      }
    
}