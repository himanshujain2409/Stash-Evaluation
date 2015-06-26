/**
 Task : 1 =>  Updating Milestone types count
 Task : 2 =>  Updating Lastest Time card date
*/
trigger ProjectMsTrigger on pse__Proj__c (before update) {
    Map<Id,Integer> projectMsCountMap = new Map<Id,Integer>();
    Map<Id,Integer> financialMsCountMap = new Map<Id,Integer>();
    Map<Id,Integer> trainingMsCountMap =  new Map<Id,Integer>();
    Map<Id,Double> billableAmountMap = new Map<Id,Double>();
    Map<Id,Date> maxEndDateMap = new Map<Id,Date>();
    Map<Id,String> weeklyCommentMap = new Map<Id,String>();
    Map<Id,String> concatStrMap = new Map<Id,String>();
    Map<Id,Date> maxWeekEndDateMap = new Map<Id,Date>();
    
    List<pse__Milestone__c> mileStones = [select Id,Name,Training_Milestone__c,pse__Project__c from pse__Milestone__c where pse__Project__c in :Trigger.newMap.keyset()];
     /**
		Checking for mile stone types
		*/
	if(mileStones != null){
		for(pse__Milestone__c mileStone : mileStones){
			 Integer financialMsCount = financialMsCountMap.containskey(mileStone.pse__Project__c) ? financialMsCountMap.get(mileStone.pse__Project__c) : 0;
			 Integer projectMsCount = projectMsCountMap.containskey(mileStone.pse__Project__c) ? projectMsCountMap.get(mileStone.pse__Project__c) : 0;
			 Integer trainingMsCount = trainingMsCountMap.containskey(mileStone.pse__Project__c) ? trainingMsCountMap.get(mileStone.pse__Project__c) : 0;
			 
		     if(mileStone.Training_Milestone__c != null) {
		         if(mileStone.Training_Milestone__c == 'Financial') {  
		             financialMsCount++;
		         } else if(mileStone.Training_Milestone__c == 'Project'){
		             projectMsCount++;
		         }else if(mileStone.Training_Milestone__c == 'Training'){
		             trainingMsCount++;
		         }
		     }
			financialMsCountMap.put(mileStone.pse__Project__c,financialMsCount);
			projectMsCountMap.put(mileStone.pse__Project__c,projectMsCount);
			trainingMsCountMap.put(mileStone.pse__Project__c,trainingMsCount);
		}
	}
    /*For updating time card maximum end date*/
   
     List<pse__Timecard_Header__c> timecards = [select Id,pse__End_Date__c,pse__Status__c,pse__Project__c from pse__Timecard_Header__c where pse__Project__c in :Trigger.newMap.keyset()];
     /**
		Checking for maximum timecard end date
		*/
    if(timecards != null){
     for(pse__Timecard_Header__c timecard : timecards){  
     	 Date maxEndDate = maxEndDateMap.containskey(timecard.pse__Project__c) ? maxEndDateMap.get(timecard.pse__Project__c) : null;      
         if(timecard.pse__End_Date__c != null && timecard.pse__Status__c != null && timecard.pse__Status__c == 'Approved') {
            Date enddate = timecard.pse__End_Date__c;
             if(maxEndDate != null){
                 if(maxEndDate <= enddate){
                     maxEndDate = enddate;
                 }
             }else{
                  maxEndDate = enddate;
             }
         }
         maxEndDateMap.put(timecard.pse__Project__c,maxEndDate);
     }
    }
    /* For the sum of Billable amount on Biiling Event */
     List<pse__Billing_Event__c> billingEvents = [select Id,Approved_billable_amount__c,pse__Project__c from pse__Billing_Event__c where pse__Project__c in :Trigger.newMap.keyset()];
    if(billingEvents != null){
     for(pse__Billing_Event__c billingEvent : billingEvents){
     	 Double billableAmount = billableAmountMap.containskey(billingEvent.pse__Project__c) ? billableAmountMap.get(billingEvent.pse__Project__c) : 0;
         if(billingEvent.Approved_billable_amount__c != null) {
             billableAmount += billingEvent.Approved_billable_amount__c;
         }
         billableAmountMap.put(billingEvent.pse__Project__c,billableAmount);
     }
    }
     /*For updating max project activity date data*/
     List<Project_Activity_NEW__c> projectActivities = [select Id,Weekly_Comments__c,CreatedBy.FirstName,CreatedBy.LastName,Apttus_PS_Date_Entered_2013__c,Apttus_PS_Week_Ending_2013__c,Project2__c from Project_Activity_NEW__c where Project2__c in :Trigger.newMap.keyset()];
    if(projectActivities != null){
    	system.debug(LoggingLevel.INFO,' >>> projectActivities length '+projectActivities.size());
     for(Project_Activity_NEW__c projectactivity : projectActivities){    
	    Date maxWeekEndDate = maxWeekEndDateMap.containskey(projectactivity.Project2__c) ? maxWeekEndDateMap.get(projectactivity.Project2__c) : null;
	    string weeklyComment = weeklyCommentMap.containskey(projectactivity.Project2__c) ? weeklyCommentMap.get(projectactivity.Project2__c) : '';
	    String concatStr = concatStrMap.containskey(projectactivity.Project2__c) ? concatStrMap.get(projectactivity.Project2__c) : '';   
         if(projectactivity.Apttus_PS_Week_Ending_2013__c != null) {
            Date weekenddate = projectactivity.Apttus_PS_Week_Ending_2013__c;
             if(maxWeekEndDate != null){
                 if(maxWeekEndDate <= weekenddate){
                     maxWeekEndDate = weekenddate;
                      concatStr = projectactivity.CreatedBy.FirstName+' '+projectactivity.CreatedBy.LastName+' on '+(projectactivity.Apttus_PS_Date_Entered_2013__c != null ?(projectactivity.Apttus_PS_Date_Entered_2013__c.format()):'')+':';
     				weeklyComment = projectactivity.Weekly_Comments__c;
                 }
             }else{
                  maxWeekEndDate = weekenddate;
                   concatStr = projectactivity.CreatedBy.FirstName+' '+projectactivity.CreatedBy.LastName+' on '+(projectactivity.Apttus_PS_Date_Entered_2013__c != null ?(projectactivity.Apttus_PS_Date_Entered_2013__c.format()):'')+':';
     			weeklyComment = projectactivity.Weekly_Comments__c;
             }
         }
         system.debug(LoggingLevel.INFO,' >>> concatStr '+concatStr);
          system.debug(LoggingLevel.INFO,' >>> weeklyComment '+weeklyComment);
         maxWeekEndDateMap.put(projectactivity.Project2__c,maxWeekEndDate);
         weeklyCommentMap.put(projectactivity.Project2__c,weeklyComment);
         concatStrMap.put(projectactivity.Project2__c,concatStr);
     }
    }
    
    
    //Updating Project record
     for(pse__Proj__c project : trigger.new) {
	         if(financialMsCountMap.get(project.Id) != null){
	         	project.Financial_MS_Count__c = financialMsCountMap.get(project.Id);
	         }else{
	         	project.Financial_MS_Count__c = 0;
	         }
	          if(projectMsCountMap.get(project.Id) != null){
	         	project.Project_MS_Count__c = projectMsCountMap.get(project.Id);
	         }else{
	         	project.Project_MS_Count__c = 0;
	         }
	         if(trainingMsCountMap.get(project.Id) != null){
	         	project.Training_MS_Count__c = trainingMsCountMap.get(project.Id);
	         }else{
	         	project.Training_MS_Count__c = 0;
	         }
	         if(maxEndDateMap.get(project.Id) != null){
	            project.Latest_Timecards_Date__c = maxEndDateMap.get(project.Id);
	         }
	         if(billableAmountMap.get(project.Id) != null){
	         	project.Finance_Billed_Amount__c = billableAmountMap.get(project.Id);
	         }else{
	         	project.Finance_Billed_Amount__c = 0;
	         }
	          if(concatStrMap.get(project.Id) != null){
	         	project.Weekly_Comments_Stamp__c = concatStrMap.get(project.Id);
	         }else{
	         	project.Weekly_Comments_Stamp__c = '';
	         }
	          if(weeklyCommentMap.get(project.Id) != null){
	         	project.Apttus_Project_Status_Report__c = weeklyCommentMap.get(project.Id);
	         }else{
	         	project.Apttus_Project_Status_Report__c = '';
	         }
	         
     }
}