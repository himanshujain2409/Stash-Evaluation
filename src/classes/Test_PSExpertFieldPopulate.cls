@IsTest
public class Test_PSExpertFieldPopulate
{
public static pse__Work_Calendar__c wc = new pse__Work_Calendar__c();
public static pse__Region__c parentrg = new pse__Region__c();
public static pse__Region__c prg = new pse__Region__c();
public static pse__Permission_Control__c pcs = new pse__Permission_Control__c();
public static Account ac=  new Account();
public static Contact pm= new Contact();
public static pse__Practice__c testPractice = new pse__Practice__c(Name = 'Global', CurrencyISOCode = 'USD', pse__Practice_Name_Chain__c = 'NA West');
public static pse__Proj__c p = new pse__Proj__c();
public static Case Testcase = new Case();
public static pse__Practice__c nawest= new pse__Practice__c(Name = 'NA West', CurrencyISOCode = 'USD', pse__Practice_Name_Chain__c = 'NA West');
public static pse__Practice__c nacentral= new pse__Practice__c(Name = 'NA Central', CurrencyISOCode = 'USD', pse__Practice_Name_Chain__c = 'NA West');
public static  pse__Practice__c naeast= new pse__Practice__c(Name = 'NA East', CurrencyISOCode = 'USD', pse__Practice_Name_Chain__c = 'NA West');
public static pse__Practice__c emea= new pse__Practice__c(Name = 'EMEA', CurrencyISOCode = 'USD', pse__Practice_Name_Chain__c = 'NA West');
public static pse__Practice__c cbu= new pse__Practice__c(Name = 'CBU', CurrencyISOCode = 'USD', pse__Practice_Name_Chain__c = 'NA West');
public static pse__Practice__c apac= new pse__Practice__c(Name = 'APAC', CurrencyISOCode = 'USD', pse__Practice_Name_Chain__c = 'NA West');

   public static void createData()
   {
		Profile pr = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
		User u = new User(Alias = 'test', Email='tcuser@testorg.com', 
		EmailEncodingKey='UTF-8', LastName='testtc', LanguageLocaleKey='en_US', 
		LocaleSidKey='en_US', ProfileId = pr.Id, 
		TimeZoneSidKey='America/Los_Angeles', UserName='tcuser@testorg.com');
		System.runAs(u) {
		DateTime dt = System.now() ;
		Date d = dt.date();
		DateTime dt1 = System.now() +6;
		Date d1 = dt1.date();
		wc.Name= 'US Calender';
		wc.pse__Monday_Hours__c = 8;
		wc.pse__Monday_Hours__c = 8;
		insert wc;

		parentrg.Name = 'Us Region';
		parentrg.CurrencyIsoCode = 'USD';
		parentrg.pse__Default_Work_Calendar__c = wc.Id;
		parentrg.pse__Hierarchy_Depth__c =0; 
		insert parentrg;

		prg.Name = 'Us Region';
		prg.CurrencyIsoCode = 'USD';
		prg.pse__Default_Work_Calendar__c = wc.Id;
		prg.pse__Parent_Region__c = parentrg.Id;
		prg.pse__Headquarters_Region__c = parentrg.Id;
		prg.pse__Hierarchy_Depth__c =1;
		insert prg;

		pcs.pse__User__c = u.Id;
		pcs.CurrencyIsoCode = 'USD';
		pcs.pse__Cascading_Permission__c = true;
		pcs.pse__Region__c = parentrg.Id;
		pcs.pse__Staffing__c = true;
		pcs.pse__Resource_Request_Entry__c = true;
		pcs.pse__Timecard_Entry__c = true;
		pcs.pse__Timecard_Ops_Edit__c = true;
		insert pcs;

		ac.Name= 'TestAcc';
		ac.CurrencyIsoCode = 'USD';
		insert ac;

		pm.FirstName ='Pm';
		pm.LastName ='User1';
		pm.pse__Is_Resource__c = true;
		pm.pse__Is_Resource_Active__c = true;
		pm.pse__Work_Calendar__c = wc.Id;
		pm.pse__Region__c = prg.Id;
		pm.AccountId = ac.Id;
		pm.Email='k@apttusexample.com';
		insert pm;

		DateTime ps1 = System.now() -30;
		Date psd1 = ps1.date();
		DateTime pe1 = System.now() +60;
		Date ped1 = pe1.date();
		insert testPractice;

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
		p.pse__Practice__c =testPractice.Id;
		insert p;

		Testcase.Status='Expert Review';
		Testcase.Origin = 'Phone';
		Testcase.Contact = pm;
		Testcase.Account = ac;
		Testcase.Subject = 'Test Case';
		Testcase.Description = 'Test Case';
		Testcase.Product__c='Contract Management';
		Testcase.Project_Name__c=p.Id;
		Testcase.Global_Expert__c = 'Kavitha Gondi';
		Testcase.Contact__c=pm.Id;
		insert Testcase;
		insert nawest;
		insert nacentral;
		insert naeast;
		insert cbu;
		insert emea;
		insert apac;
   }
   }
   
    Static TestMethod void doTesting1(){
    createData();
    Test.startTest();
	Testcase.Product__c='Advanced Approvals';
	update Testcase;
	Testcase.Product__c='Configure, Price, Quote';
	update Testcase;
	Testcase.Product__c='Billing';
	update Testcase;
	Test.StopTest();
	}
	Static TestMethod void doTesting2(){
    createData();
	Test.startTest();
	p.pse__Practice__c =nawest.Id;
	update p;
    Testcase.Product__c='Contract Management';
	update Testcase;
	Testcase.Product__c='Advanced Approvals';
	update Testcase;
	Testcase.Product__c='Configure, Price, Quote';
	update Testcase;
	Testcase.Product__c='Billing';
	update Testcase;
	Test.StopTest();
	}
	Static TestMethod void doTesting3(){
    createData();
	Test.startTest();
	p.pse__Practice__c =nacentral.Id;
	update p;
     Testcase.Product__c='Contract Management';
	update Testcase;
	Testcase.Product__c='Advanced Approvals';
	update Testcase;
	Testcase.Product__c='Configure, Price, Quote';
	update Testcase;
	Testcase.Product__c='Billing';
	update Testcase;
	Test.StopTest();
	}
	Static TestMethod void doTesting4(){
    createData();
	Test.startTest();
	p.pse__Practice__c =naeast.Id;
	update p;
	 Testcase.Product__c='Contract Management';
	update Testcase;
    Testcase.Product__c='Advanced Approvals';
	update Testcase;
	Testcase.Product__c='Configure, Price, Quote';
	update Testcase;
	Testcase.Product__c='Billing';
	update Testcase;
	Test.StopTest();
	}
	Static TestMethod void doTesting5(){
    createData();
	Test.startTest();
	p.pse__Practice__c =emea.Id;
	update p;
     Testcase.Product__c='Contract Management';
	update Testcase;
	Testcase.Product__c='Advanced Approvals';
	update Testcase;
	Testcase.Product__c='Configure, Price, Quote';
	update Testcase;
	Testcase.Product__c='Billing';
	update Testcase;
	Test.StopTest();
	}
	Static TestMethod void doTesting6(){
    createData();
	Test.startTest();
	p.pse__Practice__c =cbu.Id;
	update p;
     Testcase.Product__c='Contract Management';
	update Testcase;
	Testcase.Product__c='Advanced Approvals';
	update Testcase;
	Testcase.Product__c='Configure, Price, Quote';
	update Testcase;
	Testcase.Product__c='Billing';
	update Testcase;
	Test.StopTest();
	}
	Static TestMethod void doTesting7(){
    createData();
	Test.startTest();
	p.pse__Practice__c =apac.Id;
	update p;
     Testcase.Product__c='Contract Management';
	update Testcase;
	Testcase.Product__c='Advanced Approvals';
	update Testcase;
	Testcase.Product__c='Configure, Price, Quote';
	update Testcase;
	Testcase.Product__c='Billing';
	update Testcase;
	Test.StopTest();
	}

}