public with sharing class ChildTriggerHandler {

	public void onAfterInsert(List<Child__c> lstChild){
		
		Set<Id> setParentId = new Set<Id>();
		
		for(Child__c objChild: lstChild){
			if(objChild.Parent__c != null)
				setParentId.add(objChild.Parent__c);
		}
		
		Map<Id, Parent__c> mapParent = new Map<Id, Parent__c>([select Id, Children__c from Parent__c where Id IN: setParentId]);
		List<Parent__c> lstParentToUpdate = new List<Parent__c>();
		
		for(Child__c objChild: lstChild){
			
			if(objChild.Parent__c != null){
				Parent__c objParent = mapParent.get(objChild.Parent__c);
				
				if(objParent.Children__c == null){
					objParent.Children__c = objChild.Name;
				}
				else{
					objParent.Children__c += ',' + objChild.Name;
				}
				lstParentToUpdate.add(objParent);
			}
		}
		
		if(!lstParentToUpdate.isEmpty())
			update lstParentToUpdate;
	}
	
	public void onAfterDelete(List<Child__c> lstChild){
		
		Set<Id> setParentId = new Set<Id>();
		
		for(Child__c objChild: lstChild){
			if(objChild.Parent__c != null)
				setParentId.add(objChild.Parent__c);
		}
		
		Map<Id, Parent__c> mapParent = new Map<Id, Parent__c>([select Id, Children__c from Parent__c where Id IN: setParentId]);
		List<Parent__c> lstParentToUpdate = new List<Parent__c>();
		
		for(Child__c objChild: lstChild){
			
			if(objChild.Parent__c != null){
				Parent__c objParent = mapParent.get(objChild.Parent__c);
				
				List<String> lstCsv = objParent.Children__c.split(',');
				system.debug('-----lstCsv:'+lstCsv);
				
				if(lstCsv.size() == 1 && lstCsv[0] == objChild.Name){
					objParent.Children__c = null;
				}
				else{
					String tempString = '';
					for(String str: lstCsv){
						
						if(str != objChild.Name){
							tempString += ',' + str;						
						}
					}
					objParent.Children__c = tempString.removeStart(',');
				}
				
				lstParentToUpdate.add(objParent);
			}
		}
		
		if(!lstParentToUpdate.isEmpty())
			update lstParentToUpdate;
		
	}
	
	public void onAfterUpdate(Map<Id, Child__c> mapOldChild, List<Child__c> lstChild){
		
		Set<Id> setParentId = new Set<Id>();
		
		for(Child__c objChild: lstChild){
			if(objChild.Parent__c != null)
				setParentId.add(objChild.Parent__c);
		}
		
		Map<Id, Parent__c> mapParent = new Map<Id, Parent__c>([select Id, Children__c from Parent__c where Id IN: setParentId]);
		List<Parent__c> lstParentToUpdate = new List<Parent__c>();
		
		for(Child__c objChild: lstChild){
			
			if(objChild.Parent__c != null){
				Parent__c objParent = mapParent.get(objChild.Parent__c);
				
				List<String> lstCsv = objParent.Children__c.split(',');
				system.debug('-----lstCsv:'+lstCsv);
				
				String tempString = '';
				for(String str: lstCsv){
					
					if(str == mapOldChild.get(objChild.Id).Name){
						tempString += ',' + objChild.Name;						
					}
					else{
						tempString += ',' + str;
					}
				}
				objParent.Children__c = tempString.removeStart(',');
				
				lstParentToUpdate.add(objParent);
			}
		}
		
		if(!lstParentToUpdate.isEmpty())
			update lstParentToUpdate;
	}
}