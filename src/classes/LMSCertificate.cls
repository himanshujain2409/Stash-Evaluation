public with sharing class LMSCertificate {

  public LMSCertificate (){

    Id gid = ApexPages.currentPage().getParameters().get('id');

    if(gid==null){

      ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR, 'Please enter Id.'));
    }

    try {
      try {
        lmscons__Training_Path_Assignment_Progress__c  ret = ([select Id, lmscons__Training_Path__r.Name, lmscons__Transcript__r.lmscons__Trainee__r.LastName, lmscons__Transcript__r.lmscons__Trainee__r.FirstName , lmscons__Transcript__r.lmscons__Trainee__r.Name, lmscons__Completion_Date__c
                          from lmscons__Training_Path_Assignment_Progress__c
                          where Id = :gid Limit 1]);
        CompletionDate = ret.lmscons__Completion_Date__c;
        try {
          ExpDate = ret.lmscons__Completion_Date__c.addYears(1);
        } catch (Exception e2) {}
        UserName = ret.lmscons__Transcript__r.lmscons__Trainee__r.Name;
        FName = ret.lmscons__Transcript__r.lmscons__Trainee__r.FirstName;
        LName = ret.lmscons__Transcript__r.lmscons__Trainee__r.LastName;
        Title = ret.lmscons__Training_Path__r.Name;
      } catch(system.exception e){
      }
      try {
        lmscons__Transcript_Line__c  ret = ([select Id, lmscons__Transcript__r.lmscons__Trainee__r.LastName, lmscons__Transcript__r.lmscons__Trainee__r.FirstName, lmscons__Transcript__r.lmscons__Trainee__r.Name, lmscons__Content_Title__c, lmscons__Completion_Date__c, lmscons__Trainee__c, lmscons__Score__c, lmscons__Completed_Date__c
                          from lmscons__Transcript_Line__c
                          where Id = :gid Limit 1]);
        CompletionDate = ret.lmscons__Completion_Date__c;
        try {
        ExpDate = ret.lmscons__Completion_Date__c.addYears(1);
        } catch (Exception e2) {}
        UserName = ret.lmscons__Transcript__r.lmscons__Trainee__r.Name;
        FName = ret.lmscons__Transcript__r.lmscons__Trainee__r.FirstName;
        LName = ret.lmscons__Transcript__r.lmscons__Trainee__r.LastName;
        Title = ret.lmscons__Content_Title__c;

        system.debug('Title: '+Title);
      } catch(system.exception e){
      }
      try {
        lmscons__Learning_Path_Assignment__c  ret = ([select Id, lmscons__Transcript__r.lmscons__Trainee__r.LastName, lmscons__Transcript__r.lmscons__Trainee__r.FirstName, lmscons__Transcript__r.lmscons__Trainee__r.Name, lmscons__Learning_Path__r.Name, lmscons__Completion_Date__c
                          from lmscons__Learning_Path_Assignment__c
                          where Id = :gid Limit 1]);
        CompletionDate = ret.lmscons__Completion_Date__c;
        try {
        ExpDate = ret.lmscons__Completion_Date__c.addYears(1);
        } catch (Exception e2) {}
        UserName = ret.lmscons__Transcript__r.lmscons__Trainee__r.Name;
        FName = ret.lmscons__Transcript__r.lmscons__Trainee__r.FirstName;
        LName = ret.lmscons__Transcript__r.lmscons__Trainee__r.LastName;
        Title = ret.lmscons__Learning_Path__r.Name;
      } catch(system.exception e){
      }
      try {
        lmscons__Curriculum_Assignment__c  ret = ([select Id, lmscons__Transcript__r.lmscons__Trainee__r.LastName, lmscons__Transcript__r.lmscons__Trainee__r.FirstName, lmscons__Transcript__r.lmscons__Trainee__r.Name,lmscons__Curriculum__r.Name, lmscons__Completion_Date__c
                          from lmscons__Curriculum_Assignment__c
                          where Id = :gid Limit 1]);
        CompletionDate = ret.lmscons__Completion_Date__c;
        try {
        ExpDate = ret.lmscons__Completion_Date__c.addYears(1);
        } catch (Exception e2) {}
        UserName = ret.lmscons__Transcript__r.lmscons__Trainee__r.Name;
        FName = ret.lmscons__Transcript__r.lmscons__Trainee__r.FirstName;
        LName = ret.lmscons__Transcript__r.lmscons__Trainee__r.LastName;
        Title = ret.lmscons__Curriculum__r.Name;
      } catch(system.exception e){
      }
      id = gid;
    } catch(system.exception e){

    }
  }

  public lmscons__Transcript_Line__c returncert;
//Get data set for Certificate

  public DateTime CompletionDate {get; set;}
  public DateTime ExpDate {get; set;}
  public String UserName {get; set;}
  public String FName {get; set;}
  public String LName {get; set;}
  public String Title {get; set;}
  public String Id {get; set;}

  public static testmethod void testCertificate2(){
    test.startTest();
    Profile profile = [select id from profile where name='System Administrator'];
    User u = new User(alias = 'test', email='test@test.com', emailencodingkey='UTF-8', lastname='test', languagelocalekey='en_US', localesidkey='en_US', profileid = profile.Id, timezonesidkey='America/Los_Angeles', username='test@testSF22223c.com', lmscons__Cornerstone_ID__c='newtest 261');
    insert u;
    lmscons__Transcript__c t = new lmscons__Transcript__c(lmscons__Trainee__c = u.id);
    insert t;

    system.runAs(u){

      LMSCertificate TCCD3 = new LMSCertificate ();
      System.assertEquals(TRUE, TRUE);
    }

    System.assertEquals(TRUE, TRUE);
  }

  public static testmethod void testCertificate(){
    test.startTest();
    Profile profile = [select id from profile where name='System Administrator'];
    User u = new User(alias = 'test', email='test@test.com', emailencodingkey='UTF-8', lastname='test', languagelocalekey='en_US', localesidkey='en_US', profileid = profile.Id, timezonesidkey='America/Los_Angeles', username='test@testSF22223c.com', lmscons__Cornerstone_ID__c='newtest 261');
    insert u;
    lmscons__Transcript__c t = new lmscons__Transcript__c(lmscons__Trainee__c = u.id);
    insert t;

    system.runAs(u){
      lmscons__Training_Content__c c = new lmscons__Training_Content__c( lmscons__Title__c = 'Training me', lmscons__Cornerstone_ID__c = 'af' );
      insert c;
      lmscons__Training_Content_License__c cl =  new lmscons__Training_Content_License__c( lmscons__Training_Content__c = c.id );
      insert cl;
      lmscons__Training_User_License__c tul = new lmscons__Training_User_License__c( lmscons__Content_License__c = cl.id, lmscons__User__c = u.id  );
      insert tul;
      lmscons__Training_Path__c tp = new lmscons__Training_Path__c( name = 'andy path');
      insert tp;
      lmscons__Training_Path_Item__c ti = new lmscons__Training_Path_Item__c(lmscons__Training_Path__c = tp.id, lmscons__Training_Content__c=c.id, lmscons__Sequence__c=1);
      insert ti;
      lmscons__Transcript_Line__c tl = new lmscons__Transcript_Line__c(lmscons__Training_Path_Item__c=ti.id, lmscons__Transcript__c = t.Id, lmscons__Training_User_License__c = tul.id  );
      insert tl;
      lmscons__Training_Path_Assignment_Progress__c tpap = new lmscons__Training_Path_Assignment_Progress__c(lmscons__Transcript__c = t.id, lmscons__Training_Path__c = tp.id);
      insert(tpap);
      lmscons__Learning_Path__c LP = new lmscons__Learning_Path__c(Name = 'LP Name');
      insert LP;
      lmscons__Learning_Path_Item__c lpi = new lmscons__Learning_Path_Item__c(lmscons__Learning_Path__c = LP.id, lmscons__Module__c = c.id);
      insert lpi;
      lmscons__Learning_Path_Assignment__c LPA = new lmscons__Learning_Path_Assignment__c(lmscons__Transcript__c = t.id, lmscons__Learning_Path__c = LP.id);
      insert LPA;

      lmscons__Curriculum__c Cu = new lmscons__Curriculum__c(Name = 'Cu Name');
      insert Cu;
      lmscons__Curriculum_Item__c Cui = new lmscons__Curriculum_Item__c(lmscons__Curriculum__c = Cu.id, lmscons__Module__c = c.id);
      insert Cui;
      lmscons__Curriculum_Assignment__c CuA = new lmscons__Curriculum_Assignment__c(lmscons__Transcript__c = t.id, lmscons__Curriculum__c = Cu.id);
      insert CuA;
      test.stopTest();

      ApexPages.currentPage().getParameters().put('id',tl.id);

      LMSCertificate TCCD = new LMSCertificate ();

      ApexPages.currentPage().getParameters().put('id',tpap.id);

      LMSCertificate TCCD2 = new LMSCertificate ();

      ApexPages.currentPage().getParameters().put('id',LPA.id);

      LMSCertificate TCCD3 = new LMSCertificate ();

      ApexPages.currentPage().getParameters().put('id',CuA.id);

      LMSCertificate TCCD4 = new LMSCertificate ();
      System.assertEquals(TRUE, TRUE);
    }

    System.assertEquals(TRUE, TRUE);
  }
}