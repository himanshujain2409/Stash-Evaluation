trigger Lead on Lead (after update) 
{
    if (Trigger.new.size() == 1 && ((Lead)Trigger.new[0]).isConverted && !((Lead)Trigger.old[0]).isConverted &&
        ((Lead)Trigger.new[0]).ConvertedContactId != null)
    {
        List<FRLS_Round__c> leadRounds = [
                SELECT Contact__c, Lead__c 
                FROM FRLS_Round__c 
                WHERE Lead__c = :((Lead)Trigger.new[0]).Id];
                
        for (FRLS_Round__c leadRound : leadRounds)
        {
            leadRound.Lead__c = null;
            leadRound.Contact__c = ((Lead)Trigger.new[0]).ConvertedContactId;
        }
        update leadRounds;
    }
}