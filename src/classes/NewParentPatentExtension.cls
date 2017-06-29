public with sharing class NewParentPatentExtension{
    public Parent_Patent_Detail__c objParentPatent{get; set;}
    
    public NewParentPatentExtension(ApexPages.StandardController controller){
        objParentPatent = new Parent_Patent_Detail__c();    
    }
    
    public PageReference savePatent(){
        system.debug('-------objParentPatent:'+objParentPatent); 
        return null;
    }
    
    public void cancelPatent(){
        
    }
}