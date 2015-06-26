trigger CreateEventOnTranscriptSave on LiveChatTranscript (after insert) {
		Set <Id> leadIds = new Set <Id>();
	    Map<Id,LiveChatTranscript> transctiptsMap = new Map<Id,LiveChatTranscript>();
	    
        for (LiveChatTranscript lct:Trigger.new){
                        transctiptsMap.put(lct.LeadId, lct);
                        leadIds.add(lct.LeadId);
        }
        
        Map<Id,Lead> leadsMap= new Map<Id,Lead>([Select Id,OwnerId from Lead where Id in:leadIds]);

        List<Task> tasksList = new List<Task>();
        String body;
        DateTime endTime;
        if (leadIds !=null){
            for(Id leadId:leadIds){
				endTime = transctiptsMap.get(leadId).EndTime;
				body = transctiptsMap.get(leadId).Body;
				
				if(body == null) {
					body = '';
				} else {
					body = body.unescapeHtml4();
					body = body.replaceAll('</p>|<br>', '\n'); 
					body = body.replaceAll('<[^>]*>', '');	
				} 
				
				Task t = new Task(Subject='Live Chat', 
					WhoId=leadId, 
					Status='Completed', 
					Description = body,
					ActivityDate = Date.newInstance(endTime.year(), endTime.month(), endTime.day()),
					Call_Classification__c='Live Chat');
            	tasksList.add(t);
            }
        }
        System.debug(tasksList);
        insert tasksList;
}