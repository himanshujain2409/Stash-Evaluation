/*
    Name : AddContact_QTCCampaign
    Created on : 4/21/2014
    Description : This Trigger will pefrorm following actions:
            1. When contact is created(Actually Note Created) by TestCraft,system will check if there is any lead with same email. 
            If found, it will attach the note under it and delete the contact. But if the lead is not found then system will 
                first create lead and then attach note to it and delete contact.
            2. Add Leads/Contacts to 'QTC Campaign' when they take assessment from TestCraft and passes it.
*/

Trigger AddContact_QTCCampaign on Note (Before Insert){

    Set<Id> setContactIds = New Set<Id>();                       // Set of Contact Ids
    List<Contact> lstContact = New List<Contact>();              // List of contacts to which the note is associated
    Map<Id, String> MapContactIdtoEmail = New Map<Id, String>(); // Map storing Contact Id and Contact Email
    Map<String, Lead> MapEmailtoLead = New Map<String, Lead>();  // Map Storing Email and Lead
    Map<String, Lead> MapInsertLead = New Map<String, Lead>();   // Map Storing Email and newly created lead
    List<Contact> lstDeleteContacts = New List<Contact>();       // List of Contacts to be deleted
    
    Set<Id> SetExistingMemberIds = New Set<Id>();                // Set of Contact / Lead ids already present under Campaign
    List<Id> lstMemberIds = New List<Id>();                      // List of Contact / Lead ids to be added to Campiagn
    
    // Query the Account where all the contacts are associated created by TestCraft    
    List<Account> lstQTCAccount = [Select Id, Name from Account where Name = :Label.QTC_Account_Name limit 1];

    if( lstQTCAccount.size() == 1)
    {
        For( Note resultnote : Trigger.New )
        {
            if( resultnote.ParentId != null && String.ValueOf(resultnote.ParentId).left(3) == Contact.sObjectType.getDescribe().getKeyPrefix() )
                setContactIds.add(resultnote.ParentId);
        }
        
        if( setContactIds.size()>0 )
        {
            // Qury related Contacts
            lstContact = [ Select Id, Email, AccountId, FirstName, LastName from Contact where Id IN: setContactIds and AccountId = :lstQTCAccount[0].Id and Email != null ];
            
            For( Contact con : lstContact )
            {
                MapContactIdtoEmail.put(con.Id, con.Email);
            }

            if( MapContactIdtoEmail.KeySet().size() > 0 )
            {  
                // Fetch all Leads having matching email ids
                For( Lead l : [ Select Id, Email, IsConverted From Lead where Email IN: MapContactIdtoEmail.Values() ] )
                {
                    MapEmailtoLead.put(l.Email, l);
                }
                
                For( Contact con : lstContact )
                {
                    // Create new Lead with same Email if it does not exist in database & Delete Contact
                    if( !MapEmailtoLead.KeySet().Contains(con.Email) )
                    {
                        Lead l = New Lead();
                        l.FirstName = con.FirstName;
                        l.LastName = con.LastName;
                        l.Email = con.Email;
                        l.Company = lstQTCAccount[0].Name;
                        MapInsertLead.put(l.Email, l);  
                        
                        lstDeleteContacts.add(con);
                    }
                    // Delete Contact if Non-Converted Lead is present with same email
                    else if( MapEmailtoLead.get(con.Email) != null && MapEmailtoLead.get(con.Email).IsConverted == FALSE )
                    {
                        lstDeleteContacts.add(con);                                                                                              
                    }
                }
                
                if( MapInsertLead.KeySet().size()>0 )
                    Insert MapInsertLead.Values();
            }
        }
    }    

    FOr( Note resultnote : Trigger.New )
    {
        // Re-Parent the note record to corresponding Lead record
        if( MapContactIdtoEmail.get(resultnote.ParentId) != null )
        {
            // If Existing Lead is found & Lead is non-converted
            if( MapEmailtoLead.get(MapContactIdtoEmail.get(resultnote.ParentId)) != null && MapEmailtoLead.get(MapContactIdtoEmail.get(resultnote.ParentId)).IsConverted == False )
                resultnote.ParentId = MapEmailtoLead.get(MapContactIdtoEmail.get(resultnote.ParentId)).Id;
            // If New Lead was creaated            
            else if( MapInsertLead.get(MapContactIdtoEmail.get(resultnote.ParentId)) != null )
                resultnote.ParentId = MapInsertLead.get(MapContactIdtoEmail.get(resultnote.ParentId)).Id;
        }
        
        // Check if Note title & Body contains specific text.
        if( resultnote.Title.Contains(Label.TestCraft_Note_Title_Text) && resultnote.Body.Contains(Label.TestCraft_Note_Body_Text) )
        {
            lstMemberIds.add(resultnote.ParentId);
        }
    }
    
    if( lstMemberIds.size()>0 )
    {
        List<Campaign> QTCCampaign = [ Select Id From Campaign where Name = :Label.QTC_Campaign_Name limit 1];
        
        List<CampaignMember> lstCampaignMember = New List<CampaignMember>();
        
        if( QTCCampaign.size() == 1 )
        {
            // Fetch Existing Campaign Members from QTC Campaign
            For( CampaignMember cmpmember : [Select Id, LeadId, ContactId From CampaignMember where CampaignId = :QTCCampaign[0].Id ] )
            {
                if( cmpmember.LeadId != null )
                    SetExistingMemberIds.add(cmpmember.LeadId);
                if( cmpmember.ContactId != null )
                    SetExistingMemberIds.add(cmpmember.ContactId);
            }

            For( Id MemberId : lstMemberIds )
            {
                // Add Member only if it is not already present
                if( !SetExistingMemberIds.Contains(MemberId) )
                {
                    CampaignMember member = New CampaignMember();
                    member.CampaignId = QTCCampaign[0].Id;
                    if( String.ValueOf(MemberId).left(3) == Contact.sObjectType.getDescribe().getKeyPrefix() )
                        member.ContactId = MemberId;
                    else
                        member.LeadId = MemberId;
                    lstCampaignMember.add(member);
                }
            }
            
            if( lstCampaignMember.size() > 0 )
            {
                insert lstCampaignMember;
            }
        }
    }
    
    if( lstDeleteContacts.size()>0 )
        Delete lstDeleteContacts;
}