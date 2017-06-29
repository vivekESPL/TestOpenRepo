trigger EmployeeTrigger on Employee__c (after delete, after insert, after update) 
{
	EmployeeTriggerHandler hndlr=new EmployeeTriggerHandler();
	if(trigger.isAfter && trigger.isUpdate)
	{
		hndlr.onAfterInsert(trigger.new);
		
	}

}