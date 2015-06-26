/***************************************************************************************************************
**  File:   GSCustRefBatchSchedulable.cls 
**  Desc:   Customer Reference Milestone Scheduler.
**          Built for Apttus
**  Auth:   Rory Sherony
**  Date:   5.23.14
****************************************************************************************************************
**  Change History
**  PR  Date        Author          Description 
**  --  --------    ------------    ------------------------------------
***************************************************************************************************************/

global class GSCustRefBatchSchedulable implements Schedulable {

    global void execute(SchedulableContext scMain) {
        database.executebatch(new GSCustRefBatch(), 50);
    }
}