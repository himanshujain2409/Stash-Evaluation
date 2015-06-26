@isTest
private class TestOpportunityTriggers{

    public static testmethod void TestOpportunityTriggers(){
    
        Opportunity opp = new Opportunity(Name='test opp', StageName='stage', Probability = 95, CloseDate=system.today());
        insert opp;
    
    }

}