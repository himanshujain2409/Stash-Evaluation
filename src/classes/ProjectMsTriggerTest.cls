@isTest (seealldata=true)
public class ProjectMsTriggerTest{
	 static testMethod void projectMSAndTCTest() {
    try{
       
    	 pse__Proj__c p = new pse__Proj__c();
    	p.Name = 'ProjectTest';
    	p.pse__Is_Active__c = true;
    	p.Training_MS_Count__c=0;
    	insert p;
    	
    	DateTime dt = System.now();
		Date d = dt.date();
    	/*Code for inserting Milestone*/
    	pse__Milestone__c pmt = new pse__Milestone__c();
    	pmt.Name = 'MilestoneTrainTgTest';
    	pmt.Training_Milestone__c = 'Training';
    	pmt.pse__Project__c = p.Id;
    	pmt.pse__Target_Date__c = d;
    	pmt.pse__Milestone_Amount__c = 1000;
    	insert pmt;
    	
    	
    	pse__Milestone__c pmf = new pse__Milestone__c();
    	pmf.Name = 'MilestoneTgFinacialTest';
    	pmf.Training_Milestone__c = 'Financial';
    	pmf.pse__Project__c = p.Id;
    	pmf.pse__Target_Date__c= d;
    	pmf.pse__Milestone_Amount__c = 1000;
    	insert pmf;
    	
    	pse__Milestone__c pmp = new pse__Milestone__c();
    	pmp.Name = 'MilestoneProjTgTest';
    	pmp.Training_Milestone__c = 'Project';
    	pmp.pse__Project__c = p.Id;
    	pmp.pse__Target_Date__c = d;
    	pmp.pse__Milestone_Amount__c = 0;
    	insert pmp;
    	
    	/**Code  for inserting billing amount*/
        pse__Billing_Event__c pbe = new pse__Billing_Event__c();
    	pbe.CurrencyIsoCode = 'USD';
    	pbe.Billable_Amount__c = 1000;
    	pbe.pse__Project__c = p.Id;
    	insert pbe;
    	pbe.Billable_Amount__c = 2000;
    	update pbe;
        
    	p.SOW_Amount__c = 200;
    	update p;
    	
    	/**Code  for inserting Project activity*/
        Project_Activity_NEW__c panc = new Project_Activity_NEW__c();
    	panc.Project2__c = p.Id;
    	panc.Weekly_Comments__c = 'Test comment';
    	panc.Apttus_PS_Date_Entered_2013__c = d;
    	panc.CurrencyIsoCode = 'USD';
    	insert panc;
  
  
		}catch(Exception e){
			System.debug('ERROR:' + e);
		}
    }
}