/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest(seeAllData = False)
private class APTPS_BenchDataTest {

    static testMethod void myUnitTest() {
          MAP<String, Schema.SObjectType> MapGD = Schema.getGlobalDescribe();
	    DescribeSobjectResult result  = MapGD.get('Contact').GetDescribe();
	    Map<String,Schema.RecordTypeInfo> MapRecordType = result.GetRecordTypeInfosByName();        
	    id spRecordTypeID =  MapRecordType.Get('PS Resource').GetRecordTypeId();
        
        
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
        Date d1 = dt1.date() + 500;
        
        Test.startTest();
        pse__Work_Calendar__c wc = new pse__Work_Calendar__c();
        wc.Name= 'US Calender';
        wc.pse__Monday_Hours__c = 8;
          wc.pse__Monday_Hours__c = 8;
         // wc.pse__Tuesday_Hours__c = 8;
          //wc.pse__Wednesday_Hours__c = 8;
          //wc.pse__Thursday_Hours__c = 8;
          //wc.pse__Friday_Hours__c = 8;
          //wc.pse__Saturday_Hours__c = 0;
          //wc.pse__Saturday_Hours__c = 0;
          //wc.pse__Standard_Hours_Per_Day__c = 8;
          //wc.pse__Week_Start_Day__c='Sunday';
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
        Test.stopTest();
        
        DateTime ps1 = System.now() -30;
        Date psd1 = ps1.date();
        DateTime pe1 = System.now() +1000;
        Date ped1 = pe1.date();
        
        pse__Proj__c p = new pse__Proj__c();
        p.Name = 'ProjectTest';
        p.pse__Is_Active__c = true;
        p.CurrencyIsoCode = 'USD';
        p.Actual_Start_Date__c= psd1;
        p.Actual_End_Date__c = ped1;
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
        c.recordtypeId = spRecordTypeID; 
        c.AccountId = ac.Id;
        c.pse__Is_Resource__c = true;
        c.pse__Is_Resource_Active__c = true;
        c.pse__Work_Calendar__c = wc.Id;
        c.pse__Region__c = prg.Id;
        insert c;
        
        DateTime st = System.now() ;
        Date sd = st.date();
        DateTime et = System.now() ;
        Date ed = et.date();
        pse__Schedule__c ps = new pse__Schedule__c();
        ps.pse__Start_Date__c = sd;
        ps.pse__End_Date__c = ed.addDays(210);
        ps.pse__Monday_Hours__c = 8;
        ps.pse__Tuesday_Hours__c = 8;
        ps.pse__Wednesday_Hours__c = 8;
        ps.pse__Thursday_Hours__c = 8;
        ps.pse__Friday_Hours__c = 8;
        ps.pse__Saturday_Hours__c = 8;
        ps.pse__Sunday_Hours__c = 8;
        insert ps;
        
         pse__Schedule_exception__c psException = new pse__Schedule_exception__c();
        psException.pse__schedule__c =  ps.id;
        psException.pse__Date__c =   sd.addDays(21);
        psException.pse__End_Date__c = ed.addDays(21);
        psException.pse__Monday_Hours__c = 8;
        psException.pse__Tuesday_Hours__c = 8;
        psException.pse__Wednesday_Hours__c = 8;
        psException.pse__Thursday_Hours__c = 8;
        psException.pse__Friday_Hours__c = 8;
        psException.pse__Saturday_Hours__c = 8;
        psException.pse__Sunday_Hours__c = 8;
        insert psException;
          
        pse__Assignment__c pac = new pse__Assignment__c();
        pac.Name='Sample Assign111';
        pac.pse__Resource__c = c.Id;
        pac.pse__Project__c = p.Id;
        pac.pse__Role__c = 'Developer';
        pac.CurrencyIsoCode = 'USD';
        pac.pse__Schedule__c = ps.Id;
        pac.pse__Bill_Rate__c = 100;
        pac.pse__Cost_Rate_Amount__c = 0;
        pac.End_Date__c =  ped1;        
        pac.pse__Status__c = 'Scheduled';
        pac.pse__Percent_Allocated__c = 0;
        pac.pse__Schedule_Updated__c = false;
       pac.pse__Is_Billable__c = true;
        System.debug('Mihir Test'+pac); 
        insert pac;
         
     //APTPS_BenchDataUtility.createBenchData();
       APTPS_BenchDataUtility oBatch = new APTPS_BenchDataUtility();
         database.executeBatch(oBatch,10);
           
    }
    }
    
    

		
	static testMethod void  Method2(){	
        
		Test.StartTest();
		APTPS_BenchDataUtilitySchedule sh1 = new APTPS_BenchDataUtilitySchedule();      
		 String sch = '0 0 9 * * ?';
		        system.schedule('Test check'+DateTime.now(), sch, sh1);
		   
		Test.stopTest();
	}
	
}