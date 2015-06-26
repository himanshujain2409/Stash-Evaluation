public with sharing class CSForce_SearchController {

    public List<CustomerStory__c> CSStories {get; set;}
    public CustomerStory__c csSearch {get; set;}
    public List<CSForce_SearchHelper> csHelperList {get; set;}
    public String tSearch {get; set;}
    public List<SelectOption> productsSelect {get; set;}
    public String productSelected {get; set;}
    public List<SelectOption>  competitorsSelect {get; set;}
    public String competitorSelected {get; set;}
    public List<SelectOption> vertIndustrySelect {get; set;}
    public String vertIndustrySelected {get; set;}
    public String listLink {get; set;}
    
    // setup in constructor. Used if 'All' is selected
    private String allProducts;
    private String allCompetitors;
    private String allVertIndustries;
    
    // search values
    private String storyType;
    private String title;
    private String salesRef;
    private String sharingRes;
    private String product;
    private String competitor;
    private String vertIndustry;
    private ID account;
    
    public CSForce_SearchController() {
        
        setupListLink();
        csSearch = new CustomerStory__c();
        
        setProductsFieldInfo();
        setCompetitorsFieldInfo();
        setVertIndustriesFieldInfo();
    }

    private void setupListlink() {
        
        Schema.Describesobjectresult r = CustomerStory__c.sObjectType.getDescribe();
        String keyPref = r.getKeyPrefix();
        listLink = '/'+keyPref+'/o';
    }
    
    private void setProductsFieldInfo() {
        
        Schema.DescribeFieldResult F = CustomerStory__c.Products__c.getDescribe();
        List<Schema.PicklistEntry> plSchemaList = F.getPicklistValues();
        
        productsSelect = new List<SelectOption>();
        productsSelect.add(new SelectOption('All', 'All'));
        allProducts = '';
        
        for (Schema.Picklistentry ple : plSchemaList) {
            productsSelect.add(new SelectOption(ple.getValue(), ple.getValue()));
            allProducts += ple.getValue()+';';
        }
    }

    private void setCompetitorsFieldInfo() {
        
        Schema.DescribeFieldResult F = CustomerStory__c.Win_Against__c.getDescribe();
        List<Schema.PicklistEntry> plSchemaList = F.getPicklistValues();
        
        competitorsSelect = new List<SelectOption>();
        competitorsSelect.add(new SelectOption('All', 'All'));
        allCompetitors = '';
        
        for (Schema.Picklistentry ple : plSchemaList) {
            competitorsSelect.add(new SelectOption(ple.getValue(), ple.getValue()));
            allCompetitors += ple.getValue()+';';
        }
    }

    private void setVertIndustriesFieldInfo() {
        
        Schema.DescribeFieldResult F = CustomerStory__c.Vertical_Industry__c.getDescribe();
        List<Schema.PicklistEntry> plSchemaList = F.getPicklistValues();
        
        vertIndustrySelect = new List<SelectOption>();
        vertIndustrySelect.add(new SelectOption('All', 'All'));
        allVertIndustries = '';
        
        for (Schema.Picklistentry ple : plSchemaList) {
            vertIndustrySelect.add(new SelectOption(ple.getValue(), ple.getValue()));
            allVertIndustries += ple.getValue()+';';
        }
    }
    
    public void doSearch() {
        
        setupSearchFields();
        
        if (tSearch != null && tSearch.length() > 2) {
            soslSearch();
        } else {
            soqlSearch();
        }
        
        csHelperList = new List<CSForce_SearchHelper>();
        
        if (CSStories != null) {
            for (CustomerStory__c cs : CSStories) {
                csHelperList.add(new CSForce_SearchHelper(cs));
            }
        }
    }
    
    private void soslSearch() {
        
        String searchString;
        searchString = 'Find :tSearch IN ALL Fields ';
        searchString += 'RETURNING CustomerStory__c ';
        searchString += '(Name, Id, Synopsis__c, Story_Type__c, Win_Against__c, ';
        searchString += 'Sales_Reference__c, Sharing_Restriction__c, Products__c, Status__c, ';
        searchString += 'callRef__c, sharingR__c, Vertical_Industry__c, Account__c, Account__r.Name ';
        searchString += ' WHERE '; 
        searchString += ' Story_Type__c Like :storyType ';
        //searchString += ' AND Status__c = \'Available\' ';
     //   searchString += ' AND Sales_Reference__c Like :salesRef ';
     //   searchString += ' AND Sharing_Restriction__c Like :sharingRes ';
        
        if (product != null) {
            searchString += ' AND Products__c INCLUDES (:product)';
        }
        
        if (competitor != null) {
            searchString += ' AND Win_Against__c INCLUDES (:competitor) ';
        }
        
        if (vertIndustry != null) {
            searchString += ' AND Vertical_Industry__c INCLUDES (:vertIndustry) ';
        }
        
        if (account != null) {
            searchString += ' AND Account__c = :account ';
        }

        searchString += ') limit 150';
        
        LIST<LIST<SObject>> soList = search.query(searchString);
        CSStories = soList[0];
       
    }
    
    private void soqlSearch() {
        
        String searchString = 'select Name, Id, Synopsis__c, Story_Type__c, Win_Against__c, ';
        searchString += 'Sales_Reference__c, Sharing_Restriction__c, Products__c, Status__c, ';
        searchString += 'callRef__c, sharingR__c, Vertical_Industry__c, Account__c, Account__r.Name ';
        searchString += 'from CustomerStory__c ';
        searchString += ' WHERE ';
        searchString += ' Story_Type__c Like :storyType ';
        //searchString += ' AND Status__c = \'Available\' ';
       // searchString += ' AND Sales_Reference__c Like :salesRef ';
       // searchString += ' AND Sharing_Restriction__c Like :sharingRes ';
        
        if (product != null) {
            searchString += ' AND Products__c INCLUDES (:product) ';
        }
        
        if (competitor != null) {
            searchString += ' AND Win_Against__c INCLUDES (:competitor) ';
        }
        
        if (vertIndustry != null) {
            searchString += ' AND Vertical_Industry__c INCLUDES (:vertIndustry) ';
        }
        
        if (account != null) {
            searchString += ' AND Account__c = :account ';
        }

        searchString += ' limit 150';
        system.debug(LoggingLevel.INFO,'searchString='+searchString);
        CSStories = Database.query(searchString);
         System.Debug('QUERY@@@@ '+ searchString);
          System.Debug('********* ' + salesRef + sharingRes);
        System.Debug('+++++++ ' + product + competitor + vertIndustry + account);
    }
    
    private void setupSearchFields() {

        if (csSearch.Story_Type__c != null) {
            storyType = csSearch.Story_Type__c;
        } else {
            storyType ='%';
        }
        
        if (csSearch.Name != null) {
            title = '%' + csSearch.Name + '%';
        } else {
            title ='%';
        }
        
        if (csSearch.Sales_Reference__c == null) {
            salesRef = '%';
        } else {
            salesRef = csSearch.Sales_Reference__c;
        }
         
        if (csSearch.Sharing_Restriction__c == null) {
            sharingRes = '%';
        } else {
           sharingRes = csSearch.Sharing_Restriction__c;
        }

        if (productSelected == 'All') {
            product = null;
        } else {
            product = productSelected + ';';
        }
            
        if (competitorSelected == 'All') {
            competitor = null;
        } else {
            competitor = competitorSelected + ';';
        }

        if (vertIndustrySelected == 'All') {
            vertIndustry = null;
        } else {
            vertIndustry = vertIndustrySelected + ';';
        }

        if (csSearch.Account__c != null) {
            account = csSearch.Account__c;
        } else {
            account = null;
        }
    }

}