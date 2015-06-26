public class APTPS_RequestOrderFormController {

    public Id quoteId;
    public Apttus_Proposal__Proposal__c proposal;

    public APTPS_RequestOrderFormController() {
        quoteId = ApexPages.CurrentPage().getParameters().get('id');
        system.debug('**** quoteId : ' + quoteId );
        if(quoteId != null) {
            proposal = [select Id,Name, Apttus_Proposal__Account__r.Name, OwnerId, Apttus_Proposal__Opportunity__r.Name,
                        Apttus_Proposal__Proposal_Name__c, Apttus_Proposal__Description__c, Apttus_Proposal__Valid_Until_Date__c,
                        Apttus_Proposal__Primary_Contact__r.Name
                        from Apttus_Proposal__Proposal__c where id =: quoteId];
            system.debug('**** proposal : ' + proposal);
        }
    }
    
    public Pagereference sendEmail() {
        String messageBody;
        String ownerName = '';
        List<User> user = [select name, email, firstName, lastName from User where id = :proposal.OwnerId];
        if(user != null && user.size() > 0) {
            ownerName = user[0].Name;
        }
        Messaging.SingleEmailMessage EMail = new Messaging.Singleemailmessage();
        EMail.setToAddresses(new String[]{'salesoperations@apttus.com'});
        EMail.setSubject('Order Form Request for Quote/Proposal ' + proposal.Apttus_Proposal__Opportunity__r.Name + ' has been submitted for your review.');
        messageBody = '<html><body>' +
        'Dear Sales Operations: '+ '</br></br>' +
        'Order Form Request for Quote/Proposal ' + proposal.Apttus_Proposal__Opportunity__r.Name + ' has been submitted for your review.'+ '</br></br>' +
        'Account Name:' + proposal.Apttus_Proposal__Account__r.Name + '</br>' + 
        'Quote/Proposal Number :' + proposal.Name + '</br>' +
        'Quote/Proposal Name :' + proposal.Apttus_Proposal__Proposal_Name__c+ '</br>' +
        'Quote/Proposal Description :' + proposal.Apttus_Proposal__Description__c+ '</br>' +
        'Quote/Proposal Owner FullName :' + ownerName + '</br>' +
        'Quote/Proposal Primary contact :' + proposal.Apttus_Proposal__Primary_Contact__r.Name+ '</br>' +
        'Quote/Proposal Valid Until Date :' + proposal.Apttus_Proposal__Valid_Until_Date__c+ '</br></br>' +
         'Click : <a href="https://cs4.salesforce.com/' +proposal.Id + '"> here</a>' + ' to access the Quote/Proposal' +
        '</body></html>';
        EMail.setHtmlBody(messageBody);
        Messaging.sendEmail(new Messaging.Singleemailmessage[]{ EMail });
    
        Pagereference pageRef = new Pagereference('/'+quoteId);
        return pageRef;

    }
}