/***************************************************************************************************************
**  File:   GainsightHealthUsageBatchSchedulable.cls 
**  Desc:   Health Trend Scheduler.
**          Built for Apttus
**  Auth:   Rory Sherony
**  Date:   3.22.14            DEPRECATED
****************************************************************************************************************
**  Change History
**  PR  Date        Author          Description 
**  --  --------    ------------    ----DEPRECATED---------
***************************************************************************************************************/

global class GainsightHealthUsageBatchSchedulable implements Schedulable {

    global void execute(SchedulableContext scMain) {
        database.executebatch(new GainsightHealthUsageBatch(), 50);
    }
}