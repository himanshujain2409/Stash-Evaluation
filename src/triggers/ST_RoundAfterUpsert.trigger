trigger ST_RoundAfterUpsert on FRLS_Round__c (after insert, after update) {
	ST_RoundAfterUpsert.setLastTouched(Trigger.new);
}