trigger TimeCardValidation on pse__Timecard_Header__c (after update) {
 
 Date startdate, enddate;
 Id ids;
 String ContactType;
 for(pse__Timecard_Header__c header : Trigger.new) {
    ContactType =header.Contact_Type__c;
    startdate=header.pse__Start_Date__c;
    enddate=header.pse__End_Date__c ;
    ids=header.pse__Resource__c ;
    }
List<pse__Timecard_Header__c > timecards =[select Id,pse__Total_Hours__c   from pse__Timecard_Header__c where pse__Resource__c = : ids
                                            and pse__Start_Date__c = : startdate and pse__End_Date__c = : enddate];
 Decimal totalhours=0;

 for(pse__Timecard_Header__c cards : timecards) {
    totalhours += cards.pse__Total_Hours__c   ;
 }
 
 for(pse__Timecard_Header__c header : Trigger.new) {
 if(totalhours < 40 && header.Contact_Type__c!='Other' && !header.Contact_Type__c.contains('Contractor') && header.pse__Submitted__c 
         && !Trigger.oldMap.get(header.id).pse__Submitted__c)
        {
            header.adderror('Total Week hours should not be less than 40 hours for full time employees ');
        }
 }
 
 
 System.debug('size::'+totalhours);
  /*  Decimal totalhours=0;
    String ContactType='';
    Boolean submitted=false;
    Id ids;
    for(pse__Timecard_Header__c header : Trigger.new) {
    
         totalhours+=header.pse__Total_Hours__c;  
         ContactType=header.Contact_Type__c;
         submitted=header.pse__Submitted__c;
         ids=header.ID;
     }
     if(totalhours < 40 && ContactType!='Other' && !header.Contact_Type__c.contains('Contractor') && submitted=true 
         && !Trigger.oldMap.get(ids).pse__Submitted__c)
        {
            Trigger.adderror('jhb');
        }
  
    
*/
    
   /* Set<Id> resourceIds = new Set<Id>();
    Map<Id, pse__Timecard_Header__c> mapResourceToTimeCard = new Map<Id, pse__Timecard_Header__c>();
    for(pse__Timecard_Header__c header : Trigger.new) {
        
        resourceIds.add(header.pse__Resource__c);
        //mapResourceToTimeCard.put(header.resour, header);
    }
    List<pse__Timecard_Header__c > timeCardEntryList =[Select Id,pse__Total_Hours__c ,pse__Submitted__c  
        from pse__Timecard_Header__c where pse__Status__c='Saved' and pse__Resource__c in :resourceIds];
    
    Decimal totalHours; 
    for(pse__Timecard_Header__c header : Trigger.new) {
        totalHours = 0;
        for(pse__Timecard_Header__c existingheader : timeCardEntryList) {
            totalHours += existingheader.pse__Total_Hours__c ;
        }
        totalHours = totalHours + header.pse__Total_Hours__c;
         if(totalHours <40) {
    
    header.adderror('error '+totalhours+'  size' +Trigger.size);
    }
    }
    */
    /*
    for(pse__Timecard_Header__c header : timeCardEntryList) {        
            totalHours += header.pse__Total_Hours__c ;
    }
    
    for(pse__Timecard_Header__c header : Trigger.new){
    if(!Trigger.oldMap.get(header.id).pse__Submitted__c && header.pse__Submitted__c )
    {
    List<pse__Timecard_Header__c > timeCardEntryList =[Select Id,pse__Total_Hours__c ,pse__Submitted__c  from pse__Timecard_Header__c where pse__Status__c='Saved' 
    and pse__Resource__c = : header.pse__Resource__c];
        Decimal totalHours = 0;
        header.addError(' first Total Week hours should not be less than 40 hours for full time employees '+timeCardEntryList.size() );
        for(pse__Timecard_Header__c card : timeCardEntryList )
        {
        totalHours += card.pse__Total_Hours__c ;
        
        }
        
        
     }
        if((header.Contact_Type__c !='Other' && !header.Contact_Type__c.contains('Contractor'))&&header.pse__Submitted__c && !Trigger.oldMap.get(header.id).pse__Submitted__c
            && header.pse__Total_Hours__c < 40){
            header.addError(header.pse__Submitted__c +'  : Total Week hours should not be less than 40 hours for full time employees ');

        }
    }
    */

}