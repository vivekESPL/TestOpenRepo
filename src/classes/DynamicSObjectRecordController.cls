public with sharing class DynamicSObjectRecordController {
	
	public string objectName{get; set;}
	public string recordName{get; set;}
	
	public DynamicSObjectRecordController(){
		
	}
	
	public PageReference saveDynamicSObjectRecord(){
			
		Map<String, SObjectType> gdMap = Schema.getGlobalDescribe();
		Set<String> sobjectNameSet = gdMap.keySet();
		
		if(sobjectNameSet.contains(objectName.toLowerCase())){
			
			try{
				sObject sObj = Schema.getGlobalDescribe().get(objectName).newSObject();
				sObj.put('name', recordName);
				insert sObj;
				
				PageReference pageRef = new PageReference('/'+sObj.Id);
				return pageRef;
			}
			catch(Exception e){
				ApexPages.addMessages(e);
				return null;
			}
		}
		else{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Entered Object Name is not valid!!'));
		return null;
		}
		
		return null;
	}

}