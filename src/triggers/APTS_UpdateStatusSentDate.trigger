trigger APTS_UpdateStatusSentDate on ob1__Output_History__c (after insert, after update) {
    // Start: Mod by Nimit S on 06/10/14  
    Set<ID> objProjectSet = new Set<ID>();
    List<pse__Proj__c> objProjects = new List<pse__Proj__c>();
    
    if(Trigger.isInsert)
    {
        for (ob1__Output_History__c objOutputHistory : Trigger.new)
        {
            if(objOutputHistory.ob1__Status__c == 'sent')
            {
                objProjectSet.Add(objOutputHistory.Project__c);
            }
        }
    }
    else if(Trigger.isUpdate)
    {
        for (ob1__Output_History__c objOutputHistory : Trigger.new)
        {
            ob1__Output_History__c oldStatus = Trigger.oldMap.get(objOutputHistory.Id);
            
            if(objOutputHistory.ob1__Status__c == 'sent' && oldStatus.ob1__Status__c <> 'sent')
            {
                objProjectSet.Add(objOutputHistory.Project__c);
            }
        }
    }
    for(ID objID: objProjectSet)
    { 
        objProjects.Add(new pse__Proj__c(Id=objID, APTS_Project_Status_Sent_Date__c = System.now()));
    }
    if (objProjects.size() > 0)
    {
        update objProjects;
    }
    // End: Mod by Nimit S on 06/10/14 
    if(Trigger.isInsert || Trigger.isUpdate)
    {
        if(objProjectSet.size()>0)
        {
            Map<Id,pse__Proj__c> projectMap = new Map<Id,pse__Proj__c>([select Id,pse__Account__c,Name from pse__Proj__c where Id in :objProjectSet ]);
            pse__Proj__c project;
            List<PS_Project_Status_Reports__c> psProjectList = new List<PS_Project_Status_Reports__c>();
            for (ob1__Output_History__c objOutputHistory : Trigger.new)
            {
                if(objOutputHistory.ob1__Status__c == 'sent')
                {
                    project = projectMap.get(objOutputHistory.Project__c);
                    
                    PS_Project_Status_Reports__c psProject = new PS_Project_Status_Reports__c();
                    psProject.Account__c = project.pse__Account__c;
                    psProject.Approved__c = objOutputHistory.ob1__Approved__c;
                    psProject.BCC__c = objOutputHistory.ob1__BCC__c;
                    psProject.CC__c = objOutputHistory.ob1__CC__c;
                    psProject.Content_Type__c = objOutputHistory.ob1__Content_Type__c;
                    psProject.Object_ID__c = objOutputHistory.ob1__Object_ID__c;
                    psProject.Object_Name__c = objOutputHistory.ob1__Object_Name__c;
                    psProject.Project__c = project.Name;
                    psProject.Reply_To__c = objOutputHistory.ob1__Reply_To__c;
                    psProject.Resend_To__c = objOutputHistory.ob1__Resend_To__c;
                    psProject.Sender_Display_Name__c = objOutputHistory.ob1__Sender_Display_Name__c;
                    psProject.Status__c = objOutputHistory.ob1__Status__c;
                    psProject.Subject__c = objOutputHistory.ob1__Subject__c;
                    psProject.Template_Class__c = objOutputHistory.ob1__Template_Class__c;
                    psProject.Template_Name__c = objOutputHistory.ob1__Template_Name__c;
                    psProject.To__c = objOutputHistory.ob1__To__c;
                    
                    psProjectList.add(psProject);
                }
            }
            if(psProjectList.size()>0)insert psProjectList;
        }
    }
}