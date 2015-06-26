/***************************************************************************************************************
**  File:   GainsightCaseSurveyBatchSchedulable.cls 
**  Desc:   Case Survey Scheduler.
**          Built for Apttus
**  Auth:   Rory Sherony
**  Date:   4.29.14
****************************************************************************************************************
**  Change History
**  PR  Date        Author          Description 
**  --  --------    ------------    ------------------------------------
***************************************************************************************************************/

global class GainsightCaseSurveyBatchSchedulable implements Schedulable {

    global void execute(SchedulableContext scMain) {
        database.executebatch(new GainsightAutomatedCaseSurvey(), 50);
    }
}