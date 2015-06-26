/* APTS_mbowrapper
 * Wrapper class used to display MBO's in hierarchial view.
 *
 * Developer: Harish Emmadi, APTTUS
 * Business Owner: 
 *
 * Scenario:
 * 
 * 
 *
 * History:
 
 * 02/20/2015, Harish Emmadi, APTTUS - created APTS_mbowrapper class.
 */
global class APTS_mbowrapper implements Comparable{
	public String branchId;
	public String username{get; private set;}
	public List<MBO__c> mbos{get; private set;}
	public String rowId{get; private set;}
	public String parentId{get; private set;}
	public APTS_mbowrapper(String branchId, List<MBO__c> mbos){
		this.branchId = branchId;
		this.username = mbos.get(0).Employee__r.Name;
		this.mbos = mbos;
		this.rowId = mbos.get(0).Employee__c;
		this.parentId = mbos.get(0).Manager__c;
	}
	
	// Compare opportunities based on the opportunity amount.
    global Integer compareTo(Object compareTo) {
        
        // Cast argument to OpportunityWrapper
        APTS_mbowrapper compareTombo = (APTS_mbowrapper)compareTo;
        
        // The return value of 0 indicates that both elements are equal.
        Integer returnValue = 0;
        if (branchId > compareTombo.branchId) {
            // Set return value to a positive value.
            returnValue = 1;
        } else if (branchId < compareTombo.branchId) {
            // Set return value to a negative value.
            returnValue = -1;
        }
        
        return returnValue;       
    }
}