/*************************************************************
@Name: APTS_MBOPerformanceReviewController
@Author: KrishnaRajani Yadlapalli,PS - Apttus
@CreateDate: 02/13/2015
@Description: Controller for Perfamance Feedback Visual force page
@UsedBy: APTS_MBOPerformanceReview page
******************************************************************
@ModifiedBy: 
@ModifiedDate: 
@ChangeDescription: 

******************************************************************/
public with sharing class APTS_MBOPerformanceReviewController {
    Id performanceReviewId;
    public Performance_Reviews__c performanceReview{get{
        if(performanceReview == null && performanceReviewId != null){
            List<Performance_Reviews__c> performanceReviews = APTS_MBOHelper.getEmployeePerfReviews(null, performanceReviewId);
            if(performanceReviews != null && !performanceReviews.isEmpty())
                performanceReview = performanceReviews.get(0);
        }
        return performanceReview;
        }set;}
    public String loggedinuserId{get; private set;}
        
    public  APTS_MBOPerformanceReviewController(Apexpages.standardcontroller stdController)
    {
        loggedinuserId = UserInfo.getUserId();
         performanceReviewId = stdController.getRecord().Id;
    }
    
    public Boolean getrendersavebuttons(){
        if((performanceReview.Employee__c == loggedinuserId
             && performanceReview.Self_Review_Completed__c == false)
            ||(performanceReview.Manager__c == loggedinuserId
               && performanceReview.Manager_Review_Completed__c == false
               && performanceReview.Self_Review_Completed__c == true))
            return true;
        return false;
    }

    /*Method to Save  Performance Reviews and not to submit*/
    public PageReference saveAndPending(){
        if(performanceReview != null && performanceReview.Id != null)
        {
            try
            {
                System.debug('saveAndPending performanceReview--'+performanceReview);
                //performanceReview.Approval_Fire__c = true;
                update performanceReview;

            }catch(Exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
                return null;
            }
        }
        return Page.APTS_MyTeamMBOs;
    }

    /*Method to Save and Submit  Performance Reviews */
    public PageReference saveAndSubmit(){
        if(performanceReview != null 
            && performanceReview.Id != null){
            // check Self_Review_Completed__c if employee clicks on save&submit
            if(performanceReview.Employee__c == loggedinuserId)
            {
                performanceReview.Self_Review_Completed__c = true;
                performanceReview.Status__c = APTS_CONSTANTS.PR_STATUS_EMP_COMPLETE;
                performanceReview.Self_Review_Submitted_Date__c = System.today();
            }
            // check Manager_Review_Completed__c if manager clicks on save&submit
            if(performanceReview.Manager__c == loggedinuserId)
            {
                performanceReview.Manager_Review_Completed__c = true;
                performanceReview.Status__c = APTS_CONSTANTS.PR_STATUS_COMPLETE;
                performanceReview.Manager_Review_Submitted_Date__c = System.today();

                if(String.isNotBlank(performanceReview.Overall_Rating__c)
                    && performanceReview.Overall_Rating__c != APTS_CONSTANTS.PR_OVERALLRATING_1)
                {
                    performanceReview.Approval_Status__c = APTS_CONSTANTS.PR_APPROVALSTATUS_APPROVED;
                }
            }
            try
            {
                System.debug('saveAndSubmit performanceReview--'+performanceReview);
                update performanceReview;

                //Submitting for approval only if Overall rating is 1. Failure to Launch
                if(performanceReview.Overall_Rating__c != null 
                   && performanceReview.Overall_Rating__c == APTS_CONSTANTS.PR_OVERALLRATING_1)
                {
                    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                    req1.setObjectId(performanceReview.id);
                    req1.setSubmitterId(UserInfo.getUserId());              
                    req1.setProcessDefinitionNameOrId('Performance_Feedback_Approval_Process');
                    req1.setSkipEntryCriteria(true);
                    Approval.ProcessResult result = Approval.process(req1);
                }

            }catch(Exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
                return null;
            }
        }
        return Page.APTS_MyTeamMBOs;
    }

    /* make results visible to employee once approved.*/
    public PageReference makeresultsvisibletoemployee(){
        if(performanceReview != null 
            && performanceReview.Id != null){
            performanceReview.Review_Visible_to_Employee__c = APTS_CONSTANTS.PR_REVIEW_VISIBLE_EMP_YES;
            performanceReview.Results_Made_Visible_to_Employee_Date__c = System.today();
            try
            {
                update performanceReview;
            }catch(Exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
                return null;
            }
        }
        return Page.APTS_MyTeamMBOs;
    }

    public PageReference gotoMBO(){
        return Page.APTS_MyTeamMBOs;
    }
}