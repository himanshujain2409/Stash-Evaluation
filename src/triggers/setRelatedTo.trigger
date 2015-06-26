trigger setRelatedTo on Event (before Insert, before Update) {

    List<Event> EvntList = new List<Event>{};
    List<String> ISRNameList= new List<string>{};
    List <India_Service_Request__c> ISRList = new List<India_Service_Request__c>{};
    
    //Retrieve Events.
    for(Event Ev_new:Trigger.new){ 
        Integer index;
        String name;
        if (Ev_new.subject != null &&Ev_new.subject.contains('ISR-')) {
            EvntList.add(Ev_new);  
            index = Ev_new.subject.indexOf('ISR-');
            name = Ev_new.subject.subString(index,index+9);
            ISRNameList.add(name);
        }
    } 
    
    ISRList = [select id, name from India_Service_Request__c where name =: ISRNameList];
    
    if(ISRList != null && ISRList.size()!=0) {
        for(Event Ev_filtered:EvntList) {
            for(India_Service_Request__c ISR:ISRList )
            {
                if(Ev_filtered.subject != null && Ev_filtered.subject.contains(ISR.name))
                   Ev_filtered.WhatId = ISR.Id;
            }
        }
    }
    
}