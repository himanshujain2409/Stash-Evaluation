trigger beforeServiceRequestInsertUpdate on India_Service_Request__c (before insert, before update) {
    
    Id recordTypeId = [select id from recordtype where name ='Pre-Sales Sales Engineering' and SobjectType = 'India_Service_Request__c' limit 1].Id;
    Set <Id> userIdSet = new Set <Id>();//Set for all User Id's of owner, SE assigned to build,SE/PS assigned to service request
    Set <Id> queueIdSet = new Set <Id>();//Set for all queue Id's of owner, SE assigned to build,SE/PS assigned to service request
    
    List<User> userList = new List<User>();//List for all User's of owner, SE assigned to build,SE/PS assigned to service request
    List<Group> queuelist = new List<Group>();//List for all Queue's of owner, SE assigned to build,SE/PS assigned to service request
    //List<GroupMember> queueMemberList = new List<GroupMember>();
    Map<Id,String> userIdUserNameMap = new Map<Id,String>(); //Map that contains userId and name of user
    //Map<Id,String> queueIdQueueNameMap = new Map<Id,String>(); //Map that contains queue and name of queue
    Map<id,String> queueIdQueueMembersMap = new Map<Id,String>(); //Map that contains queue and name of all users in queue
    
    for(India_Service_Request__c serviceRequestObj : Trigger.new){    
        if(recordTypeId == serviceRequestObj.RecordTypeId){
            String idString = serviceRequestObj.Ownerid;
            if(idString.startsWith('00G')){
                queueIdSet.add(serviceRequestObj.Ownerid);
            }
            else{
                userIdSet.add(serviceRequestObj.Ownerid);
            }
            userIdSet.add(serviceRequestObj.SE_Assigned_to_Build__c); 
            userIdSet.add(serviceRequestObj.SE_Assigned_To_Request__c);
        }          
    }
    
    queuelist = [SELECT Id,Name,(SELECT GroupId,UserOrGroupId FROM GroupMembers) FROM Group where id in :queueIdSet];
    
    
    
    if(queuelist!=null && queuelist.size()>0){
        for(Group queueObj : queuelist){
            if(queueObj.GroupMembers!=null && queueObj.GroupMembers.size()>0){
                for(GroupMember queueMember : queueObj.GroupMembers){
                    userIdSet.add(queueMember.UserOrGroupId);
                }
            }
        }
    }
    
    userList = [select id, name from User where id in : userIdSet];
    
    if(userList!=null && userList.size()>0){
        for(User userObj : userList){
            userIdUserNameMap.put(userObj.id,userObj.name);
        }
    }
    
    if(queuelist!=null && queuelist.size()>0){
        for(Group queueObj : queuelist){
            String queueUsersName = '';
            //queueIdQueueNameMap.put(queueObj.id,queueObj.name);
            if(queueObj.GroupMembers!=null && queueObj.GroupMembers.size()>0){
                for(GroupMember queueMember : queueObj.GroupMembers){
                    if(userIdUserNameMap.containsKey(queueMember.UserOrGroupId)){
                        if(queueUsersName == '')
                            queueUsersName += userIdUserNameMap.get(queueMember.UserOrGroupId);
                        else{
                            queueUsersName += ', ';
                            queueUsersName += userIdUserNameMap.get(queueMember.UserOrGroupId);
                        }
                    }
                }
            }
            queueIdQueueMembersMap.put(queueObj.id,queueUsersName);
        }
    }
    
    
    for(India_Service_Request__c serviceRequestObj : Trigger.new){
        if(recordTypeId == serviceRequestObj.RecordTypeId){
            String ownerName = userIdUserNameMap.get(serviceRequestObj.ownerid);
            //String queueName = queueIdQueueNameMap.get(serviceRequestObj.ownerid);
            String queueUsersName = queueIdQueueMembersMap.get(serviceRequestObj.ownerid);
            String assignedToBuildName = userIdUserNameMap.get(serviceRequestObj.SE_Assigned_to_Build__c);
            String assignedToName = userIdUserNameMap.get(serviceRequestObj.SE_Assigned_To_Request__c);
            
            serviceRequestObj.SE_Team__c ='';
            
            String idString = serviceRequestObj.Ownerid;
            if(idString.startsWith('00G')){
                if(queueUsersName != null && queueUsersName != ''){
                    serviceRequestObj.SE_Team__c += queueUsersName;
                }
            }
            else{
                if(ownerName != null && ownerName != ''){
                    serviceRequestObj.SE_Team__c += ownerName;
                }
            }
            
            serviceRequestObj.SE_Team__c += ', ';
            
            if(assignedToBuildName != null && assignedToBuildName != ''){
                serviceRequestObj.SE_Team__c += assignedToBuildName;
            }
            
            serviceRequestObj.SE_Team__c += ', ';
            
            if(assignedToName != null && assignedToName != ''){
                serviceRequestObj.SE_Team__c += assignedToName;
            }
         }
    }
    
}