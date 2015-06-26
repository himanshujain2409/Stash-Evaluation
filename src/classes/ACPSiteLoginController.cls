/*
 Controller that exposes the site login functionality. 
 Controller used in ApttusCustomerPortalSiteLogin
*/

global with sharing class ACPSiteLoginController {
    global String username {get; set;}
    global String password {get; set;}
    global Boolean rememberUser {get; set;}

    global PageReference login() {
        String rememberUserValue = rememberUser ? 'true' : 'false';
        Cookie remember = new Cookie('rememberPortalUser',rememberUserValue,null,315360000,false);
        ApexPages.currentPage().setCookies(new Cookie[]{remember});
        if(rememberUser){
            Cookie user = new Cookie('portalUser',username,null,315360000,false);
            ApexPages.currentPage().setCookies(new Cookie[]{user});
        }

        String startUrl = System.currentPageReference().getParameters().get('startURL');
        if (startUrl == null) {
            startUrl = '/home/home.jsp';
        }
 
        return Site.login(username, password, startUrl);
    }

     global ACPSiteLoginController () {
        Cookie remember = ApexPages.currentPage().getCookies().get('rememberPortalUser');
        Cookie user     = ApexPages.currentPage().getCookies().get('portalUser');
        if(remember != null){
            if ((remember.getValue() == 'true') && user != null) {
                rememberUser = true;
                username = user.getValue();
            }
        }else{
            rememberUser = false;
        }
     }

    @IsTest(SeeAllData=true) global static void testSiteLoginController () {
        // Instantiate a new controller with all parameters in the page
        ACPSiteLoginController controller = new ACPSiteLoginController ();
        controller.username = 'test@salesforce.com';
        controller.password = '123456'; 

        System.assertEquals(controller.login(),null);
    }    
}