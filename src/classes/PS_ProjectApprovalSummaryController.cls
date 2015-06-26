public class PS_ProjectApprovalSummaryController {

    public class SummaryWrapper
    {
        public pse__Proj__c Project {get;set;}
        public Concession_Request__c ConcessionRequest{get;set;}
        
        public SummaryWrapper(pse__Proj__c project,Concession_Request__c concessionRequest)
        {
            this.Project = project;
            this.ConcessionRequest = concessionRequest;
        }
    }
    
    
    
    Private SummaryWrapper summaryWrapper;
    private static final String FIELD_NAME_ID = 'Id';
    private static final String RELATIONSHIP_FIELD_NAMES = 'pse__Account__r.Id,pse__Account__r.Name,pse__Account__r.AccountStatusGS__c,pse__Account__r.Account_Level__c,pse__Account__r.CSM__c';
    private String ProjectId;
    private Integer isredirect = 0;
    private ApexPages.StandardController controller {get;set;}
    private Apttus_Approval.ApprovalActionController2 actionController;
    
    public PS_ProjectApprovalSummaryController(ApexPages.StandardController stdController) {
        controller=stdController;
        actionController = new Apttus_Approval.ApprovalActionController2(stdController);
        Apttus_Approval__Approval_Request__c requestSO = (Apttus_Approval__Approval_Request__c) stdController.getRecord();
        system.debug('The Approval Request ---> ' + requestSO );
        Apttus_Approval__Approval_Request__c request = [select Apttus_Approval__Object_Id__c FROM Apttus_Approval__Approval_Request__c  where Id =: requestSO.Id];
        System.debug('The Request --> ' + request);
        ProjectId = request.Apttus_Approval__Object_Id__c;
        this.summaryWrapper= getProjectSO(request.Apttus_Approval__Object_Id__c);
    }
    
    public boolean isPageModeApproveRequest 
    {
        get{
            return actionController.getIsPageModeApproveRequest();
        }
    }
    public boolean isUserAuthorized 
    {
        get{
            return actionController.getIsUserAuthorized();
            }
    }
    
    public String SubmissionComment1Label
    {
        get
        {
            return actionController.getSubmissionComment1Label();
        }
    }
    
    public String SubmissionComment2Label
    {
        get
        {
            return actionController.getSubmissionComment2Label();
        }
    }
    public String SubmissionComment3Label
    {
        get
        {
            return actionController.getSubmissionComment3Label();
        }
    }
    
  
    public PageReference doApprove()
    {
        
        actionController.doApprove();
        PageReference pr = new PageReference('/' +  ProjectId);
        pr.setRedirect(true);
        return pr;
    }
    
    public PageReference doReject()
    {
        actionController.doReject();
        PageReference pr = new PageReference('/' +  ProjectId);
        pr.setRedirect(true);
        return pr;
    }
    
    public PageReference doAddComment()
    {
        actionController.doAddComment();
        PageReference pr = new PageReference('/' +  ProjectId);
        pr.setRedirect(true);
        return pr;
    }
    
    public PageReference doCancel()
    {
        PageReference pr = new PageReference('/' +  ProjectId);
        pr.setRedirect(true);
        return pr;
    }
    
    public PageReference doAttachFile()
    {
         
         PageReference pr = actionController.doAttachFile();
         return pr;
        //PageReference pr = new PageReference('/apex/Apttus_Approval__ApprovalRequestAttachment?Id=' + controller.getRecord().Id);
        //pr.setRedirect(true);
        //return pr;
        //return null;        
    }
    
    public PageReference RedirectToPage()
    {
        if(isredirect == 0)
            return null;
        PageReference pr = new PageReference('/' + ProjectId);
        pr.setRedirect(true);
        return pr;
    }
    
    public List<Attachment> getARAttachments()
    {
        return actionController.getARAttachments();
    }
    public SummaryWrapper getSummaryWrapper() {
       return summaryWrapper;
    }
    
    public pse__Proj__c getProject() {
       
        return summaryWrapper.Project ;
    }
    
     public Concession_Request__c  getConcessionRequest() {
       
        return summaryWrapper.ConcessionRequest;
    }
   
    private static SummaryWrapper getProjectSO(ID projectId) {
    
        pse__Proj__c projectSO = null;
        Concession_Request__c concessionRequestSO = null;
        SummaryWrapper summaryWrapperObj;
        System.debug('The Project Id --> ' + projectId);
    
        List<String> fieldNames = new List<String>();
        Integer numFields = 0;
       
        String qryStr = 'SELECT ';
        Schema.DescribesObjectResult metadata = pse__Proj__c.getSobjectType().getDescribe();
        for (Schema.SObjectField field : metadata.fields.getMap().values()) {
            Schema.DescribeFieldResult fldMetadata = field.getDescribe();
            if (numFields > 0) {
                qryStr += ',';
        
        }
            // add the field
            qryStr += fldMetadata.getName();
            numFields++;
        }
    qryStr += ',' + RELATIONSHIP_FIELD_NAMES + '  ';
    qryStr += ' FROM ' + pse__Proj__c.getSObjectType();
    qryStr += ' WHERE ';
    qryStr += FIELD_NAME_ID + ' = :projectId';
    qryStr += ' LIMIT 1';
  
    List<pse__Proj__c> projects = Database.query(qryStr);
    
    system.debug('The Project Details --> ' + projects);
    
    fieldNames = null;
    numFields = 0;
    fieldNames = new List<String>();
    metadata = null;
    metadata = Concession_Request__c.getSobjectType().getDescribe();
    
    qryStr = 'SELECT ';
    for (Schema.SObjectField field : metadata.fields.getMap().values()) {
        Schema.DescribeFieldResult fldMetadata = field.getDescribe();
        if (numFields > 0) {
            qryStr += ',';
    
        }
        // add the field
        qryStr += fldMetadata.getName();
        numFields++;
    }
    
    qryStr += ' FROM ' + Concession_Request__c.getSObjectType();
    qryStr += ' WHERE ';
    qryStr += 'Project__c' + ' = :projectId';
    qryStr += ' LIMIT 1';
      
    List<Concession_Request__c> lstConcessionRequest = Database.query(qryStr);
    
    projectSO = (!projects.isEmpty() ? projects[0] : null);
    concessionRequestSO  = (!lstConcessionRequest.isEmpty() ? lstConcessionRequest [0] : null);
    
    summaryWrapperObj= new SummaryWrapper(projectSO ,concessionRequestSO);
    
    return summaryWrapperObj;
   }
   
       
}