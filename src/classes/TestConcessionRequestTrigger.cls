@isTest
public class TestConcessionRequestTrigger
{
     static testmethod void TestCase_Before_Insert()
    {
       Schema.sObjectType objType = pse__Proj__c.getSObjectType(); 
       Schema.DescribeSObjectResult objDescribe = objType.getDescribe();       
       map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
       list<Schema.PicklistEntry> values =
       fieldMap.get('pse__Stage__c').getDescribe().getPickListValues();
       
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
        System.assert(request.Id != null);
        project.Approval_Status__c = 'Pending Approval';
        update project;
        
    }
}