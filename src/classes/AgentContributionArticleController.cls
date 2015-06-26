public class AgentContributionArticleController {
    // DKB using code sample in Knowledge implementation guide for this
    // The constructor must take a ApexPages.KnowledgeArticleVersionStandardController as an argument
    public AgentContributionArticleController(ApexPages.KnowledgeArticleVersionStandardController ctl) {
        SObject article = ctl.getRecord();   //this is the SObject for the new article. 
                                             //It can optionally be cast to the proper article type, e.g. FAQ__kav article = (FAQ__kav) ctl.getRecord();
        
        String sourceId = ctl.getSourceId(); //this returns the id of the case that was closed.
        Case c = [select subject, description, root_cause_analysis__c, Resolution_Description__c from Case where id=:sourceId];
        
        article.put('Summary__c',c.subject);  //this overrides the default behavior of pre-filling the title of the article with the subject of the closed case. 
        article.put('ApttusDescription__c',c.Root_Cause_Analysis__c); 
        article.put('ApttusResolution__c',c.Resolution_Description__c); //this should be changed once a permanent field is designated
        article.put('Summary',c.description);
        
       // ctl.selectDataCategory('Geography','USA');  Only one category per category group can be specified.
       // ctl.selectDataCategory('Topics','Maintenance');                        
    }
    }