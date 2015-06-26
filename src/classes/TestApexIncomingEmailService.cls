@isTest
public class TestApexIncomingEmailService {

    static testmethod void TestEmail()
    {
        Case_Custom_Settings__c cs=new Case_Custom_Settings__c();
        cs.Blank_Subject_in_Email_Template_Name__c='qwe';
        cs.Cannot_Reopen_Closed_Case_Template_Name__c='qweqwe';
        cs.Case_Number_Missing_Email_Template_Name__c='qweqwe';
        cs.Email_Sender_Display_Name__c='qwewqe';
        cs.Email_Service_Name__c='qweqwe';
        cs.Empty_Email_Body_Template_Name__c='qweqwe';
        cs.Invalid_Case_Number_Email_Template_Name__c='qweqwe';
        cs.Invalid_Contact_For_Case__c='qweqwe';
        cs.Number_of_Days__c=2;
        cs.Support_Email_Address__c='qweqwe@as.com';
        cs.Users_with_Publish_Permission__c='qweqwe';
        cs.Name='System Properties';
        cs.Number_of_Days__c = 5;
        insert cs;
        Test.startTest();
        ApexIncomingEmailService em=new ApexIncomingEmailService();
        Test.stopTest();
    }
}