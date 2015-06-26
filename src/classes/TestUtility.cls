/**************
Class Name : Test Utility
Developer by : Sekhar Babu
Developed Date : 
***************/

public class TestUtility
{
    // Creating Concession Request and return the List
    // passing the parameters of the  Project id,Concession Type,Approval Status  and Number of records to created.
    public static List<Concession_Request__c> CreateConcessionRequest(String projectId,String concessionType,String approvalStatus,Integer noOfRecords)
    {
        List<Concession_Request__c> cRequestList = new List<Concession_Request__c>();
        Concession_Request__c request;
        
        for(Integer i = 0; i < noOfRecords; i++) {
                request = new Concession_Request__c();
                request.Project__c = ProjectId;
                request.Concession_Type__c = ConcessionType;
                request.Root_cause__c = 'Communication issues';
                request.Requestor__c = userinfo.getuserid();
                request.Requested_on_behalf__c =  userinfo.getuserid();
                request.Hours_Requested__c = 10;
                request.X1_Has_work_been_delivered__c = '';
                request.Reasons_for_cost_and_time_overruns__c ='test';
                request.Delivery_Confidence__c= 'test';
                request.Risks__c ='test';
                request.Approval_Status__c = ApprovalStatus;
                cRequestList.add(request);
       }
       
       return cRequestList;
    }
    
    
    //Creating Project and return the List
    //passing the parameters project name,stage of the project and number of records to be created.
    public static List<pse__Proj__c> CreateProject(String projectName,String stage,Integer noOfRecords)
    {
        List<pse__Proj__c> projectList = new List<pse__Proj__c>();
        pse__Proj__c project;
        for(Integer i = 0; i < noOfRecords; i++) {
                project = new pse__Proj__c();
                project.Name = projectName + string.valueof(i);
                project.pse__Stage__c = stage;
                projectList.add(project);
       }
       
       return projectList;
    }
    
    //Creating Approval Request and return the List
    //passing the parameters Sobject of Parent,List of the Sobject for Child object and assigned name to the Approval Request.
    public static List<Apttus_Approval__Approval_Request__c > CreateApprovalRequest(SObject parentSObject,List<SObject> childSObject,String assignedToName)
    {
        List<Apttus_Approval__Approval_Request__c > requestSOList = new List<Apttus_Approval__Approval_Request__c>();
        Apttus_Approval__Approval_Request__c requestSO;
        for(SObject s : childSObject) {
            requestSO = new Apttus_Approval__Approval_Request__c();
            requestSO.Apttus_Approval__Object_Id__c = parentSObject.Id;
            requestSO.Apttus_Approval__ChildObjectId__c = s.Id;
            requestSO.Apttus_Approval__Assigned_To_Name__c = assignedToName;
            requestSOList.add(requestSO);
        }
        
        return requestSOList;
        
    }
    
    //Create the Account and return account object
    //passing the parameter as Account Name
    public static Account CreateAccount(String accountName)
    {
        Account acct =new Account(Name=accountName);
        return acct;
    }
    
    //create project and return Project object
    //passing the parameter as Project Name,Stage,AccountId
    public static pse__Proj__c CreateProject(String projectname,String stage,String accountId)
    {
        pse__Proj__c project = new pse__Proj__c();
        project.Name = projectname;
        project.pse__Stage__c = stage;
        project.pse__Account__c = accountId;
        return project;
    }
    
    //create Attachment and return Attachment Object
    //passing the parameter as Attachment Name,Body,ParentId.
    public static Attachment  CreateAttachment(String attachmentName,String attachmentBody,string attachmentParentId)
    {
        Attachment attach=new Attachment();    
        attach.Name = attachmentName;
        Blob bodyBlob = Blob.valueOf(attachmentBody);
        attach.body = bodyBlob;
        attach.parentId = attachmentParentId;
        return attach;
    }
    
}