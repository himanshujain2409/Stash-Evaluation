// This trigger will roll-up the total no of Contact to the specific Account.
// And also will will roll-up the total no of Active Portal users (It a check box in contact object) to the specific Account.

trigger ContactRollupTrigger on Contact (after delete, after insert, after undelete, after update) {

    Contact[] cons;
    if (Trigger.isDelete)
        cons = Trigger.old;
    else
        cons = Trigger.new;

    // get list of accounts
    Set<ID> acctIds = new Set<ID>();
    for (Contact con : cons) {
            acctIds.add(con.AccountId);
    }
   
     // Calling the required method from Apex class. 
   UpdateContactInfoTriggerHandler.UpdateContactCountOnAccount(acctIds);
    
}