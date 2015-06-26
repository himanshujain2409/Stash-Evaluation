trigger ST_RoundAfterInsert on FRLS_Round__c (after insert) {
	   List <task> taskToInsert = new List <task> ();

   for (FRLS_Round__c r : Trigger.new) {
   
	   task t = new task ();
       String description = '';

	   t.Subject = 'RoundToTask';
	   t.OwnerId = UserInfo.getUserId();
	   t.WhatId = r.id;
	   t.Status = 'Not Started';
	   t.Priority = 'Normal';
	   description = r.name;
  /*     if(r.Admin_Dialogue__c == true)
           description += '[x] Admin Dialogue, ';
       else
           description += '[] Admin Dialogue, ';
       
       if(r.Admin_VM__c == true)
           description += '[x] Admin VM, ';
       else
           description += '[] Admin VM, ';
       
       if(r.Admin_EM__c == true)
           description += '[x] Admin EM, ';
       else
           description += '[] Admin EM, ';
       
       if(r.Fax__c == true)
           description += '[x] Fax, ';
       else
           description += '[] Fax, '; 

       if(r.KP_Dialogue__c == true)
           description += '[x] KP Dialogue, ';
       else
           description += '[] KP Dialogue, ';       

       if(r.KP_EM__c == true)
           description += '[x] KP_EM, ';
       else
           description += '[] KP_EM, ';       

       if(r.KP_VM__c == true)
           description += '[x] KP_VM, ';
       else
           description += '[] KP_VM, ';       

       if(r.Mail__c == true)
           description += '[x] Mail, ';
       else
           description += '[] Mail, ';       

       if(r.Previous_Round_KP__c == true)
           description += '[x] Previous_Round_KP, ';
       else
           description += '[] Previous_Round_KP, ';       

       if(r.Referral__c == true)
           description += '[x] Referral, ';
       else
           description += '[] Referral ';  */                
	   t.Description = description;
	   taskToInsert.add(t);
	}
	/*insert taskToInsert;*/
}