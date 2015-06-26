/**************************************************************
 * Name             : PMProductivityReport
 * Created Date     : Sep 24, 2012.
 * Purpose          : Productivity Summary Report
 **************************************************************/
public with sharing class PMProductivityReportController {

  public transient List<FRLS_Round__c> roundList{get;set;}
  public List<RoundSummaryWrapper> roundSummaryList{get;set;}
  public FRLS_Round__c fromDate{get;set;}
  public FRLS_Round__c toDate{get;set;}
  public List<Selectoption> showOptions{get;set;}
  public String showOption{get;set;}
  
  public static String SHOW_MY_TOUCH = 'My touch track';
  public static String SHOW_TEAMS_TOUCH = 'My team\'s touch track';
  public static String SHOW_ALL_TOUCH = 'All touch track';
  
  public Integer grandTotalAdminDialog{get;set;}
  public Integer grandTotalAdminEM{get;set;}
  public Integer grandTotalAdminVM{get;set;}
  public Integer grandTotalKPDialog{get;set;}
  public Integer grandTotalKPEM{get;set;}
  public Integer grandTotalKPVM{get;set;}
  public Integer grandTotalReferral{get;set;}
  public Double grandTotalMI{get;set;}
  public Double grandTotalRound1KP{get;set;}
  public Integer grandTotalNoOfTouches{get;set;}
  public Decimal grandTotalRoundScores{get;set;}
  public Integer grandTotalNoOfContacts{get;set;}
  public Integer grandTotalNoOfAccounts{get;set;}
  public Integer grandTotalNoOfRounds{get;set;} 
  public Integer grandTotalNoOfMIs{get;set;}  
  
  private Date startDate{
        get{
          if(fromDate != null && fromDate.Callback_Date__c != null) {
            return fromDate.Callback_Date__c;
          } else {
            return null;
          }
        }
    }
    
    private Date endDate{
        get{
          if(toDate != null && toDate.Callback_Date__c != null) {
            return (toDate.Callback_Date__c + 1);
          } else {
            return null;
          }
        }
    }
    
    private String userId{
      get{
        return Userinfo.getUserId();
      }
    }
    
    private Set<Id> myTeamIds{
      get{
      Set<Id> teamIds = new Set<Id>();
      teamIds.add(UserInfo.getUserId()); 
      teamIds.addAll(ReportUtils.getRoleSubordinateUsers(UserInfo.getUserId()));
        return teamIds;
      }
    }
    
  /**
  * Constructor
  */
  public PMProductivityReportController(){
    
    fromDate = new FRLS_Round__c(Callback_Date__c=System.today());
    toDate = new FRLS_Round__c(Callback_Date__c=System.today());
    
    initShowOptions();
    init();
  }
  
  /**
  * Init show options
  */
  public void initShowOptions(){
    
    showOption = SHOW_MY_TOUCH;
    showOptions = new List<Selectoption>();
    
    showOptions.add(new SelectOption(SHOW_MY_TOUCH,SHOW_MY_TOUCH));
    showOptions.add(new SelectOption(SHOW_TEAMS_TOUCH,SHOW_TEAMS_TOUCH));
    showOptions.add(new SelectOption(SHOW_ALL_TOUCH,SHOW_ALL_TOUCH));
  }
  
  /**
  * Load data, calculate summary & grand total
  */
  public void init(){
    
    String query = 'Select Id, Name, Admin_Dialogue__c, Account__c, Admin_EM__c, Admin_VM__c, KP_Dialogue__c, Round_Priority__c,';
    query += ' KP_VM__c, KP_EM__c, Referral__c, MI__c, Round_1_KP__c, Related_Name__c, Rel_Company__c, Contact__c, Lead__c, OwnerId, Owner.Name, Rel_Owner__c  from FRLS_Round__c';
    
    String filterCond = buildFilterCond();
    
    query += filterCond;
    roundList = Database.query(query); 
    
    initRoundSummaryList();
  }
  
  /**
  * Filter rounds which CreatedDate between startDate & endDate
  * Filter by show option selected
  */
  public String buildFilterCond(){
    
    String filterCond = '';
    //Filter by date range
    if(fromDate.Callback_Date__c!=null){
      filterCond = ' Where CreatedDate >= :startDate ';
    }
    
    if(toDate.Callback_Date__c!=null){
      if(filterCond.equals('')){
        filterCond = ' Where CreatedDate < :endDate ';
      }else{
        filterCond += ' AND CreatedDate < :endDate ';
      }
    }
    //Filter by show option
    if(showOption.equals(SHOW_MY_TOUCH)){
      if(filterCond.equals('')){
        filterCond = ' Where OwnerId=:userId ';
      }else{
        filterCond += ' AND OwnerId=:userId ';
      }
    }else if(showOption.equals(SHOW_TEAMS_TOUCH)){
      if(filterCond.equals('')){
        filterCond = ' Where OwnerId IN :myTeamIds ';
      }else{
        filterCond += ' AND OwnerId IN :myTeamIds ';
      }
    }
    
    return filterCond;
  }
  
  /**
  * 
  */
  public void initRoundSummaryList(){
    Set<String> roundOwnerNames = new Set<String>();
    for(FRLS_Round__c r : roundList){
      if(!roundOwnerNames.contains(r.Owner.Name)){
        roundOwnerNames.add(r.Owner.Name);
      }
    }
    
    roundSummaryList = new List<RoundSummaryWrapper>();
    
    for(String name : roundOwnerNames){
      RoundSummaryWrapper rsW = new RoundSummaryWrapper();
      for(FRLS_Round__c r : roundList){
        if(r.Owner.Name==name){
          
          rsW.roundList.add(r);
        }
      }
      rsW.roundOwnerName = name;
      roundSummaryList.add(rsW);
    }
    //Calculate summaries
    calculateSummaryTotal();
    calculateGrandTotal();
  }
  
  /**
  * 
  */
  public void calculateSummaryTotal(){
    for(RoundSummaryWrapper rsW : roundSummaryList){
      
      Set<Id> contactLeadIds = new Set<Id>();
      Set<String> accountIds = new Set<String>();
      
      for(FRLS_Round__c round : rsW.roundList){
        if(round.Admin_Dialogue__c==true){
          rsW.totalAdminDialog++;
        }
        
        if(round.Admin_EM__c==true){
          rsW.totalAdminEM++;
        }
        
        if(round.Admin_VM__c==true){
          rsW.totalAdminVM++;
        }
        
        if(round.KP_Dialogue__c==true){
          rsW.totalKPDialog++;
        }
        
        if(round.KP_EM__c==true){
          rsW.totalKPEM++;
        }
        
        if(round.KP_VM__c==true){
          rsW.totalKPVM++;
        }
        
        if(round.Referral__c==true){
          rsW.totalReferral++;
        }
        
        rsW.totalMI += round.MI__c;
        rsW.totalRound1KP += round.Round_1_KP__c;
        rsW.totalRoundScores += round.Round_Priority__c;
        rsW.noOfRounds++;
        //No of unique Contact/Lead
        if(round.Contact__c != null && !contactLeadIds.contains(round.Contact__c)){
          contactLeadIds.add(round.Contact__c);
        }else if(round.Lead__c != null && !contactLeadIds.contains(round.Lead__c)){
          contactLeadIds.add(round.Lead__c);
        }
        //No of unique Account
        if(round.Rel_Company__c != null && !accountIds.contains(round.Rel_Company__c)){
          accountIds.add(round.Rel_Company__c);
        }
      }
      
      rsW.noOfContacts = contactLeadIds.size();
      rsW.noOfAccounts = accountIds.size();
      rsW.noOfTouches = rsW.totalAdminDialog + rsW.totalAdminEM + rsW.totalAdminVM + rsW.totalKPDialog + rsW.totalKPEM + rsW.totalKPVM + rsW.totalReferral;
      //Calculate MIs executed
      rsW.noOfMIs = calculateMis(rsW.roundOwnerName);
    }
  }
  
  /**
  * 
  */
  public Integer calculateMis(String roundOwnerName){
    String query = 'SELECT Id FROM Event WHERE Owner.Name=\'' + roundOwnerName + '\' AND Subject =\'Meaningful Interaction (MI)\' ';
    String filterCond = '';
    
    if(fromDate.Callback_Date__c!=null){
      filterCond = ' AND ActivityDate >= :startDate';
    }
    if(toDate.Callback_Date__c!=null){
      if(filterCond.equals('')){
        filterCond = ' AND ActivityDate <= :endDate';
      }else{
        filterCond += ' AND ActivityDate <= :endDate';
      }
    }
    filterCond += ' AND PPM_Status__c = \'Executed\'';
    
    query += filterCond;
    return Database.query(query).size();
  }
  
  /**
  * 
  */
  public void calculateGrandTotal(){
    
    grandTotalAdminDialog = 0;
    grandTotalAdminEM = 0;
    grandTotalAdminVM = 0;
    grandTotalKPDialog = 0;
    grandTotalKPEM = 0;
    grandTotalKPVM = 0;
    grandTotalReferral = 0;
    grandTotalMI = 0;
    grandTotalRound1KP = 0;
    grandTotalNoOfTouches = 0;
    grandTotalRoundScores = 0;
    grandTotalNoOfContacts = 0;
    grandTotalNoOfAccounts = 0;
    grandTotalNoOfRounds = 0; 
    grandTotalNoOfMIs = 0;
  
    for(RoundSummaryWrapper rsW : roundSummaryList){
      grandTotalAdminDialog += rsW.totalAdminDialog;
      grandTotalAdminEM += rsW.totalAdminEM;
      grandTotalAdminVM += rsW.totalAdminVM;
      grandTotalKPDialog += rsW.totalKPDialog;
      grandTotalKPEM += rsW.totalKPEM;
      grandTotalKPVM += rsW.totalKPVM;
      grandTotalReferral += rsW.totalReferral;
      grandTotalMI += rsW.totalMI;
      grandTotalRound1KP += rsW.totalRound1KP;
      grandTotalNoOfTouches += rsW.noOfTouches;
      grandTotalRoundScores += rsW.totalRoundScores;
      grandTotalNoOfContacts += rsW.noOfContacts;
      grandTotalNoOfAccounts += rsW.noOfAccounts;
      grandTotalNoOfRounds += rsW.noOfRounds; 
      grandTotalNoOfMIs += rsW.noOfMIs;
    }
  }
  
  /**
  * Export to xls file
  */
  public PageReference xlsExport(){
    Pagereference page = new PageReference('/apex/PMPProductivityExport');
    return page;
  }
  
  public PageReference filter(){
    init();
    return null;
  }
  
  public class RoundSummaryWrapper{
    public Integer totalAdminDialog{get;set;}
    public Integer totalAdminEM{get;set;}
    public Integer totalAdminVM{get;set;}
    public Integer totalKPDialog{get;set;}
    public Integer totalKPEM{get;set;}
    public Integer totalKPVM{get;set;}
    public Integer totalReferral{get;set;}
    public Double totalMI{get;set;}
    public Double totalRound1KP{get;set;}
    public Integer noOfTouches{get;set;}
    public Decimal totalRoundScores{get;set;}
    public Integer noOfContacts{get;set;}
    public Integer noOfAccounts{get;set;}
    public Integer noOfRounds{get;set;}
    public Integer noOfMIs{get;set;}
    
    public String roundOwnerName{get;set;}
    public transient List<FRLS_Round__c> roundList{get;set;}
    
    public RoundSummaryWrapper(){
      
      roundList = new List<FRLS_Round__c>();
      roundOwnerName = '';
      
      totalAdminDialog = 0;
      totalAdminEM = 0;
      totalAdminVM = 0;
      totalKPDialog = 0;
      totalKPEM = 0;
      totalKPVM = 0;
      totalReferral = 0;
      totalMI = 0;
      totalRound1KP = 0;
      noOfTouches = 0;
      totalRoundScores = 0;
      noOfContacts = 0;
      noOfAccounts = 0;
      noOfRounds = 0;
      noOfMIs = 0;
    }
  }
}