trigger ContactSkillRating on Contact (after insert) {
    List<pse__Skill_Certification_Rating__c> skillRatingList = new List<pse__Skill_Certification_Rating__c>();
    List<pse__Skill__c> skillList = [select Name, pse__Type__c, pse__Skill_Or_Certification__c from pse__Skill__c];      
            
    for(Id c : Trigger.newMap.keySet()){
        if(String.isNotBlank(c) && Trigger.newMap.get(c).pse__Is_Resource__c)  {
            for(pse__Skill__c sk : skillList){
                pse__Skill_Certification_Rating__c scr = new pse__Skill_Certification_Rating__c();
                scr.pse__Skill_Certification__c = sk.id;
                scr.pse__Resource__c = c;
                scr.pse__Evaluation_Date__c = date.today();
                scr.pse__Rating__c = 'None';
                skillRatingList.add(scr);
            }        
        }
    }    
    insert skillRatingList;
}