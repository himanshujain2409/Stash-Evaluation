@isTest
private class Test_CaseCommentUpdate {
    static testMethod void myUnitTest() {
        Account acc = new Account(Name = 'Test Account12345');
        acc.BillingCountry = 'United States';        
        insert acc;
        
        Contact cnt = new Contact(); 
        cnt.LastName = 'Test Contact12345';
        cnt.AccountId = acc.Id;
        insert cnt;

        Case Testcase = new Case();
        Testcase.Status = 'New';
        Testcase.Origin = 'Phone';
        Testcase.Contact = cnt;
        Testcase.Account = acc;
        Testcase.Subject = 'Test Case';
        Testcase.Description = 'Test Case';
        insert Testcase;
               
        CaseComment Casecmnt1 = new CaseComment();
        Casecmnt1.CommentBody='first Private Comment';
        Casecmnt1.ParentId = Testcase.id;
        Casecmnt1.IsPublished=false;
        insert Casecmnt1;
        
        CaseComment Casecmnt2 = new CaseComment();
        Casecmnt2.CommentBody='first Public Comment';
        Casecmnt2.ParentId = Testcase.id;
        Casecmnt2.IsPublished=True;
        insert Casecmnt2;
        
        CaseComment Casecmnt3 = new CaseComment();
        Casecmnt3.CommentBody='Second Public Comment';
        Casecmnt3.ParentId = Testcase.id;
        Casecmnt3.IsPublished=True;
        insert Casecmnt3;
    }
}