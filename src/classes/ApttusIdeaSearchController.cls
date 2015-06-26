public with sharing class ApttusIdeaSearchController {

    private final ApexPages.StandardController ideaController;
    private final string queryString;
    public List<Idea> lstIdeaResult{get; set;}
    
    public ApttusIdeaSearchController(ApexPages.IdeaStandardController ideaController){
        
        //this.ideaController = (ApexPages.IdeaStandardController)ideaController;
    }
    
    public ApttusIdeaSearchController(ApexPages.StandardController ideaController){
        
        this.ideaController = ideaController;
        this.queryString = ApexPages.currentPage().getParameters().get('q');
        lstIdeaResult = new List<Idea>();
    }
    
    public pageReference doSearchIdeas(){
        
        if(queryString != null && queryString != ''){
            
            List<List<SObject>> lstIdeas = [FIND :queryString IN ALL FIELDS RETURNING Idea(Id, Title, Body, Categories, VoteScore, VoteTotal)];
            Idea [] ideans = ((List<Idea>)lstIdeas[0]);
            
            for(Idea idsa : ideans){
                lstIdeaResult.add(idsa);
            }
        }
        return null;
    }
}