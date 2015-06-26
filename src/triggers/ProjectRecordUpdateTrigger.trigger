trigger ProjectRecordUpdateTrigger on pse__Timecard_Header__c (after insert, after update, before update) {
   
    //Initialization
    List<Id> listProjIds = new List<Id>();
    List<pse__Proj__c> lstPrj = new List<pse__Proj__c>();
    //variable to hold project records for update
    List<pse__Proj__c> updateProjRecords = new List<pse__Proj__c>(); 

    Decimal costDefine;
    Decimal costDesign;
    Decimal costLaunch;
    Decimal costNA;
    Decimal costPlan;
    Decimal costBuild;
    Decimal costTest;
    Decimal amountBuild;
    Decimal amountDesign;
    Decimal amountDefine;
    Decimal amountLaunch;
    Decimal amountNA;
    Decimal amountPlan;
    Decimal amountTest;

    //Fetch project id associated with approved timecards
    for(pse__Timecard_Header__c childObj : Trigger.new)
    {
        if(childObj.pse__Approved__c == TRUE)
            listProjIds.add(childObj.pse__Project__c);
    }
    
    if(listProjIds != null && listProjIds.size() > 0) {

        //Fetch project details with their timecard details for approved timecards
        lstPrj = [Select Id,Total_Resource_Timecard_Cost_Build__c,Total_Resource_Timecard_Cost_Define__c,
                      Total_Resource_Timecard_Cost_Design__c,Total_Resource_Timecard_Cost_Launch__c,
                      Total_Resource_Timecard_Cost_N_A__c,Total_Resource_Timecard_Cost_Plan__c,
                      Total_Resource_Timecard_Cost_Test__c,Total_Billable_Amount_Build__c,
                      Total_Billable_Amount_Define__c,Total_Billable_Amount_Design__c,
                      Total_Billable_Amount_Launch__c,Total_Billable_Amount_N_A__c,
                      Total_Billable_Amount_Plan__c,Total_Billable_Amount_Test__c,
                      (Select Total_Resource_Timecard_Cost__c,pse__Total_Billable_Amount__c,pse__Project_Phase__c 
                  from pse__Timecards__r)
                      from pse__Proj__c where Id in :listProjIds];
    }
    //if timecards don't have associated projects then skip the operaion
    if(lstPrj.isEmpty()) return;
    
    for(pse__Proj__c proj : lstPrj) {
        
        costDefine = 0.0;
        costDesign = 0.0;
        costLaunch = 0.0;
        costNA = 0.0;
        costPlan = 0.0;
        costBuild = 0.0;
        costTest = 0.0;
        amountBuild = 0.0;
        amountDesign = 0.0;
        amountDefine = 0.0;
        amountLaunch = 0.0;
        amountNA = 0.0;
        amountPlan = 0.0;
        amountTest = 0.0;
        
        if(proj.pse__Timecards__r.isEmpty()) return;  //if project associated timecards are empty then return
      
        //loop through project timecards and fetch summation of phases respective values
        for(pse__Timecard_Header__c timeCard : proj.pse__Timecards__r) {
        
            if(timeCard.pse__Project_Phase__c == 'Plan') {
                costPlan = costPlan + timeCard.Total_Resource_Timecard_Cost__c;
                amountPlan = amountPlan + timeCard.pse__Total_Billable_Amount__c;
            } else if(timeCard.pse__Project_Phase__c == 'Define') {
                costDefine = costDefine + timeCard.Total_Resource_Timecard_Cost__c;
                amountDefine = amountDefine + timeCard.pse__Total_Billable_Amount__c;
            } else if(timeCard.pse__Project_Phase__c == 'Design') {
                costDesign = costDesign + timeCard.Total_Resource_Timecard_Cost__c;
                amountDesign = amountDesign + timeCard.pse__Total_Billable_Amount__c;
            } else if(timeCard.pse__Project_Phase__c == 'Build') {
                costBuild = costBuild + timeCard.Total_Resource_Timecard_Cost__c;
                amountBuild = amountBuild + timeCard.pse__Total_Billable_Amount__c;
            } else if(timeCard.pse__Project_Phase__c == 'Test') {
                costTest= costTest + timeCard.Total_Resource_Timecard_Cost__c;
                amountTest = amountTest + timeCard.pse__Total_Billable_Amount__c;
            } else if(timeCard.pse__Project_Phase__c == 'Launch') {
                costLaunch= costLaunch + timeCard.Total_Resource_Timecard_Cost__c;
                amountLaunch  = amountLaunch + timeCard.pse__Total_Billable_Amount__c;
            } else if((timeCard.pse__Project_Phase__c == 'N/A')) {
                costNA = costNA + timeCard.Total_Resource_Timecard_Cost__c;
                amountNA  = amountNA + timeCard.pse__Total_Billable_Amount__c;
            }
        }
        
        //Assign timecard final values to project final values
        proj.Total_Resource_Timecard_Cost_Build__c = costBuild;
        proj.Total_Resource_Timecard_Cost_Define__c = costDefine;
        proj.Total_Resource_Timecard_Cost_Design__c = costDesign;
        proj.Total_Resource_Timecard_Cost_Launch__c = costLaunch;
        proj.Total_Resource_Timecard_Cost_N_A__c = costNA;
        proj.Total_Resource_Timecard_Cost_Plan__c = costPlan;
        proj.Total_Resource_Timecard_Cost_Test__c = costTest;
        proj.Total_Billable_Amount_Build__c = amountBuild;
        proj.Total_Billable_Amount_Define__c = amountDefine;
        proj.Total_Billable_Amount_Design__c = amountDesign;
        proj.Total_Billable_Amount_Launch__c = amountLaunch;
        proj.Total_Billable_Amount_N_A__c = amountNA;
        proj.Total_Billable_Amount_Plan__c = amountPlan;
        proj.Total_Billable_Amount_Test__c = amountTest;
        updateProjRecords.add(proj);
        
    }    

    //Update final project list 
    if(!updateProjRecords.isEmpty()) {
        update updateProjRecords;
    } 
     if(trigger.isUpdate){               
                Set<ID> ids = Trigger.newMap.keySet();
                
                List<pse__Proj__c> pList = [select Id from pse__Proj__c where pse__Is_Active__c = true];
                Set<Id> rs = (new Map<Id,pse__Proj__c>(pList)).keySet();                                        
                
                List<pse__Timecard_Header__c> tList = [select Id, pse__Total_Hours__c, pse__Project__c from pse__Timecard_Header__c where Id IN :ids AND pse__Project__c IN :rs];
                Set<Id> tProj = new Set<Id>();
                for(pse__Timecard_Header__c th : tList){
                                tProj.add(th.pse__Project__c);
                }
                
                List<pse__Milestone__c> mList = [select Id, pse__Project__c from pse__Milestone__c where pse__Project__c IN :tProj AND RecordType.Name IN ('Project_Level1_Implementation',
                'Project_Level_2_LaunchPack','Project_Level_3_Exception')];
                Set<Id> ms = (new Map<Id, pse__Milestone__c>(mList)).keySet();                       
                
                List<pse__Milestone__c> milestoneList = new List<pse__Milestone__c>();
                for(pse__Timecard_Header__c childObj : Trigger.new){
                                for(Id mileId : ms){System.debug( '******'+childObj.pse__Project_Phase__c);
                                                if( childObj.pse__Status__c == 'Approved' && childObj.pse__Project_Phase__c == 'Plan')
                                                                milestoneList.add(new pse__Milestone__c(Id = mileId, Actual_Hours_Plan_Phase__c = childObj.pse__Total_Hours__c));                                                                
                                                if(childObj.pse__Status__c == 'Approved' && childObj.pse__Project_Phase__c == 'Define')
                                                                milestoneList.add(new pse__Milestone__c(Id = mileId, Actual_Hours_Define_Phase__c = childObj.pse__Total_Hours__c));
                                                if(childObj.pse__Status__c == 'Approved' && childObj.pse__Project_Phase__c == 'Design')
                                                                milestoneList.add(new pse__Milestone__c(Id = mileId, Actual_Hours_Design_Phase__c = childObj.pse__Total_Hours__c));
                                                if(childObj.pse__Status__c == 'Approved' && childObj.pse__Project_Phase__c == 'Build')
                                                                milestoneList.add(new pse__Milestone__c(Id = mileId, Actual_Hours_Build_Phase__c = childObj.pse__Total_Hours__c));
                                                if(childObj.pse__Status__c == 'Approved' && childObj.pse__Project_Phase__c == 'Test')
                                                                milestoneList.add(new pse__Milestone__c(Id = mileId, Actual_Hours_Test_Phase__c = childObj.pse__Total_Hours__c));
                                                if(childObj.pse__Status__c == 'Approved' && childObj.pse__Project_Phase__c == 'Launch')
                                                                milestoneList.add(new pse__Milestone__c(Id = mileId, Actual_Hours_Launch_Phase__c = childObj.pse__Total_Hours__c));
                                }                                                              
                }
                update milestoneList;
}

                
}