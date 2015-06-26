Public class ProjectCostUpdate {


public List<pse__Proj__c> projectToUpdate =new List<pse__Proj__c>();
    
    public List<pse__Timecard_Header__c> timeCardList = new List<pse__Timecard_Header__c>([select Id , Total_Time_Card_Cost__c , pse__Project__c from pse__Timecard_Header__c  
                                                                                    where (pse__Project__c != null and pse__Approved__c =true )]);
    public Map <Id,Decimal> mapTimecard =new Map <Id,Decimal>();
 
 public void calculateProjectCost(){  
   
    
    for(pse__Timecard_Header__c t: timeCardList ) 
    {
        Decimal temp=0;
        if(mapTimecard.containsKey(t.pse__Project__c))
        {
        
           temp = mapTimecard.get(t.pse__Project__c);
           temp += t.Total_Time_Card_Cost__c ;
           mapTimecard.put(t.pse__Project__c, temp); 
        }
        else
        {
            mapTimecard.put(t.pse__Project__c, ((mapTimecard.get(t.pse__Project__c)==null?0:mapTimecard.get(t.pse__Project__c))+t.Total_Time_Card_Cost__c)); 
        }
    }
    for(Id pId : mapTimecard.keySet() )
    {
        projectToUpdate.add(new pse__Proj__c(Id = pId , Project_Cost__c = mapTimecard.get(pId)) );
    }
    List<pse__Proj__c> oProj =new List<pse__Proj__c>();
    for(pse__Proj__c pw : [select Id from pse__Proj__c where Id not in : projectToUpdate ] )
    {
        pw.Project_Cost__c =0;
        oProj.add(pw);
        System.Debug(pw);
    }
    update oProj;
    update projectToUpdate;     
 } 
}