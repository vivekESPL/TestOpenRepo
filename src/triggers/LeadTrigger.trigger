trigger LeadTrigger on Lead (after insert, after update, before insert, 
before update) 
{
	LeadTriggerHandler1 hndlr=new LeadTriggerHandler1();
	if(trigger.isAfter && trigger.isInsert)
	{
		hndlr.onAfterInsert(trigger.new);
	}
	
	if(trigger.isAfter && trigger.isUpdate)
	{
		hndlr.onAfterUpdate(trigger.old,trigger.new);
	}
	
	if(trigger.isBefore && trigger.isInsert)
	{
		
	}

}