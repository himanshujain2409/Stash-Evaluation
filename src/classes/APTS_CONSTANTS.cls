/* APTS_CONSTANTS
 * Class to hold hardcoded values like picklists and record types.
 *
 * Developer: Harish Emmadi, APTTUS
 * Business Owner: 
 *
 * Scenario:
 * 
 * 
 *
 * History:
 
 * 02/24/2015, Harish Emmadi, APTTUS - created APTS_CONSTANTS.
 */
public with sharing class APTS_CONSTANTS {
    // MBO related
    public static final String MBO_YQ_12 = 'Q1/Q2';
    public static final String MBO_YQ_34 = 'Q3/Q4';

    // Performance Review related
    public static final String PR_STATUS_PENDING = 'Pending';
    public static final String PR_STATUS_EMP_COMPLETE = 'Employee complete';
    public static final String PR_STATUS_COMPLETE = 'Complete';
    public static final String PR_REVIEW_VISIBLE_EMP_YES = 'Yes';
    public static final String PR_APPROVALSTATUS_APPROVED = 'Approved';
    public static final String PR_OVERALLRATING_1 = 'Failure to Launch';
    
    // Parm custom settings
    public static final String PARM_TABSCOUNT_MBOPAGE = 'tabcountinmbopage';
}