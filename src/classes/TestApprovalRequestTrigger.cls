@isTest
public class TestApprovalRequestTrigger {
    static testmethod void  test1() {
         // STEP I - Create a new case
        Account acct =new Account(Name='Test Account');
        insert acct;
        
        Opportunity opp = new Opportunity(Name = 'Test -Opp');
        opp.AccountId = acct.Id;
        opp.StageName = 'Negotiate';
        Date myDate = Date.newInstance(1960, 2, 17);
        opp.CloseDate = system.today();
        opp.Type='';
        insert opp;
        
        Concession_Request_CS__c cRequest = new Concession_Request_CS__c();
        cRequest.Concession_Request_Type__c = '';
        cRequest.Concession_Request_Sub_Type__c= 'Rate Discount [# hours, proposed rate]';
        cRequest.Opportunity__c = opp.Id;
        cRequest.Justification__c = 'Testing';
        cRequest.Root_cause_characteristics__c = 'Keep customer happy';
        cRequest.Account__c = acct.Id;        
        insert cRequest;
        
                                                                                                                                                                                                                                                      
        // STEP II - Create a new approval request
        Apttus_Approval__Approval_Request__c requestSO = new Apttus_Approval__Approval_Request__c();
        requestSO.Apttus_Approval__Object_Id__c = acct.Id;
        requestSO.Apttus_Approval__Approval_Status__c  = 'Assigned';
        requestSO.Apttus_Approval__Assigned_To_Name__c = 'Sekhar Babu';
        requestSO.Apttus_Approval__ChildObjectId__c = cRequest.Id;
        insert requestSO;
        
        requestSO.Apttus_Approval__Approval_Status__c  = 'Reassigned';
        requestSO.Apttus_Approval__Assigned_To_Name__c = 'Parin';
        update requestSO;
        
        // STEP I - Create a new case
        pse__Proj__c project = new pse__Proj__c();
        project.Name = 'Test project';
        project.pse__Stage__c = 'Pipeline';
        insert project;
        Concession_Request__c request = new Concession_Request__c();
        request.Project__c = project.Id;
        request.Concession_Type__c = 'PS';
        request.Root_cause__c = 'Communication issues';
        request.Requestor__c = userinfo.getuserid();
        request.Requested_on_behalf__c =  userinfo.getuserid();
        request.Hours_Requested__c = 10;
        request.X1_Has_work_been_delivered__c = '';
        request.Reasons_for_cost_and_time_overruns__c ='test';
        request.Delivery_Confidence__c= 'test';
        request.Risks__c ='test';
        insert request;
        
        // STEP II - Create a new approval request
        Apttus_Approval__Approval_Request__c requestSO2 = new Apttus_Approval__Approval_Request__c();
        requestSO2.Apttus_Approval__Object_Id__c = project.Id;
        requestSO2.Apttus_Approval__Approval_Status__c  = 'Assigned';
        requestSO2.Apttus_Approval__Assigned_To_Name__c = 'Sekhar Babu';
        requestSO2.Apttus_Approval__ChildObjectId__c = request.Id;
        insert requestSO2;
        
        requestSO2.Apttus_Approval__Approval_Status__c  = 'Reassigned';
        requestSO2.Apttus_Approval__Assigned_To_Name__c = 'Parin';
        update requestSO2;
        
        
        
    }
}