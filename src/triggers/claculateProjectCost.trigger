trigger claculateProjectCost on pse__Timecard_Header__c (after update) {
if(Trigger.size==1){

for(pse__Timecard_Header__c t : Trigger.new){
    System.debug('*** new approved - ' + t.pse__Approved__c);
    System.debug('*** old approved - ' + Trigger.oldMap.get(t.Id).pse__Approved__c);
    System.debug('*** t.pse__Project__c ' + t.pse__Project__c);
if(t.pse__Approved__c == true && Trigger.oldMap.get(t.Id).pse__Approved__c != true && t.pse__Project__c!= null){
    Decimal total=0;
    for(pse__Timecard_Header__c  q : [select Id,Total_Time_Card_Cost__c from pse__Timecard_Header__c  
                                    where (pse__Project__c = :t.pse__Project__c and pse__Approved__c =true )]){
    total = total + q.Total_Time_Card_Cost__c;
    }
       pse__Proj__c prj = new pse__Proj__c(Id = t.pse__Project__c, Project_Cost__c =total);
       update prj;
        }   
    }
   }
}