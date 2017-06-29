public with sharing class OpportunityProductRedirectExtension {

    Id oppId;

    public OpportunityProductRedirectExtension(ApexPages.StandardController controller) {
        oppId = [select Id, OpportunityId from OpportunityLineItem where Id = :controller.getRecord().Id limit 1].OpportunityId;
    }
    
    public pageReference redirect(){
        return new PageReference('/apex/opportunityProductEntry?id=' + oppId);
    }

}