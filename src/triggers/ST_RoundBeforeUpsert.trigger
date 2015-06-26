trigger ST_RoundBeforeUpsert on FRLS_Round__c (before insert, before update) {
	ST_RoundBeforeUpdate.setAccountLookup(Trigger.new);
	ST_RoundAfterUpsert.updateReferenceFields(Trigger.new);
}