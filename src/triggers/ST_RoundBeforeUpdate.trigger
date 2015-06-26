trigger ST_RoundBeforeUpdate on FRLS_Round__c (before update) {
	ST_RoundBeforeUpdate.calcCallbackDate(Trigger.new);
}