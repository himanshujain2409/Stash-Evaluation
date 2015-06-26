public with sharing class PS_ProjectApprovalEmailController {

    private static final String FIELD_NAME_ID = 'Id';
    private Apttus_Approval.ContextApprovalEmailController context = null;
    public List<Concession_Request__c> ConcessionRequestList{get;set;}
    public Concession_Request__c ConcessionRequest{get;set;}
    public Apttus_Approval__Approval_Request__c requestSO {get;set;}
    
    public class ConcessionRequestWrapper
    {
        public Apttus_Approval__Approval_Request__c ApprovalRequest {get;set;}
        public Concession_Request__c ConcessionRequest {get;set;}
        public ConcessionRequestWrapper(Apttus_Approval__Approval_Request__c requestSO,Concession_Request__c cRequestSO) {
            this.ApprovalRequest = requestSO;
            this.ConcessionRequest = cRequestSO;
        }
    }
    
    private List<ConcessionRequestWrapper> lstConcessionRequestWrapper;
    
    public class EmailWrapper
    {
        public pse__Proj__c ProjectSO {get;set;}
        public Concession_Request__c ConcessionRequest{get;set;}
        public List<ConcessionRequestWrapper> ConcessionRequestList{get;set;}
        public EmailWrapper(pse__Proj__c Project,List<ConcessionRequestWrapper> lstConcessionRequest,Concession_Request__c concessionRequest) {
            this.ProjectSO = Project;
            this.ConcessionRequestList = lstConcessionRequest;
            this.ConcessionRequest = concessionRequest;           
        }
    }
       
    
    public PS_ProjectApprovalEmailController() {
         this.context= new Apttus_Approval.ContextApprovalEmailController();
         
    }

    public Apttus_Approval.ContextApprovalEmailController getContext() {
        return context;
    }
    
    public EmailWrapper getEmailWrapper()
    {
        Apttus_Approval__Approval_Request__c requestSO = Context.getRequestSO();
        if(requestSO.Apttus_Approval__Object_Id__c != null)
        {
                          
              Apttus_Approval__Approval_Request__c request = [select Apttus_Approval__ChildObjectId__c From Apttus_Approval__Approval_Request__c where Id =: requestSO.Id];
              EmailWrapper projectSO = getProjectSO(requestSO.Apttus_Approval__Object_Id__c,request.Apttus_Approval__ChildObjectId__c);
              return projectSO;
        }
        return null;
    }
    
    public EmailWrapper getProjectSO(string projectId,string childObjectId) 
    {
        pse__Proj__c projectSO = [select Id,Name,Hours_per_original_SOW_Build__c,
                                        Hours_per_original_SOW_Define__c,Hours_per_original_SOW_Design__c,
                                        Hours_per_original_SOW_Launch__c,Hours_per_original_SOW_Plan__c,
                                        Hours_per_original_SOW_Test__c,Hours_revised_Build__c,
                                        Hours_revised_Define__c,Hours_revised_Design__c,
                                        Hours_revised_Launch__c,Hours_revised_Plan__c,
                                        Hours_revised_Test__c,pse__Account__r.Id,
                                        pse__Account__r.Name,pse__Account__r.AccountStatusGS__c,
                                        pse__Account__r.Account_Level__c,pse__Account__r.CSM__c,pse__Account__r.CSM__r.Name,
                                        pse__Project_Manager__c,pse__Opportunity__r.ACV__c,
                                        OwnerId,Owner.Name,pse__Project_Manager__r.Name,
                                        PS_Bookings__c,pse__Planned_Hours__c,
                                        Concession_amount__c,Concession_Hours__c,
                                        Gross_Bookings__c,Total_Planned_Hours__c,
                                        pse__Billing_Type__c,PM_Estimated_Total_Hours__c,
                                        pse__Bookings__c,Total_hours_spent__c,
                                        Total_Hours_per_SOW__c,Total_Hours_revised__c,
                                        Revised_hours_SOW_hours__c,Revised_hours_SOW__c,
                                        of_Approved_Requested_Concession_Hours__c,of_Requested_Concession_Hours__c,
                                        Budget_Utilized__c,Pct_of_Funds_Remaining__c,
                                        (select   Name,Concession_Type__c,Root_cause__c,Hours_Requested__c,Reasons_for_cost_and_time_overruns__c,Why_not_a_CO__c,
                                                  Delivery_Confidence__c,Account_Status__c,Approval_Status__c,Requested_on_behalf__r.Name,
                                                  Requestor__r.Name,Project__c,Project__r.Name,X1_Has_work_been_delivered__c,Executive_Sponsor__r.Name,
                                                  Project__r.Planned_Effective_Rate__c,Project__r.Actual_Effective_Rate__c,Risks__c 
                                                  from Concession_Requests__r Where Approval_Status__c = 'Pending Approval' order by createddate desc LIMIT 1000),
                                        (select Id,Name,pse__Target_Date__c,Revised_Completion_Date__c,pse__Actual_Date__c,pse__Milestone_Amount__c,pse__Status__c,
                                                 pse__Approved_for_Billing__c,pse__Billed__c,Training_Milestone__c from pse__Milestones__r LIMIT 1000),
                                        (select Budget_Hours__c,Name,pse__Account__c,pse__Amount__c,pse__Billable__c,pse__Effective_Date__c,
                                                  pse__Exclude_from_Billing__c,pse__Include_In_Financials__c,pse__Status__c,pse__Type__c,Subtype__c 
                                                from pse__Budgets__r LIMIT 1000)
                                        from pse__Proj__c Where Id =: ProjectId];
                            
             ConcessionRequestList= ((projectSO.Concession_Requests__r != null && projectSO.Concession_Requests__r.size() > 0) ? projectSO.Concession_Requests__r : null);
             
             if(!ConcessionRequestList.isEmpty()) {
                 Map<Id,Concession_Request__c> mapConcessionRequest = new Map<Id,Concession_Request__c>(ConcessionRequestList);
                 if(childObjectId != null) {
                     if(mapConcessionRequest.get(childObjectId) != null) {
                          ConcessionRequest = mapConcessionRequest.get(childObjectId);
                          mapConcessionRequest.remove(childObjectId);
                     }
                     else {
                         ConcessionRequest = ConcessionRequestList[0];
                     }
                 }
                 else {
                     ConcessionRequest = ConcessionRequestList[0];
                }
                ConcessionRequestList = mapConcessionRequest.values();
                Map<Id,List<Apttus_Approval__Approval_Request__c>> mapApprovalRequestHistory = new Map<Id,List<Apttus_Approval__Approval_Request__c>>();
                 
                for(Apttus_Approval__Approval_Request__c approvalRequest :  [select id,Name,Apttus_Approval__ChildObjectId__c,Apttus_Approval__Assigned_To_Name__c from Apttus_Approval__Approval_Request__c 
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
                
                lstConcessionRequestWrapper = new List<ConcessionRequestWrapper>();
                
                for(Concession_Request__c cRequest : ConcessionRequestList) {
                     Apttus_Approval__Approval_Request__c request = mapApprovalRequestHistory.get(cRequest.Id) != null ? mapApprovalRequestHistory.get(cRequest.Id)[0] : new Apttus_Approval__Approval_Request__c();
                     lstConcessionRequestWrapper.add(new ConcessionRequestWrapper(request,cRequest));
                }

            }                                                                                        
             
         return new EmailWrapper(ProjectSO,lstConcessionRequestWrapper,ConcessionRequest);
        
    }
    
}