public class APTS_AccountEmailController {

    public class AccountWrapper {
        public Account AccountSO {get;set;}
        public Concession_Request_CS__c ConcessionRequestSO {get;set;}
        public List<ConcessionRequestWrapper> SupportPendingRequestSO {get;set;}
        public List<ConcessionRequestWrapper> SalesPendingRequestSO {get;set;}
        public AccountWrapper(Account accountSO,Concession_Request_CS__c concessionRequestSO,List<ConcessionRequestWrapper> supportPendingRequestSO,List<ConcessionRequestWrapper> salesPendingRequestSO) {
            this.AccountSO = accountSO;
            this.ConcessionRequestSO = concessionRequestSO;
            this.SupportPendingRequestSO = supportPendingRequestSO;
            this.SalesPendingRequestSO = salesPendingRequestSO;
        }
    }
    
    public class ConcessionRequestWrapper
    {
    // ...
        public Apttus_Approval__Approval_Request__c ApprovalRequestSO {get;set;}
        public Concession_Request_CS__c ConcessionRequestSO {get;set;}
        public ConcessionRequestWrapper(Apttus_Approval__Approval_Request__c requestSO,Concession_Request_CS__c cRequestSO) {
            this.ApprovalRequestSO = requestSO;
            this.ConcessionRequestSO = cRequestSO;
        }
    }


    public Apttus_Approval__Approval_Request__c approvalRequest{
        get{
            return Context.getRequestSO();
        }
    }
    
    Apttus_Approval.ContextApprovalEmailController context = null;
    
    
      
    public APTS_AccountEmailController(){
        this.context = new Apttus_Approval.ContextApprovalEmailController();
    }
    
    
    public Apttus_Approval.ContextApprovalEmailController getContext(){          
        return context;
    }
    

    public AccountWrapper GetAccountWrapper() {
    
       Account accountSO;
       Concession_Request_CS__c concessionRequestSO;
       List<ConcessionRequestWrapper> supportPendingRequestSO;
       List<ConcessionRequestWrapper> salesPendingRequestSO;
       if(approvalRequest.Apttus_Approval__Object_Id__c!=null){
       accountSO =  [SELECT Name,Owner.Name,AccountStatusGS__c,Account_Status__c,CSM__c,Account_Level__c,Executive_Sponsor__c,CSM__r.Name,
                                        (SELECT Request__c,Financial_Impact__c,Timeframe__c,What_they_are_willing_to_do_for_ask__c,
                                                ACV__c,Contact__c,Renewal_term__c,Renewal_Date__c,Extension_previously_Granted__c,Background__c,
                                                Product__c,RecordType.Name,Hours_Requested__c,Account__c,Case__c,Concession_Request_Sub_Type__c,
                                                Concession_Request_Type__c,Number_of_Users__c,Price_user_Month__c,Customer_Status__c,
                                                   Has_CR_been_Negotiated_with_Customer__c,Justification__c,Notes__c,Proposed_Rate__c,
                                                   Requested_Concession_Amount__c,Requested_Concession_Hours__c,Request_to_waive_FP_uplift__c,
                                                   Request_to_waive_onsite_rate__c,Opportunity__r.FY_ACV__c,Opportunity__r.ACV__c,Opportunity__r.Ramped_ACV__c,
                                                   Opportunity__r.ACV_Value_Change__c,Opportunity__r.ACV_Prior_Amount__c,Root_cause_characteristics__c,SOW_Hours__c,
                                                   of_Rate_Discount_Hours__c
                                                   , Apttus_Region__c, Approval_Status__c, Approved_and_Requested_Support_CR_Sum__c
                                                   , Name
                                                   , Concession_Amount__c, CR_Age_days__c, Currently_Assigned_To__c
                                                   , Date_CR_Assigned_for_Approval__c, Time_Pending_Approval__c, Executive_Sponsor__c, On_Off_site__c
                                                   , Opportunity__c, Rate_Discount_Amount__c, Request_Type__c
                                                   FROM Concession_Requests_CS__r 
                                                    LIMIT 1000)
                                         FROM Account Where Id =: approvalRequest.Apttus_Approval__Object_Id__c];
       
       Map<Id,Concession_Request_CS__c> mapConcessionRequest = new Map<Id,Concession_Request_CS__c>(accountSO.Concession_Requests_CS__r);
       concessionRequestSO = mapConcessionRequest.get(approvalRequest.Apttus_Approval__ChildObjectId__c);
       Map<Id,List<Apttus_Approval__Approval_Request__c>> mapApprovalRequestHistory = new Map<Id,List<Apttus_Approval__Approval_Request__c>>();
       
       for(Apttus_Approval__Approval_Request__c approvalRequest : [select id,Name,Apttus_Approval__ChildObjectId__c,Apttus_Approval__Approval_Status__c,Apttus_Approval__Assigned_To_Name__c, Owner.Name from Apttus_Approval__Approval_Request__c 
                                                                         where Apttus_Approval__Assigned_To_Name__c != '' AND Apttus_Approval__ChildObjectId__c IN :mapConcessionRequest.keyset()]) {
             if(mapApprovalRequestHistory.containsKey(approvalRequest.Apttus_Approval__ChildObjectId__c)) {
                 mapApprovalRequestHistory.get(approvalRequest.Apttus_Approval__ChildObjectId__c).add(approvalRequest);
             }
             else {
                 List<Apttus_Approval__Approval_Request__c> lstRequest = new List<Apttus_Approval__Approval_Request__c>();
                 lstRequest.add(approvalRequest);
                 mapApprovalRequestHistory.put(approvalRequest.Apttus_Approval__ChildObjectId__c,lstRequest);
             }                         
       }
       
       supportPendingRequestSO = new List<ConcessionRequestWrapper>();
                
       for(Concession_Request_CS__c cRequest : accountSO.Concession_Requests_CS__r) {
             if(cRequest.RecordType.Name == Label.APTS_PS_Concession_Support) {
                 Apttus_Approval__Approval_Request__c request = mapApprovalRequestHistory.get(cRequest.Id) != null ? mapApprovalRequestHistory.get(cRequest.Id)[0] : new Apttus_Approval__Approval_Request__c();
                 supportPendingRequestSO.add(new ConcessionRequestWrapper(request,cRequest));
             }
       }
       
       salesPendingRequestSO = new List<ConcessionRequestWrapper>();
       for(Concession_Request_CS__c cRequest : accountSO.Concession_Requests_CS__r) {
      
             if(cRequest.RecordType.Name == Label.APTS_PS_Concession_Sales) {
                 Apttus_Approval__Approval_Request__c request = mapApprovalRequestHistory.get(cRequest.Id) != null ? mapApprovalRequestHistory.get(cRequest.Id)[0] : new Apttus_Approval__Approval_Request__c();
                 salesPendingRequestSO.add(new ConcessionRequestWrapper(request,cRequest));
             }
       }
       }
        
       return new AccountWrapper (accountSO,concessionRequestSO,supportPendingRequestSO,salesPendingRequestSO);
    }  
    
}