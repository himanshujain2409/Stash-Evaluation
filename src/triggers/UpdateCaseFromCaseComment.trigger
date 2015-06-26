trigger UpdateCaseFromCaseComment on CaseComment (before insert, after insert, after update) {

    Set<Id> PrntId = new Set<Id>{};
    List<Case> caselist = new List<Case>{};
    List<CaseComment> cmt= new List<CaseComment>();
    List<CaseComment> caseCommentsLst= new List<CaseComment>();
    List<CaseComment> FinalCaseComment = new List<CaseComment>{};
    Map<Id, Case> MapCaseIdToCase = New Map<Id, Case>();
    
    for(CaseComment cmnt:Trigger.new){
        PrntId.add(cmnt.ParentId);
    }

    cmt=[Select Id,CreatedDate,CommentBody,ParentId,IsPublished,CreatedById from CaseComment 
            where ParentId=:PrntId AND IsPublished = True
            ORDER BY ParentId ASC,CreatedDate ASC];
    
    caseCommentsLst=[Select Id,CreatedDate,CommentBody,ParentId,IsPublished,CreatedById from CaseComment 
            where ParentId=:PrntId 
            ORDER BY ParentId ASC,CreatedDate ASC];
   

    caselist = [select id,ResponceTime__c, status, ClosedDate, IsClosed from case
                where id=:PrntId];
    

    
    If( Trigger.IsBefore )
    {        
        Date CaseReopenDate ;
        Case_Custom_Settings__c caseproperties = Case_Custom_Settings__c.getValues('System Properties'); 
        
        String strUserType = UserInfo.getUserType();
        
        if( strUserType == 'CSPLitePortal' || strUserType == 'CustomerSuccess' || strUserType == 'PowerCustomerSuccess' )
        {        
            For( Case c : caselist )
            {
                MapCaseIdToCase.put(c.Id, c);
            }
                
            if( caseproperties != null && caseproperties.Number_of_Days__c != null)
            {
                CaseReopenDate = System.Today().adddays(- Integer.ValueOf(caseproperties.Number_of_Days__c));
                
                For( CaseComment cc : Trigger.New )
                {
                    if( MapCaseIdToCase.get(cc.ParentId) != null && MapCaseIdToCase.get(cc.ParentId).IsClosed == TRUE )
                    {
                        if( MapCaseIdToCase.get(cc.ParentId).ClosedDate.Date() < CaseReopenDate )
                        {
                            cc.addError(Label.ACPCaseReopenErrorMessage);
                        }
                    }
                }
            }
        }
    }
    else if( Trigger.IsAfter )
    {
        if(cmt.size()>0){

            FinalCaseComment.add(cmt[0]);
        }
    
        for(integer j=0;j<cmt.size();j++){
            system.debug('&&&&&&& inside for loop====J==='+j);
            if(j!=(cmt.size()-1)){
                if(cmt[j].parentid != cmt[j+1].parentid){
                    system.debug('&&&&&&& inside If Loop====J'+j);
                    FinalCaseComment.add(cmt[j+1]);                
                }
            }                              
        }
    
    
        String createdById = '';
        for(Case c :caselist){
            Datetime d=null;
            for(CaseComment Cscmt:FinalCaseComment){    
                if(Cscmt.parentId == c.id){
                    d = Cscmt.CreatedDate;    
                    createdById = Cscmt.CreatedById;
                           
                }
            }    
        
            c.ResponceTime__c = d;   
              
        }          
    
      /*  if(cmt!=null && cmt.size()> 0 && caselist!=null && caselist.size() > 0)       
        {
            List<User> user = [select name from user where id =  :cmt[0].CreatedById];    
    
            if(user!=null && user.size() > 0 )
            {
                caselist[0].Case_Response_Owner__c =  user[0].name;          
            }
            else
            {
                List<SelfServiceUser> selfServiceUser = [select name from SelfServiceUser where id =  :cmt[0].CreatedById];
                caselist[0].Case_Response_Owner__c =  selfServiceUser[0].name;
            }    
        }*/
        
        if(caseCommentsLst!=null && caseCommentsLst.size()> 0)
        
        {
        
        for (Case c :caselist)
        {
        
      
 
        if(caseCommentsLst[caseCommentsLst.size()-1].CommentBody!=null && caseCommentsLst[caseCommentsLst.size()-1].CommentBody.length() > 0 && !(caseCommentsLst[caseCommentsLst.size()-1].CommentBody.contains('auto-closed') && (!caseCommentsLst[caseCommentsLst.size()-1].CommentBody.contains('Apttus Technical Support') || !caseCommentsLst[caseCommentsLst.size()-1].CommentBody.contains('Apttus Support Team')) ))     
                            {
                            
                                c.Status='Updated';
                            }
                        
        
        
        }
        
        }
        
        
         if(cmt!=null && cmt.size()> 0 && caselist!=null && caselist.size() > 0)       
        {
           
          List<CaseHistory> caseHistoryLst = [select createdById from CaseHistory where caseId = :cmt[0].parentId order by createdDate];
          List<ID> createdByIdLst = new List<ID>();
          Map<Id,String> userIdNameMap = new Map<Id,String>();
          if (caseHistoryLst !=null && caseHistoryLst.size() > 0) 
          {
          
            for(CaseHistory caseHistory: caseHistoryLst)
            {
                createdByIdLst.add(caseHistory.createdById);
            }
          }
           
             List<User> userLst = [select id,name from user where id  in  :createdByIdLst and email like '%@apttus.com%']; 


            if(userLst !=null && userLst.size() > 0)

            {
            
                for(User user : userLst)
                {
                    if(userIdNameMap.get(user.id) == null)
                    { 
                        userIdNameMap.put(user.id, user.name);
                    }
                    
                }
            }           

            
            for(CaseHistory caseHistory: caseHistoryLst)
            {
                
                if(userIdNameMap.get(caseHistory.createdById)!=null)
                {
                 caselist[0].Case_Response_Owner__c = userIdNameMap.get(caseHistory.createdById);
                 break;
                }
            
            }
          
            
        }
        
        
        update caselist;                
    }
}