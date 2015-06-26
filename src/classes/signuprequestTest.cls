@isTest
private class signuprequestTest {
  @istest(SeeAllData=true)
  public static void testSignup() {
  
      signuprequest srq = new signuprequest();
      srq.SignupEmail='czhang@apttus.com';
      srq.lastname='Zhang';
      srq.country='US';
      srq.username='czhang@apttus.com.demo';
      srq.company='Apttus';
      srq.TemplateId='0TTU0000000cHwh';
      
      insert srq;

      ApexPages.StandardController stdSignup = new ApexPages.StandardController(srq);

      SignupRequestExt signupcontroller = new SignupRequestExt(stdSignup);
      signupcontroller.getItems();




   }  
 
  @istest(SeeAllData=true)
  public static void testSignupExt() {

    OauthClass oauth = new OauthClass();
    oauth.firstName = 'Cathy';
    oauth.lastName = 'Zhang';
    oauth.Company = 'Salesforce';
    oauth.SignupEmail = 'Cathy@test.com';
    oauth.Country = 'US';
    oauth.signupusername = 'Cathy@test.com';
    oauth.description = 'Test';
  
    oauth.createResponse();

    oauth.login();



  }



}