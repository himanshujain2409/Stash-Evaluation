/*
* NAME : ApttusMbos
* NOTE: class will used when user clicks on "Mbos" Home Page Link,it shows My Mbos,My Team Mbos
* Author : Apttus
*/
public with sharing class ApttusMbos {

  public ApexPages.StandardSetController mboRecordSet;
  public String mboId {get;set;}
  public Id mbId {get; set;}
  public Boolean showTab{get;set;}
  
   public ApttusMbos (ApexPages.StandardSetController controller) {
     string strUserID = UserInfo.getUserID();
      List<MBO__c> teamMbos = [SELECT ID From MBO__c  WHERE Manager__c = :strUserID];
      if(teamMbos != null && teamMbos.size()>0)
            showTab = TRUE;
         else
           showTab = FALSE;
     }   
     
         private String sortDirection = 'ASC';
      private String sortExp = 'name';
      public String sortExpression{
          get{
              return sortExp;
          }set{
              //if the column is clicked on then switch between Ascending and Descending modes
              if (value == sortExp)
                  sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
              else
                  sortDirection = 'ASC';
              sortExp = value;
          }
      }
      public String getSortDirection(){
          //if not column is selected 
          if (sortExpression == null || sortExpression == '')
              return 'ASC';
          else
              return sortDirection;
      }
      public void setSortDirection(String value){  
          sortDirection = value;
      }
      
      public ApexPages.StandardSetController getMboRecordSet(Integer flag){
        string sortFullExp = sortExpression  + ' ' + sortDirection;
     if(sortFullExp  == ''){
         sortFullExp  = 'lastmodifieddate desc';
     }
        if(flag == 1){
        //My Mbos
        string strUserID = UserInfo.getUserID();
        string strSOQL = 'Select  m.Id, m.Name, m.Manager__r.Name,m.Employee__r.Name, m.MBO_1__c, m.MBO_2__c,m.MBO_3__c,  m.MBO_4__c, m.MBO_5__c, m.Status__c';
     strSOQL += ' From MBO__c m WHERE m.Employee__c = :strUserID ';
        strSOQL += ' ORDER BY ' + sortFullExp;
        
        mboRecordSet = new ApexPages.StandardSetController( Database.getQueryLocator(strSOQL));
        }
         if(flag == 2){ 
        // My Team Mbos
        string strUserID = UserInfo.getUserID();
        string strSOQL = 'Select  m.Id, m.Name, m.Manager__r.Name,m.Employee__r.Name, m.MBO_1__c, m.MBO_2__c,m.MBO_3__c,  m.MBO_4__c, m.MBO_5__c, m.Status__c';
     strSOQL += ' From MBO__c m WHERE m.Manager__c = :strUserID ';
        strSOQL += ' ORDER BY ' + sortFullExp;
            
        mboRecordSet = new ApexPages.StandardSetController(Database.getQueryLocator(strSOQL));
        }
         mboRecordSet.setPageSize(mboRecordSet.getResultSize());
        
        return mboRecordSet;
    }
    
     // Requests Tab 1 My  Mbos
    public List<MBO__c > getMyMbos(){
        List<MBO__c > tapprRequestRecords = new List<MBO__c >();
        if (getmboRecordSet(1) != null) {            
            tapprRequestRecords =  mboRecordSet.getRecords();
        }
         return tapprRequestRecords;
    } 
    // Requests Tab 2 My Team Mbos
    public List<MBO__c > getMyTeamMbos(){
        List<MBO__c > tapprRequestRecords = new List<MBO__c >();
        if (getmboRecordSet(2) != null) {            
            tapprRequestRecords =  mboRecordSet.getRecords();
        }
         return tapprRequestRecords;
    }
    public void sortRequestRecords(){
        getMyMbos();
    } 
     public PageReference goMbo(){
        return new PageReference('/'+mboId);        
    }
   
}