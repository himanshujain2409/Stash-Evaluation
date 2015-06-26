@isTest
public class DataCategoryInfoTest {
    static testMethod void createNewinstance(){
        DataCategoryInfo testDataCategoryInfo = new DataCategoryInfo('this is name', 'this is label', 'this is displayName'); 
        string name = testDataCategoryInfo.getName();
        System.assertEquals('this is name', testDataCategoryInfo.getName());
        System.assertEquals('this is label', testDataCategoryInfo.getLabel());
        System.assertEquals('this is displayName', testDataCategoryInfo.getDisplayName());
    }
}