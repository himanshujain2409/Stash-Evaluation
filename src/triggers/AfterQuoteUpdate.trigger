trigger AfterQuoteUpdate on Apttus_Proposal__Proposal__c (After Update) {
    if(trigger.new.size()>1)
        return;
    Opportunity Opp;    
    Apttus_Proposal__Proposal__c Proposal=trigger.new[0];
    Apttus_Proposal__Proposal__c oldProposal=trigger.old[0];
    
    if(((proposal.Apttus_QPConfig__ConfigurationFinalizedDate__c!=null 
        && oldProposal.Apttus_QPConfig__ConfigurationFinalizedDate__c==null) 
        || (proposal.Apttus_QPConfig__ConfigurationFinalizedDate__c!=null 
        && oldProposal.Apttus_QPConfig__ConfigurationFinalizedDate__c!=null
        && proposal.Apttus_QPConfig__ConfigurationFinalizedDate__c!=oldProposal.Apttus_QPConfig__ConfigurationFinalizedDate__c))
        && proposal.Apttus_Proposal__Opportunity__c!=null){
            
            Opp=[select id,ACV__c from Opportunity where id=:proposal.Apttus_Proposal__Opportunity__c];
            Opp.ACV__c = proposal.Annual_Amount__c;
            Opp.Total_Deal_Value__c = proposal.Total_Price__c;
        
        }
        
        if(Opp!=null) update Opp;
    
}