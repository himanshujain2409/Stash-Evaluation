@isTest
public class TestAttachmentTrigger {
    public testmethod static void TestCaseForAttachmentTrigger(){
        
        /*Account acct =new Account(Name='Test Account');
        insert acct;
        
       
        pse__Proj__c project = new pse__Proj__c();
        project.Name = 'Test project';
        project.pse__Stage__c = 'Pipeline';
        project.pse__Account__c = acct.Id;
        insert project;
        
        Attachment attach=new Attachment();    
        attach.Name = 'Unit Test Attachment';
        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
        attach.body = bodyBlob;
        attach.parentId = project.id;
        insert attach;*/
        
        Account acct = TestUtility.CreateAccount('Test Account');
        insert acct;
        pse__Proj__c project = TestUtility.CreateProject('Test project','Pipeline',acct.Id);
        insert project;
        Attachment attach = TestUtility.CreateAttachment('Unit Test Attachment','Unit Test Attachment Body', project.id);
        insert attach;
        
        Attachment  attachment = [select Id from Attachment where parentId = : acct.Id];
              
        System.assertNotEquals(attachment,null);
        
        
    }
}