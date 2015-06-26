public class UpdateContactInfoTriggerHandler{
    public UpdateContactInfoTriggerHandler(){
    
    }
    
    public static void UpdateContactCountOnAccount(set<id> AccountIDs){
        List<account> ListOfAcc = [select id,Number_Of_Contacts__c,(select id,Active_Portal_User__c from contacts) from account where id in:AccountIDs];
        for (account acc:ListOfAcc){
            if (acc.Number_Of_Contacts__c==null || acc.Number_Of_Contacts__c !=acc.contacts.size())
                acc.Number_Of_Contacts__c =acc.contacts.size();
            integer PortUserCount = 0;
            for(contact con: acc.contacts)
                if (con.Active_Portal_User__c == true)
                    PortUserCount = PortUserCount + 1;
            acc.Number_Of_Active_Portal_Users__c = PortUserCount;
            
        }
        update ListOfAcc;
    }
    
    public void OnAfterInsertOrUpdate(User[] newUsers){
        Set<Id> contactIds = new Set<Id>();
        for(User user : newUsers){
            if(user.ContactId != null){
                contactIds.add(user.ContactId);
            }
        }
        if(contactIds.size() > 0){
            setContactInfo(contactIds);
        }
    }
    @future
    public static void setContactInfo(Set<Id> contactIdSet){
        Map<Id,User> mapContactIdProfileName = new Map<Id,User>();
        for(User u : [Select Id, IsActive, ContactId, LastLoginDate, Profile.Name from User where ContactId In : contactIdSet]){
            mapContactIdProfileName.put(u.ContactId, u);
        }
        List<Contact> contactListForUpdate = new List<Contact>();
        for(Contact cont : [Select Id, Name from contact where Id In : contactIdSet]){
            User usr = mapContactIdProfileName.get(cont.Id);
            cont.Active_Portal_User__c = usr.IsActive;
            cont.Portal_Profile__c = usr.Profile.Name;
            cont.Last_Login__c = String.valueOf(usr.LastLoginDate);
            contactListForUpdate.add(cont);
        }
        
        if(contactListForUpdate.size() > 0){
            update contactListForUpdate;
        }
    }

}