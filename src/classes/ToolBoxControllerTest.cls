@isTest
private class ToolBoxControllerTest {
	public static testMethod void unittest() {
		ToolBoxController tbc = new ToolBoxController();
		tbc.searchText = 'MDO';
		tbc.search();
		tbc.gotonext();
	}	
}