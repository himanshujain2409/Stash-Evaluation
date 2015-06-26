@isTest
public class operateUsageMetricsTest {

    static testMethod void operateUsageMetricsTest(){
        
         Test.startTest();

         database.executebatch(new operateUsageMetrics(), 50);

         Test.stopTest();
        
    }
    
}