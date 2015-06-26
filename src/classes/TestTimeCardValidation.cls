@isTest
public class TestTimeCardValidation {

    static testmethod void TimeCardValidation()
    {
        test.startTest();
        Profile pr = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
      User u = new User(Alias = 'test', Email='tcuser@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='testtc', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = pr.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='tcuser@testorg.com');
      System.runAs(u) {
         // The following code runs as user 'u' 
        DateTime dt = System.now() ;
        Date d = dt.date();
        
        DateTime dt1 = System.now() +6;
        Date d1 = dt1.date();
        pse__Work_Calendar__c wc = new pse__Work_Calendar__c();
        wc.Name= 'US Calender';
        wc.pse__Monday_Hours__c = 8;
          wc.pse__Monday_Hours__c = 8;
         /* wc.pse__Tuesday_Hours__c = 8;
          wc.pse__Wednesday_Hours__c = 8;
          wc.pse__Thursday_Hours__c = 8;
          wc.pse__Friday_Hours__c = 8;
          wc.pse__Saturday_Hours__c = 0;
          wc.pse__Saturday_Hours__c = 0;
          wc.pse__Standard_Hours_Per_Day__c = 8;
          wc.pse__Week_Start_Day__c='Sunday';*/
        insert wc;
          
        pse__Region__c parentrg = new pse__Region__c();
        parentrg.Name = 'Us Region';
        parentrg.CurrencyIsoCode = 'USD';
        parentrg.pse__Default_Work_Calendar__c = wc.Id;
        parentrg.pse__Hierarchy_Depth__c =0; 
        insert parentrg;
        
        pse__Region__c prg = new pse__Region__c();
        prg.Name = 'Us Region';
        prg.CurrencyIsoCode = 'USD';
        prg.pse__Default_Work_Calendar__c = wc.Id;
        prg.pse__Parent_Region__c = parentrg.Id;
        prg.pse__Headquarters_Region__c = parentrg.Id;
        prg.pse__Hierarchy_Depth__c =1;
        insert prg;
          
          pse__Permission_Control__c pcs = new pse__Permission_Control__c();
          pcs.pse__User__c = u.Id;
          pcs.CurrencyIsoCode = 'USD';
          pcs.pse__Cascading_Permission__c = true;
          pcs.pse__Region__c = parentrg.Id;
          pcs.pse__Staffing__c = true;
          pcs.pse__Resource_Request_Entry__c = true;
          pcs.pse__Timecard_Entry__c = true;
          pcs.pse__Timecard_Ops_Edit__c = true;
          insert pcs;
          
          Account ac=  new Account();
          ac.Name= 'TestAcc';
          ac.CurrencyIsoCode = 'USD';
          insert ac;
          
        Contact pm= new Contact();
        pm.FirstName ='Pm';
        pm.LastName ='User1';
        pm.pse__Is_Resource__c = true;
        pm.pse__Is_Resource_Active__c = true;
        pm.pse__Work_Calendar__c = wc.Id;
        pm.pse__Region__c = prg.Id;
        pm.AccountId = ac.Id;
        insert pm;
       
        
        DateTime ps1 = System.now() -30;
        Date psd1 = ps1.date();
        DateTime pe1 = System.now() +60;
        Date ped1 = pe1.date();
        
        pse__Proj__c p = new pse__Proj__c();
        p.Name = 'ProjectTest';
        p.pse__Is_Active__c = true;
        p.CurrencyIsoCode = 'USD';
        p.Actual_Start_Date__c= Date.newInstance(2015, 04, 17) ;
        p.Actual_End_Date__c = Date.newInstance(2016, 04, 17);
        p.SOW_Amount__c = 1000;
        p.pse__Region__c = prg.Id;
        p.Billing_Rate__c=100;
        p.pse__Is_Billable__c = true;
          p.pse__Stage__c = 'Planned';
          p.pse__Project_Phase__c = 'Planning';
          p.pse__Project_Manager__c = pm.Id;
          p.pse__Account__c = ac.Id;
        insert p;
        
        
        Contact c= new Contact();
        c.FirstName ='abc';
        c.LastName ='xyz';
        c.AccountId = ac.Id;
        c.pse__Is_Resource__c = true;
        c.pse__Is_Resource_Active__c = true;
        c.pse__Work_Calendar__c = wc.Id;
        c.pse__Region__c = prg.Id;
        insert c;
        
        DateTime st = System.now()+6 ;
        Date sd = st.date();
        DateTime et = System.now() +60;
        Date ed = et.date();
        pse__Schedule__c ps = new pse__Schedule__c();
        ps.pse__Start_Date__c = Date.newInstance(2015, 04, 17);
        ps.pse__End_Date__c = Date.newInstance(2016, 04, 17);
        ps.pse__Monday_Hours__c = 8;
        /*ps.pse__Tuesday_Hours__c = 8;
        ps.pse__Wednesday_Hours__c = 8;
        ps.pse__Thursday_Hours__c = 8;
        ps.pse__Friday_Hours__c = 8;
        ps.pse__Saturday_Hours__c = 8;
        ps.pse__Sunday_Hours__c = 8;*/
        insert ps;
        
        DateTime str = System.now()+7 ;
        Date sdr = str.date();
        DateTime etr = System.now() +55;
        Date edr = etr.date();
        pse__Assignment__c pac = new pse__Assignment__c();
        pac.Name='Sample Assign';
        pac.pse__Resource__c = c.Id;
        pac.pse__Project__c = p.Id;
        pac.pse__Role__c = 'Developer';
        pac.CurrencyIsoCode = 'USD';
        pac.pse__Schedule__c = ps.Id;
        pac.pse__Bill_Rate__c = 0;
        pac.pse__Cost_Rate_Amount__c = 0;
        pac.End_Date__c = Date.newInstance(2016, 01, 17);
        //pac.pse__Status__c = 'Scheduled';
        //pac.pse__Percent_Allocated__c = 0;
        pac.pse__Schedule_Updated__c = false;
        pac.pse__Is_Billable__c = true;
        insert pac;
          List<pse__Assignment__c> OAssigmentList = new  List<pse__Assignment__c>([select Name,pse__Resource__c,pse__Project__c,
                                                                                   pse__Role__c,CurrencyIsoCode,pse__Schedule__c,
                                                                                   pse__Bill_Rate__c,pse__Cost_Rate_Amount__c,
                                                                                   End_Date__c,pse__Schedule_Updated__c,pse__Is_Billable__c 
                                                                                   from pse__Assignment__c]);
        
          pse__Timecard_Header__c pth = new pse__Timecard_Header__c();
        pth.pse__Start_Date__c = d;
        pth.pse__End_Date__c = d1;
        pth.pse__Project__c = p.Id;
        pth.pse__Resource__c = c.Id;
        //pth.pse__Total_Hours__c = 10;
        pth.pse__Bill_Rate__c = 0;
        pth.pse__Status__c = 'Submitted';
        pth.pse__Assignment__c =pac.Id ;
        pth.pse__Monday_Hours__c = 1;
        pth.pse__Monday_Notes__c = 'Developed';
        pth.pse__Tuesday_Hours__c=1;
        pth.pse__Tuesday_Notes__c = 'Developed';
          pth.pse__Wednesday_Hours__c=1;
        pth.pse__Wednesday_Notes__c = 'Developed';
          pth.pse__Thursday_Hours__c=1;
        pth.pse__Thursday_Notes__c = 'Developed';
          pth.pse__Friday_Hours__c=1;
        pth.pse__Friday_Notes__c = 'Developed';
           pth.pse__Saturday_Hours__c=0;
        pth.pse__Saturday_Notes__c = 'Developed';
           pth.pse__Sunday_Hours__c=0;
        pth.pse__Sunday_Notes__c = 'Developed';
        pth.pse__Project_Phase__c = 'n/a';
         pth.pse__Submitted__c=false;
        try {
        insert pth;
        }
        catch(Exception e){
        system.debug(' ****  Exception e: '+e.getMessage());
        }  
        
          test.stopTest();
        
   
}
        
    }
    
   
}