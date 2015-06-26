/*
* Controller for ApttusCustomerPortalCaseViews page
* @author Copyright (c) 2012 Apttus.
* @author dberriel@altimetrik.com
*/

public with sharing class ACPCaseViewsController {

    

    //List of cases
    List<Case>  myCasesList;
    public List<Case>  CasesToExportList{get;set;}
    //List of possible views
    private List<Selectoption> listViews;
    public String Soql{get;set;}
    //Limit to case's query
    private Integer caseLimit = 200;
    //View selected
    public String myView {get;set;}
    public List<List_View_Fields__c> listView{get;set;}
    
    //Search Term Entered by User
    public String SearchTerm {get; set;}

    public Boolean filter = false;//True if there is a selected view.
    private User currentUser = ACPUtils.getCurrentUser();
    //StandardSetController for pagination
    public ApexPages.StandardSetController pageCon{get; set;}  
    public List<String> recordTypes = getRecordTypes();
        
    public List<Case> getMyCasesList(){
         return (List<Case>)pageCon.getRecords();//All current user's cases.
    }
    //Attribute to sort list
    private String order1 = 'DESC';
    private String fSort = 'CreatedDate';

    /*Controller's constructor*/
    public ACPCaseViewsController()  
    {  
        listView = new List<List_View_Fields__c>();
        
        userCases();
       
        
    }  
    
    public List<String> getRecordTypes() {
    
    List<String> names = new List<String>();
    List<RecordTypeInfo> infos = Case.SObjectType.getDescribe().getRecordTypeInfos();
    // If there are 2 or more RecordTypes...
    if (infos.size() > 1) {
        for (RecordTypeInfo i : infos) {
           if (i.isAvailable() 
           // Ignore the Master Record Type, whose Id always ends with 'AAA'.
           // We check the Id because Name can change depending on the user's language.
            && !String.valueOf(i.getRecordTypeId()).endsWith('AAA'))
                names.add(i.getName());
        }
    } 
    // Otherwise there's just the Master record type,
    // so add it in, since it MUST always be available
    else names.add(infos[0].getName());

 System.debug('Available recordTypes ' + names);
 return names;
    }
    
    //Property to sort table
    public String FieldSort
    {
        get
        {
            return fSort;
        }
        set
        {
            //if the column is clicked on then switch between Ascending and Descending modes
            if (value == fSort)
                order1 = (order1 == 'ASC')? 'DESC' : 'ASC';
            else
                order1 = 'ASC';
            fSort = value;
        }
    }

    public String getOrder1()
    {
       //if not column is selected 
       if (fieldSort == null || fieldSort == '')
         return 'ASC';
       else
        return order1;
    }
    
    public void setOrder1(String value)
    {  
      order1 = value;
    }

/***Paging controller section***/
    
     //Boolean to check if there are more records after the present displaying records  
    public Boolean hasNext  
    {  
        get  
        {  
            return pageCon.getHasNext();  
        }  
        set;  
    }  
   
    //Boolean to check if there are more records before the present displaying records  
    public Boolean hasPrevious  
    {  
        get  
        {  
            return pageCon.getHasPrevious();  
        }  
        set;  
    }  
   
    //Page number of the current displaying records  
    public Integer pageNumber  
    {  
        get  
        {  
            return pageCon.getPageNumber();  
        }  
        set;  
    }  
  
    //Returns the first page of records  
    public void first()  
    {  
        pageCon.first();  
    } 
    
      //Returns the last page of records  
    public void last()  
    {  
        pageCon.last();  
    } 
  
    //Returns the previous page of records  
    public void previous()  
    {  
        pageCon.previous();  
    }  
   
    //Returns the next page of records  
    public void next()  
    {  
        pageCon.next();  
    }  
/***End Paging controller section***/
    
    //Return the list of view options
    public List<Selectoption> getListViews(){
        listViews = new List<selectOption>(); 
        listViews.add(new selectOption('MyCases', Label.ACPCaseFilterMyCases)); 
        listViews.add(new Selectoption('OpenCases',Label.ACPCaseFilterOpenCases));
        listViews.add(new Selectoption('ClosedCases',Label.ACPCaseFilterCloseCases));
        listViews.add(new Selectoption('MyCompanyCases',Label.ACPCaseFilterCompanyAllCases));
        listViews.add(new Selectoption('MyCompanyOpenCases',Label.ACPCaseFilterAllCases));
        listViews.add(new Selectoption('MyCompanyClosedCases',Label.ACPCaseFilterCompanyClosedCases));
        return listViews;
    }

    //Returns the current user's cases
    public void userCases(){
        
        Soql = 'Select ';
        listView = [Select id, Display_Name__c, Field_API_Name__c, Sequence_Number__c,Already_in_Query__c from List_View_Fields__c order by Sequence_Number__c ASC];
        if(listView.size() > 0){
            for(List_View_Fields__c k: listView){
                if(k.Already_in_Query__c == false) 
                Soql = Soql + k.Field_API_Name__c + ',';
                
                }
            
        }
 
         Soql = Soql + 'id,IsClosed,CreatedDate,CreatedById FROM Case WHERE recordTypeId in ( SELECT id FROM RecordType where name in :recordTypes ) and ContactId = ' + '\'' +currentUser.ContactId + '\''+  'ORDER BY ' + FieldSort +  ' ' + order1 + ' LIMIT ' + caseLimit;

        
        
        myCasesList = Database.query(Soql);
        /*String query1 = 'SELECT ';
        for(Schema.FieldSetMember f : this.getFields()) {
            query1 += f.getFieldPath() + ', ';
        }
        query1 += 'Id  FROM Case';
        
        myCasesList = Database.query(query1);
        
        /*myCasesList = [SELECT Subject, Status, Priority, IsClosed, 
                        Id, CreatedDate, CreatedById, Contact.Name, 
                        ContactId, ClosedDate, CaseNumber, AccountId, 
                        Open__c 
                        FROM Case WHERE ContactId = :currentUser.ContactId
                        ORDER BY CreatedDate DESC
                        LIMIT :caseLimit];*/
        CasesToExportList = myCasesList;
        //Initialize the pagination controller
        pageCon = new ApexPages.StandardSetController(myCasesList);  
        //Set the number of records per page  
        pageCon.setPageSize(10);  
        
    }
    
    //return the fields present in fieldset
    public List<Schema.FieldSetMember> getFields() {
        return SObjectType.Case.FieldSets.List_view.getFields();
    }
    
    
    
    //Return all user account's cases
    public void getMyCompanyOpenCases(){
        //Identification of the current user's account
        Id accountId = currentUser.Contact.AccountId;
        
        Soql = 'Select ';
        listView = [Select id, Display_Name__c, Field_API_Name__c, Sequence_Number__c,Already_in_Query__c from List_View_Fields__c order by Sequence_Number__c ASC];
        if(listView.size() > 0){
            for(List_View_Fields__c k: listView){
                if(k.Already_in_Query__c == false) 
                Soql = Soql + k.Field_API_Name__c + ',';
                
                }
            
        }

        Soql = Soql + 'id,IsClosed,CreatedDate,CreatedById FROM Case WHERE IsClosed=false and recordTypeId in ( SELECT id FROM RecordType where name in :recordTypes ) and AccountId = ' + '\'' +accountId + '\''+  'ORDER BY ' + FieldSort +  ' ' + order1 + ' LIMIT ' + caseLimit;
        
        myCasesList = Database.query(Soql);
        
        /*List<Case> myCasesList = [SELECT Subject, Status, Priority, IsClosed, 
                        Id, CreatedDate, CreatedById, Contact.Name, 
                        ContactId, ClosedDate, CaseNumber, AccountId, 
                        Open__c   
                        FROM Case  WHERE AccountId = :accountId 
                        ORDER BY CreatedDate DESC
                        LIMIT :caseLimit];*/
                        
        CasesToExportList = myCasesList;                
        //Initialize the pagination controller
        pageCon = new ApexPages.StandardSetController(myCasesList);  
        //Set the number of records per page  
        pageCon.setPageSize(10);  
        
    }
    
    
    //Return all user account's cases
    public void getMyCompanyClosedCases(){
        //Identification of the current user's account
        Id accountId = currentUser.Contact.AccountId;
        
        Soql = 'Select ';
        listView = [Select id, Display_Name__c, Field_API_Name__c, Sequence_Number__c,Already_in_Query__c from List_View_Fields__c order by Sequence_Number__c ASC];
        if(listView.size() > 0){
            for(List_View_Fields__c k: listView){
                if(k.Already_in_Query__c == false) 
                Soql = Soql + k.Field_API_Name__c + ',';
                
                }
            
        }
        
      
        Soql = Soql + 'id,IsClosed,CreatedDate,CreatedById FROM Case WHERE IsClosed=true and recordTypeId in ( SELECT id FROM RecordType where name in :recordTypes ) and AccountId = ' + '\'' +accountId + '\''+  'ORDER BY ' + FieldSort +  ' ' + order1 + ' LIMIT ' + caseLimit;
                       
        
        myCasesList = Database.query(Soql);
        
        /*List<Case> myCasesList = [SELECT Subject, Status, Priority, IsClosed, 
                        Id, CreatedDate, CreatedById, Contact.Name, 
                        ContactId, ClosedDate, CaseNumber, AccountId, 
                        Open__c   
                        FROM Case  WHERE AccountId = :accountId 
                        ORDER BY CreatedDate DESC
                        LIMIT :caseLimit];*/
                        
        CasesToExportList = myCasesList;                
        //Initialize the pagination controller
        pageCon = new ApexPages.StandardSetController(myCasesList);  
        //Set the number of records per page  
        pageCon.setPageSize(10);  
        
    }
    
    
    //Return all user account's cases
    public void getMyCompanyCases(){
        //Identification of the current user's account
        Id accountId = currentUser.Contact.AccountId;
        
        Soql = 'Select ';
        listView = [Select id, Display_Name__c, Field_API_Name__c, Sequence_Number__c,Already_in_Query__c from List_View_Fields__c order by Sequence_Number__c ASC];
        if(listView.size() > 0){
            for(List_View_Fields__c k: listView){
                if(k.Already_in_Query__c == false) 
                Soql = Soql + k.Field_API_Name__c + ',';
                
                }
            
        }
        
      
        Soql = Soql + 'id,IsClosed,CreatedDate,CreatedById FROM Case WHERE recordTypeId in ( SELECT id FROM RecordType where name in :recordTypes ) and AccountId = ' + '\'' +accountId + '\''+  'ORDER BY ' + FieldSort +  ' ' + order1 + ' LIMIT ' + caseLimit;
                       
        
        myCasesList = Database.query(Soql);
        
        /*List<Case> myCasesList = [SELECT Subject, Status, Priority, IsClosed, 
                        Id, CreatedDate, CreatedById, Contact.Name, 
                        ContactId, ClosedDate, CaseNumber, AccountId, 
                        Open__c   
                        FROM Case  WHERE AccountId = :accountId 
                        ORDER BY CreatedDate DESC
                        LIMIT :caseLimit];*/
                        
        CasesToExportList = myCasesList;                
        //Initialize the pagination controller
        pageCon = new ApexPages.StandardSetController(myCasesList);  
        //Set the number of records per page  
        pageCon.setPageSize(10);  
        
    }
    
    
    //Returns the current user's open cases
    public void userOpenCases(){
    Id accountId = currentUser.Contact.AccountId;
        //Result list of open cases
        Soql = 'Select ';
        listView = [Select id, Display_Name__c, Field_API_Name__c, Sequence_Number__c,Already_in_Query__c from List_View_Fields__c order by Sequence_Number__c ASC];
        if(listView.size() > 0){
            for(List_View_Fields__c k: listView){
                if(k.Already_in_Query__c == false) 
                Soql = Soql + k.Field_API_Name__c + ',';
                
                }
            
        }

  
           Soql = Soql + 'id,IsClosed,CreatedDate,CreatedById FROM Case WHERE recordTypeId in ( SELECT id FROM RecordType where name in :recordTypes ) and IsClosed = false and ContactId = ' + '\'' +currentUser.ContactId + '\'' + ' and AccountId = ' + '\'' +accountId + '\'' +  'ORDER BY ' + FieldSort +  ' ' + order1 + ' LIMIT ' + caseLimit;   

        
        myCasesList = Database.query(Soql);
        
        /*List<Case> resultList = new List<Case>();
        for(Case c: myCasesList){
            if (!c.IsClosed){
                resultList.add(c);
            }
        }*/
        
        CasesToExportList = myCasesList;
        //New instance of Standard Set Controller
        pageCon = new ApexPages.StandardSetController(myCasesList);  
        //Set the number of records per page  
        pageCon.setPageSize(10); 
        
    }
    
    //Returns the current user's closed cases
    public void userClosedCases(){
    Id accountId = currentUser.Contact.AccountId;
        //Result list of closed cases
        Soql = 'Select ';
        listView = [Select id, Display_Name__c, Field_API_Name__c, Sequence_Number__c,Already_in_Query__c from List_View_Fields__c order by Sequence_Number__c ASC];
        if(listView.size() > 0){
            for(List_View_Fields__c k: listView){
                if(k.Already_in_Query__c == false) 
                Soql = Soql + k.Field_API_Name__c + ',';
                
                }
            
        }
        
       
        Soql = Soql + 'id,IsClosed,CreatedDate,CreatedById FROM Case WHERE recordTypeId in ( SELECT id FROM RecordType where name in :recordTypes ) and IsClosed = true and AccountId = ' + '\'' +accountId + '\''+  'ORDER BY ' + FieldSort +  ' ' + order1 + ' LIMIT ' + caseLimit;        
        
        myCasesList = Database.query(Soql);
        
        /*List<Case> resultList = new List<Case>();
        for(Case c: myCasesList){
            if (c.IsClosed){
                resultList.add(c);
            }
        }*/
        
        CasesToExportList = myCasesList;
        //New instance of Standard Set Controller
        pageCon = new ApexPages.StandardSetController(myCasesList);  
        //Set the number of records per page  
        pageCon.setPageSize(10); 
         
    }
    
    //Update cases according to selected view 
    public Pagereference selectedCasesView(){
        if(myView == 'MyCompanyOpenCases'){
            getMyCompanyOpenCases();
        }
        else if(myView == 'MyCompanyClosedCases'){
            getMyCompanyClosedCases();
        }
        else if(myView == 'MyCompanyCases')
        {
         getMyCompanyCases();
        }
        else
            if(myView == 'MyCases'){
                userCases();
            }
            else
                if(myView == 'OpenCases'){
                    userOpenCases();
                }
                else
                {
                    userClosedCases();
                }
        return null;
    }
    /*Use to sort de case's list, according column selected*/
    /*public void sortCases(){
        Integer tope = 0;
        List<Case> resultList = new List<Case>();
        //Reset pageCon
        pageCon.first();
        //Add all cases into the sort list
        while(tope < pageCon.getResultSize())
        {
            for (Sobject obj: pageCon.getRecords()){
                resultList.add((Case)obj);
            }
            pageCon.next();
            tope += pageCon.getPageSize();
        }
        //Sort cases
        ACPUtils.sortList(resultList, fieldSort, order1);    
        //New instance of Standard Set Controller
        pageCon = new ApexPages.StandardSetController(resultList);  
        //Set the number of records per page  
        pageCon.setPageSize(10);
        //Clear result list
        resultList.clear();
    }*/
    
     public Pagereference sortCases(){
        
        
        if(myView == 'MyCompanyOpenCases'){
            getMyCompanyOpenCases();
        }
        else  if(myView == 'MyCompanyClosedCases'){
            getMyCompanyClosedCases();
        }
        else if(myView=='MyCompanyCases')
        {
            getMyCompanyCases();
        }
        else
            if(myView == 'MyCases'){
                userCases();
            }
            else
                if(myView == 'OpenCases'){
                    userOpenCases();
                }
                else
                {
                    userClosedCases();
                }
                
        return null;
    }
    
    //Call to create a new case
    public Pagereference newCase(){
        return new PageReference('/setup/ui/recordtypeselect.jsp?ent=Case&retURL=%2Fapex%2FApttusCustomerPortalCaseViews&save_new_url=%2F500%2Fe%3FretURL%3D%252Fapex%2FApttusCustomerPortalCaseViews');
        
    }
    
     public Pagereference exportToExcel(){
         return new PageReference('/apex/ExportApttusCasesToExcel');
         
    }
    
    public PageReference SearchCases() {
        Soql = 'Select ';
        listView = [Select id, Display_Name__c, Field_API_Name__c, Sequence_Number__c,Already_in_Query__c from List_View_Fields__c order by Sequence_Number__c ASC];
        if(listView.size() > 0){
            for(List_View_Fields__c k: listView){
                if(k.Already_in_Query__c == false) 
                Soql = Soql + k.Field_API_Name__c + ',';
                }
        }
        string SearchTermWildCards = '';
        if(SearchTerm != '') {
            SearchTermWildCards = SearchTerm.Replace('?','_').replace('*','%');
            Soql = Soql + 'id,IsClosed,CreatedDate,CreatedById FROM Case WHERE recordTypeId in ( SELECT id FROM RecordType where name in :recordTypes ) and  CaseNumber Like \'' + SearchTermWildCards + '\' ORDER BY ' + FieldSort +  ' ' + order1 + ' LIMIT ' + caseLimit;
        }
        else {
            Soql = Soql + 'id,IsClosed,CreatedDate,CreatedById FROM Case WHERE recordTypeId in ( SELECT id FROM RecordType where name in :recordTypes ) ORDER BY ' + FieldSort +  ' ' + order1 + ' LIMIT ' + caseLimit;
        }   
        System.Debug('$$recordTypes' + recordTypes); 
        System.Debug('$$Soql' + Soql); 
        myCasesList = Database.query(Soql);
        CasesToExportList = myCasesList;                
        pageCon = new ApexPages.StandardSetController(myCasesList);  
        pageCon.setPageSize(10); 
        return null;
    }
}