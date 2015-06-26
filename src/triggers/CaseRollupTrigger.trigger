trigger CaseRollupTrigger on Case (after delete, after insert, after undelete,
    after update, before update) {
        
private Integer daysOff(Datetime sdate, Datetime edate)
    {
        System.debug('end dateformat:::::::' + edate);
        Integer iCount = 0;
        while (sdate <= edate) 
        {
            System.debug('inside dateformat:::::::' + sdate.format('E') );
            if (sdate.format('E') == 'Sat' | sdate.format('E') == 'Sun')
            {   
                System.debug('count increased');            
                iCount = iCount + 1;
                edate = edate + 1;
            }
            sdate = sdate.addDays(1);
        }
        return iCount;
    }
    
    private Datetime addBussinessDays(Datetime startDate, Integer iDays)
    {
        Datetime endDate = startDate.addDays(iDays);
        Integer iOffDays = daysOff(startDate + 1,endDate);
        return endDate.addDays(iOffDays);
    }
    
    
        Case[] cases;
        if (Trigger.isDelete)
            cases = Trigger.old;
        else
            cases = Trigger.new;

        // get list of accounts
        Set<ID> acctIds = new Set<ID>();
        for (Case cse : cases) {
                acctIds.add(cse.AccountId);
        }
       
        Map<ID, Case> casesForAccounts = new Map<ID, Case>([select Id
                                                                ,AccountId
                                                                from Case
                                                                where AccountId in :acctIds]);

        Map<ID, Account> acctsToUpdate = new Map<ID, Account>([select Id
                                                                     ,Number_Of_Cases__c
                                                                      from Account
                                                                      where Id in :acctIds]);
                                                                    
        for (Account acct : acctsToUpdate.values()) {
            Set<ID> caseIds = new Set<ID>();
            for (Case cse : casesForAccounts.values()) {
                if (cse.AccountId == acct.Id)
                    caseIds.add(cse.Id);
            }
            if (acct.Number_Of_Cases__c != caseIds.size())
                acct.Number_Of_Cases__c = caseIds.size();
        }

        update acctsToUpdate.values();
        
        //code added for setting workflow evaluation date field
        if((Trigger.isUpdate || Trigger.isInsert) && Trigger.isBefore){
            for (Case cse : cases) {
                if(cse.Status == 'Additional Info' && Trigger.oldMap.get(cse.id).status != 'Additional Info'){
                    cse.Workflow_Evaluation_Date__c = addBussinessDays(Datetime.now(), Integer.valueof(Case_Status_Duration__c.getValues('Additional Info').Number_of_Days__c));
                    //cse.Workflow_Evaluation_Date__c = Datetime.now().addMinutes(2);
                }
                
                if(cse.Status == 'Confirm Resolution' && Trigger.oldMap.get(cse.id).status != 'Confirm Resolution'){
                    cse.Confirm_Resolution_WF_Evaluation_Date__c = addBussinessDays(Datetime.now(), Integer.valueof(Case_Status_Duration__c.getValues('Confirm Resolution').Number_of_Days__c));
                    //cse.Confirm_Resolution_WF_Evaluation_Date__c = Datetime.now().addMinutes(2);
                }
                
        }
        }
    }