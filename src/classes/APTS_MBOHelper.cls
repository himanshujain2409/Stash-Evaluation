/*************************************************************
@Name: APTS_MBOHelper
@Author: KrishnaRajani Yadlapalli,PS - Apttus
@CreateDate: 02/13/2015
@Description: Helper Class for MBO and Perfamance controller files
@UsedBy: APTS_MyTeamMBOsController,APTS_MBOPerformanceReviewController
******************************************************************
@ModifiedBy: 
@ModifiedDate: 
@ChangeDescription: 

******************************************************************/
public with sharing class APTS_MBOHelper {
    
    public APTS_MBOHelper() {
        
    }

    /*
    @Description: 
    @Parameters: userId of type Id  
    */
    public static List<MBO__c> getEmployeeMbos(Id userId)
    {
    

         String mbosQuery = 'Select Id,Name,MBO_Year__c,Manager__c,Manager__r.Name,Employee__c,Employee__r.Name,'+
                            'MBO_1__c,MBO_2__c,MBO_3__c,MBO_4__c, MBO_5__c,   '+
                            'Year_Quarter__c,Status__c,Enable_Self_Review__c '+
                            ' From MBO__c WHERE Employee__c = :userId order by MBO_Year__c desc ';

         List<MBO__c> mbosList = Database.query(mbosQuery);
         return mbosList;
    }

  /*
    Added by JPG  -- getEmploye


  */

/* Added by JPG */
  public static List<User> getEmployees(Id ManagerId)
  {
    String userQuery = 'SELECT Name, FirstName, ManagerId, Manager.Name,  Hire_Date__c FROM User WHERE ManagerId = : ManagerId';
    List<User> listEmployees = Database.query(userQuery);
    return listEmployees;
  }

    public static List<Performance_Reviews__c> getEmployeePerfReviews(Id userId,Id perRevId)
    {

        String prvsQuery = 'SELECT Development_Plan__c,Employee__c,Employee__r.Name,Employee__r.FirstName,Manager__c,Manager__r.Name,'+
                            'Hire_Date__c,Id,MBO_Year__c,Name,'+
                            'Overall_Rating__c,Q1_Q2_Overall_Score__c,Q3_Q4_Overall_Score__c,Manager_Review_Completed__c,'+
                            'Review_Visible_to_Employee__c,Self_Review_Completed__c,Title__c,'+
                            'Major_Accomplishments_Employee__c,Major_Accomplishments_Manager__c,'+
                            'Different_Actions_Employee__c, Professional_Goals_Employee__c, '+
                            'Different_Actions_Manager__c, '+
                            'Major_Area_of_Focus_Employee__c,Major_Area_of_Focus_Manager__c,'+
                            'APTS_MBO_Q1_Q2_Goal_1_Manager_Evaluation__c,APTS_MBO_Q1_Q2_Goal_1__c,'+
                            'APTS_MBO_Q1_Q2_Goal_2_Manager_Evaluation__c,APTS_MBO_Q1_Q2_Goal_2__c,APTS_MBO_Q1_Q2_Goal_3_Manager_Evaluation__c,'+
                            'APTS_MBO_Q1_Q2_Goal_3__c,APTS_MBO_Q1_Q2_Goal_4_Manager_Evaluation__c,APTS_MBO_Q1_Q2_Goal_4__c,'+
                            'APTS_MBO_Q1_Q2_Goal_5_Manager_Evaluation__c,APTS_MBO_Q1_Q2_Goal_5__c,MBO_Q1_Q2__c,APTS_MBO_Q3_Q4_Goal_1_Manager_Evaluation__c,'+
                            'APTS_MBO_Q3_Q4_Goal_1__c,APTS_MBO_Q3_Q4_Goal_2_Manager_Evaluation__c,APTS_MBO_Q3_Q4_Goal_2__c,APTS_MBO_Q3_Q4_Goal_3_Manager_Evaluation__c,'+
                            'APTS_MBO_Q3_Q4_Goal_3__c,APTS_MBO_Q3_Q4_Goal_4_Manager_Evaluation__c,APTS_MBO_Q3_Q4_Goal_4__c,APTS_MBO_Q3_Q4_Goal_5_Manager_Evaluation__c,'+
                            'APTS_MBO_Q3_Q4_Goal_5__c,MBO_Q3_Q4__c, Status__c,Approval_Status__c '+
                            ' FROM Performance_Reviews__c ';
            
        if(userId != null)
            prvsQuery += 'Where Employee__c = :userId';
        if(perRevId != null)
            prvsQuery += (userId != null ? 'AND' : 'Where ')+' Id = :perRevId';
        System.debug('prvsQuery--'+prvsQuery);
        List<Performance_Reviews__c> performanceReviewList = Database.query(prvsQuery);
        return performanceReviewList;
    }


    public static List<Performance_Reviews__c> getTeamPerfReviews(Id managerId)
    {
        Set<String> statusSet = new Set<String>{APTS_CONSTANTS.PR_STATUS_EMP_COMPLETE,APTS_CONSTANTS.PR_STATUS_COMPLETE};
         String prvsQuery = 'SELECT Development_Plan__c,Employee__c,Employee__r.Name,Employee__r.FirstName,Manager__c,Manager__r.Name,'+
                            'Hire_Date__c,Id,MBO_Year__c,Name,'+
                            'Overall_Rating__c,Q1_Q2_Overall_Score__c,Q3_Q4_Overall_Score__c,Manager_Review_Completed__c,'+
                            'Review_Visible_to_Employee__c,Self_Review_Completed__c,Title__c,'+
                            'Major_Accomplishments_Employee__c,Major_Accomplishments_Manager__c,'+
                            'Different_Actions_Employee__c, Professional_Goals_Employee__c, '+
                            'Different_Actions_Manager__c, '+
                            'Major_Area_of_Focus_Employee__c,Major_Area_of_Focus_Manager__c,'+
                            'APTS_MBO_Q1_Q2_Goal_1_Manager_Evaluation__c,APTS_MBO_Q1_Q2_Goal_1__c,'+
                            'APTS_MBO_Q1_Q2_Goal_2_Manager_Evaluation__c,APTS_MBO_Q1_Q2_Goal_2__c,APTS_MBO_Q1_Q2_Goal_3_Manager_Evaluation__c,'+
                            'APTS_MBO_Q1_Q2_Goal_3__c,APTS_MBO_Q1_Q2_Goal_4_Manager_Evaluation__c,APTS_MBO_Q1_Q2_Goal_4__c,'+
                            'APTS_MBO_Q1_Q2_Goal_5_Manager_Evaluation__c,APTS_MBO_Q1_Q2_Goal_5__c,MBO_Q1_Q2__c,APTS_MBO_Q3_Q4_Goal_1_Manager_Evaluation__c,'+
                            'APTS_MBO_Q3_Q4_Goal_1__c,APTS_MBO_Q3_Q4_Goal_2_Manager_Evaluation__c,APTS_MBO_Q3_Q4_Goal_2__c,APTS_MBO_Q3_Q4_Goal_3_Manager_Evaluation__c,'+
                            'APTS_MBO_Q3_Q4_Goal_3__c,APTS_MBO_Q3_Q4_Goal_4_Manager_Evaluation__c,APTS_MBO_Q3_Q4_Goal_4__c,APTS_MBO_Q3_Q4_Goal_5_Manager_Evaluation__c,'+
                            'APTS_MBO_Q3_Q4_Goal_5__c,MBO_Q3_Q4__c, Status__c,Approval_Status__c '+
                            ' FROM Performance_Reviews__c ';
            
        if(managerId != null)
            prvsQuery += 'Where Manager__c = :managerId';
       /* if(managerId != null)
            prvsQuery += ' AND Status__c In : statusSet';
         */   
        List<Performance_Reviews__c> performanceReviewList = Database.query(prvsQuery);
        return performanceReviewList;
    }



    public static Performance_Reviews__c preparePerfRev(String mboYear,List<MBO__c> mbosList)
    {
        Performance_Reviews__c perfRev = new Performance_Reviews__c();
        perfRev.Employee__c = mbosList.get(0).Employee__c;
        perfRev.Manager__c = mbosList.get(0).Manager__c;
        perfRev.MBO_Year__c = mboYear;

        for(MBO__c mbo : mbosList){
            if(APTS_CONSTANTS.MBO_YQ_12.equalsIgnoreCase(mbo.Year_Quarter__c))
            {
                perfRev.MBO_Q1_Q2__c = mbo.Id;
            }
            if(APTS_CONSTANTS.MBO_YQ_34.equalsIgnoreCase(mbo.Year_Quarter__c))
            {
                perfRev.MBO_Q3_Q4__c = mbo.Id;  
            }
        }
        return perfRev;
    }
}