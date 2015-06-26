@isTest
public class VfSearchControllerTest {
    public static testMethod void unitTest(){
        VfSearchController testVfSearchController = new VfSearchController();
        testVfSearchController.searchstring = 'a';
        PageReference pg = Page.ApttusArticleList;
         Test.setCurrentPage(pg);             
         System.currentPagereference().getParameters().put('categoryType_Apttus_Products','All');
       // ApexPages.currentPage().getParameters().put('categoryType_KnowledgeArticleVersion', billTo.id);
        DataCategoryGroupInfo[] dataCategoryGroups = testVfSearchController.getDataCategoryGroupInfo();
        for(DataCategoryGroupInfo dcgi : dataCategoryGroups)
        {            
            system.debug('categoryType : ' + System.currentPageReference().getParameters().Get('categoryType_'+dcgi.getName()));
        }        
        testVfSearchController.getCategoryKeyword();
        testVfSearchController.refreshSearchResult();
        testVfSearchController.getNextRequired();
        testVfSearchController.getPrevRequired();
        testVfSearchController.next();
        testVfSearchController.getCurrentPageNumber();
        testVfSearchController.previous();
        
    }
}