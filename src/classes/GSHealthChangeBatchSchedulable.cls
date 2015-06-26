/****************************************************************************************
**  File:   GSHealthChangeBatchSchedulable.cls
**  Desc:   Scheduler for GSHealthChangeBatch.cls
**  Auth:   Rory Sherony
**  Date:   6.10.14
*****************************************************************************************
**  Change History
**  PR  Date        Author          Description 
**  --  --------    ------------    ------------------------------------
****************************************************************************************/

global class GSHealthChangeBatchSchedulable implements Schedulable {

    global void execute(SchedulableContext scMain) {
        database.executebatch(new GSHealthChangeBatch(), 50);
    }
}