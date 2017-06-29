trigger ChildTrigger on Child__c (after delete, after insert, after update) {
	
	ChildTriggerHandler objHandler = new ChildTriggerHandler();
	
	if(trigger.isAfter){
		if(trigger.isInsert){
			objHandler.onAfterInsert(trigger.new);
		}
		
		if(trigger.isDelete){
			objHandler.onAfterDelete(trigger.old);
		}
		
		if(trigger.isUpdate){
			objHandler.onAfterUpdate(trigger.oldMap, trigger.new);
		}
	}

}