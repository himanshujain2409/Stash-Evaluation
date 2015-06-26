/*
* Controller for ApttusCustomerPortalOrganization component
* @author Copyright (c) 2012 Apttus.
* @author lferreira@altimetrik.com

*** Updated by Hemant on 04-21-2014
*** Implementation of ISR-04822
*** Dynamic Content based on profile on VF Page
*/ 
public with sharing class ACPOrganizationController {
    
    /* Contact with the account's information to display */
    
    public Contact contactInformation{get; set;}
    public Boolean IsRestrictedProfile {get; private set ;}
    SucessPortalOverrideProfile__c OverRideProfile;
    public Boolean IsTrainingAvailable {get; private set;}
    
    public Map<string,boolean> MapOfAvailableTabs {get; private set;}
    
    public transient FINAL string HOMETAB = 'Home';
    public transient FINAL string CASETAB = 'Case';
    public transient FINAL string KNOWLEDGETAB = 'Knowledge';
    public transient FINAL string DOCUMENTTAB = 'Document';
    public transient FINAL string IDEATAB = 'Ideas';
    public transient FINAL string TRAININGTAB = 'Training';
    public transient FINAL string INSTALLTAB = 'Install Center';
    
   
    
    
    public ACPOrganizationController(){
            
        
        /* get the current user */
        
        User currentUser = ACPUtils.getCurrentUser();
        IsTrainingAvailable = (currentUser.lmscons__Cornerstone_Id__c != null && currentUser.lmscons__Cornerstone_Id__c != '');
        System.debug('### currentUser' + currentUser);
        /* get the contact with the account information */
        
        List<Contact> contacts = [SELECT Account.Support_Level__c, Account.Name, Account.Case_Response_Time__c FROM Contact WHERE Id = :currentUser.ContactId LIMIT 1];
        
        if(contacts.size() > 0)
            contactInformation = contacts[0];
            
         if(MapOfAvailableTabs == null)
             MapOfAvailableTabs = new Map<string,boolean>();
        
         if (IsRestrictedProfile == null) {
            string CurrentProfileName = '';
           // List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
           // if(PROFILE != null)
             CurrentProfileName = currentUser.Profile_Name__c;
             IsRestrictedProfile = currentUser.Community_Profile__c;
             
             List<SucessPortalOverrideProfile__c> ListOfCustomSetting = new List<SucessPortalOverrideProfile__c>();
             ListOfCustomSetting = [SELECT Available_Tabs__c, Profile_Name__c FROM SucessPortalOverrideProfile__c 
                                                                         WHERE Profile_Name__c= :CurrentProfileName];
             if(ListOfCustomSetting.size() > 0) {
             OverRideProfile  =    ListOfCustomSetting[0];
             if(CurrentProfileName.toLowerCase() == OverRideProfile.Profile_Name__c.toLowerCase()) {
                 IsRestrictedProfile = true;
                 List<string> AvailableTabs = new List<string>();
                 AvailableTabs = OverRideProfile.Available_Tabs__c.split(',');
                 
                if(AvailableTabs.size() == 0)
                    AvailableTabs.add(OverRideProfile.Available_Tabs__c);
                
                for(string str: AvailableTabs) {
                    MapOfAvailableTabs.put(str,true);
                }
             }
            
           }
        }  
             
          FillBlankMapWithAllkey();
        
    }
    
   /* public string GetRenderDynamicStyle() {
        string DynamicString = '';
        if(IsRestrictedProfile) {
            DynamicString = '<script type="text/javascript">$(\'head\').append(\'alert(\'test message\');\\n<style type="text/css">';
            if (OverRideProfile != null && OverRideProfile.Available_Tabs__c != '') {
                    
                    if(str == HOMETAB) {
                        DynamicString += ' .nav-home active {dipslay:none;} ';
                    }
                    else if(str == CASETAB) {
                        DynamicString += ' .nav-cases {dipslay:none;} ';
                    }
                     else if(str == KNOWLEDGETAB) {
                        DynamicString += ' .nav-knowledge {dipslay:none;} ';
                    }
                     else if(str == DOCUMENTTAB) {
                        DynamicString += ' .nav-doc {dipslay:none;} ';
                    }
                     else if(str == IDEATAB ) {
                        DynamicString += ' .nav-ideas {dipslay:none;} ';
                    }
                     else if(str == TRAININGTAB ) {
                        DynamicString += ' .nav-training {dipslay:none;} ';
                    }
                     else if(str == INSTALLTAB ) {
                        DynamicString += ' .nav-downloads {dipslay:none;} ';
                    }
                
            }
          
          DynamicString += '</style>\');</script>';
        }
      return DynamicString;
    
    }*/
    
  void FillBlankMapWithAllkey() {
      if(MapOfAvailableTabs.get(HOMETAB) == null) {
            MapOfAvailableTabs.put(HOMETAB,false);
        }
        if(MapOfAvailableTabs.get(CASETAB) == null) {
            MapOfAvailableTabs.put(CASETAB,false);
        }
        if(MapOfAvailableTabs.get(KNOWLEDGETAB) == null) {
            MapOfAvailableTabs.put(KNOWLEDGETAB,false);
        }
        if(MapOfAvailableTabs.get(DOCUMENTTAB) == null) {
            MapOfAvailableTabs.put(DOCUMENTTAB,false);
        }
        if(MapOfAvailableTabs.get(IDEATAB) == null) {
            MapOfAvailableTabs.put(IDEATAB,false);
        }
        if(MapOfAvailableTabs.get(TRAININGTAB) == null) {
            MapOfAvailableTabs.put(TRAININGTAB,false);
        }
        if(MapOfAvailableTabs.get(INSTALLTAB) == null) {
            MapOfAvailableTabs.put(INSTALLTAB,false);
        }
      
  }
    
}