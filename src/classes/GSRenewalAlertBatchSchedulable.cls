/***************************************************************************************************************
**  File:   GSRenewalAlertBatchSchedulable.cls 
**  Desc:   Upcoming Renewal Alert Scheduler.
**          Built for Apttus
**  Auth:   Rory Sherony
**  Date:   6.30.14                    DEPRECATED
****************************************************************************************************************
**  Change History
**  PR  Date        Author          Description 
**  --  --------    ------------    ----------DEPRECATED-------------------------
***************************************************************************************************************/

global class GSRenewalAlertBatchSchedulable implements Schedulable {

    global void execute(SchedulableContext scMain) {
        database.executebatch(new GSRenewalAlertBatch(), 50);
    }
}