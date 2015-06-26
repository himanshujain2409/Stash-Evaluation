global class APTS_MBOInsertPerfReviewBatch implements Database.Batchable<sObject> {
	
	String query;
	
	global APTS_MBOInsertPerfReviewBatch() {
		
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
	
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}
	
}