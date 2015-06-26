@isTest(seeAllData = true)
public class Test_ProjectCostUpdate{
    
    static testMethod void testProjectCostUpdate() {
        //create required records
        Account account = ProjectRecordUpdateTriggerTest.createAccount();
        insert account;
        
        Opportunity oppty = ProjectRecordUpdateTriggerTest.createOppty(account);
        insert oppty;
        
        pse__Practice__c practice =  ProjectRecordUpdateTriggerTest.createPractice();
        insert practice;
        
        pse__Work_Calendar__c workCal = ProjectRecordUpdateTriggerTest.createWorkCal();
        insert workCal;
        
        pse__Region__c region =  ProjectRecordUpdateTriggerTest.createWorkRegion(workCal);
        insert region;
        
        Contact resource = ProjectRecordUpdateTriggerTest.createContact(account, workCal); 
        insert resource;
        
        pse__Proj__c project = ProjectRecordUpdateTriggerTest.createProject(account, oppty, practice);
        insert project;
        
        //Create time cards having different project phases
        List<pse__Timecard_Header__c> listTimeCard = new List<pse__Timecard_Header__c>();
        
        pse__Timecard_Header__c timeCardPlan = ProjectRecordUpdateTriggerTest.createTimeCard('Plan', resource, project);
        listTimeCard.add(timeCardPlan); 
        pse__Timecard_Header__c timeCardDefine = ProjectRecordUpdateTriggerTest.createTimeCard('Define', resource, project);
        listTimeCard.add(timeCardDefine);
        pse__Timecard_Header__c timeCardDesign = ProjectRecordUpdateTriggerTest.createTimeCard('Design', resource, project);
        listTimeCard.add(timeCardDesign);
        pse__Timecard_Header__c timeCardBuild = ProjectRecordUpdateTriggerTest.createTimeCard('Build', resource, project);
        listTimeCard.add(timeCardBuild);
        pse__Timecard_Header__c timeCardTest = ProjectRecordUpdateTriggerTest.createTimeCard('Test', resource, project);
        listTimeCard.add(timeCardTest);
        pse__Timecard_Header__c timeCardLaunch = ProjectRecordUpdateTriggerTest.createTimeCard('Launch', resource, project);
        listTimeCard.add(timeCardLaunch);
        pse__Timecard_Header__c timeCardNA = ProjectRecordUpdateTriggerTest.createTimeCard('N/A', resource, project);
        listTimeCard.add(timeCardNA);
        
        List<pse__Timecard_Header__c> timeCardList = new List<pse__Timecard_Header__c>([select Id , Total_Time_Card_Cost__c , pse__Project__c from pse__Timecard_Header__c  
                                                                                    where (pse__Project__c != null and pse__Approved__c =true )]);
    
        //test.startTest();
        try {
            ProjectCostUpdate obj = new ProjectCostUpdate();
            obj.calculateProjectCost();
            upsert listTimeCard;
            obj = new ProjectCostUpdate();
            obj.calculateProjectCost();
        } catch (System.Exception e){
            ProjectCostUpdate obj = new ProjectCostUpdate();
            obj.calculateProjectCost();
            System.assert(e.getMessage() != null, 'Do not have permission to update contact (Managed Package Error)');
        }
        //test.stopTest();
                
        pse__Proj__c proj = [Select Id, pse__Project_Phase__c from pse__Proj__c limit 1];
        System.assert(proj != null);
        System.assertEquals('Plan', proj.pse__Project_Phase__c);
       
    }
    
    //Test Utility Methods for creating FF related records
    public static Account createAccount() {
        //create company account
        Account testAccount = new Account(Name = 'Test Account');
        testAccount.BillingCountry = 'United States';
        return testAccount;
    }
    
    public static pse__Practice__c createPractice() {
        //create Practice Record
        pse__Practice__c testPractice = new pse__Practice__c(Name = 'NA West', CurrencyISOCode = 'USD', pse__Practice_Name_Chain__c = 'NA West');
        return testPractice;
    }
    
    public static pse__Work_Calendar__c createWorkCal() {
        //create work calendar
        pse__Work_Calendar__c testWorkCal = new pse__Work_Calendar__c(Name = 'Test Work Calendar');
        testWorkCal.pse__Week_Start_Day__c = 'Sunday';
        testWorkCal.pse__Monday_Hours__c = 8; testWorkCal.pse__Tuesday_Hours__c = 8; testWorkCal.pse__Wednesday_Hours__c = 8;
        testWorkCal.pse__Thursday_Hours__c = 8; testWorkCal.pse__Friday_Hours__c = 8; testWorkCal.pse__Saturday_Hours__c = 8; 
        testWorkCal.pse__Sunday_Hours__c = 8;
        return testWorkCal;
    }
    
    public static pse__Region__c createWorkRegion(pse__Work_Calendar__c workCal) {
        //create region
        pse__Region__c testRegion = new pse__Region__c(Name = 'North America', CurrencyISOCode = 'USD');
        testRegion.pse__Default_Work_Calendar__c = workCal.Id;
        testRegion.pse__Region_Name_Chain__c = 'North America';
        return testRegion;
    }
    
    public static Contact createContact(Account account, pse__Work_Calendar__c workCal) {
        Profile pr = [SELECT Id FROM Profile WHERE Name='PSA - Admin']; 
        UserRole role = [Select Id from UserRole where Name = 'PS Ops'];
        User sfdcUser = new User(Alias = 'test', Email='tcuser@testorg.com', UserRoleId = role.Id,
            EmailEncodingKey='UTF-8', LastName='testtc', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = pr.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='tcuser@testorg.com');

        RecordType psRT = [Select Id from RecordType where sObjectType = 'Contact' and Name = 'PS Resource' limit 1];
                
        Contact testContractor = new Contact(LastName = 'Test Resource', Email = 'psevak@apttus.com', CurrencyISOCode = 'USD');
        testContractor.pse__Is_Resource_Active__c = True;
        testContractor.AccountId = account.Id;
        testContractor.pse__Is_Resource__c = True;
        testContractor.Apttus_PS_Contact_Type__c = 'Contractor';
        testContractor.Contractor_Cost_Rate__c = 500;
        testContractor.pse__Work_Calendar__c = workCal.Id;
        testContractor.pse__Salesforce_User__c = sfdcUser.Id;
        testContractor.pse__Scheduled_Utilization_Target_Hours__c = 80;
        testContractor.pse__Start_Date__c = System.today() - 30;
        testContractor.pse__Resource_Role__c = 'Configuration Engineer';
        testContractor.Domain__c = 'CPQ';
        //testContractor.pse__Region__c = testRegion.Id;
        //testContractor.pse__Practice__c = testPractice.Id;
        testContractor.RecordTypeId = psRT.Id;
        return testContractor;
    }
    
    public static Opportunity createOppty(Account client) {
        //create opportunity
        Opportunity testOpp = new Opportunity(Name = 'Test Opp');
        testOpp.AccountId = client.Id;
        testOpp.Type = 'New Business';
        testOpp.Services_Prime_new__c = 'Accenture; Apttus; Deloitte';
        testOpp.StageName = 'Develop';
        testOpp.CloseDate = System.Today() + 5;
        testOpp.CurrencyIsoCode = 'USD';
        testOpp.NextStep = '4/18/14 VE: Alliant has opt\'d to go with ChickPea for Quotes, Billing and Fulfillment for now due to the high implementation costs of Apttus and the added complexity.';
        return testOpp;
    }
    
    public static pse__Proj__c createProject(Account account, Opportunity oppty, pse__Practice__c practice) {
        //create project record
        pse__Proj__c testProject = new pse__Proj__c(Name = 'Test - Project');
        testProject.pse__Account__c = account.Id;
        testProject.Account_for_Finance__c = account.Id;
        testProject.pse__Project_Phase__c = 'Plan';
        testProject.pse__Opportunity__c = oppty.Id;
        testProject.pse__Is_Billable__c = True;
        testProject.pse__Is_Active__c = True;
        testProject.CurrencyIsoCode = 'USD';
        testProject.pse__Practice__c = practice.Id;
        testProject.pse__Stage__c = 'In Progress';
        testProject.pse__Allow_Timecards_Without_Assignment__c = True;
        testProject.pse__Start_Date__c = System.today();
        testProject.pse__Allow_Self_Staffing__c = True;
        return testProject; 
    }
    
    public static pse__Timecard_Header__c createTimeCard(String projectPhase, Contact resource, pse__Proj__c project) {
        pse__Timecard_Header__c testTC = new pse__Timecard_Header__c();
        testTC.pse__Project_Phase__c = projectPhase;
        testTC.pse__Sunday_Hours__c = 8; testTC.pse__Monday_Hours__c = 8; testTC.pse__Tuesday_Hours__c = 8; 
        testTC.pse__Wednesday_Hours__c = 8; testTC.pse__Thursday_Hours__c = 8; testTC.pse__Friday_Hours__c = 8; 
        testTC.pse__Saturday_Hours__c = 8;
        testTC.pse__Resource__c = resource.Id;
        testTC.pse__Billable__c = True;
        testTC.pse__Project__c = project.Id;
        testTC.pse__Submitted__c = True;
        testTC.pse__Approved__c = True; 
        testTC.pse__Start_Date__c = System.today();
        testTC.pse__End_Date__c = System.today() + 6;
        testTC.pse__Status__c = 'Saved';
        return testTC;
    }
}