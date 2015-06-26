trigger ATPS_UpdateProjecTime_Trigger on pse__Assignment__c (after insert, after update) {
    
    if(Trigger.Isafter && (Trigger.Isinsert || Trigger.Isupdate))
    {
            
        APTS_AssignmentHelper oHelper = new APTS_AssignmentHelper();
        
        //Update the project end date if the assignment end date is greater than project end date
        If(!oHelper.UpdateProjectEndDate(Trigger.New))
        {   System.debug('MIHIR SHAH'+oHelper.sError);        
            for(pse__Assignment__c OAssign  :Trigger.New )
            {
                OAssign.ADDERROR(oHelper.sError);
            }           
        }
    
    }
}