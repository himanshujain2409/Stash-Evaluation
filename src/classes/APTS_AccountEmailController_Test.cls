@istest(SeeAllData=true)
public  class APTS_AccountEmailController_Test{
 
    public static testMethod void runPositiveTest() {
        Account acc= new Account();
        acc.name='testing'+DateTime.now();
        insert acc;
        Opportunity opp =[select id,Name,Account.id,Type,CloseDate,StageName,ForecastCategoryName,FY_ACV__c,ACV__c,Ramped_ACV__c,Renewal_ACV_Due__c from Opportunity where ACV__c!=null limit 1];
        
        
        Concession_Request_CS__c cr= new Concession_Request_CS__c();
        cr.Account__c=acc.id;
        cr.Root_cause_characteristics__c='Lack of skill set in support';
        cr.Hours_Requested__c=11;
        cr.Justification__c='testting sample data';
        cr.Concession_Request_Type__c='Sales';
        cr.Opportunity__c=opp.id;
        
        insert cr;
        
        Apttus_Approval__Approval_Request__c appreq= new Apttus_Approval__Approval_Request__c();
        appreq.Apttus_Approval__Object_Type__c='Account';
        appreq.Apttus_Approval__Object_Name__c=acc.name;
        appreq.Apttus_Approval__ChildObjectName__c=cr.name;
        appreq.Apttus_Approval__Object_Id__c=acc.id;
        appreq.Apttus_Approval__ChildObjectId__c=cr.id;
       insert appreq;
        
         User userSO = null;
       
        System.runAs(new User(Id = System.UserInfo.getUserId())) {
            userSO = Apttus_Approval.TestSupport.createUser('assignee1@approvals.xyz.com', 
                                                            'ast1', 
                                                            'assignee1',
                                                            'tester',
                                                            'assignee1@approvals.xyz.com',
                                                            ID.valueOf(UserInfo.getProfileId()));
                                         
            // fetch the assignee 
            userSO = Apttus_Approval.TestSupport.getUserSO(userSO.Id);
           
        
        }
        
        APTS_AccountEmailController controller = new APTS_AccountEmailController();
        Test.startTest();
         
        Apttus_Approval.ContextApprovalEmailController context = controller.getContext();
        
        context.setRequestSO(appreq);
        context.setRecipientSO(userSO);
       
       controller.GetAccountWrapper();
         
         Test.stopTest();
}
}