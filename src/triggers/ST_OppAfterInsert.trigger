trigger ST_OppAfterInsert on Opportunity (after insert) {
	ST_OppNew.linkMIEvent(Trigger.new);
}