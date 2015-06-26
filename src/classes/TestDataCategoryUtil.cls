@isTest
public class TestDataCategoryUtil {

    static testMethod void  testDataCategory()
    {
        test.startTest();
        DataCategoryUtil.getInstance().getAllCategoryGroups();
    	test.stopTest();
    }
}