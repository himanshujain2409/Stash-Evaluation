trigger A4A_AccountTrigger on Account (after update) {
    
    List<Concession_Request_CS__c> conRequests = new List<Concession_Request_CS__c>();
    List<Account> accounts = new List<Account>();
    
    Set<Id> accountIds= new Set<Id>();
    Set<Id> cancelledPSE = new Set<Id>();
    
    
    
    if(trigger.isafter  && trigger.isupdate) {
        accountIds = new Set<Id>();
        for(Account acct : trigger.new){
            
            if(acct.Approval_Status__c == 'Pending Approval' || acct.Approval_Status__c == 'Cancelled'){
                accountIds.add(acct.Id);
            } 
        }
        
        
          if(accountIds .size()>0){
        
            accounts = [Select Id, Approval_Status__c, (Select Id, Approval_Status__c From Concession_Requests_CS__r) From Account Where Id IN :accountIds];
            
            if(accounts.size()>0){
                for(Account acct: accounts){
                    if(acct.Concession_Requests_CS__r.size()>0){
                        for(Concession_Request_CS__c con: acct.Concession_Requests_CS__r){                        
                             if(acct.Approval_Status__c == 'Pending Approval' && (con.Approval_Status__c == 'Approval Required' || con.Approval_Status__c == 'Cancelled')){
                                 con.Approval_Status__c = acct.Approval_Status__c;
                                 conRequests.add(con); 
                             } else if(acct.Approval_Status__c == 'Cancelled' && con.Approval_Status__c == 'Pending Approval'){
                                 con.Approval_Status__c = acct.Approval_Status__c;
                                 conRequests.add(con);
                             }
                        }
                    } 
                }
            }
        }
        
        
        if(conRequests.size()>0){
            try{
                update conRequests;
            } 
            catch(exception e){
                system.debug('@@@@@@@@@@@@@@@@ Exception e: '+e.getMessage());
            }
            
        }
    }
}