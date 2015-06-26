public class ApprovalRequestTrigger
{
    private ApprovalRequestTrigger() { }
    
    public static void PopulateAssignedToNameOnConcessionRequest(List<Apttus_Approval__Approval_Request__c> approvalRequestList) {   
        if(approvalRequestList.size() <= 0)
            return;
        
        Map<Id,String> mapApprovalUsers = new Map<Id,String>();
        Set<Id> setConcessionRequestIds = new Set<Id>();
        List<Concession_Request__c> ConcessionRequestList;
        Map<Id,Concession_Request__c>mapConcessionRequest;
        Map<Id,String> mapReassignApprovalUser = new Map<Id,String>();
        List<Account> accountList;
        Set<Id> setAccountIds = new Set<Id>();
        
        UpdateAccountConcessionRequestAssignedTo(approvalRequestList);
        
        for(Apttus_Approval__Approval_Request__c approvalRequest : approvalRequestList) {
            if(approvalRequest.Apttus_Approval__ChildObjectId__c != null && approvalRequest.Apttus_Approval__Assigned_To_Name__c != '' 
                        && (approvalRequest.Apttus_Approval__Approval_Status__c == 'Assigned' || approvalRequest.Apttus_Approval__Approval_Status__c == 'Reassigned')){
                     if(mapApprovalUsers.containskey(approvalRequest.Apttus_Approval__ChildObjectId__c)) {
                         String approvalUserName = mapApprovalUsers.get(approvalRequest.Id);
                         approvalUserName = approvalRequest.Apttus_Approval__Assigned_To_Name__c;
                         mapApprovalUsers.put(approvalRequest.Apttus_Approval__ChildObjectId__c ,approvalUserName );
                     }
                     else {
                         mapApprovalUsers.put(approvalRequest.Apttus_Approval__ChildObjectId__c ,approvalRequest.Apttus_Approval__Assigned_To_Name__c);
                     } 
                     
                     system.debug('@@@@@@@@@ approval Request ' + mapApprovalUsers);
                     setConcessionRequestIds.add(approvalRequest.Apttus_Approval__ChildObjectId__c);
                     if(approvalRequest.Apttus_Approval__Object_Id__c.startsWith('001')) {
                         setAccountIds.add(approvalRequest.Apttus_Approval__Object_Id__c);
                     }
                     
            }
            
        }
        
  
        if(setConcessionRequestIds.size() > 0) {
            ConcessionRequestList = [select Id,Current_Approval_User__c from Concession_Request__c where Id IN :setConcessionRequestIds];
            
            if(ConcessionRequestList.size() > 0) {
                mapConcessionRequest = new Map<Id,Concession_Request__c>(ConcessionRequestList);
                for(Apttus_Approval__Approval_Request__c approvalRequest : approvalRequestList) {
                   if(mapConcessionRequest.get(approvalRequest.Apttus_Approval__ChildObjectId__c) != null 
                       && approvalRequest.Apttus_Approval__Approval_Status__c == 'Assigned') {
                           Concession_Request__c cRequest = mapConcessionRequest.get(approvalRequest.Apttus_Approval__ChildObjectId__c);
                           cRequest.Current_Approval_User__c =  mapApprovalUsers.get(approvalRequest.Apttus_Approval__ChildObjectId__c);
                           mapConcessionRequest.put(approvalRequest.Apttus_Approval__ChildObjectId__c,cRequest);
                           system.debug('@@@@@@@@@ assigned concession Request ' + cRequest);
                   } else if(mapConcessionRequest.get(approvalRequest.Apttus_Approval__ChildObjectId__c) != null 
                                   && approvalRequest.Apttus_Approval__Approval_Status__c == 'Reassigned') {
                           Concession_Request__c cRequest = mapConcessionRequest.get(approvalRequest.Apttus_Approval__ChildObjectId__c);
                           cRequest.Current_Approval_User__c =  mapApprovalUsers.get(approvalRequest.Apttus_Approval__ChildObjectId__c);
                           mapConcessionRequest.put(approvalRequest.Apttus_Approval__ChildObjectId__c,cRequest);
                           system.debug('@@@@@@@@@ reassign concession Request ' + cRequest);
                   }

                }
            }
            if(ConcessionRequestList.size() > 0) {
                List<Concession_Request__c> ConcessionRequestToUpdate = new List<Concession_Request__c>();
                for(Concession_Request__c  cRequest : ConcessionRequestList) {
                    if(mapConcessionRequest.get(cRequest.Id) != null) {
                        system.debug('@@@@@@@@@ update concession Request ' + cRequest);
                        ConcessionRequestToUpdate.add(mapConcessionRequest.get(cRequest.Id));
                    }
                }
                
                update ConcessionRequestToUpdate;
            }
                
        }
        
        
        
        
    }
    
    private static void UpdateAccountConcessionRequestAssignedTo(List<Apttus_Approval__Approval_Request__c> approvalRequestList) {
        system.debug('@@@@@@@@@@@@@@@@@@@@@@@@ Update the Concession request on Account @@@@@@@@@@@@@@@@@@@@');
        Set<Id> setAccountIds = new Set<Id>();
        for(Apttus_Approval__Approval_Request__c approvalRequest : approvalRequestList) {
            if(approvalRequest.Apttus_Approval__Object_Id__c.startsWith('001')) {
               setAccountIds.add(approvalRequest.Apttus_Approval__Object_Id__c);
            }
        }
        
        system.debug('@@@@@@@@@@@@@@ Set of AccountIds size @@@@@@@@@@@@@@@@@@@@' + setAccountIds.size());
        List<Concession_Request_CS__c> concessionRequestList = new List<Concession_Request_CS__c>();
        set<string> concessionIdSet = new set<string>();
        if(setAccountIds.size() > 0) {
            List<Account> accountList = [select Id,(select Id,Currently_Assigned_To__c from Concession_Requests_CS__r) from Account Where Id IN :setAccountIds];
            system.debug('@@@@@@@@@@@@@@ List of accounts size @@@@@@@@@@@@@@@@@@@@' + accountList.size());
            if(accountList != null && accountList.size() > 0) {
                for(Account acct : accountList) {
                    system.debug('@@@@@@@@@@@@@@ List of Concession Request size @@@@@@@@@@@@@@@@@@@@' + acct.Concession_Requests_CS__r.size());
                    for(Concession_Request_CS__c cRequest : acct.Concession_Requests_CS__r) {
                          for(Apttus_Approval__Approval_Request__c approvalRequest : approvalRequestList) {
                              system.debug('@@@@@@@@@@@ approvalRequest child Object Id @@@@@@@@' + approvalRequest.Apttus_Approval__ChildObjectId__c);
                              system.debug('@@@@@@@@@@@ Concession request Id @@@@@@@@' + cRequest.Id);
                              if(approvalRequest.Apttus_Approval__ChildObjectId__c == cRequest.Id && approvalRequest.Apttus_Approval__Assigned_To_Name__c != '' 
                                        && (approvalRequest.Apttus_Approval__Approval_Status__c == 'Assigned'
                                                 || approvalRequest.Apttus_Approval__Approval_Status__c == 'Reassigned')) {
                                if(!concessionIdSet.contains(cRequest.Id)){
                                  Concession_Request_CS__c csRequest = new Concession_Request_CS__c();
                                  csRequest.Id = cRequest.Id;
                                  csRequest.Currently_Assigned_To__c = approvalRequest.Apttus_Approval__Assigned_To_Name__c;
                                  system.debug('csRequest before addition to concessionRequestList: '+csRequest);
                                  concessionRequestList.add(csRequest);
                                  concessionIdSet.add(csRequest.Id);
                                }
                                 
                              }
                          }
                    }
               }
            }
            
        }
        
        system.debug('@@@@@@@@@@@@@@ List of Update Concession Request size @@@@@@@@@@@@@@@@@@@@' + concessionRequestList.size());

        system.debug('@@@@@@@@@@@@@@ List of Update Concession Request  @@@@@@@@@@@@@@@@@@@@' + concessionRequestList);

        if(concessionRequestList.size() > 0) {
            update concessionRequestList;
        }
        
    }
    
    
}