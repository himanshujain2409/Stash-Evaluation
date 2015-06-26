@isTest
public class DataCategoryGroupInfoTest {
    static testMethod void createNewInstance(){
        DataCategoryInfo[] testDataCategoryInfo = new DataCategoryInfo[]{
            								new DataCategoryInfo('this is name', 'this is label', 'this is displayName')
        };        
        DataCategoryGroupInfo testDataCategoryGroupInfo = new DataCategoryGroupInfo('this is name'
                                                                                   ,'this is label'
                                                                                   ,'this is description'
                                                                                   ,testDataCategoryInfo);
        System.assertEquals('this is name', testDataCategoryGroupInfo.getName());
        System.assertEquals('this is label', testDataCategoryGroupInfo.getLabel());
        System.assertEquals('this is description', testDataCategoryGroupInfo.getDescription());  
        System.assertEquals(testDataCategoryInfo[0], testDataCategoryGroupInfo.getGroupStructure()[0]);
    }
}