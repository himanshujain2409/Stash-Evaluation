public class OauthClass {


   /*
     Test environment
    private static final String SERVER = 'https://test.salesforce.com';
    private static final String USERNAME = 'czhang@apttus.com.cathys';
    private static final String PASSWORD = 'Quick898';
    private static final String CLIENT_ID = '3MVG982oBBDdwyHiyPqpgWDHSNH8atLc5G9agOrTiAcvaAw2shQpsj1FnKEzcwS92Txhb_hAjsjEH0sQepxyN';
    private static final String CLIENT_SECRET = '2270000687959203452';

    */

     // Production setting
    private static final String SERVER = 'https://login.salesforce.com';
    private static final String USERNAME = 'czhang@apttus.com';
    private static final String PASSWORD = 'Quick898';
    private static final String CLIENT_ID = '3MVG9Km_cBLhsuPwrQaHfR9kFRz.cpO_sTju30NMyi2mBH_4vxEsI680wwQc75WLLJGpef5hXZGUL2PXfqkzA';
    private static final String CLIENT_SECRET = '3830806544999024591';


    public String firstName {get; set;}
    public String lastName  {get; set;}
    public String Company   {get; set;}
    public String SignupEmail     {get; set;}
    public String Country   {get; set;}
    public String signupusername  {get; set;} 
 
    public String description  {get; set;}

    public String resBody   {get; set;}
    public String resBody2  {get; set;}

    public String accessToken    {get; set;}
    public String instanceUrl    {get; set;}

    public Boolean submitted    {get; set;}


    public OauthClass() {

        resBody = 'resBody';
        resBody2 = 'resBody2';
        submitted = false;
    }

    public PageReference login() {
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        String body = '';

        body += 'grant_type=' + EncodingUtil.urlEncode('password', 'UTF-8');
        body += '&client_id=' + EncodingUtil.urlEncode(CLIENT_ID, 'UTF-8');
        body += '&client_secret=' + EncodingUtil.urlEncode(CLIENT_SECRET, 'UTF-8');
        body += '&username=' + EncodingUtil.urlEncode(USERNAME, 'UTF-8');
        body += '&password=' + EncodingUtil.urlEncode(PASSWORD, 'UTF-8');

        req.setEndpoint(SERVER + '/services/oauth2/token');
        req.setMethod('POST');
        req.setBody(body);
        // otherwise we hit a limit of 32000
        // req.setCompressed(true);
        System.debug('Callout: ' + req.getEndpoint()  + 'body: ' + req.getBody());
        if (!Test.isRunningTest()) {
        try {
            res = h.send(req);
        } catch (System.CalloutException e) {
            System.debug('Callout error: ' + e);
            System.debug(res.toString());
        }
        
        resBody = res.getBody();
        } else {
          resBody = '{"id":"https://test.salesforce.com/id/00DW0000008wO4kMAE/00550000003hEIlAAM","issued_at":"1415925199207","token_type":"Bearer","instance_url":"https://apttus--Cathys.cs13.my.salesforce.com","signature":"dIS3gFiBG//jWmgfDbtgHPxqrEWnkgBJMnIVKBPFh5Q=","access_token":"00DW0000008wO4k!ARMAQL37flJ5As1ARi_gwv5wN29bQWbkPD2exIdpJVgeFjsKG5sEPptzMg9Yubyt9E.qPKNCBmbEpvYLQCMNuzGlqrwneWdU"}';

        }
        system.debug('resBody is' + resBody);
        Map<String, Object> mapRes = (Map<String, Object>)JSON.deserializeUntyped(resBody);

        accessToken = (String)mapRes.get('access_token');
        instanceUrl = (String)mapRes.get('instance_url');
        
        system.debug('accessToken is ' + accessToken);
        system.debug('instanceUrl is ' +  instanceUrl);
      
        req.setEndpoint(instanceUrl + '/services/data/v32.0/sobjects/SignupRequest/');
        req.setMethod('POST');
        req.setHeader('Authorization','Bearer ' + accessToken);
        req.setHeader('Content-Type', 'application/json');
        req.setBody(createResponse());

        System.debug('request again: ' + req.getBody());
        if (!Test.isRunningTest()) {
        try {
            res = h.send(req);
        } catch (System.CalloutException e) {
            System.debug('Callout error: ' + e);
            System.debug(res.toString());
        }

        resBody2 = res.getBody();
        }
        system.debug('resBody2 '+ resBody2);
        submitted = true;
        return null;

    }

     public String createResponse(){

        List<TSOTemplate__c> templates = new List<TSOTemplate__c>();
        templates = [select name, TemplateID__c from TSOTemplate__c where name = 'SFDCSpin'];

        JSONGenerator responseJson = Json.createGenerator(true);

        responseJson.writeStartObject();
        responseJson.writeStringField('FirstName', firstName);
        responseJson.writeStringField('LastName', lastName);
        responseJson.writeStringField('Company', Company);
        responseJson.writeStringField('SignupEmail', SignupEmail);
        responseJson.writeStringField('Country', Country);
        responseJson.writeStringField('Username', signupusername);
        responseJson.writeStringField('TemplateId', templates[0].TemplateID__c);
        responseJson.writeStringField('description__c', description);
        responseJson.writeStringField('Source_MDO__c', 'External Org');


        responseJson.writeEndObject();
        System.debug(responseJson.getAsString());

        return responseJson.getAsString();

    }

    

   
}