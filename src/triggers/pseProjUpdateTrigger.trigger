trigger pseProjUpdateTrigger on pse__Proj__c (after update) {
    
    List<Concession_Request__c> conRequests = new List<Concession_Request__c>();
    List<pse__Proj__c> projects = new List<pse__Proj__c>();
    Set<Id> pseIds= new Set<Id>();
    Set<Id> cancelledPSE = new Set<Id>();
    
    if(trigger.isAfter && trigger.isUpdate){
        
        for(pse__Proj__c  pse: trigger.new){
            
            if(pse.Approval_Status__c == 'Pending Approval' || pse.Approval_Status__c == 'Cancelled'){
                pseIds.add(pse.Id);
            } 
        }
        
        if(pseIds.size()>0){
        
            projects = [Select Id, Approval_Status__c, (Select Id, Approval_Status__c From Concession_Requests__r) From pse__Proj__c Where Id IN:pseIds];
            
            if(projects.size()>0){
                for(pse__Proj__c  pses: projects){
                    if(pses.Concession_Requests__r.size()>0){
                        for(Concession_Request__c con: pses.Concession_Requests__r){                        
                             if(pses.Approval_Status__c == 'Pending Approval' && (con.Approval_Status__c == 'Approval Required' || con.Approval_Status__c == 'Cancelled')){
                                 con.Approval_Status__c = pses.Approval_Status__c;
                                 conRequests.add(con); 
                             } else if(pses.Approval_Status__c == 'Cancelled' && con.Approval_Status__c == 'Pending Approval'){
                                 con.Approval_Status__c = pses.Approval_Status__c;
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