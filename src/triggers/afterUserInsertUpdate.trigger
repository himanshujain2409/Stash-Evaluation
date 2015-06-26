trigger afterUserInsertUpdate on User (after insert, after update) {
    //Get UserRole
    UserRole directorSalesEngineering = [select id, name, ParentRoleId from UserRole where name ='Director Sales Engineering' limit 1];
    //Get Child UserRole of "Director Sales Engineering"
    List<UserRole> childUserRoles = [Select Id from UserRole where ParentRoleId =: directorSalesEngineering.Id];
    Set<Id> childUserRoleIds = new Set<Id>();
    for(UserRole ur : childUserRoles) {
        childUserRoleIds.add(ur.Id);
    }
    childUserRoleIds.add(directorSalesEngineering.Id);
    boolean isDirectSalesEng = false;
    for(User newUser : Trigger.new){        
        for(Id childUserId : childUserRoleIds) {
            if(newUser.UserRoleId == childUserId) {
                isDirectSalesEng = true;        
            }    
        }
    }
    
    List<User> newUserList = new List<User>();
    If(Trigger.isInsert){
        for(User newUser : Trigger.new){
            if(newUser.UserRoleId != null && isDirectSalesEng){
                newUserList.add(newUser);
            }
        }
    }
    else if(Trigger.isUpdate){
        for(User newUser : Trigger.new){
            if(newUser.UserRoleId != null && newUser.UserRoleId != Trigger.oldMap.get(newUser.id).UserRoleId && isDirectSalesEng){
                newUserList.add(newUser);
            }
        }
    }
    
    if(newUserList.size() > 0){
        
        //Get Groups
        List<Group> groups = [Select Id from Group where type='Queue' and Name='Sales Engineering Queue' limit 1];
        
        //Get GroupMember
        Set<Id> queueUserIds = new Set<Id>();
        if(groups.size() > 0) {
            List<GroupMember> groupMembers = [Select UserOrGroupId From GroupMember where GroupId =: groups[0].id];
        
            for(GroupMember grpMemeber : groupMembers) {
                queueUserIds.add(grpMemeber.UserOrGroupId);    
            }
        }
        
        //Get all Users in Queue
        List<User> usersInQueue = [SELECT Id from User where Id in : queueUserIds];
        //List of GroupMembers to be added into Queue
        List<GroupMember> groupMembersList = new List<GroupMember>(); 
        for(User newUser : newUserList){
            for(User oldUser : usersInQueue){
                if(newUser.Id != oldUser.Id) {
                    GroupMember grpMember = new GroupMember();
                    grpMember.UserOrGroupId = newUser.Id; 
                    if(groups.size() > 0) {
                        grpMember.GroupId = groups[0].Id;
                        groupMembersList.add(grpMember);
                    }
                }    
            }
        }
    
        if(groupMembersList.size() > 0) {
            //Insert New User to Queue
            insert groupMembersList;
        }
    }
}