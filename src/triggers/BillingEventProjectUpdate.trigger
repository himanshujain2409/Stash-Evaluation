trigger BillingEventProjectUpdate on pse__Billing_Event__c (after delete, after insert, after update) {
 List<pse__Proj__c> parentObjList = new List<pse__Proj__c>();    
  public List<Id> listIds = new List<Id>();
if(trigger.isInsert) {
  for(pse__Billing_Event__c childObj : Trigger.new){    
    listIds.add(childObj.pse__Project__c);    
  }  
}else{
  for(pse__Billing_Event__c childObj : Trigger.old){    
    listIds.add(childObj.pse__Project__c);    
  }
}
    
   if(listIds != null){
 	parentObjList = [SELECT Id,Name FROM pse__Proj__c WHERE ID IN :listIds];
  	update parentObjList;  
   }
}