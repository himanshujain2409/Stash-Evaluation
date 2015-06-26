// This is Batch Apex class to update the all Contacts. In production have around 150000 contacts 
// so i can not update with simple script. It is a one time batch class.

global class batchContactUpdate implements Database.Batchable<sObject>
{
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String query = 'SELECT Id,Name FROM Account';
        return Database.getQueryLocator(query);
    }
  
    global void execute(Database.BatchableContext BC, List<account> scope)
    {
       Set<ID> acctIds = new Set<ID>();
    for (account acc : scope) {
            acctIds.add(acc.id);
    }
        //apex class method
         UpdateContactInfoTriggerHandler.UpdateContactCountOnAccount(acctIds);
    }  
    global void finish(Database.BatchableContext BC)
    {
    }
}