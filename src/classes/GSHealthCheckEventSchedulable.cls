/***************************************************************************************************************
**  File:   GSHealthCheckEventSchedulable.cls 
**  Desc:   Upcoming Health Check Scheduler.
**          Built for Apttus
**  Auth:   Rory Sherony
**  Date:   7.20.14        DEPRECATED
****************************************************************************************************************
**  Change History
**  PR  Date        Author          Description 
**  --  --------    ------------    ------------------------------------
                    DEPRECATED
***************************************************************************************************************/

global class GSHealthCheckEventSchedulable implements Schedulable {

    global void execute(SchedulableContext scMain) {
        database.executebatch(new GSHealthCheckEventBatch(), 50);
    }
}