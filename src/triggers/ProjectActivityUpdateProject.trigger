trigger ProjectActivityUpdateProject on Project_Activity_NEW__c (after delete, after insert, after update) {
 List<pse__Proj__c> parentObjList = new List<pse__Proj__c>();    
  public List<Id> listIds = new List<Id>();
if(trigger.isInsert) {
  for(Project_Activity_NEW__c childObj : Trigger.new){    
    listIds.add(childObj.Project2__c);    
  }  
}else{
  for(Project_Activity_NEW__c childObj : Trigger.old){    
    listIds.add(childObj.Project2__c);    
  }
}
    
   if(listIds != null){
 	parentObjList = [SELECT Id,Name FROM pse__Proj__c WHERE ID IN :listIds];
  	update parentObjList;  
   }
}