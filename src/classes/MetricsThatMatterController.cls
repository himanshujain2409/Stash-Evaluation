/**************************************************************
 * Name             : MetricsThatMatter
 * Created Date     : Sep 26, 2012.
 * Purpose          : Metrics That Matter Report
 **************************************************************/
public with sharing class MetricsThatMatterController {

    public List<MetricWrapper> metricWrappers{get;set;}
    public FRLS_Round__c fromDate{get;set;}
    public FRLS_Round__c toDate{get;set;}
    public List<Selectoption> showOptions{get;set;}
    public String showOption{get;set;}
    
    public static String SHOW_MY_TOUCH = 'My touch track';
    public static String SHOW_TEAMS_TOUCH = 'My team\'s touch track';
    public static String SHOW_ALL_TOUCH = 'All touch track';
    
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
    public MetricsThatMatterController(){
        
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
    * Load data
    */
    public void init(){
        String query = 'Select Id, Name, Admin_Dialogue__c, Account__c, Admin_EM__c, Admin_VM__c, KP_Dialogue__c, Round_Priority__c,CreatedDate,';
        query += ' KP_VM__c, KP_EM__c, Referral__c, MI__c, Round_1_KP__c, Related_Name__c, Rel_Company__c, Contact__c, Lead__c, OwnerId, Owner.Name  from FRLS_Round__c';
        
        String filterCond = buildFilterCond();
        
        //filter condition for show option
        query += filterCond + ' LIMIT 9999';
        
        List<FRLS_Round__c> roundList = Database.query(query); 
        
        
        initMetricList(roundList);
        
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
    * Calculate values of the report
    */
    public void initMetricList(List<FRLS_Round__c> roundList){
        Set<String> teamMemberNames = new Set<String>();
        for(FRLS_Round__c r : roundList){
            if(!teamMemberNames.contains(r.Owner.Name)){
                teamMemberNames.add(r.Owner.Name);
            }
        }
        
        metricWrappers = new List<MetricWrapper>();
        
        for(String name : teamMemberNames){
            MetricWrapper wrapper = new MetricWrapper();
            for(FRLS_Round__c r : roundList){
                if(r.Owner.Name==name){
                    wrapper.roundList.add(r);
                }
            }
            wrapper.teamMember = name;
            metricWrappers.add(wrapper);
        }
        
        calculateReportValues();
    }
    
    /**
    * Calculate values of the report
    */
    public void calculateReportValues(){
        Map<Id, DateTime> contactLeadMap = new Map<Id, DateTime>();
          Map<Id, Datetime> leadMap = new Map<Id, Datetime>();
        List<FRLS_Round__c> leadList = [Select f.Lead__c, f.CreatedDate From FRLS_Round__c f where f.lead__c <> null];
        for(FRLS_Round__c round : leadList){
           if(!leadMap.containsKey(round.Lead__c)){
              leadMap.put(round.Lead__c, round.CreatedDate);
           }else if(leadMap.get(round.Lead__c) > round.CreatedDate){
              leadMap.put(round.Lead__c, round.CreatedDate);
           }
        }
        for(Id leadId : leadMap.keySet()){
            contactLeadMap.put(leadId, leadMap.get(leadId));
        }
        
        Map<Id, Datetime> contactMap = new Map<Id, Datetime>();
        LIST<FRLS_Round__c> contactList = [Select Contact__c, CreatedDate From FRLS_Round__c f where Contact__c <> null];
        for(FRLS_Round__c round : contactList){
           if(!contactMap.containsKey(round.Contact__c)){
              contactMap.put(round.Contact__c, round.CreatedDate);
           }else if(contactMap.get(round.Contact__c) > round.CreatedDate){
              contactMap.put(round.Contact__c, round.CreatedDate);
           }
        }
        for(MetricWrapper wrapper : metricWrappers){
            
            Set<Id> contactLeadIds = new Set<Id>();
            Set<String> accountIds = new Set<String>();
            Integer noOfKPs = 0;
            Integer noOfKPDialogues = 0;
            Integer noOfKPEmail = 0;
            Decimal totalMIs = 0;
            Integer totalAdminDialog = 0;
            Integer totalAdminEM = 0;
            Integer totalAdminVM = 0;
            Integer totalReferral = 0;
            Integer unique_KPs = 0;
            
            //Calculate Rounds/Day = SUM(Round) / (Max(round.CreatedDate)-Min(round.CreatedDate))
            if(endDate != null && startDate != null){
                Integer workingDays = ReportUtils.calWorkingDays(startDate, endDate.addDays(-1));
                if(workingDays > 0){
                    wrapper.rounds_Days = Decimal.valueOf(wrapper.roundList.size()) / Decimal.valueOf(workingDays);
                }
            }
            
            for(FRLS_Round__c round : wrapper.roundList){
                if(round.Admin_Dialogue__c==true){
                    totalAdminDialog++;
                }
                
                if(round.Admin_EM__c==true){
                    totalAdminEM++;
                }
                
                if(round.Admin_VM__c==true){
                    totalAdminVM++;
                } 
                if(round.Referral__c==true){
                    totalReferral++;
                }
                //Calculate no of KPs
                if(round.KP_Dialogue__c==true){
                    noOfKPs++;
                    noOfKPDialogues++;
                }
                if(round.KP_EM__c==true){
                    noOfKPs++;
                    noOfKPEmail++;
                }
                if(round.KP_VM__c==true){
                    noOfKPs++;
                }
                
                //No of unique Contact or Lead
                if(round.Contact__c != null && !contactLeadIds.contains(round.Contact__c)){
                    contactLeadIds.add(round.Contact__c);
                    if(round.KP_VM__c == true || round.KP_EM__c == true || round.KP_Dialogue__c == true){
                        unique_KPs++;
                    }
                }else if(round.Lead__c != null && !contactLeadIds.contains(round.Lead__c)){
                    contactLeadIds.add(round.Lead__c);
                    if(round.KP_VM__c == true || round.KP_EM__c == true || round.KP_Dialogue__c == true){
                        unique_KPs++;
                    }
                }
                //No of unique Account
                if(round.Rel_Company__c != null && !accountIds.contains(round.Rel_Company__c)){
                    accountIds.add(round.Rel_Company__c);
                }
                //Calculate Total Mis
                totalMIs += round.MI__c;
            }
            if(accountIds.size() > 0){
                //Calculate KP/Company ration
                wrapper.kp_CompanyRatio = Decimal.valueOf(contactLeadIds.size())/ Decimal.valueOf(accountIds.size());
                //Calculate Rounds/Company              
                wrapper.rounds_Company = Decimal.valueOf(wrapper.roundList.size()) / Decimal.valueOf(accountids.size()); 
            }
            //Calculate Touches per rounds
            if(wrapper.roundList.size() > 0){
                Integer noOfTouches = noOfKPs + totalAdminDialog + totalAdminEM + totalAdminVM + totalReferral;
                wrapper.touchesPerRoundRatio = Decimal.valueOf(noOfTouches) / Decimal.valueOf(wrapper.roundList.size());
            }
            //Calculate Rounds/KP
            if(noOfKPs > 0){
                wrapper.rounds_KP = Decimal.valueOf(wrapper.roundList.size()) / Decimal.valueOf(contactLeadIds.size());
            }
            //Calculate Rounds/MIs Booked
            if(totalMIs > 0){
                wrapper.rounds_MIsBooked = Decimal.valueOf(wrapper.roundList.size()) / totalMIs;
            }
            //Calculate MI/KP Dialogues
            if(noOfKPDialogues > 0){
                wrapper.mi_KPDialogues = totalMIs / Decimal.valueOf(noOfKPDialogues);   
            }
            //Calculate Email % to Unique KP (= COUNT(KP EM) / COUNT(uniqueKPs))
            if(noOfKPs > 0){
                wrapper.emailPercent = (Decimal.valueOf(noOfKPEmail) + Decimal.valueOf(totalAdminEM)) / Decimal.valueOf(contactLeadIds.size());
            }
            //Calculate Round 1KP/Rounds %
            Integer noOf1KP = 0;
            /*
            //LIST<AggregateResult> leadList = [Select Lead__c, MIN(CreatedDate) From FRLS_Round__c f where lead__c <> null group by lead__c];
            //LIST<AggregateResult> contactList = [Select Contact__c, MIN(CreatedDate) From FRLS_Round__c f where Contact__c <> null group by Contact__c];
            
            //for(AggregateResult rec : leadList){
            //    contactLeadMap.put(((Id)rec.get('Lead__c')), (DateTime)rec.get('expr0'));               
            //}
            //for(AggregateResult rec : contactList){
            //    contactLeadMap.put(((Id)rec.get('Contact__c')), (DateTime)rec.get('expr0'));                
            //}
            */
            for(Id contactId : contactMap.keySet()){
                contactLeadMap.put(contactId, contactMap.get(contactId));
            }
            //Calculate # of 1KP
            for(FRLS_Round__c round : wrapper.roundList){
                if((contactLeadMap.get(round.Contact__c)==round.CreatedDate) || (contactLeadMap.get(round.Lead__c)==round.CreatedDate)){
                    noOf1KP++;
                }
            }
            wrapper.round1KP_Round = (Decimal.valueOf(noOf1KP) / Decimal.valueOf(wrapper.roundList.size()))*100;
        }
    }
    //Export excel file
    public PageReference exportXls(){
        Pagereference page = new PageReference('/apex/MetricsThatMatterExport');
        return page;
    }
    //Filer rounds by CreatedDate
    public PageReference filter(){
        init();
        return null;
    }
    
    public class MetricWrapper{
        
        public transient List<FRLS_Round__c> roundList{get;set;}
        
        public String teamMember{get;set;}
        public Decimal rounds_Days{get;set;}
        public Decimal round1KP_Round{get;set;}
        public Decimal kp_CompanyRatio{get;set;}
        public Decimal touchesPerRoundRatio{get;set;}
        public Decimal emailPercent{get;set;}
        public Decimal rounds_Company{get;set;}
        public Decimal rounds_KP{get;set;}
        public Decimal rounds_MIsBooked{get;set;}
        public Decimal mi_KPDialogues{get;set;}
        
        public MetricWrapper(){
            roundList = new List<FRLS_Round__c>();
            teamMember = '';
            rounds_Days = 0;
            round1KP_Round = 0;
            kp_CompanyRatio = 0;
            touchesPerRoundRatio = 0;
            emailPercent = 0;
            rounds_Company = 0;
            rounds_KP = 0;
            rounds_MIsBooked = 0;
            mi_KPDialogues = 0;
        }
        
    }
}